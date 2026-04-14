# UC-017: MedEase App Self-Inquiry

## User Goal
Understand what MedEase is, what it can help with, how it works, and whether
it's the right tool for their situation.

## Who Triggers This
A first-time user who landed on the app without context, a student who heard
about MedEase from a peer, or anyone who wants to understand the tool before
committing a real question to it. May also be a user who hit a limitation and
wants to understand why.

## Intent Signals
- "what is MedEase"
- "what can you do"
- "how does this work"
- "can you help me with [X]"
- "what are you"
- "is this a real person or AI"
- "how do you know about DAS"
- "are you affiliated with Emory"
- "is this private / is my data safe"
- "what can't you help with"
- Blank first message or very short opener ("hi", "hello", "?")

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to App Self-Inquiry handler
   (this is a lightweight, pre-RAG response; no corpus query needed for
   most questions).
3. **Response Layer** — answers from a fixed, curated description of MedEase.
   For nuanced capability questions ("can you help me with X"), run a quick
   intent check on X to route appropriately after answering.

## Actions
- **Render a capabilities card** — a structured, scannable artifact listing what MedEase can do (DAS process, documentation, testing accommodations, triage, etc.) and what it can't (diagnose, access Emory records, provide legal advice, guarantee outcomes). This is the primary output for "what can you do" questions — not prose.
- **Immediately initiate the relevant flow** — if the user asks "can you help me with X" and X is in scope, answer yes and start the flow in the same response. Don't describe what will happen; do it.
- **Render a privacy card on request** — for data/privacy questions, output a structured card: what is stored (none by default / session only), what is not stored, who built MedEase, how to contact with concerns. Factual; no over-assurance.
- **Surface a "Try Me" prompt** — for blank or very short openers, output the capabilities card plus a suggested first question to lower the activation energy for first-time users.

## Information Sources
- Curated app description (not RAG corpus — this is product knowledge, not
  DAS knowledge)
- If user asks "can you help with X" → run X through intent classifier and
  respond with a capability answer + offer to proceed

## Response Criteria
**Good response:**
- Concise — 3–5 sentences for a general "what is this" question
- Honest about what MedEase is and isn't (AI tool, not affiliated with Emory,
  not a replacement for DAS advisors)
- Invites the user to ask their real question
- For privacy questions: straightforward answer about what is and isn't stored;
  don't over-promise

**Bad response:**
- Long marketing-style pitch
- Overstates capabilities ("I can answer any healthcare question")
- Claims Emory affiliation or official DAS status
- Leaves the user unsure of what to do next

## Canonical App Description (for response use)

> MedEase is an AI assistant designed to help Emory students navigate
> Disability and Accessibility Services (DAS). I can answer questions about
> the accommodation process, help you understand documentation requirements,
> explain your options for exams, housing, and more — and I'll tell you
> when something is outside what I can help with.
>
> I'm not affiliated with Emory or DAS, and I'm not a replacement for
> speaking with a DAS advisor. Think of me as a way to understand the
> system before (or alongside) those conversations.

## Key Honest Limitations to Communicate

| Question | Honest Answer |
|----------|---------------|
| Are you affiliated with Emory? | No — independent tool built for Emory students |
| Can you access my DAS records? | No — no access to any Emory systems |
| Is this a real person? | No — AI assistant |
| Can you guarantee I'll get accommodations? | No — DAS makes all decisions |
| Can you help with [non-DAS topic]? | Depends; check UC-016 for deflection guidance |

## Edge Cases & Handoffs
- User asks "can you help me with X" where X is in scope → confirm yes,
  offer to proceed immediately
- User asks "can you help me with X" where X is out of scope → brief
  deflection (→ UC-016), invite a DAS-related question
- User expresses skepticism about AI tools → acknowledge it, don't argue;
  offer to answer one question so they can judge for themselves
- User asks about data privacy → be straightforward; don't over-assure

## Out of Scope
- Detailed technical explanations of how the AI works
- Marketing or persuasion — just describe honestly and let the user decide
