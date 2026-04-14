# Short-Term Plan

> Current sprint / active quarter.
> Updated by Claude Code as work progresses.
> Last updated: 2026-03-28

## Completed This Sprint

- MedEase-App: repo housekeeping (2026-03-26)
  - ✅ Consolidated `start.sh` / `start_backend.sh` / `start_frontend.sh` → single `dev.sh` with subcommands
  - ✅ Moved `agent-architecture.md` → `docs/agent-architecture.md`; all references updated
  - ✅ Removed stale root `requirements.txt` (backend canonical) and orphaned logo files
  - ✅ Added `README.md` with badges, collapsible sections, architecture diagram, full dev/deploy docs
  - ✅ All local branches synced to remote

- MedEase-App: deployed to production (2026-03-28)
  - ✅ Backend live on GCP Cloud Run (`medease-491604`, `us-central1`, 1 vCPU / 512 MiB, scales to zero)
  - ✅ Backend URL: `https://medease-backend-476216843409.us-central1.run.app`
  - ✅ Frontend live on Cloudflare Pages: `https://medease.pages.dev`
  - ✅ Dockerized: `backend/Dockerfile`, `frontend/Dockerfile`, `docker-compose.yml`
  - ✅ Lazy-load fix on BART classifier (no model download at startup)
  - ✅ CORS updated to allow `*.medease.pages.dev` preview URLs
  - ✅ Current public-facing state: waitlist join only — all other features (chat, medication, caregiver, simplify) hidden from UI

- MedEase-App: landing page + demo workflow shipped to `main`
  - ✅ Landing page fully wired to react-i18next across all sections (Hero, Mission, Product, About, LP_Team, LP_UserStories, Footer, TopBar navbar)
  - ✅ LP_Team and LP_UserStories: full translations in en, zh-CN, ko, es
  - ✅ Logo unified across LandingPage and demo TopBar (SVG M + "edEase" text, gap 0)
  - ✅ TopBar demo mode: language switcher + "Quit Demo" only; no user icon in demo routes
  - ✅ Demo workflow live on `main`: `/survey/*` → `/home` → `/community/*` → `/notes`
  - ✅ Demo UI/UX overhaul (`feat/demo-uiux`, merged to dev → main 2026-03-25):
    - All demo pages viewport-constrained (`calc(100vh - 64px)`, no page scroll)
    - `DemoSectionNav` shared component (replaces 4× copy-pasted nav)
    - `/home`: care stages as pill chips, recommendation panel collapsible, chat fills height and scrolls internally
    - Chat window: Grid → plain flex Box fixes scroll and right-panel layout
    - Community hub: horizontal row cards, tighter spacing
    - `CommunityLayout`: viewport-constrained, uses `DemoSectionNav`
    - Notes: MUI blue tabs fixed (`textColor="inherit"`), tabs at 36px
    - `NotesWeekView`: trimmed to 7am–10pm (15 hrs × 36px in scroll container)
    - `NotesMonthView`: cells 36px max, tighter header
  - ✅ SurveyShell: capped at `maxHeight: calc(100vh - 128px)` with internal scroll
  - ✅ Favicon updated to medease-logo.svg
  - ✅ Nav order: Mission / Product / About / User Stories / Team (no Docs)

## In Progress

- MedEase-App: multi-agent RAG chat system (backend)
  - ✅ `/dashboard` — full-page RAG chat UI (`ChatPage.jsx`) is now the post-login landing
  - ✅ `/settings` — user settings page with profile + institution (Emory DAS) + sign-out
  - ✅ RAG pipeline live: 216 chunks from 51 Emory DAS records indexed into ChromaDB
  - ✅ Corpus handoff: `sync_corpus.sh` script at repo root; ADR-001 documents decision + GCS migration path
  - 🔲 i18n AI layer: pass `locale` in Socket.IO payload, backend injects `"Respond in {language}"` directive
  - 🔲 Institution auth: wire real institution membership check (backend)
  - 🔲 Conversation history: sidebar placeholder ready, persistence not yet implemented

## Up Next

- i18n AI layer: locale-aware system prompt injection (see [[adr-003-i18n-multilingual-strategy|ADR-003]]; UI layer complete)
- End-to-end RAG test: spin up backend, send DAS question through chat, verify retrieval + citations
- MedEase-Utils V3 gap-closure (see [[scraping-meta-plan]])
  - Scope includes multi-source corpus expansion — see [[inbox]] (2026-03-22 entry)
  - High-priority new sources: `studenthealth.emory.edu`, `counseling.emory.edu`, `emoryhealthcare.org/patients-visitors/patient-resources`
  - Requires source metadata tagging on ChromaDB chunks

## Blocked

_Nothing currently blocked._

## Backlog

- **[Deployment — when ML features go live]** Bump Cloud Run memory from 512 MiB → 2 GiB before enabling `/simplify` — BART model (~400MB+ runtime) will OOM at current limit: `gcloud run services update medease-backend --memory 2Gi --region us-central1`
- **[Deployment — when ready]** Set up GitHub Actions workflow for automated Cloud Run backend deploy on push to `main` (service account key → `GCP_SA_KEY` GitHub secret)

- **[Compliance — pre-contract]** PHI de-identification pipeline: two-layer (regex + spaCy/Ollama) preprocessing before outbound LLM calls — see [[adr-002-phi-deidentification-strategy]]; benchmarking under MedEase-PoC-Eval
- **[Compliance — post-incorporation]** Sign MongoDB Atlas BAA or evaluate Vanta/Drata for compliance automation — see [[hipaa-overview]]
- **[Compliance — pre-contract]** Draft Privacy Policy + add consent checkpoint at account creation
- **[Compliance — pre-contract]** Add audit logging for PHI access events in FastAPI backend
- Remove or archive obsolete frontend pages: `reportsimplification/`, `medication/`, `careGiver/` (routes already removed; files kept)
- SignUp flow: redirect to `/dashboard` after registration (currently only Login redirects)

---

*Related: [[roadmap]] · [[milestones]] · [[feature-registry]]*
