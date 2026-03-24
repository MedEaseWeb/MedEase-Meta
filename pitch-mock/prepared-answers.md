# Pitch Mock — Prepared Answers

> Created: 2026-03-23
> Context: Student Founders Showcase prep
> See also: personas-and-questions.md

The three hardest questions are at the top. Each answer includes a **key phrase** — a one-liner to anchor the answer if you go blank under pressure.

---

## The Hard Three

---

### #2 — HIPAA / BAA (Compliance Judge)

> "Walk me through your HIPAA compliance story — do you have a BAA with your data vendors? Are you processing PHI through third-party LLM APIs?"

**Answer:**

"Great question, and one we've thought through carefully. Here's the honest picture.

HIPAA formally binds us as a Business Associate only once we sign a contract with an institution — that's when Emory becomes the Covered Entity and we handle their students' PHI on their behalf. We're not there yet, so we're not technically required to be HIPAA-compliant today. But that framing would be the wrong way to build.

So here's what we're doing now: we're building a PHI de-identification middleware layer that strips all 18 HIPAA identifiers before any user message leaves our system and hits an external LLM API. That means names, dates, student IDs, diagnoses — gone before it reaches Anthropic or OpenAI, neither of which offers a BAA on standard tiers. This protects users regardless of legal timing, and it's a stronger architectural pattern than chasing a BAA with a provider.

On storage — we're on MongoDB. When we incorporate and sign our first contract, we move to MongoDB Atlas with a BAA in place. We've already mapped that path.

The short version: we know compliance is pre-contract work, not post-contract scrambling, and we're treating it that way."

**Key phrase:** *"HIPAA binds us at contract, but we're building for compliance now."*

---

### #6 — Institutional Liability (Emory Administrator)

> "Has Emory officially endorsed this? If a student gets wrong information about their accommodation eligibility, who's liable?"

**Answer:**

"Emory hasn't officially endorsed MedEase yet — we're student founders, and we're building toward that conversation, not claiming it's already happened.

On liability: MedEase is explicitly not a replacement for DAS advisors or medical professionals. The system is designed to surface accurate information from DAS's own published documentation and to say 'I don't know — here's where to go' when it can't answer confidently. We've built that honesty in as a design principle, not an afterthought.

The appropriate framing is that MedEase is like a well-informed study guide for navigating DAS — not an official determination. A student still has to go through DAS for any official accommodation decision. We're reducing the barrier to that conversation, not replacing it.

Liability in the long term lives in our Terms of Service and the institutional contract structure. Those get finalized before we go live with an institution. But the core protection is the product itself: a system that is honest about its limits."

**Key phrase:** *"We reduce the barrier to the conversation, not replace it."*

---

### #8 — FERPA / Caregiver Consent (Parent in Audience)

> "My kid is 19 — they're an adult. How are you handling consent for sharing their information with me as a parent?"

**Answer:**

"You're right to push on this — FERPA and HIPAA both treat 18+ students as independent adults, and that's exactly how we've designed MedEase.

The student controls their account. The caregiver dashboard is only populated when a student explicitly chooses to grant a caregiver access — they initiate it, they revoke it. There is no default sharing with family members. Nothing flows to a caregiver without affirmative student consent.

We're still designing the exact UX for the consent flow, but the principle is non-negotiable: the student is the data subject, and the student holds the key. A parent can't request access on their own — the student has to invite them."

**Key phrase:** *"The student holds the key. Always."*

---

## The Rest

---

### #1 — "Why not just use ChatGPT?"

"ChatGPT doesn't know Emory's DAS. It doesn't know the specific forms, the timelines, the documentation requirements, or the language DAS actually uses. A student asking ChatGPT about accommodation eligibility gets a generic answer that may not match Emory's policies at all.

MedEase is grounded — our RAG system is built on DAS's own published materials. The answers are accurate to Emory's actual process. That's the difference between a general-purpose tool and a purpose-built one."

---

### #3 — "Your market is too small. What's the expansion story?"

"Emory is a testbed, not the ceiling. DAS-style offices exist at every university in the country. The accommodation navigation problem is universal — complicated documentation, institutional jargon, students who fall through the cracks.

We're disciplined about V1 being Emory only because we want to get it right before we scale. But the product architecture is institution-agnostic — you swap the corpus for another university's DAS content. The business model is B2B SaaS per institution, which means revenue scales with contracts, not users."

---

### #4 — "Did you actually talk to students with disabilities?"

Answer this one honestly based on what you've actually done. If you have — name specific things you learned and changed. If you haven't done formal user research yet, say:

"We've had informal conversations, and they've shaped the product — for example, [insert real example]. Structured user research with students who use DAS is on our near-term roadmap before we go live institutionally. We know we can't build an accessibility tool in isolation."

Don't overstate. Judges respect honesty about gaps more than hollow claims.

---

### #5 — "What happens when the corpus is incomplete — does it hallucinate?"

"We've built graceful failure as a first-class requirement. When the RAG system can't find a confident answer, the agent is designed to say so explicitly and point the user to a human — DAS advisors, the office phone number, the relevant web page. Hallucinating an answer is worse than no answer, especially in a healthcare-adjacent context. Our guardrail and intent-routing layer is specifically there to catch those edge cases before they reach the student."

---

### #7 — "What's your moat? Can't Emory just build this themselves?"

"Emory could — but they won't, for the same reason hospitals don't build their own EHR software. It's not their core competency, and the build cost is high. The more likely threat is a large EdTech vendor licensing something generic. Our moat is depth: we're purpose-built for the DAS accommodation workflow, not bolted on. And institutions will pay for something that actually reduces advisor load — that's a measurable outcome we can demonstrate."

---

### #9 — "Who pays?"

"The institution, not the student. We're B2B — MedEase sells to universities, and students use it for free as part of their DAS services. We haven't closed a contract yet, but that's the model we're building toward and why Emory is both our pilot and our first target customer."

---

### #10 — "What if a student in crisis gets a bad response?"

"This is the scenario we've been most careful about. The system has an intent-routing layer that classifies incoming messages — if something looks like a crisis or mental health emergency, it doesn't try to answer, it routes directly to resources: Emory counseling services, a crisis line, a human. We don't let the chatbot play therapist.

The system is also designed to be honest about what it can't do. A bad response in a low-stakes context — wrong form name — is recoverable. A bad response to someone in crisis is not. Those two failure modes require different handling, and we treat them differently."
