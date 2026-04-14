# UC-015: Crisis & Emergency Detection

## User Goal
A student (or person on their behalf) needs immediate safety support —
either a medical emergency, a mental health crisis, or a situation of
imminent danger.

## Who Triggers This
Any user who expresses or implies they are in immediate danger — physically
or psychologically. This use case overrides all others and is triggered by
the Guardrail layer, not the Intent Classifier.

## Intent Signals (Guardrail triggers — hard interrupt)
**Immediate life-threatening:**
- Chest pain, difficulty breathing, stroke symptoms
- Severe allergic reaction / anaphylaxis
- Unresponsive or altered consciousness
- Active bleeding, serious injury
- Overdose (accidental or intentional)

**Mental health crisis:**
- Explicit mention of suicidal thoughts or intent
- "I want to hurt myself" / "I don't want to be here anymore"
- "I've taken pills" / "I hurt myself"
- Severe dissociation or psychotic episode described

**Soft signals (add crisis resources alongside normal response):**
- "I feel hopeless"
- "nobody cares"
- "what's the point"
- Extreme despair combined with any other distress signal

## Agent Workflow
1. **Guardrail** — detects crisis signal; hard interrupt.
2. **All other routing suspended** — do not attempt to answer the original
   question first.
3. **Crisis Response Layer:**
   - Hard interrupt: immediate safety resources (formatted for urgency)
   - Warm, brief, non-clinical tone
   - No lengthy explanation; no diagnostic questions
4. **After resources:** if soft signal (not hard emergency), offer to continue
   with whatever the student originally needed.

## Actions
- **Hard interrupt all other agent routing** — on any guardrail trigger, immediately halt the normal pipeline. No intent classification, no RAG query. Crisis response layer fires first.
- **Render crisis contacts as action buttons** — not inline text. Each contact (911, Emory Police, CAPS Crisis Line, 988, Crisis Text Line) is rendered as a tappable/clickable button with the number visible. This is a UI-level requirement, not just response content.
- **Generate a personal safety plan stub** — for soft-signal cases (not hard emergencies), after surfacing resources, offer to generate a short safety plan: who to call, what to do first, where to go. Student fills in names; system pre-fills the Emory-specific contacts.
- **Log the crisis signal** — flag the session internally for follow-up review (platform-level action, not user-visible). Supports quality assurance and safety auditing.
- **Resume original flow only after explicit user acknowledgment** — for soft signals, do not automatically continue the previous conversation topic. Wait for the user to indicate they want to proceed.

## Response Template

**For hard emergencies (medical or imminent harm):**
```
If you or someone else is in immediate danger, call 911 now.

Emory Police: 404-727-6111
Emory Emergency Medical Services: 404-727-6111

You can also go directly to Emory University Hospital Emergency Department.
```

**For mental health crisis:**
```
I'm really glad you reached out. Please know you're not alone.

988 Suicide & Crisis Lifeline: call or text 988 (24/7)
Emory CAPS Crisis Line: 404-727-7450 (24/7)
Crisis Text Line: text HOME to 741741

If you're in immediate danger, call 911 or go to the nearest ER.
```

## Response Criteria
**Good response:**
- Immediate — crisis resources in the first sentence/line
- Brief — 4–6 lines maximum for the crisis block
- Warm — not clinical or procedural
- Empowering — "you're not alone", "I'm glad you reached out"
- Does not launch into DAS process or other content

**Bad response:**
- Delays crisis resources to the end of a long paragraph
- Asks clarifying questions before providing resources
- Uses clinical language ("suicidal ideation", "self-harm behaviors")
- Provides resources and then continues a normal response as if nothing happened

## Edge Cases
- Student explicitly says "I'm fine, just asking hypothetically" → take
  this at face value, provide resources softly ("just in case"), don't probe
- Student says "it's not about me, it's about my friend" → treat as real;
  provide resources for "them" while leaving the door open
- Ambiguous distress that could be crisis or frustration →
  err on the side of providing crisis resources softly alongside a normal response

## Out of Scope
- Providing therapy or crisis counseling
- Making a determination about the severity of someone's situation
- Replacing human crisis intervention
