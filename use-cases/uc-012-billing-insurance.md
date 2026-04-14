# UC-012: Billing & Insurance Questions

## User Goal
Understand what healthcare costs are covered through Emory's student health
insurance, whether disability-related services are covered, or how to
navigate a bill or insurance claim.

## Who Triggers This
A student confused about a healthcare bill, unsure whether their insurance
covers a service at Student Health, or trying to understand what the Emory
student health insurance plan covers (especially for disability-related care,
medications, or mental health services).

## Intent Signals
- "how much does DAS cost"
- "does Emory insurance cover [service/medication]"
- "I got a bill from Student Health"
- "what does the student health plan cover"
- "mental health coverage at Emory"
- "insurance for therapy"
- "medication costs on Emory insurance"
- "financial assistance for disability services"
- "are accommodations free"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent (for Emory-specific policy)
   with light Medication Agent assist if medication costs are involved.
3. **RAG Agent** — queries for:
   - Whether DAS services themselves cost anything (generally no)
   - What Student Health insurance covers (plan-level, not claim-specific)
   - Mental health / counseling coverage
   - Pharmacy benefits
   - Financial assistance programs at Emory
4. **Response** — answer what we can from corpus; be explicit about limits
   (we can't adjudicate a claim or read their specific plan).

## Actions
- **Render a "DAS is free" card upfront** — any time cost or billing is mentioned alongside DAS, immediately output a visible callout: "DAS accommodations have no cost to students." Prevents the misconception from sticking.
- **Generate a billing inquiry email template** — for students who have received a specific bill, generate a pre-written inquiry to the Student Health billing office: patient name placeholder, service date, question about the charge, request for itemization. Student reviews and sends.
- **Inject Student Health billing office CTA** — "Contact Student Health Billing" button with phone and portal link; appears whenever a specific bill is being disputed or a coverage question exceeds what we can answer.
- **Generate an insurance options card** — for uninsured students or those asking about plan options, produce a structured card: (1) Emory student health insurance plan enrollment, (2) Georgia Medicaid eligibility note, (3) ACA marketplace note. Does not recommend a specific plan.

## Information Sources
- DAS corpus: any coverage/cost information
- Emory Student Health insurance plan general information
- Note: we do NOT have access to individual insurance records

## Response Criteria
**Good response:**
- Clarifies upfront that DAS accommodations themselves are free to students
  (this is a common misconception)
- Provides general coverage info (mental health parity, pharmacy benefits)
  while noting it's general and the student should confirm with the insurer
- Points to Emory Student Health billing office for specific questions
- Mentions that financial assistance programs exist at Emory if applicable

**Bad response:**
- Claims to know what the student's specific plan covers
- Gives a definitive answer on whether a specific claim will be covered
- Misses the "DAS is free" point when a student is asking about DAS costs

## Edge Cases & Handoffs
- Student has a specific bill dispute → we can't resolve this; direct to
  Student Health billing office
- Student is on a parent's insurance, not Emory plan → note the difference;
  their coverage questions should go to their insurer
- Student is uninsured → provide information about Emory's plan enrollment
  and Georgia Medicaid/ACA options; note we can't advise on specific plans
- International student insurance → note that Emory has specific requirements
  for international students; direct to appropriate office

## Out of Scope
- Insurance claims adjudication
- Reading or interpreting the student's specific insurance documents
- Financial advice beyond Emory-available programs
