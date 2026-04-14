# UC-008: Grievance & Appeals Process

## User Goal
Understand how to appeal a DAS decision, file a complaint about a denied
or ignored accommodation, or escalate a situation where their rights are
not being honored.

## Who Triggers This
A student who has been denied accommodations, had their accommodations
refused by a professor or office, or feels the process failed them.
High-stakes and often emotionally charged interactions.

## Intent Signals
- "DAS denied my accommodations"
- "my professor won't honor my letter"
- "how do I appeal a DAS decision"
- "I want to file a complaint"
- "disability discrimination"
- "my accommodations aren't being followed"
- "what are my rights"
- "I feel like DAS is being unfair"

## Agent Workflow
1. **Guardrail** — passes; but flag emotional tone to response layer
   (respond with empathy first).
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - DAS internal appeal process
   - Emory's Office of Accessibility (if separate from DAS)
   - Formal complaint pathways (Emory Equity, Civil Rights Office, etc.)
4. **Response** — lead with acknowledgment of the difficulty, then
   procedural pathway. Do not render judgment on whether the denial was right.

## Actions
- **Generate a documentation log template** — a structured incident record the student fills out: date of incident, who was involved, what was said or denied, what accommodation was at issue, any written evidence. Rendered as a fillable card; student can export or copy.
- **Draft an appeal letter** — when a student has been denied by DAS, generate a formal appeal letter to the DAS supervisor using the student's provided context. Factual, professional tone; no inflammatory language. Offer to revise before submission.
- **Generate an escalation path card** — a step-by-step structured card: (1) DAS advisor → (2) DAS Director → (3) Emory Office of Equity and Inclusion → (4) Federal OCR complaint. Each step includes the appropriate contact point.
- **Route to UC-015** if the student expresses distress that crosses into crisis signals — override and inject crisis resources first.

## Information Sources
- DAS corpus: appeal and grievance procedures
- Emory institutional knowledge: OCR complaint pathway, equity office

## Response Criteria
**Good response:**
- Leads with empathy — this is a high-stress situation
- Explains internal appeal first (DAS → supervisor → formal Emory process)
- Notes that federal OCR complaints exist as an external escalation path,
  without pressure to use them
- Does not take sides or validate that the student was "definitely wronged"
  (we don't have the full picture)
- Recommends the student document everything (dates, emails, names)

**Bad response:**
- Immediately jumps to legal threats or OCR before internal options
- Dismisses the student's experience
- Takes a definitive side on whether the denial was correct
- Provides generic "contact HR" advice that doesn't apply to students

## Edge Cases & Handoffs
- Student is in active crisis about this (distressed, mentions harm) →
  safety-first, handoff to UC-015
- Student needs help writing an appeal letter → offer to draft, stay
  factual and professional, avoid inflammatory language
- Professor refusing accommodations (not DAS) → this is a different pathway;
  involves DAS intervention, not an appeal of DAS itself

## Out of Scope
- Legal representation or practicing law
- Filing complaints on behalf of the student
- Rendering judgment on whether decisions were fair
