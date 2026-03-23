# Feature Registry

> The authoritative list of all features: their status and owner.
> Last updated: 2026-03-23

This is the single source of truth for what's being built, proposed,
or deliberately not built. If a feature isn't here, it doesn't officially
exist yet. If it's deprioritized, the reason should be noted.

---

## Built / Shipped

| Feature | Description | Notes |
|---------|-------------|-------|
| RAG chat (accommodation) | Multi-agent chat answering DAS accommodation questions | Active build focus |
| Emory DAS corpus scraper | Scrapes accessibility.emory.edu for RAG corpus | V2 merged |
| Guardrail + intent routing | Safety layer + intent classifier in chat pipeline | In progress |

## In Progress

| Feature | Description | Owner | Target |
|---------|-------------|-------|--------|
| Multi-agent orchestration | Full agent pipeline: RAG / Medication / Triage / Caregiver | Claude Code | — |
| PHI de-identification pipeline | Middleware to strip 18 HIPAA identifiers before outbound LLM calls | Rolf | Pre-contract |
| PHI de-id benchmarking (PoC-Eval) | Benchmark rule-based vs. NLP vs. local LLM de-identification in MedEase-PoC-Eval | Rolf | Pre-contract |

## Proposed (not yet approved)

| Feature | Proposed by | Status |
|---------|-------------|--------|
| Privacy Policy + user consent checkpoint | Rolf (2026-03-23) | Needed before first institutional contract |
| MongoDB Atlas BAA | Rolf (2026-03-23) | Needed before first institutional contract; path dependent on incorporation |

## Deprioritized

| Feature | Reason |
|---------|--------|
| MedEase-PoC-Eval general benchmarking | Superseded by direct product iteration — **but re-activated for PHI de-identification benchmarking specifically** |

---

*To propose a new feature: add it to `ideation/inbox.md` first.
It graduates to this registry only after Alignment review.*
