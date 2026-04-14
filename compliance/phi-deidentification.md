# PHI De-identification Strategy

> Last updated: 2026-03-23
> Status: Research / approach selection — not yet implemented

This document covers how MedEase should strip Protected Health Information (PHI)
from user messages before they are forwarded to external LLM APIs.

---

## What Counts as PHI (the 18 HIPAA Identifiers)

Per HHS Safe Harbor de-identification standard:
https://www.hhs.gov/hipaa/for-professionals/special-topics/de-identification/index.html

| # | Identifier | Examples |
|---|-----------|---------|
| 1 | Names | "John Smith", "my son Alex" |
| 2 | Geographic subdivisions smaller than state | street, city, zip, county |
| 3 | Dates related to an individual | DOB, admission date, discharge date, date of death |
| 4 | Phone numbers | mobile, home, work |
| 5 | Fax numbers | |
| 6 | Email addresses | |
| 7 | Social Security numbers | |
| 8 | Medical record numbers | |
| 9 | Health plan beneficiary numbers | |
| 10 | Account numbers | |
| 11 | Certificate / license numbers | driver's license, professional license |
| 12 | Vehicle identifiers | license plate, VIN |
| 13 | Device identifiers | serial numbers, device IDs |
| 14 | URLs | user-specific URLs |
| 15 | IP addresses | |
| 16 | Biometric identifiers | fingerprints, voiceprints |
| 17 | Full-face photographs or comparable images | |
| 18 | Any other unique identifying number, code, or characteristic | |

In our context, the most likely identifiers in user messages are:
**1 (names), 2 (location details), 3 (specific dates), 4/6 (phone/email),
and 18 (student IDs, Emory ID, diagnosis codes mentioned informally).**

---

## De-identification Approaches

### Option A: Rule-Based / Regex (Baseline)

Pattern matching for known PHI formats: email regex, phone number patterns,
SSN patterns, date patterns, zip codes.

**Pros:** Fast, deterministic, zero latency overhead, fully local.
**Cons:** Low recall on names and free-text identifiers. Brittle to variations.
**Verdict:** Necessary as a baseline layer but not sufficient alone.

---

### Option B: Clinical NLP — pyConText / spaCy NER

`pyConText` is a rule-based clinical NLP library designed for medical text.
spaCy with a clinical NER model (e.g., `en_core_sci_md` from scispaCy) can
identify person names, locations, and dates in clinical contexts.

**Pros:** Purpose-built for medical text; better than generic NER on clinical language.
**Cons:** Models need evaluation on the specific kind of student-written informal text
we'll receive (not clinical notes). Requires Python dependency management.
**Verdict:** Strong candidate for the NLP de-identification layer.

Healthcare NLP comparison (John Snow Labs vs. Amazon vs. Azure):
https://medium.com/john-snow-labs/comparing-de-identification-performance-healthcare-nlp-amazon-and-azure-47f17d185c87

---

### Option C: Local LLM via Ollama

Run a small language model locally (e.g., Llama 3 8B, Mistral 7B) to perform
de-identification as a preprocessing step. No PHI leaves the server.

**Pros:** High recall for informal/conversational text; handles edge cases better
than rule-based approaches; PHI never leaves our infrastructure.
**Cons:** Adds inference latency (~100–500ms); requires GPU or sufficient CPU RAM
on the backend server; nondeterministic.

Reference implementation (Ollama-based local PHI de-identification):
https://dev.to/b-d055/de-identifying-hipaa-phi-using-local-llms-with-ollama-38j3

**Verdict:** Best quality option; viable if GCP App Engine instance has sufficient resources.

---

### Option D: Azure OpenAI or Vertex AI (BAA-covered external API)

Sign enterprise agreements with a provider that offers a HIPAA BAA and use their
hosted models for both de-identification and chat completion.

**Pros:** No infrastructure burden; commercial SLA; BAA covers liability.
**Cons:** Expensive for a startup; Azure/GCP vendor lock-in; still doesn't eliminate
the de-identification requirement (we'd still want to scrub before logging).
**Verdict:** Better as a Phase 2 or Phase 3 option when revenue supports it.

---

## Recommended Architecture (Near-Term)

```
User message (raw)
      │
      ▼
[Layer 1] Rule-based filter
  - Regex for emails, phone numbers, SSN patterns, dates
  - Block-list for Emory student ID formats
      │
      ▼
[Layer 2] Clinical NLP de-identification
  - spaCy / scispaCy NER: persons, locations, dates
  - Or local LLM (Ollama) for higher recall
      │
      ▼
Sanitized message → forwarded to OpenAI / Anthropic API
      │
      ▼
LLM response → returned to user (no reverse-mapping needed for chat)
```

**Key principle:** De-identification is one-way for chat. We do not need to
re-identify in the response — the user knows who they are. We only need to ensure
the outbound payload doesn't contain PHI.

---

## Benchmarking Resources

These papers benchmark local LLM vs. rule-based PHI de-identification performance:

- **NEJM AI (2024)** — Benchmarking local LLM PHI de-identification:
  https://ai.nejm.org/doi/full/10.1056/AIdbp2400537

- **ScienceDirect (2025)** — Comparative study on de-identification methods:
  https://www.sciencedirect.com/science/article/pii/S1386505625004423

- **John Snow Labs comparison** — Healthcare NLP vs. Amazon Comprehend Medical vs. Azure:
  https://medium.com/john-snow-labs/comparing-de-identification-performance-healthcare-nlp-amazon-and-azure-47f17d185c87

Key finding from NEJM study: local LLMs (8B–13B parameter range) achieve F1 scores
competitive with commercial de-identification services on clinical notes, with some
degradation on informal text. Rule-based + LLM hybrid outperforms either alone.

---

## What We Still Need to Decide

1. **Precision vs. recall tradeoff:** Over-masking (flagging non-PHI as PHI)
   is always preferable to under-masking in a HIPAA context. We should err toward
   replacing borderline text with `[REDACTED]` rather than passing it through.

2. **Acceptable latency budget:** A local Ollama model adds ~200–500ms per message.
   Is that acceptable UX in a chat interface? If not, rule-based + spaCy is faster.

3. **Logging policy:** Even de-identified messages should be logged with care.
   Conversation logs (even scrubbed) may be reconstructable if the system stores
   enough context. Define a minimal retention policy.

4. **User notification:** In-chat UI indicator that de-identification is active.
   Low-friction, non-alarming. Something like a small shield icon in the message bar.

5. **Testing / validation:** We need a small benchmark dataset of synthetic
   student messages with known PHI to measure our pipeline's recall before launch.
   This does not require real student data — generate synthetic examples.

---

*Related: [[hipaa-overview]] · [[adr-002-phi-deidentification-strategy]] · [[feature-registry]]*
