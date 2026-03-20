# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Workspace Is

MedEase-Meta is a meta-workspace giving a unified view of all MedEase sub-projects. You operate at the organizational level here — tracking architecture decisions, cross-project dependencies, and strategic direction. Each sub-project has its own `CLAUDE.md` with detailed build/run instructions.

## Sub-Projects

| Directory | Purpose | Stack |
|-----------|---------|-------|
| `MedEase-App/` | Production application — medication management, AI report simplification, multi-agent chat, caregiver dashboards | React/Vite (Cloudflare Pages) + FastAPI (Google App Engine) + MongoDB |
| `MedEase-Utils/` | Web scraper that produces the RAG corpus from `accessibility.emory.edu` | Python, crawl4ai, pdfplumber |
| `MedEase-PoC-Eval/` | Benchmarking and evaluation framework for MedEase pipelines | Python |

## Cross-Project Data Flow

```
MedEase-Utils (Scraping/)
    └── outputs corpus JSON to → MedEase-App (backend/src/rag/corpus/)
                                      └── indexed by indexer.py → ChromaDB
                                              └── queried by rag_agent.py
                                                      └── surfaced in chat (Socket.IO)
```

The scraper (Utils) is upstream of the RAG pipeline (App). The handoff between them is currently **manual**:
1. Run scraper in `MedEase-Utils/Scraping/` → produces `output/emory_das_data_latest.json`
2. Copy `latest.json` into `MedEase-App/backend/src/rag/corpus/`
3. Run `python -m src.rag.indexer` in the App backend to rebuild ChromaDB

## Core Product Architecture

MedEase is an accessibility-focused healthcare assistant for Emory students. The central feature is a multi-agent chat system:

**Message lifecycle:** Socket.IO → Guardrail Agent → Intent Classifier → Orchestrator → Specialist Agent (RAG / Accommodation / Medication / Caregiver / Triage)

Detailed agent contracts and routing logic are in `docs/agent-architecture.md` (symlinked from `MedEase-App/`).

## Deployment Topology

- **Frontend**: Cloudflare Pages (auto-deploy on push to `main`)
- **Backend**: Google Cloud App Engine, Python 3.12, port 8080
- **Vector store**: ChromaDB, local-persistent at `backend/src/rag/chroma_store/`
- **Database**: MongoDB (async via Motor)

## Active Development State (as of 2026-03-20)

- MedEase-Utils V2 is merged; V3 gap-closure is planned (see `docs/utils-logs/scraping-meta-plan.md`)
- MedEase-App's multi-agent RAG chat system is the active build focus
- MedEase-PoC-Eval is mostly obsolete/deprioritized

## Docs (Live Mirrors)

Key architectural documents are symlinked here from their home repos — always reflects the latest:

- `docs/agent-architecture.md` ← `MedEase-App/agent-architecture.md`
- `docs/utils-logs/scraping-meta-plan.md` ← `MedEase-Utils/log/scraping-meta-plan.md`
- `docs/utils-logs/v1_assessment.md` ← `MedEase-Utils/log/v1_assessment.md`
- `docs/utils-logs/v2_assessment.md` ← `MedEase-Utils/log/v2_assessment.md`

## Sub-Project CLAUDE.md Files

- `MedEase-App/CLAUDE.md` — full build/run/deploy instructions, API routes, agent table, env vars
- `MedEase-Utils/CLAUDE.md` — scraper commands, corpus schema, key design decisions, V3 known gaps
