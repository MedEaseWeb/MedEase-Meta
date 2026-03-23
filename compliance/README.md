# Compliance

This folder covers regulatory, legal, and certification requirements for MedEase.
It is distinct from Planning and Decisions because compliance work is non-negotiable
by nature — it constrains what we build and how, regardless of product priorities.

## Contents

| File | Covers |
|------|--------|
| `hipaa-overview.md` | HIPAA applicability assessment and the three risk pillars |
| `phi-deidentification.md` | PHI handling strategy for external LLM calls: 18 identifiers, tooling options, benchmarks |

## Why a separate folder?

- Compliance obligations don't graduate from ideation; they are pre-conditions.
- They are driven by external regulators (HHS), not internal product decisions.
- They need a stable home reviewable by both founders and external advisors.

## Current posture (as of 2026-03-23)

| Area | Status |
|------|--------|
| Data storage (MongoDB) | Likely OK — MongoDB Atlas is HIPAA-eligible; **BAA required** |
| Internal API calls | Low risk — PHI stays within our own stack boundary |
| External LLM calls | **Critical gap** — no current PHI masking before OpenAI/Anthropic requests |
| User-facing disclosure | Not yet written |
| Staff training / policy docs | Not started |
