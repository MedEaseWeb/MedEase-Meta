# HIPAA Compliance Overview

> Last updated: 2026-03-23
> Status: Assessment phase — compliance obligations not yet binding; see timing section below

---

## When Do HIPAA Obligations Actually Bind Us?

MedEase operates on a **B2B2C model** — we sell to institutions (Emory, other
universities), who then make the product available to their students.

In this structure:
- The **institution** (e.g., Emory DAS) is the Covered Entity under HIPAA
- MedEase becomes a **Business Associate** only once we sign a contract with an
  institution that involves handling their patients'/students' PHI
- Before any such contract exists, HIPAA obligations do not formally bind us

**Practical implication:** We are not required to be fully HIPAA-compliant before
beta launch. The hard deadline is when we sign the first institutional contract.
That is also the point at which MedEase should be incorporated as a legal entity,
which opens additional compliance paths (see Storage section below).

**Still worth doing now:** PHI de-identification for external LLM calls is a Phase 1
engineering task regardless of legal timing — both as a trust signal to institutions
and because it's architecturally cleaner to build in than retrofit.

---

## Three Risk Pillars

### Pillar 1 — Data Storage

**Assessment: Not a current blocker; multiple paths available when the time comes.**

The key requirement is that any storage system handling PHI under an institutional
contract must meet HIPAA technical safeguards (encryption at rest + in transit,
access controls, audit logging) and must be covered by a BAA with the vendor.

**Path A: MongoDB Atlas with BAA**
MongoDB Atlas is HIPAA-eligible. Requirements:
- M10 or higher cluster (shared/free tiers not eligible)
- BAA signed with MongoDB, Inc.
- Encryption at rest and in transit (enabled by default on eligible tiers)

Reference: https://www.mongodb.com/products/platform/trust/hipaa

**Path B: Compliance automation platforms (Vanta, Drata, others)**
Services like Vanta and Drata help companies achieve and maintain HIPAA (and SOC 2)
compliance posture. They integrate with existing infrastructure, automate evidence
collection, and guide the BAA/vendor management process. This is a practical path
once MedEase is incorporated — the platform handles much of the overhead of managing
vendor agreements and ongoing compliance monitoring.

**Path C: Switch to a HIPAA-native managed storage vendor**
Other database/storage vendors with strong HIPAA programs exist (AWS RDS, Google
Cloud SQL, Azure Cosmos DB). Not a preferred path unless we migrate off MongoDB for
other reasons — switching storage for compliance alone adds unnecessary cost.

**Current recommendation:** Stay on MongoDB. When incorporation happens and the first
institutional contract is in scope, pursue Path A (MongoDB BAA) and evaluate
Path B (Vanta/Drata) for ongoing posture management.

---

### Pillar 2 — Internal Communications / API Calls

**Assessment: Acceptable. No action required.**

The internal chain — React frontend → FastAPI backend → MongoDB / ChromaDB — stays
within our own infrastructure boundary. HIPAA does not require special protocols
for internal system communication as long as:
- Data in transit is encrypted (HTTPS/TLS everywhere — Cloudflare Pages + GCP App Engine cover this)
- Access controls are in place (auth middleware, no unauthenticated endpoints)

ChromaDB stores embeddings derived from public Emory websites, not student-specific
PHI. The internal data flow is not a HIPAA risk.

Audit logging for PHI access is a good engineering practice and will be required
under any institutional contract — defer implementation to the compliance sprint
that precedes contract signing.

---

### Pillar 3 — External LLM / API Calls

**Assessment: Phase 1 engineering priority — PHI de-identification middleware.**

Every user message forwarded to an external LLM API (OpenAI, Anthropic) may contain
PHI: names, diagnoses, student IDs, medications, dates. Transmitting this without
a BAA is a HIPAA violation once we are under an institutional contract.

**LLM provider HIPAA posture:**

| Provider | HIPAA BAA available? | Notes |
|----------|---------------------|-------|
| OpenAI | Enterprise tier only | Standard API is NOT covered |
| Anthropic | No BAA currently offered | As of early 2026 |
| Google Gemini via Vertex AI | Yes | Requires GCP enterprise agreement |
| Azure OpenAI | Yes | Covered under Microsoft HIPAA BAA |

**Phase 1 answer: PHI de-identification middleware.**

Strip or replace the 18 HIPAA identifiers before any message leaves our system.
This keeps us on standard API pricing, works with any LLM provider, and is the
right architectural pattern regardless of future BAA status.

Implementation and benchmarking will be done under **MedEase-PoC-Eval** — see
`compliance/phi-deidentification.md` for the approach and `decisions/adr-002`
for the formal decision record.

Reference on OpenAI + HIPAA: https://www.accountablehq.com/post/is-openai-hipaa-compliant-what-healthcare-teams-need-to-know

Enterprise BAA path (Azure OpenAI or Vertex AI) deferred to Phase 2/3 when
institutional contracts and revenue support it.

---

## User Disclosure

Once institutional contracts are in scope, we will need:
1. A Privacy Policy stating what PHI is collected, how it is protected, and that
   de-identification occurs before third-party AI processing
2. An in-app consent checkpoint at account creation
3. Optionally: a UI indicator in the chat interface ("Messages are de-identified before AI processing")

User-facing language should be plain: "We protect your privacy by removing personal
identifiers before sending your question to our AI."

---

## Compliance Timeline

| Trigger | Required actions |
|---------|-----------------|
| Now (pre-incorporation) | Build PHI de-identification middleware; benchmark in MedEase-PoC-Eval |
| Incorporation | Evaluate Vanta/Drata for compliance automation; begin vendor BAA process |
| First institutional contract | Sign MongoDB BAA; implement audit logging; publish Privacy Policy; add consent checkpoint |
