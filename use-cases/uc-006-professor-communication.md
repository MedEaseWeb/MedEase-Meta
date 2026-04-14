# UC-006: Professor Communication Support

## User Goal
Communicate disability accommodations to a professor — either understand the
process, draft language for an email, or navigate a difficult conversation.

## Who Triggers This
A student with approved accommodations who needs to notify a professor.
Often the student feels anxious about disclosure and wants help saying
the right thing without oversharing. May also be triggered when a professor
responds skeptically or refuses.

## Intent Signals
- "how do I tell my professor about my accommodations"
- "do I have to tell my professors"
- "can you help me write an email to my professor"
- "my professor is asking why I need accommodations"
- "I don't want to explain my disability to my professor"
- "accommodation letter"
- "professor won't accept my accommodation letter"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent; if email drafting is requested,
   also invokes a response-generation step.
3. **RAG Agent** — queries DAS corpus for:
   - How DAS accommodation letters work (what they say, what they don't)
   - Student rights around disclosure (you don't have to share a diagnosis)
   - Process for submitting accommodation letters to professors
4. **If email drafting requested:**
   - Generate a draft email using the accommodation letter framing
   - Keep it brief, professional, non-disclosing of diagnosis
   - Offer to adjust tone (formal vs. casual)
5. **Response** — answer the process question + offer the draft if wanted.

## Actions
- **Draft the professor email immediately** — when a student asks for help communicating their accommodations, generate the email in-line without waiting for a follow-up request. Include: course greeting, reference to DAS accommodation letter (no diagnosis mentioned), request for a brief acknowledgment. Offer tone variants (formal / casual).
- **Render a "What Your Accommodation Letter Says" card** — a short explainer the student can share with a skeptical professor: what the letter includes, what it deliberately omits, and what the professor is legally required to do.
- **Draft a DAS escalation email** if the professor is refusing or demanding diagnosis disclosure — generate the escalation email to the student's DAS advisor documenting the incident; student reviews before sending.
- **Route to UC-008** if the situation escalates to a formal dispute — initiate grievance flow.

## Information Sources
- DAS corpus: accommodation letter process, faculty notification procedures
- User context: which course, what accommodation, what's the situation

## Response Criteria
**Good response:**
- Clarifies that accommodation letters don't disclose the diagnosis —
  this reassures anxious students
- Provides a draft email if asked (or offers to)
- If professor is pushing back, validates the student's experience without
  inflaming the situation; routes to grievance pathway if needed

**Bad response:**
- Tells the student to "just explain their disability" — they don't have to
- Drafts an email that overshares medical detail
- Dismisses professor pushback as routine when it may be a real violation

## Edge Cases & Handoffs
- Professor demands the student explain their diagnosis → this is inappropriate;
  accommodation letters exist precisely to prevent this; note the student's
  rights, suggest DAS advisor involvement
- Student doesn't yet have an accommodation letter (unregistered) → redirect to
  UC-002 registration flow first
- Professor dispute escalates → handoff to UC-008 grievance process

## Out of Scope
- Mediating directly between student and professor
- Legal advice about ADA compliance (note it as a factor; don't practice law)
