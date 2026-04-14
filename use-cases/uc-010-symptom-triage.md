# UC-010: Symptom Triage

## User Goal
Understand whether a symptom or health situation warrants immediate care,
a scheduled appointment, or self-management — and where to go at Emory.

## Who Triggers This
A student experiencing a health issue who wants guidance on urgency. Often
asking because they're unsure whether to go to the ER, urgent care, or
wait for a regular appointment. May have a chronic condition and be
experiencing an unusual episode.

## Intent Signals
- "I feel [symptom], should I go to the doctor"
- "is this serious"
- "I've had [symptom] for [duration]"
- "do I need to go to the ER"
- "where should I go for [health issue]"
- "I think I'm having [episode related to chronic condition]"
- "I'm not feeling well"

## Agent Workflow
1. **Guardrail** — evaluates for safety signals. If any of the following
   are present, immediately route to UC-015 (Crisis/Emergency):
   - Chest pain, difficulty breathing, stroke symptoms
   - Severe allergic reaction
   - Mention of self-harm, suicidal ideation, overdose
   - Altered consciousness
2. **Intent Classifier** → routes to Triage Agent.
3. **Triage Agent** — applies urgency framework:
   - **Emergency (now):** life-threatening → call 911 or go to ER
   - **Urgent (same day):** serious but stable → Emory Urgent Care / Student Health walk-in
   - **Routine (schedule):** non-urgent → schedule at Student Health
   - **Self-care (monitor):** minor → home management + watch for changes
4. **Response** — clear triage level + specific Emory resource + when to
   escalate if things change.

## Actions
- **Render a triage output card** — a structured artifact with four fields: (1) Urgency level (Emergency / Urgent / Routine / Self-care), (2) Recommended Emory resource with address or contact, (3) What to do right now, (4) Watch for — specific escalation signals to monitor. This card is the primary output; prose explanation is secondary.
- **Inject emergency CTAs** — for Emergency-level triage, render "Call 911" and "Emory Police: 404-727-6111" as prominent action buttons at the top of the response, before any explanatory text.
- **Generate a symptom log for appointment prep** — if triage level is Routine or Self-care, offer to generate a brief symptom summary the student can bring to their Student Health appointment (onset, severity, duration, relevant history).
- **Hard-route to UC-015** — if any guardrail trigger fires during triage, immediately override the triage card with the crisis response; do not complete the triage first.

## Information Sources
- Triage agent clinical knowledge base
- Emory campus health resources (Student Health, urgent care locations)

## Response Criteria
**Good response:**
- States the triage level clearly and early
- Gives a specific Emory resource, not just "see a doctor"
- Includes a "watch for" escalation signal if recommending self-care
- Does not diagnose — only triages urgency

**Bad response:**
- Diagnoses the condition
- Dismisses symptoms that could be serious
- Over-catastrophizes minor symptoms
- Fails to route obvious emergencies to UC-015

## Edge Cases & Handoffs
- Any life-threatening symptom description → immediate UC-015 override
- Student has a known chronic condition and describes an expected episode →
  acknowledge the context, still triage the current situation appropriately
- Student asks "what do I have" → gently redirect: we can help with where
  to go, not with diagnosis
- Student is asking about someone else → note the distinction, still provide
  guidance, watch for proxy crisis signals

## Out of Scope
- Diagnosing conditions
- Recommending specific treatments or medications
- Replacing a clinical assessment
