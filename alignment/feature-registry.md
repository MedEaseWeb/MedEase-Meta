# Feature Registry

> The authoritative list of all features: their status and owner.
> Last updated: 2026-03-20

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

## Proposed (not yet approved)

| Feature | Proposed by | Status |
|---------|-------------|--------|
| [Add proposals here] | | |

## Deprioritized

| Feature | Reason |
|---------|--------|
| MedEase-PoC-Eval benchmarking | Superseded by direct product iteration |

---

*To propose a new feature: add it to `ideation/inbox.md` first.
It graduates to this registry only after Alignment review.*
