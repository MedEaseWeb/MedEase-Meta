# UC-009: Medication Management Questions

## User Goal
Understand how to manage medications in a university context — storage,
refills, documentation for DAS, or questions about controlled substances
on campus.

## Who Triggers This
A student who takes prescription medication and needs to navigate Emory's
policies or healthcare resources. May be seeking practical help (where to
store medication, how to get refills) or trying to understand if their
medication relates to their DAS accommodations.

## Intent Signals
- "how do I get my prescriptions refilled at Emory"
- "can I keep medication in my dorm"
- "I take [medication] for [condition] — does that affect my accommodations"
- "controlled substance on campus"
- "I ran out of medication"
- "medication storage requirements"
- "Emory health pharmacy"
- "ADHD medication refill"

## Agent Workflow
1. **Guardrail** — passes; note if this edges toward a medical emergency
   (e.g., ran out of critical medication) and flag for UC-010 / UC-015 check.
2. **Intent Classifier** → routes to Medication Agent.
3. **Medication Agent** — addresses:
   - Emory Student Health pharmacy and refill process
   - Campus policies on medication storage (dorms, DAS testing center)
   - When medication is relevant to a DAS accommodation request
   - General guidance on medication continuity during semester transitions
4. **Response** — practical and specific; avoid clinical advice about
   dosing or efficacy.

## Actions
- **Generate a medication continuity checklist** — action items for managing prescriptions at Emory: (1) confirm pharmacy at Emory Student Health, (2) contact home provider to authorize Emory transfer, (3) note refill timing to avoid gaps, (4) flag any DAS documentation that references medication timing. Rendered as a checkable list.
- **Surface Emory Student Health pharmacy CTA** — "Contact Student Health Pharmacy" button with phone and portal link; injected whenever a refill or supply question is detected.
- **Escalate to UC-010 framing** — if the student signals they are out of a critical medication (insulin, psychiatric medication, seizure medication), immediately render an urgency card with Student Health contact and 911 instruction; don't continue the procedural response until that card is shown.

## Information Sources
- Medication agent knowledge base
- DAS corpus: if medication ties to an accommodation (e.g., documentation
  stating medication timing affects exam performance)
- Emory Student Health resources

## Response Criteria
**Good response:**
- Addresses the practical question (refill, storage, policy)
- Notes the DAS connection if relevant (e.g., medication administration
  as an accommodation)
- Points to Emory Student Health for prescription continuity
- Does not recommend, adjust, or comment on specific medications

**Bad response:**
- Provides dosing advice or drug interaction information
- Recommends stopping or changing a medication
- Ignores urgency signals (e.g., student has run out of critical medication)

## Edge Cases & Handoffs
- Student has run out of a critical medication (insulin, psychiatric meds)
  → treat as potential urgency; route to UC-010 triage framing, recommend
  Emory Student Health immediately or 911 if medically urgent
- Student discloses they are misusing or selling medication → this triggers
  the guardrail; do not assist; provide resources
- Student asks whether a medication side effect qualifies as a disability
  → general answer (functional limitations matter, not medication itself);
  route toward DAS registration if they want to pursue accommodations

## Out of Scope
- Prescribing, adjusting, or recommending medications
- Drug interaction lookups (not a clinical tool)
- Advising on medication efficacy or alternatives
