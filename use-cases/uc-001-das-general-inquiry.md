# UC-001: General DAS Accommodation Inquiry

## User Goal
Understand what disability accommodations are available at Emory and whether
they qualify for any of them.

## Who Triggers This
A student (often newly diagnosed, or newly enrolled) who knows they have a
disability but doesn't know what Emory offers or where to start. May also be
a returning student exploring accommodations they didn't know existed.

## Intent Signals
- "what accommodations does Emory offer"
- "do I qualify for accommodations"
- "what does DAS do"
- "how does disability services work"
- "I have [condition] — can Emory help me"
- General questions about accessibility without a specific process in mind

## Agent Workflow
1. **Guardrail** — passes; no safety flags.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - Overview of available accommodation categories
   - Eligibility criteria (what DAS considers, not a diagnosis checklist)
   - Entry point to the registration process
4. **Response** — synthesized overview with a clear next step (usually: "start
   the DAS registration process" → link to UC-002 flow or DAS portal).

## Actions
- **Render an accommodation category card** — a structured list of the main accommodation types (academic, testing, housing, dining, transportation) so the user can scan rather than read prose.
- **Inject a "Start Registration" CTA** — a prominent button or link to the DAS online intake portal; appears at the end of every UC-001 response regardless of what was asked.
- **Route to UC-002 flow immediately** if the user indicates they want to apply — don't describe the next step, *begin* it.

## Information Sources
- DAS corpus (primary): accommodation categories, eligibility overview, FAQ
- No user-specific data required at this stage

## Response Criteria
**Good response:**
- Explains what accommodation categories exist (academic, housing, testing, etc.)
- States that DAS makes eligibility decisions case by case, not by diagnosis list
- Gives a concrete next step (register with DAS, gather documentation)
- Is under ~300 words; doesn't try to answer every sub-question at once

**Bad response:**
- Lists every accommodation exhaustively with no framing
- Tells the user they do or don't qualify (we can't determine that)
- Gives a generic healthcare chatbot response unanchored to Emory

## Edge Cases & Handoffs
- If user mentions a specific condition and asks about a specific accommodation → escalate detail, stay in RAG Agent but narrow the query
- If user asks "how do I apply" → transition to UC-002
- If user mentions their doctor hasn't diagnosed them yet → acknowledge, note that documentation is needed, gentle redirect

## Out of Scope
- Medical advice about whether a condition "counts" as a disability
- Accommodations at institutions other than Emory
