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
