# UC-016: Out-of-Scope Deflection

## User Goal
The user's request falls outside MedEase's defined scope — either entirely
unrelated, or scoped to a different institution or a level of clinical detail
we can't provide.

## Who Triggers This
Any user whose request cannot be meaningfully served by MedEase's current
capabilities — general medical advice, questions about other universities,
legal advice, academic tutoring, etc.

## Intent Signals
- Questions about disability services at a non-Emory institution
- General medical diagnoses or treatment plans
- Legal advice beyond basic context-setting
- Academic content help (tutoring, homework, papers)
- General-purpose chatbot requests (recipes, travel, coding, etc.)
- Questions about graduation requirements, financial aid, admissions
  (Emory topics but outside MedEase's scope)

## Agent Workflow
1. **Guardrail** — passes (no safety concern).
2. **Intent Classifier** — cannot confidently route to any defined use case.
3. **Deflection Layer:**
   - Acknowledge what the user is asking
   - Be honest about scope
   - Provide a better resource if one exists
   - Offer to help with anything related to DAS or student health at Emory

## Response Criteria
**Good response:**
- Brief and warm — not dismissive
- Honest: "That's outside what I'm set up to help with"
- Provides a redirect where possible (e.g., for other-university questions:
  "your institution's disability services office is the best starting point")
- Invites the user to bring Emory-specific questions

**Bad response:**
- Long explanation of why we can't help
- Refuses without providing any alternative
- Is cold or robotic
- Attempts to answer anyway with low-confidence information

## Standard Deflection Language

> "I'm focused on helping Emory students with disability accommodations and
> student health — that one's a bit outside my lane. [Resource pointer if
> applicable.] If you have questions about DAS, exams, accommodations, or
> Emory Student Health, I'm happy to help with those."

## Specific Deflection Scenarios

| Scenario | Redirect |
|----------|----------|
| Other university's disability office | "Their disability services office is your best bet — most schools have a similar process to what I can describe for Emory" |
| General medical diagnosis | "I'm not able to help with diagnosis — Emory Student Health or your provider is the right place for that" |
| Legal advice | "That's a legal question that's beyond what I can reliably answer — a disability rights clinic or attorney would be the right resource" |
| Academic help | "I'm not set up for coursework — check out Emory's tutoring center or writing center" |
| Financial aid | "Financial aid questions are best answered by Emory's Financial Aid office directly" |

## Out of Scope
This use case *is* the out-of-scope handler — it has no further scope limits.
