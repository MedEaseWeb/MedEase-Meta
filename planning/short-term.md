# Short-Term Plan

> Current sprint / active quarter.
> Updated by Claude Code as work progresses.
> Last updated: 2026-03-21

## In Progress

- MedEase-App: multi-agent RAG chat system (active build focus)
  - ✅ `/dashboard` — full-page RAG chat UI (`ChatPage.jsx`) is now the post-login landing
  - ✅ `/settings` — user settings page with profile + institution (Emory DAS) + sign-out
  - ✅ TopBar simplified: old nav buttons (Report Simplifier, Medication Help, CareGiver Mode) removed; Logo + profile icon only
  - ✅ Institution auth scaffold: Emory University as the single supported institution (hardcoded, badge shown in sidebar and settings)
  - ✅ RAG pipeline live: 216 chunks from 51 Emory DAS records indexed into ChromaDB
  - ✅ Corpus handoff: `sync_corpus.sh` script at repo root; ADR-001 documents decision + GCS migration path
  - 🔲 Institution auth: wire real institution membership check (backend)
  - 🔲 Conversation history: sidebar placeholder ready, persistence not yet implemented

## Up Next

- End-to-end RAG test: spin up backend, send DAS question through chat, verify retrieval + citations
- MedEase-Utils V3 gap-closure (see docs/utils-logs/scraping-meta-plan.md)

## Blocked

_Nothing currently blocked._

## Backlog

- Remove or archive obsolete frontend pages: `reportsimplification/`, `medication/`, `careGiver/` (routes already removed; files kept)
- SignUp flow: redirect to `/dashboard` after registration (currently only Login redirects)
