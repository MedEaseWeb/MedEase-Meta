# UC-014: Caregiver Information Request

> **Status: Deferred — out of scope for V1.**
> The Caregiver Agent and caregiver dashboard are planned for a future phase.
> This spec is maintained here so the design intent is preserved when the
> feature is re-prioritized. Do not implement or route to this use case until
> caregiver functionality is officially back in scope.

---

## User Goal
A caregiver (parent, guardian, family member) wants to understand the
DAS process, the student's options, or how to support their student
navigating disability services at Emory.

## Who Triggers This
A parent or guardian — often more anxious than the student themselves —
who wants to understand the system or help their student prepare. May also
be a caregiver who is trying to do things *on behalf of* the student, which
raises FERPA considerations.

## Intent Signals
- "my son/daughter/child has [condition] and is going to Emory"
- "how can I help my student with DAS"
- "I'm a parent, what accommodations can my child get"
- "caregiver dashboard"
- "how do I support my student through this"
- "FERPA" (explicit reference)
- Caregiver identifies themselves as such at the start of the session

## Agent Workflow
1. **Guardrail** — passes; activate caregiver-specific framing in response layer.
2. **Intent Classifier** → routes to Caregiver Agent.
3. **Caregiver Agent** — frames responses appropriately:
   - Information is provided at the general/procedural level, not specific
     to the student's records (FERPA)
   - Emphasizes the student as the agent of their own accommodations
   - Addresses the support role (how to encourage, how to help prepare)
4. **RAG Agent** assist — for specific process questions (same info as student
   use cases, but framed for a caregiver reader).
5. **Response** — empathetic to the caregiver's concern; empowering framing
   that keeps the student at the center.

## Information Sources
- DAS corpus (general process information)
- Caregiver-specific framing layer

## Response Criteria
**Good response:**
- Provides general process information freely (this is all public)
- Notes that the student must initiate DAS registration themselves
  (FERPA: Emory can't share records with parents without student consent)
- Gives the caregiver concrete ways to support without taking over
  (e.g., help gather documentation, encourage them to register)
- Does not make the caregiver feel dismissed

**Bad response:**
- Provides information as if the caregiver can submit on behalf of the student
- Ignores FERPA reality and implies parents can access student records
- Is cold or bureaucratic to a worried parent
- Infantilizes the student in the caregiver response

## Edge Cases & Handoffs
- Caregiver expresses that the student is in crisis → provide UC-015 resources
  for the student; note that as a caregiver they should encourage the student
  to reach out, and call 911 if there's imminent danger
- Caregiver is asking on behalf of a student who has given explicit consent →
  treat similarly to the student, but note the dependency
- Caregiver wants to know their student's current accommodation status →
  we can't share this (FERPA); point them to how the student can share if
  they choose to

## Out of Scope
- Accessing or sharing a specific student's records
- Acting as a proxy for the student in the DAS process
- Legal FERPA advice beyond basic explanation
