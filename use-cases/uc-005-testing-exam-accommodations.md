# UC-005: Testing & Exam Accommodations

## User Goal
Understand, request, or use extended time, reduced-distraction testing, or
other exam-related accommodations — including how to schedule a test through
DAS and what to do if something goes wrong.

## Who Triggers This
A student with approved accommodations who needs to schedule an exam through
DAS, or a student asking about what testing accommodations exist before
completing registration. Also triggered when something goes wrong (e.g., a
professor isn't honoring accommodations).

## Intent Signals
- "how do I schedule a test with DAS"
- "extended time on exams"
- "reduced distraction testing room"
- "my professor isn't giving me extra time"
- "how far in advance do I need to schedule a test"
- "can I use my laptop for tests"
- "scribe or reader accommodation for exams"
- "what happens if I miss the scheduling deadline"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - How to schedule exams through DAS testing center
   - Advance notice requirements (typically 5–7 business days)
   - What accommodation types exist for testing environments
   - What to do if a professor refuses to honor accommodations
4. **Response** — specific and actionable; if the student is mid-process or
   has a problem, address that first before general info.

## Actions
- **Generate an exam scheduling request template** — a pre-filled form stub the student can copy into the DAS testing portal: course name, instructor, exam date/time, accommodation type needed, lead time confirmation. Presented as a fillable card.
- **Surface scheduling deadline alert** — calculate from user-provided exam date whether the 5–7 business day window is still met; output a visible "On time" or "At risk — contact DAS today" status badge.
- **Draft a professor dispute email** — if the student says a professor isn't honoring accommodations, immediately generate a professional email to send to the DAS advisor documenting the situation; offer to adjust before the student sends.
- **Inject DAS testing center CTA** — "Schedule My Exam" button to the DAS portal testing request page.
- **Route to UC-008** if professor refusal is confirmed — begin grievance flow, don't just describe it.

## Information Sources
- DAS corpus (primary): testing center procedures, scheduling policies
- User context: are they asking proactively or is something going wrong?

## Response Criteria
**Good response:**
- Addresses the immediate situation (scheduling? dispute? missing deadline?)
- States advance-notice requirements clearly
- For professor disputes: explains that accommodations are a legal right,
  suggests contacting DAS advisor, does not guarantee resolution
- Does not over-promise outcomes

**Bad response:**
- Gives generic "contact DAS" without actionable steps
- Tells the student their professor is in the wrong (we don't know the full
  situation)
- Ignores the deadline question if the student is asking close to an exam

## Edge Cases & Handoffs
- Student missed the scheduling window → acknowledge the challenge, note
  options (emergency scheduling, professor coordination), be honest about
  limitations
- Professor is refusing to honor approved accommodations → this is a serious
  issue; provide DAS grievance pathway clearly (→ UC-008 handoff)
- Student wants a testing accommodation they don't have approved → redirect
  to UC-001 / UC-002 for the accommodation request process
- Online/remote exams → note that procedures may differ; encourage DAS contact

## Out of Scope
- Intervening directly in professor disputes
- Creating exam scheduling on behalf of the student
