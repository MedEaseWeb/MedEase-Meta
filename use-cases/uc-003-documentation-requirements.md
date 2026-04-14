# UC-003: Documentation Requirements

## User Goal
Understand what medical or psychological documentation is required to support
a DAS accommodation request — and whether what they already have is sufficient.

## Who Triggers This
A student mid-registration who has been told they need documentation and isn't
sure what qualifies. Often anxious about whether their existing records are
acceptable. May be returning to update documentation for a renewal.

## Intent Signals
- "what documentation do I need for DAS"
- "does a doctor's note work"
- "my therapist wrote a letter, is that enough"
- "I have a diagnosis from [X years ago], does that count"
- "what should the letter from my doctor say"
- "do I need to get re-evaluated"
- "my records are from another country"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - Documentation standards and requirements
   - Acceptable provider types (psychiatrist, psychologist, physician, etc.)
   - What the documentation should include (diagnosis, functional limitations,
     recommended accommodations)
   - Policies on older documentation or documentation from outside the US
4. **Response** — clear explanation of requirements, what makes documentation
   strong vs. insufficient, and where to submit or clarify.

## Actions
- **Generate a documentation requirements card** — a structured checklist of what DAS looks for: (1) licensed provider credentials, (2) diagnosis stated explicitly, (3) functional limitations described, (4) recommended accommodations if provider has them. Rendered as a checklist.
- **Generate a "What to Ask Your Provider" script** — a short, plain-language bulleted list the student can print or paste into a patient portal message to their clinician.
- **Flag documentation gaps** — if the user describes what they have, output a side-by-side "you have / you may be missing" comparison card rather than just explaining requirements.
- **Inject DAS contact CTA** — if the student's situation is unusual (old docs, international docs, ER records), surface a "Contact DAS Directly" button rather than trying to adjudicate.

## Information Sources
- DAS corpus (primary): documentation guidelines, provider requirements
- User-provided context (what they have) used to calibrate specificity of answer

## Response Criteria
**Good response:**
- Describes the key elements DAS looks for in documentation
  (diagnosis, functional impact, professional credentials of provider)
- Honest about gray areas (e.g., old documentation may or may not be accepted
  — DAS reviews case by case)
- Doesn't promise that specific docs "will" or "won't" work
- Suggests contacting DAS directly if the user's situation is unusual

**Bad response:**
- Gives a rigid checklist that implies rejection if something doesn't match
- Claims to know whether the student's specific document is acceptable
- Ignores the user's context (e.g., they said they already have a letter)

## Edge Cases & Handoffs
- Student can't afford a new evaluation → empathize, note that Emory's
  Student Health may be a resource; don't promise they'll waive requirements
- Student's documentation is from a hospitalization or ER → note this is
  atypical; encourage DAS contact to discuss
- Student asks about specific condition documentation (e.g., ADHD testing
  requirements) → provide condition-specific guidance if corpus supports it

## Out of Scope
- Advising on which provider to see (that's a medical referral)
- Legal review of documentation sufficiency
- Creating or drafting documentation on behalf of the student
