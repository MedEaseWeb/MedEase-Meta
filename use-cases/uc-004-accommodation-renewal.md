# UC-004: Accommodation Renewal

## User Goal
Renew existing DAS accommodations for a new semester or academic year —
understand what's required, what might change, and when to act.

## Who Triggers This
A student who has accommodations in place but needs to reactivate them for
a new term. May also be a student whose documentation has expired and who
isn't sure what that means for their accommodations.

## Intent Signals
- "how do I renew my accommodations"
- "do I have to reapply every semester"
- "my accommodations expired"
- "I need to update my DAS accommodations"
- "do I need new documentation to keep my accommodations"
- "I haven't used DAS in a while, what do I do"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - Renewal process and timeline
   - Whether new documentation is required for renewal
   - How to request accommodations be active for a new semester
   - What happens if a student's condition has changed
4. **Response** — clear steps for renewal, with emphasis on timing
   (accommodations are not retroactive in most cases).

## Actions
- **Generate a semester activation checklist** — distinguishes self-service reactivation steps (log into DAS portal, request letters for new courses) from steps requiring DAS advisor contact (condition changes, expired documentation). Rendered as a branching checklist, not prose.
- **Surface semester timing alert** — if current date is within 4 weeks of a semester start, prepend a visible urgency banner: "Accommodations are not retroactive — act before [date]."
- **Inject DAS portal CTA** — "Reactivate Accommodations" button pointing directly to the semester request flow.
- **Auto-transition to UC-003** if the user indicates their documentation may have expired — begin documentation requirements flow immediately.

## Information Sources
- DAS corpus (primary): renewal policy, semester activation process
- User context: how long since they last used DAS, whether anything has changed

## Response Criteria
**Good response:**
- Distinguishes between "reactivating" accommodations each semester (often
  self-service) vs. a full re-evaluation (only needed if condition changed
  or documentation expired)
- Stresses timing — accommodations must be in place before the need arises
- Notes that retroactive accommodation requests are typically not granted

**Bad response:**
- Conflates renewal with initial registration
- Fails to mention timing considerations
- Assumes the student needs all-new documentation without basis

## Edge Cases & Handoffs
- Student's condition has significantly changed → accommodations may need
  updating; encourage scheduling a new intake or advisor meeting
- Student is mid-semester and just remembered → note the timing issue honestly,
  help them understand what's still possible
- Student wants to add a new accommodation at renewal time → this is a
  modification, not just a renewal; escalate to DAS advisor meeting

## Out of Scope
- Guaranteeing that prior accommodations will be granted again
- Making decisions about whether updated documentation is needed (DAS does this)
