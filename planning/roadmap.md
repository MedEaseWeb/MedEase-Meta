# Roadmap

> Long-term direction. Updated only when strategy shifts significantly.
> Last updated: 2026-03-20

## Phase 1 — Foundation (current)

Build and validate the core DAS accommodation chat experience for Emory
students. Ship a working multi-agent RAG pipeline with guardrails,
intent routing, and a clean frontend.

Key milestones:
- Multi-agent pipeline fully operational (RAG + Triage + Medication + Caregiver agents)
- MedEase-Utils V3 corpus gap closure
- **[[adr-002-phi-deidentification-strategy|PHI de-identification middleware]]** (Phase 1 engineering; benchmarked under MedEase-PoC-Eval)
- **[[hipaa-overview|Full HIPAA compliance posture]]** before first institutional contract (MongoDB BAA / Vanta/Drata, Privacy Policy, audit logging) — not a beta blocker
- Beta accessible to a small group of Emory students

## Phase 2 — Validation

Real usage with real students. Measure: do students find it useful?
Do they trust it? What questions is it failing to answer?

## Phase 3 — Expansion (TBD)

To be defined after Phase 2 learnings. Possible directions:
other universities, other accessibility offices, caregiver-facing features.
Not scoped until Phase 1 is excellent.

---

*Related: [[north-star]] · [[feature-registry]] · [[milestones]] · [[short-term]] · [[principles]]*
