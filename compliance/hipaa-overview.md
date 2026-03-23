# HIPAA Compliance Overview

> Last updated: 2026-03-23
> Status: Assessment in progress — no formal BAAs signed yet

---

## Are we a Covered Entity or Business Associate?

MedEase operates as a healthcare-adjacent app serving students with disabilities.
If we handle Protected Health Information (PHI) on behalf of a covered entity
(e.g., Emory DAS, Emory Student Health), we are a **Business Associate** and must
sign a BAA with each covered entity before handling their data.

Even in early beta, we should operate as if we are fully subject to HIPAA, as
retrofitting compliance is substantially harder than building it in from the start.

---

## Three Risk Pillars

### Pillar 1 — Data Storage

**Assessment: Low risk, but BAA needed.**

MongoDB Atlas is HIPAA-eligible under certain tiers. Key requirements:
- Must be on **M10 or higher** Atlas cluster (shared/free tiers are not eligible)
- Must sign a **Business Associate Agreement (BAA)** with MongoDB, Inc.
- Encryption at rest and in transit must be enabled (Atlas enables this by default on eligible tiers)

Reference: https://www.mongodb.com/products/platform/trust/hipaa

**Action required:** Sign MongoDB BAA before beta launch with any real student data.

What we store today (user profile: name, email, institution) is borderline —
names and email addresses are HIPAA identifiers if associated with health information.
Once any health-related context is stored (e.g., conversation history about
accommodations or conditions), the entire user record becomes PHI.

---

### Pillar 2 — Internal Communications / API Calls

**Assessment: Acceptable, with standard security hygiene.**

The internal chain — React frontend → FastAPI backend → MongoDB / ChromaDB — stays
within our own infrastructure boundary. HIPAA does not require special protocols
for internal system communication as long as:
- Data in transit is encrypted (HTTPS/TLS everywhere — Cloudflare Pages + GCP App Engine cover this)
- Access controls are in place (auth middleware, no unauthenticated endpoints)
- Audit logging is implemented for PHI access events

ChromaDB stores embeddings, not raw PHI. The RAG corpus is scraped from public Emory
websites and does not contain student-specific PHI. This is safe.

**Known gap:** No audit logging for PHI access currently. This is a Phase 1 hardening item.

---

### Pillar 3 — External LLM / API Calls

**Assessment: Critical gap. PHI must be masked before any outbound call.**

This is the highest-risk pillar. Every time a user sends a message that may contain
PHI (name, diagnosis, medication, dates), and that message is forwarded to an
external LLM provider, we are transmitting PHI to a third party.

**Current LLM providers and their HIPAA status:**

| Provider | HIPAA BAA available? | Notes |
|----------|---------------------|-------|
| OpenAI | Yes, Enterprise tier only | Standard API (ChatGPT API) is NOT HIPAA covered |
| Anthropic | No BAA currently offered | As of early 2026 |
| Google Gemini | Yes, via Google Cloud HIPAA BAA | Requires Vertex AI, not the consumer API |
| Azure OpenAI | Yes | Covered under Microsoft HIPAA BAA |

**Bottom line:** We cannot legally transmit identifiable PHI to OpenAI or Anthropic
on standard API terms. We have two paths:

1. **Sign enterprise agreements** with a provider that offers a BAA (Azure OpenAI or
   Google Vertex AI are the most practical). Expensive and complex for a startup.

2. **De-identify PHI before every outbound LLM call** — strip or replace the 18 HIPAA
   identifiers before the message leaves our system. See `phi-deidentification.md`
   for the detailed strategy.

Path 2 is the right near-term approach. It keeps us on the standard API tier,
is implementable in our current stack, and is the industry norm for early-stage
healthcare AI products.

Reference on OpenAI + HIPAA: https://www.accountablehq.com/post/is-openai-hipaa-compliant-what-healthcare-teams-need-to-know

---

## User Disclosure Requirements

HIPAA requires we inform users:
- What PHI we collect and why
- How we protect it
- That mandatory de-identification occurs before any third-party AI processing
- Their rights regarding their data

This disclosure belongs in:
1. A Privacy Policy (to be drafted)
2. An in-app notice at account creation (consent checkpoint)
3. Optionally, a persistent indicator in the chat UI ("Your messages are de-identified before AI processing")

The user-facing language should be plain and non-alarming — "We protect your privacy
by removing personal identifiers before sending your question to our AI" is better
than a dense legal notice.

---

## Minimum Requirements Before Beta Launch

- [ ] Sign MongoDB Atlas BAA
- [ ] Implement PHI de-identification pipeline (see `phi-deidentification.md`)
- [ ] Draft and publish Privacy Policy
- [ ] Add consent checkpoint at account creation
- [ ] Enable audit logging for PHI access in FastAPI backend
- [ ] Decide on LLM vendor path: de-identification-first vs. enterprise BAA
