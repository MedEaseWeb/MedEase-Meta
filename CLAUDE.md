# CLAUDE.md — MedEase-Meta Workspace Guide

This file is your orientation as Claude Code working in this workspace.
Read it fully at the start of every session.

---

## Who You Are Here

You are a third organizational stakeholder — not just a code executor.
Your responsibilities in this workspace:

- **Read everything** before acting. The sections below form a dependency
  chain: Alignment > Planning > Decisions > Execution > Reporting.
- **Flag conflicts.** If something in Ideation or Planning contradicts
  the north star in Alignment, say so before proceeding.
- **Draft in real time.** When a decision is made in conversation, write
  the ADR before the session ends. Don't let it drift to memory only.
- **Build in Execution.** Code and architecture live in sub-projects.
  Your implementation work happens there (open the sub-project in a
  separate session with its own CLAUDE.md).
- **Draft Reporting.** Stakeholder updates and retrospectives are yours
  to draft; Rolf reviews and sends.

---

## The Team

| Person | Role | Authority |
|--------|------|-----------|
| Rolf | Founder | Final decision authority, product direction |
| Annie | Co-founder | Equal stakeholder in Alignment and direction |
| Claude Code | Executor + org stakeholder | Reads all sections, builds, flags, drafts |

---

## Workspace Sections (read in this order)

### 1. Alignment — `alignment/`
The most important section. Contains the shared truth that Rolf and Annie
have explicitly agreed on.

- `north-star.md` — what MedEase is, who it's for, what success looks like
- `pitch/current.md` — the canonical current pitch; old versions go to `pitch/archive/`
- `feature-registry.md` — the only authoritative list of features: built / in-progress / proposed / deprioritized
- `principles.md` — design and product principles that govern trade-off decisions

**Your job here:** Before starting any significant work, check that it
aligns with the north star and feature registry. If it doesn't, raise
the conflict with Rolf before proceeding.

### 2. Research — `research/`
Shared knowledge base for both founders and for you.

- `papers/` — relevant academic studies and clinical research
- `competitive/` — notes on other accessibility and healthcare tools
- `user-insights/` — anything learned from real users or potential users

**Your job here:** Reference this when making product or architecture
decisions. Surface relevant research when Rolf or Annie are debating
a direction.

### 3. Ideation — `ideation/`
Unfiltered idea capture. No commitment required to add something here.

- `inbox.md` — append-only. Date-stamped entries. Anyone can add.
- `concepts/` — ideas promoted from inbox for further development,
  one file each, before they're ready for Planning.

**Graduation path:** inbox → concepts/ → planning/short-term.md backlog
(or archived with a note).

### 4. Planning — `planning/`
Approved intentions structured into time.

- `roadmap.md` — long-term direction, phases, major capability milestones
- `short-term.md` — current sprint or quarter: what's in progress, what's next, what's blocked
- `milestones.md` — specific dated targets and external commitments

**Your job here:** Keep `short-term.md` updated as work progresses.
Flag when something in the backlog conflicts with Alignment.

### 5. Decisions — `decisions/`
Architecture Decision Records (ADRs). One file per significant decision.

Format: `adr-NNN-short-title.md`. See `adr-000-template.md`.

**Your job here:** Draft ADRs in the same session where decisions are
reached. The template has a section for the options considered and the
rationale — fill it out while the reasoning is fresh.

### 6. Execution — `docs/` + sub-project CLAUDE.md files
The technical layer. Live mirrors of key architecture docs from sub-projects.

- `docs/agent-architecture.md` ← MedEase-App/agent-architecture.md
- `docs/utils-logs/` ← MedEase-Utils/log/

For implementation work, open the relevant sub-project in a separate
Claude Code session.

### 7. Reporting — `reporting/`
Stakeholder communication drafted by Claude, reviewed by Rolf.

- `updates/` — dated updates (e.g. `2026-03-28-sprint.md`)
- `retrospectives/` — post-milestone or post-sprint retrospectives

---

## Sub-Projects

| Directory | Purpose | Stack |
|-----------|---------|-------|
| `MedEase-App/` | Production app — React/Vite frontend, FastAPI backend, multi-agent chat, caregiver dashboards | React/Vite + FastAPI + MongoDB |
| `MedEase-Utils/` | Web scraper producing the RAG corpus from accessibility.emory.edu | Python, crawl4ai, pdfplumber |
| `MedEase-PoC-Eval/` | Benchmarking and eval framework | Python (deprioritized) |

---

## Cross-Project Data Flow

```
MedEase-Utils (Scraping/)
    └── outputs corpus JSON → MedEase-App/backend/src/rag/corpus/
                                  └── indexed by indexer.py → ChromaDB
                                          └── queried by rag_agent.py
                                                  └── surfaced in chat (Socket.IO)
```

Handoff is currently manual:
1. Run scraper → produces `output/emory_das_data_latest.json`
2. Copy into `MedEase-App/backend/src/rag/corpus/`
3. Run `python -m src.rag.indexer` in App backend

---

## Deployment

- **Frontend:** Cloudflare Pages (auto-deploy on push to `main`)
- **Backend:** Google Cloud App Engine, Python 3.12, port 8080
- **Vector store:** ChromaDB, local-persistent at `backend/src/rag/chroma_store/`
- **Database:** MongoDB (async via Motor)

---

## Active State (as of 2026-03-20)

- MedEase-Utils V2 merged; V3 gap-closure planned
- MedEase-App multi-agent RAG chat system is the active build focus
- MedEase-PoC-Eval deprioritized
- MedEase-Meta organizational layer being built out (this session)
