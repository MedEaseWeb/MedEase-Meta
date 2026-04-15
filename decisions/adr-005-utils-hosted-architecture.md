# ADR-005: MedEase-Utils Hosted Architecture — Batch Jobs, GCS Corpus Storage, MongoDB Run Metadata

> Date: 2026-04-15
> Status: Accepted
> Decided by: Rolf

## Context

MedEase-Utils is currently a local CLI scraper (`python main.py`). It writes corpus output to local files, which are then manually copied into the App backend and indexed into ChromaDB. This works at the current scale of one source and one developer, but creates compounding headaches as the corpus grows:

- Adding new sources (V3 targets: `studenthealth.emory.edu`, `counseling.emory.edu`, financial assistance) means more manual file management.
- No run history, no admin visibility into scraper health.
- Corpus handoff is a manual, error-prone step (see ADR-001).
- Long-running scrapes (multi-source, higher frequency) can't be scheduled or monitored remotely.
- A future admin dashboard (planned) needs to trigger and observe scraper runs from a browser — impossible with a local CLI.

The right moment to restructure is now, while the codebase is small (one source, one scraper, ~216 chunks). The same migration done after V3 gap-closure or after adding a schedule would be meaningfully more painful.

Two sub-decisions were made together:
1. **How to host the crawler** — what compute primitive runs it
2. **Where to store the corpus content** — MongoDB vs. object storage

## Options Considered — Compute

**Option A: Long-running hosted service (always-on FastAPI/Flask)**
Pros: Can accept trigger requests at any time; easy to stream live progress.
Cons: Wasteful — a crawler runs infrequently (weekly cadence); an always-on server idles. Cost without benefit.

**Option B: Cloud Run Jobs (on-demand batch)**
Pros: Designed exactly for this — containerized batch work that runs to completion and exits. Triggered via API call or cron schedule. Scales naturally (parallel jobs per source). Already on GCP, same infrastructure as the App backend. No idle cost.
Cons: Slightly more setup than a simple script. Live log streaming requires Cloud Logging integration (straightforward).

**Option C: Keep as local CLI**
Pros: Zero infra work now.
Cons: Doesn't scale, blocks admin dashboard, requires manual corpus handoff indefinitely.

## Options Considered — Corpus Storage

**Option A: MongoDB for corpus content (full markdown per page)**
Pros: One storage system; easy to query.
Cons: MongoDB is a document store optimized for structured data, not large text blobs. Full page markdown (hundreds to thousands of words per record, 50–200+ records per source) is the wrong fit. Inflates MongoDB storage and backup cost. Adds no query value — corpus content is consumed by the indexer as a blob, not queried by field.

**Option B: GCS for corpus content, MongoDB for run metadata only**
Pros: GCS is purpose-built for large files — cheap, durable, versioned. Each run is one JSON file (a natural blob). MongoDB only stores lightweight structured records (run ID, status, timestamps, page counts, GCS path pointer). Clean separation of concerns.
Cons: Two storage systems to manage. Indexer must download from GCS before indexing (one extra step, but already required in the old manual process).

## Decision

**Compute: Cloud Run Jobs.** MedEase-Utils will be Dockerized and deployed as a Cloud Run Job. Runs are triggered via the Cloud Run Jobs API (from the App admin dashboard, or a cron schedule). Each run is a container invocation that scrapes one or more sources, writes output to GCS, writes metadata to MongoDB, and exits.

**Storage split:**
- **GCS** — corpus content. Each run produces one JSON file per source: `gs://medease-corpus/runs/{run_id}/{source_id}.json`. Run history is naturally preserved (each run is a separate object). The indexer downloads from GCS before feeding ChromaDB.
- **MongoDB** — run metadata only. One document per run, containing: `run_id`, `source_id`, `status`, `started_at`, `completed_at`, `pages_found`, `pages_scraped`, `pages_failed`, `corpus_gcs_path`, `content_hash`. The admin dashboard reads this collection.
- **ChromaDB** — embeddings, unchanged. Still local-persistent at `backend/src/rag/chroma_store/`. Indexer pipeline is unchanged except for the input source (GCS instead of local file).

The MongoDB run metadata document looks like:
```json
{
  "run_id": "2026-04-15T14:32:emory-das",
  "source_id": "C-001",
  "source_name": "Emory DAS",
  "status": "completed",
  "started_at": "2026-04-15T14:32:01Z",
  "completed_at": "2026-04-15T14:47:22Z",
  "pages_found": 53,
  "pages_scraped": 51,
  "pages_failed": 2,
  "corpus_gcs_path": "gs://medease-corpus/runs/2026-04-15T14:32-emory-das/C-001.json",
  "content_hash": "a3f5c...",
  "triggered_by": "manual"
}
```

## Consequences

**Easier:**
- Admin dashboard can show real scraper run history, page counts, and health without any file access.
- Adding V3 sources is additive: new Cloud Run Job config, new corpus-registry.md entry.
- Corpus handoff is automatic: indexer reads from GCS path stored in MongoDB, no manual copy.
- Run history preserved naturally in GCS (each run is its own object).
- Scrapes can be scheduled via Cloud Scheduler without any persistent server.

**Harder / ruled out:**
- Local `python main.py` workflow no longer produces the primary output — developers need GCS credentials to run the full pipeline locally. Mitigation: keep the local CLI working with a `--local` flag for development; `--local` writes to `output/` as before, skips GCS/MongoDB writes.
- Live terminal-style log streaming requires Cloud Logging integration or a WebSocket relay. Deferred to admin dashboard V2; V1 shows completed run summaries only.

**Follow-up actions required:**
1. Dockerize MedEase-Utils (add `Dockerfile` modeled on App backend)
2. Create GCS bucket: `medease-corpus` in `us-central1`
3. Add `--local` flag to `main.py` to preserve CLI dev workflow
4. Add MongoDB write step to `main.py` (run metadata only)
5. Add GCS write step to `main.py` (replaces local `output/` write in hosted mode)
6. Update `sync_corpus.sh` or replace with indexer-pulls-from-GCS flow
7. Deploy as Cloud Run Job: `medease-utils-scraper`
8. Update `research/corpus-registry.md` with GCS path convention
9. Admin dashboard (App `/admin`) reads `scraper_runs` MongoDB collection — separate planning item

---

*Related: [[adr-001-corpus-handoff]] · [[feature-registry]] · [[research/corpus-registry]] · [[short-term]]*
