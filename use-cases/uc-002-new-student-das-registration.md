# UC-002: New Student Registration with DAS

## User Goal
Complete the DAS registration process for the first time — understand the
steps, what to prepare, and what to expect.

## Who Triggers This
A student who has never registered with Emory DAS and wants to start. Often
a first-year student, a transfer student, or a student who was recently
diagnosed and is now seeking formal accommodations.

## Intent Signals
- "how do I register with DAS"
- "how do I get accommodations at Emory"
- "I've never used DAS before"
- "what do I need to sign up for disability services"
- "I just got diagnosed, what do I do next"
- "DAS application process"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - Step-by-step registration process
   - Required documentation types (not diagnosis-specific yet)
   - How to schedule an intake appointment
   - Timeline expectations
4. **Response** — structured walkthrough, ideally numbered steps, ending with
   the DAS portal URL or contact info as the action item.

## Information Sources
- DAS corpus (primary): registration steps, intake process, portal instructions
- No user-specific data required; this is a general procedural answer

## Response Criteria
**Good response:**
- Numbered or clearly sequenced steps
- Mentions that documentation from a licensed provider is required (without
  over-specifying what type — that's UC-003)
- Notes that an intake appointment with a DAS advisor follows submission
- Gives a concrete action item at the end (e.g., where to submit)
- Acknowledges the process can feel overwhelming and frames it manageably

**Bad response:**
- Jumps into documentation specifics without covering the overall flow
- Tells the student what accommodations they'll receive (DAS decides)
- Generic "contact disability services" with no guidance on how

## Edge Cases & Handoffs
- "What documents do I need?" mid-conversation → transition to UC-003
- Student says they're international and documentation is from another country
  → note that DAS reviews international documentation but may require
  translation; encourage contacting DAS directly for confirmation
- Student has already started the process and is stuck → shift to answering
  the specific blocker rather than restarting from step 1

## Out of Scope
- DAS registration at institutions other than Emory
- Whether the student "will" receive a particular accommodation
- Legal rights advice (ADA, Section 504) beyond basic context-setting
