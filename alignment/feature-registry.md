# Feature Registry

> The authoritative list of all features: their status and owner.
> Last updated: 2026-03-25

This is the single source of truth for what's being built, proposed,
or deliberately not built. If a feature isn't here, it doesn't officially
exist yet. If it's deprioritized, the reason should be noted.

---

## Built / Shipped

| Feature | Description | Notes |
|---------|-------------|-------|
| RAG chat (accommodation) | Multi-agent chat answering DAS accommodation questions | Live on main |
| Emory DAS corpus scraper | Scrapes accessibility.emory.edu for RAG corpus | V2 merged |
| Guardrail + intent routing | Safety layer + intent classifier in chat pipeline | Live on main |
| i18n — P1 UI layer | react-i18next wired across all landing page sections and full demo workflow; LP_Team, LP_UserStories, Hero, Mission, Product, About, Footer, TopBar, Survey, Home, Community, Notes all translated; en/zh-CN/ko/es locale files complete | Shipped 2026-03-25; AI locale system-prompt injection still pending |
| Demo workflow | Full public demo at `/survey` → `/home` → `/community` → `/notes`; survey flow, care-journey home, community hubs, notes calendar | Shipped on main 2026-03-25 |
| Demo UI/UX — viewport layout | All demo pages viewport-constrained (`calc(100vh - 64px)`); DemoSectionNav shared component; chat scrolls internally; care stages as pill chips; recommendation collapsible; community hub compact row cards; Notes tabs fixed (no blue), week view trimmed to 7am–10pm | Shipped 2026-03-25; see [[adr-004-demo-uiux-layout\|ADR-004]] |

## In Progress

| Feature | Description | Owner | Target |
|---------|-------------|-------|--------|
| Multi-agent orchestration | Full agent pipeline: RAG / Medication / Triage / Caregiver | Claude Code | — |
| PHI de-identification pipeline | Middleware to strip 18 HIPAA identifiers before outbound LLM calls | Rolf | Pre-contract |
| PHI de-id benchmarking (PoC-Eval) | Benchmark rule-based vs. NLP vs. local LLM de-identification in MedEase-PoC-Eval | Rolf | Pre-contract |
| i18n — AI layer | Locale-aware system prompt injection: pass active locale in Socket.IO payload, backend injects `"Respond in {language}"` directive | Claude Code | — |

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

*To propose a new feature: add it to [[inbox]] first.
It graduates to this registry only after Alignment review.*

---

*Related: [[north-star]] · [[adr-001-corpus-handoff]] · [[adr-002-phi-deidentification-strategy]] · [[adr-003-i18n-multilingual-strategy]] · [[hipaa-overview]] · [[use-cases/README|use cases]]*
