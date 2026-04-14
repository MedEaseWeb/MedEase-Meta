# ADR-002: PHI De-identification Before External LLM Calls

> Date: 2026-03-23
> Status: Proposed
> Decided by: Rolf (pending Annie review)

## Context

MedEase forwards user chat messages to external LLM APIs (OpenAI, Anthropic).
Users may — and likely will — include Protected Health Information (PHI) in their
messages: names, diagnoses, dates, student IDs, contact details.

Transmitting identifiable PHI to a third-party API without a HIPAA Business
Associate Agreement (BAA) is a HIPAA violation. Neither OpenAI (standard API)
nor Anthropic currently offers a BAA on standard terms.

We must either: (a) sign enterprise BAAs with a covered provider, or (b) strip
PHI before messages leave our system. This ADR records the choice between these
approaches for the near term.

## Options Considered

**Option A: Sign enterprise BAA (Azure OpenAI or Google Vertex AI)**
Pros: Cleanest legal path; commercial SLA; no de-identification latency.
Cons: Enterprise pricing not viable at current stage; vendor lock-in to
Azure or GCP model offerings; still best practice to de-identify regardless.

**Option B: De-identify at the application layer before all outbound LLM calls**
Pros: Works with any LLM provider (no BAA required); keeps us on standard API
pricing; builds a reusable compliance primitive we'd need anyway; privacy-by-design.
Cons: Adds latency; risk of under-masking if pipeline has low recall; engineering
effort upfront.

**Option C: Prohibit PHI in user inputs (UI enforcement)**
Pros: Zero infrastructure cost.
Cons: Unenforceable in a chat interface; students will naturally describe their
conditions, names, medications. Not realistic.

## Decision

**Adopt Option B — implement a de-identification pipeline as a mandatory
preprocessing step before every outbound LLM API call.**

Architecture: two-layer pipeline.
1. **Rule-based layer** — regex/pattern matching for emails, phone numbers,
   SSN formats, dates, zip codes. Fast and deterministic.
2. **NLP layer** — spaCy/scispaCy NER (or local Ollama LLM) for names,
   locations, and informal PHI patterns. Higher recall, especially on
   conversational text.

Full details in [[phi-deidentification]].

Option A (enterprise BAA) is deferred to Phase 2 or Phase 3 when product
traction and revenue support it. If we sign a BAA with a provider in future,
the de-identification pipeline remains in place as defense-in-depth.

## Consequences

**Makes easier:**
- HIPAA compliance posture without enterprise vendor relationships
- Works with any LLM provider; no lock-in
- Provides a clear internal privacy commitment we can describe to users and institutions

**Makes harder / rules out:**
- Messages with extensive PHI may be heavily redacted, potentially reducing
  LLM response quality (acceptable tradeoff; over-masking is preferable)
- Requires a benchmarked, tested de-identification pipeline before beta launch
  with real student data

**Follow-up actions required:**
- [ ] Select spaCy/scispaCy vs. Ollama as the NLP layer (benchmark first)
- [ ] Build and test the two-layer pipeline in MedEase-App backend
- [ ] Create synthetic test dataset with known PHI for recall measurement
- [ ] Add in-chat UI indicator that de-identification is active
- [ ] Sign MongoDB Atlas BAA (separate from this ADR, but part of the same compliance sprint)
- [ ] Draft Privacy Policy referencing de-identification approach

---

*Related: [[hipaa-overview]] · [[phi-deidentification]] · [[feature-registry]] · [[roadmap]]*
