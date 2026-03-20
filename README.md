# MedEase-Meta

The organizational brain of the MedEase project. No product code lives here.
This repository holds the shared context, decisions, and direction for a
three-person team: Rolf (founder), Annie (co-founder), and Claude Code
(AI collaborator and executor).

---

## Why This Exists

Software projects fail at the seams — where one person's assumptions
contradict another's, where decisions made in conversation quietly
disappear, where two founders slowly develop different pictures of what
they're building.

MedEase-Meta exists to hold that context explicitly. It is the place where:

- **Rolf and Annie stay aligned** — one canonical pitch, one feature registry,
  one north star that both have signed off on
- **Decisions outlive the conversation** that produced them
- **Claude Code has full organizational context** at the start of every session,
  without needing to be re-briefed

---

## Workspace Sections

| Section | Purpose | Key Files |
|---------|---------|-----------|
| `alignment/` | Shared truth between founders | north-star.md, pitch/current.md, feature-registry.md |
| `research/` | Shared knowledge base | papers/, competitive/, user-insights/ |
| `ideation/` | Unfiltered idea capture | inbox.md, concepts/ |
| `planning/` | Approved intentions | roadmap.md, short-term.md, milestones.md |
| `decisions/` | Architecture Decision Records | adr-NNN-*.md |
| `reporting/` | Stakeholder communication | updates/, retrospectives/ |
| `docs/` | Live mirrors of sub-project docs | symlinks to MedEase-App, MedEase-Utils |

---

## The Team

Claude Code is a third stakeholder here, not just a tool. It reads all
sections, flags conflicts, drafts ADRs in real time, and maintains
short-term.md as work progresses. Rolf sets direction; Annie co-owns
Alignment; Claude executes and maintains coherence.

---

## Sub-Projects

| Repo | Purpose | Status |
|------|---------|--------|
| [MedEase-App](https://github.com/MedEaseWeb/MedEase-App) | Production app — React/Vite + FastAPI + MongoDB | Active |
| [MedEase-Utils](https://github.com/MedEaseWeb/MedEase-Utils) | Scraper producing Emory DAS corpus for RAG | V2 complete; V3 planned |
| MedEase-PoC-Eval | Benchmarking and eval framework | Deprioritized |

---

## How to Orient (returning after time away)

1. Ask Claude Code: *"Summarize current state — what's built, in progress, next."*
2. Check `alignment/north-star.md` — has anything shifted?
3. Check `planning/short-term.md` — what's active right now?
4. Check `docs/utils-logs/` — scraper corpus status
5. Check open PRs on MedEase-App for in-flight work
