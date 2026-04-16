# Short-Term Plan

> Current sprint / active quarter.
> Updated by Claude Code as work progresses.
> Last updated: 2026-04-16

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

## Completed This Sprint (cont'd) — 2026-04-15

- MedEase-App: i18n AI layer (2026-04-15)
  - ✅ `AgentContext` gains `locale` field; `socket_server` extracts locale from every Socket.IO payload
  - ✅ `language_directive()` helper in `base_agent` maps locale → "Respond in X" system-prompt injection
  - ✅ All 5 specialist agents (RAG, medication, triage, accommodation, caregiver) are locale-aware
  - ✅ `ChatPage.jsx` and `ChatBox.jsx` pass `{ content, locale }` on every emit
  - ✅ Merged as PR #23 → `dev`

- MedEase-App: i18n UI completions (2026-04-15)
  - ✅ ChatPage welcome message uses `t("chat.welcomeMain")`; updates live on language switch if no conversation started
  - ✅ TopBar dropdown: "Signed in as" and "Settings" now translated
  - ✅ SettingsPage fully wired — all strings use `t()` across en/zh-CN/ko/es

- MedEase-App: Japanese (ja) translation (2026-04-15)
  - ✅ `locales/ja/translation.json` — complete, includes all keys current as of today
  - ✅ Wired into `i18n.js`, TopBar, LandingPage language switchers
  - ✅ `base_agent.py` locale directive map updated; orchestrator dev stubs include Japanese
  - ✅ Merged as PR #26 → `dev`

- MedEase-App: Dev Mode (2026-04-15)
  - ✅ Settings pane: "Developer" section with toggle; state persisted in `localStorage`
  - ✅ Single interceptor in `Orchestrator.handle()` — bypasses all LLM calls when on
  - ✅ Stubs stream word-by-word (45ms/word) via `bot-token` / `bot-done` protocol
  - ✅ Locale-aware stubs: en / zh-CN / ko / es / ja — never ships to `main`
  - ✅ Merged as PR #24/#25 → `dev`

- MedEase-App: Use case registry expanded (2026-04-15)
  - ✅ UC-018: Emory Healthcare Financial Assistance — proactive surfacing, international student callout, bill hold template

- MedEase-Meta: dev ↔ main sync (2026-04-15)
  - ✅ Merged main hotfixes (CORS, Dockerfile, Cloud Run, VITE_API_URL) back into dev; branches re-aligned

## Completed This Sprint (cont'd) — 2026-04-16

- MedEase-App: legacy route + frontend cleanup (2026-04-16)
  - ✅ Full route audit — separated active routes from prototype-era legacy (medication, caregiver, simplify, Google OAuth)
  - ✅ ADR-007 drafted and accepted
  - ✅ 17 backend files deleted: 4 route files, 3 service files, `s3Connection.py`, `ChatGPT.py`, 8 model files
  - ✅ 13 frontend files deleted: `careGiver/`, `medication/`, `reportsimplification/` directories
  - ✅ 13 packages removed from `requirements.txt`: full boto3 chain (AWS S3) + torch/transformers chain (BART/HuggingFace)
  - ✅ `main.py` reduced from 7 routers to 3 active routers
  - ✅ `MedEase-App/CLAUDE.md` updated to reflect current codebase state
  - ✅ Merged as PR #27 → `dev`; PR #29 (`dev` → `main`) conflicts resolved and ready to merge

- MedEase-App: i18n AI layer bug fixes (2026-04-16)
  - ✅ **Bug:** `Orchestrator.handle()` rebuilt `AgentContext` without copying `locale` → `language_directive()` always received `"en"` → no language constraint injected to specialist agents
  - ✅ **Fix:** `locale=context.locale` added to `enriched_context` construction in `orchestrator.py`
  - ✅ **Bug:** Guardrail block message and out-of-scope message hardcoded in English regardless of locale
  - ✅ **Fix:** `_BLOCKED_PREFIX` and `_OUT_OF_SCOPE` locale-keyed dicts (en/zh-CN/ko/es/ja) added to `orchestrator.py`; `GuardrailAgent` now applies `language_directive` so LLM-generated block reason is also in user's language

- MedEase-Meta: planning + decisions updated (2026-04-16)
  - ✅ ADR-003 (i18n), ADR-004 (demo UI/UX), ADR-007 (legacy cleanup) marked Accepted (Resolved)
  - ✅ Feature registry updated: medication, caregiver, simplify, manual Google OAuth moved to Deprioritized/Removed
  - ✅ Funding application infrastructure cost breakdown drafted (OpenAI API, GCP Cloud Run, Firestore, Cloudflare Pages, Firebase Auth)

## In Progress

- MedEase-App: multi-agent RAG chat system (backend)
  - ✅ `/dashboard` — full-page RAG chat UI (`ChatPage.jsx`) is now the post-login landing
  - ✅ `/settings` — user settings page with profile + institution (Emory DAS) + sign-out
  - ✅ RAG pipeline live: 216 chunks from 51 Emory DAS records indexed into ChromaDB
  - ✅ Corpus handoff: `sync_corpus.sh` script at repo root; ADR-001 documents decision + GCS migration path
  - ✅ i18n AI layer: locale passed in Socket.IO payload, backend injects language directive
  - 🔲 Institution auth: wire real institution membership check (backend)
  - 🔲 Conversation history: sidebar placeholder ready, persistence not yet implemented

## Up Next

- **Merge PR #29** (`dev` → `main`) — conflicts resolved, ready; triggers Cloudflare Pages redeploy; redeploy backend to Cloud Run after merge (smaller image now that torch/boto3 removed)
- **Firestore + Firebase Auth migration** (ADR-006) — next major backend work; sequence: create Firebase project under `medease-491604` → enable Firestore + Firebase Auth → migrate route files one at a time
- **RAG corpus sitemap / registry** ← *Rolf working on this*
  - Registry live at `research/corpus-registry.md` — 8 sources tracked (C-001 through C-008)
  - Immediate work: MedEase-Utils V3 scraping P1 sources: `studenthealth.emory.edu`, `counseling.emory.edu`, `emoryhealthcare.org/patients-visitors/patient-resources`
  - Requires source metadata tagging on ChromaDB chunks (schema defined in corpus-registry.md)
- **End-to-end RAG test** — spin up backend, send real DAS question through chat, verify retrieval + citations show correctly; first formal validation of the full pipeline
- **Conversation history** — plan at `planning/conversation-history-plan.md`; Phase 1: Firestore persistence + fixed 10-turn window + session sidebar; Phase 2: rolling summarization at >20 turns (sequence after ADR-006)
- **Institution auth** — wire real institution membership check on backend

## Blocked

_Nothing currently blocked._

## Backlog

- **[Deployment — when ready]** Set up GitHub Actions workflow for automated Cloud Run backend deploy on push to `main` (service account key → `GCP_SA_KEY` GitHub secret)
- **[Deployment — domain]** Purchase domain (considering `medease.health`); point to Cloudflare Pages; set up Cloudflare Email Routing for team inbox + Resend for transactional email (waitlist confirmations, account verification)
- **[Compliance — pre-contract]** PHI de-identification pipeline: two-layer (regex + spaCy/Ollama) preprocessing before outbound LLM calls — see [[adr-002-phi-deidentification-strategy]]; benchmarking under MedEase-PoC-Eval
- **[Compliance — post-incorporation]** Sign GCP BAA (Cloud Console → IAM & Admin → Compliance) — self-service, no minimum spend; covers Cloud Run + Firestore + GCS
- **[Compliance — pre-contract]** Draft Privacy Policy + add consent checkpoint at account creation
- **[Compliance — pre-contract]** Add audit logging for PHI access events in FastAPI backend
- SignUp flow: redirect to `/dashboard` after registration (currently only Login redirects)

---

*Related: [[roadmap]] · [[milestones]] · [[feature-registry]]*
