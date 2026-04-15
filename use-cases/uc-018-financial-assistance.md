# UC-018: Emory Healthcare Financial Assistance

## User Goal
Learn about and apply for Emory Healthcare's financial assistance program to
reduce or eliminate the cost of a medical bill they cannot afford.

## Who Triggers This
A student who has received a large medical bill from Emory Healthcare —
or who is worried about the cost of care before receiving a bill — and does
not know that a formal financial assistance program exists. This gap is
especially common among international students, who may be unfamiliar with
US hospital financial aid programs and assume they must pay whatever is billed.

**Real scenario that motivates this use case:** An international student
undergoes emergency surgery (e.g. appendicitis) at Emory Healthcare and ends
up paying almost nothing because they applied for and qualified for financial
assistance. Most of their peers never apply because they didn't know the
program existed.

## Intent Signals
- "I can't afford this bill"
- "I got a huge bill from Emory Healthcare"
- "how do I pay for surgery at Emory"
- "financial assistance Emory hospital"
- "I don't have insurance / my insurance didn't cover it"
- "how much does [hospital procedure] cost"
- "is there any help for medical bills"
- "I can't pay the hospital"
- "financial aid for medical bills"
- "does Emory have a payment plan"
- "I'm an international student and I got a bill"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent (Emory Healthcare financial
   assistance policies) with a secondary check for insurance status context.
3. **RAG Agent** — queries for:
   - Emory Healthcare financial assistance / charity care program existence
     and eligibility criteria
   - Income thresholds or documentation required to apply
   - How to access the application (button, portal, or in-person office)
   - Whether international students are eligible
   - Timelines (how long review takes, whether to request a hold on the bill)
4. **Response** — proactively surface the program even if the user only asked
   about cost or payment options; do not wait for them to ask specifically
   about "financial assistance."

## Actions
- **Surface a "Financial Assistance May Be Available" callout proactively** —
  any time a student mentions an unaffordable Emory Healthcare bill or
  inability to pay, immediately render a visible callout explaining that
  Emory Healthcare has a financial assistance program before anything else.
  Do not bury this in the middle of a longer response.
- **Generate a financial assistance application prep checklist** — produce a
  short checklist of what the student will likely need: proof of income (or
  lack thereof), student status documentation, recent tax return or
  equivalent, explanation of their situation. Framed as "gather these before
  you apply."
- **Inject a "Start Financial Assistance Application" CTA** — primary action
  button that links directly to the Emory Healthcare financial assistance
  application or the billing office contact where the application is
  initiated. This CTA should appear prominently, not just in a list.
- **Generate a bill hold request template** — for students who have a bill due
  while the review is pending, generate a short written request to the billing
  office asking them to place the account on hold during the financial
  assistance review period.
- **Surface international student note** — if the user has indicated they are
  an international student, include an explicit note that international
  students have successfully qualified for this program; eligibility is not
  limited to US citizens or permanent residents.

## Information Sources
- Emory Healthcare financial assistance / charity care policy documents
- RAG corpus: any indexed billing or financial assistance content
- Emory Healthcare billing office contact information

## Response Criteria
**Good response:**
- Leads with the financial assistance program — does not start with payment
  plans, insurance explanations, or general billing info
- Names the program clearly and gives a concrete next step (apply here)
- Addresses the information-gap reality: "Many students don't know this
  program exists" is valid framing — it's not condescending, it's accurate
- Handles international students explicitly rather than implicitly
- Provides a checklist or preparation guidance so the student feels equipped,
  not just pointed at a link

**Bad response:**
- Buries financial assistance at the end after lengthy insurance explanations
- Assumes international students are ineligible or adds unnecessary caveats
  about eligibility without information to back that up
- Only discusses Emory student health insurance when the bill is from Emory
  Healthcare (the hospital), not Student Health
- Tells the student to "contact the billing office" without telling them *why*
  (to ask about financial assistance specifically)

## Edge Cases & Handoffs
- **Bill is from Student Health, not Emory Healthcare** → different billing
  system; route to UC-012. Student Health bills are typically lower, but
  financial assistance may still apply — confirm which entity issued the bill.
- **Student has insurance but still received a large balance** → may need help
  understanding the Explanation of Benefits before deciding whether to apply
  for assistance; surface UC-012 as a companion.
- **Student is worried about cost before receiving care** → financial
  assistance can sometimes be applied pre-service; note this and direct them
  to the billing office to ask about pre-authorization of assistance.
- **Student needs immediate help and cannot wait for review** → surface the
  bill hold request template and note that the billing office can typically
  pause collections during the review.

## Out of Scope
- Determining whether a specific student qualifies (we do not have access to
  their income or financial records)
- Completing the application on their behalf
- Disputing a specific charge or claim (→ UC-012)
- Advice on personal finance, loans, or external charity programs
