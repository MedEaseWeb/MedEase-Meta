# UC-007: Housing & Dining Accommodations

## User Goal
Request or understand disability-related housing or dining accommodations —
such as a single room, accessible unit, specific meal plan modifications,
or allergen accommodations tied to a medical need.

## Who Triggers This
A student who needs their living environment or food service adapted due to
a disability or medical condition. Often a rising freshman or student moving
into new housing. May also be a student whose housing situation has changed
mid-year.

## Intent Signals
- "can I get a single room because of my disability"
- "I need a quiet room accommodation"
- "accessible dorm / wheelchair accessible housing"
- "my disability requires a certain diet"
- "I have a severe allergy and need dining accommodations"
- "emotional support animal in dorms"
- "service animal on campus"
- "medical fridge in my room"
- "housing accommodation DAS"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - Process for requesting housing accommodations through DAS
   - How DAS coordinates with Residence Life / Housing
   - Types of housing accommodations available
   - ESA (Emotional Support Animal) vs. Service Animal policies
   - Dining accommodation request process (may involve separate office)
4. **Response** — procedural walkthrough; note that housing accommodation
   requests often have earlier deadlines than academic ones.

## Information Sources
- DAS corpus: housing accommodation process, ESA/service animal policies
- Potentially cross-references Emory Housing and Dining offices

## Response Criteria
**Good response:**
- Notes the DAS + Housing coordination process (student doesn't just contact
  Housing directly — DAS facilitates)
- Flags that housing accommodation deadlines are often earlier than the
  semester start; stresses acting early
- Distinguishes ESAs (require DAS paperwork) from service animals
  (broader protections, different process)
- For dining: notes that severe allergies/medical diets may involve
  a separate process with Dining Services; DAS may or may not be the entry point

**Bad response:**
- Tells the student to contact Housing or Dining directly without DAS involvement
- Confuses ESA with service animal rights
- Doesn't mention deadline urgency

## Edge Cases & Handoffs
- Student asking mid-semester about housing change → more complex; encourage
  DAS contact quickly, be honest that mid-year changes are harder
- Student has a service animal and is facing resistance → this has legal
  dimensions (ADA Title II); provide factual information but recommend
  DAS advisor involvement
- Roommate conflict related to a disability accommodation → outside our scope;
  suggest Residence Life

## Out of Scope
- Negotiating with Housing or Dining directly
- Reviewing housing assignment decisions
- Roommate disputes unrelated to accommodation
