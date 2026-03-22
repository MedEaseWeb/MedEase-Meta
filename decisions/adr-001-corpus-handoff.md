# ADR-001: Corpus Handoff — Utils → App Backend

> Date: 2026-03-21
> Status: Accepted (Phase 1 active; Phase 2 planned)
> Decided by: Rolf

## Context

MedEase-Utils produces a scraped Emory DAS corpus (`emory_das_data_latest.json`).
MedEase-App backend needs that file in `backend/src/rag/corpus/` to build the
ChromaDB vector index that powers the RAG agent.

The two sub-projects share no runtime environment — the scraper runs locally
and the backend is deployed to Google Cloud App Engine. A safe, repeatable
handoff mechanism was needed.

## Options Considered

**Option A: Symlink**
Pros: Zero friction locally, always in sync.
Cons: Breaks in production (App Engine has no access to the Utils filesystem).

**Option B: Script-based copy (chosen for now)**
A `sync_corpus.sh` at the repo root copies the latest JSON into the backend
corpus directory and re-runs the indexer.
Pros: Simple, explicit, no infra required. Works today.
Cons: Manual — must be run after each scrape. Does not scale to automated runs.

**Option C: GCS bucket as handoff layer (planned)**
Scraper uploads `emory_das_data_latest.json` to a GCS bucket post-run.
Backend indexer downloads from that bucket at startup or on a cron.
Pros: Production-grade. Decoupled. Enables automated re-indexing.
Cons: Requires GCS bucket + credentials wired into both projects.

## Decision

**Phase 1 (now):** Option B — `sync_corpus.sh` script.
Run manually after each MedEase-Utils scrape:
```
./sync_corpus.sh   # from MedEase-Meta root
```

**Phase 2 (when scraper runs on a schedule):** Migrate to Option C.
Trigger: when MedEase-Utils V3 is complete and scraping is automated.

## Consequences

- `sync_corpus.sh` is the documented handoff step for all contributors.
- The corpus directory (`backend/src/rag/corpus/`) and the chroma_store
  (`backend/src/rag/chroma_store/`) should be git-ignored (large binary/data files).
- Phase 2 will require: a GCS bucket, service account credentials in both
  sub-projects, and a re-index trigger (App Engine cron or startup hook).
