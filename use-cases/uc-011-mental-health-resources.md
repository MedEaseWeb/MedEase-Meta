# UC-011: Mental Health Resources

## User Goal
Find mental health support at Emory — whether that's counseling services,
crisis support, or understanding how mental health conditions relate to
DAS accommodations.

## Who Triggers This
A student struggling with mental health who wants to find resources on campus.
May be a first-time help-seeker or a student whose existing mental health
condition is affecting their academics. This is a sensitive category — tone
and safety awareness are critical.

## Intent Signals
- "I need to talk to someone"
- "counseling at Emory"
- "I'm struggling mentally"
- "anxiety / depression affecting my classes"
- "can I get accommodations for anxiety"
- "mental health DAS"
- "therapy on campus"
- "I'm overwhelmed"
- "CAPS" (Emory's Counseling and Psychological Services)

## Agent Workflow
1. **Guardrail** — always run a safety screen here before any other routing.
   If distress signals present → UC-015 overlay (provide crisis resources
   alongside the response, not instead of it).
2. **Intent Classifier** → routes to RAG Agent (for DAS/accommodation angle)
   and Triage Agent (for urgency/severity check).
3. **RAG Agent** — if accommodation-focused:
   - Queries DAS corpus for mental health condition accommodation examples
   - Documentation requirements for mental health diagnoses
4. **Triage Agent** — assesses urgency of mental health distress:
   - Routine: recommend CAPS appointment scheduling
   - Moderate distress: same-day CAPS consultation or Let's Talk drop-ins
   - Crisis signals → UC-015
5. **Response** — warm, non-clinical tone; lead with the resource, not a
   clinical assessment. Normalize help-seeking.

## Actions
- **Surface crisis resource buttons immediately** — if any distress signal is detected, render "Call or Text 988" and "Emory CAPS Crisis Line: 404-727-7450" as prominent action buttons at the top of the response, regardless of the original question. These always appear before any other content when distress is present.
- **Generate a CAPS / Let's Talk access card** — a structured card with: CAPS scheduling link, Let's Talk drop-in schedule and locations, same-day consultation option. Rendered as a resource card, not a paragraph.
- **Generate a DAS mental health accommodation checklist** — if the student indicates their mental health condition is affecting academics, immediately produce the checklist: (1) gather documentation from therapist/psychiatrist, (2) register or update with DAS, (3) request academic accommodation letter. Offer to transition to UC-002.
- **Hard-route to UC-015** — on any hard crisis signal, override all other actions and inject the crisis response card first.

## Information Sources
- DAS corpus: mental health accommodations
- Emory CAPS resources, Let's Talk program, crisis lines
- Triage agent: urgency calibration

## Response Criteria
**Good response:**
- Leads with warmth and normalizes the situation
- Provides specific Emory resources (CAPS phone, Let's Talk times)
- If accommodation-related: connects to DAS process without making it feel
  transactional
- Always includes crisis line in a non-alarming way if distress is present
- Does not diagnose or label the student's mental health condition

**Bad response:**
- Clinical or cold tone
- Immediately jumps to DAS documentation requirements when student is distressed
- Misses distress signals and answers procedurally
- Promises therapy availability without checking waitlist reality

## Edge Cases & Handoffs
- Any mention of self-harm, suicidal ideation, or intent → immediate
  UC-015 override; provide crisis line before anything else
- Student explicitly says they're fine but just want resources → take at
  face value, provide CAPS info, leave door open
- Student asks about wait times at CAPS → be honest that CAPS can have
  significant wait times; mention Let's Talk as a faster entry point
- Student's mental health condition affects DAS documentation → bridge
  both tracks (mental health support + DAS process) without making it feel
  like a checklist

## Out of Scope
- Providing therapy or counseling
- Diagnosing mental health conditions
- Replacing crisis intervention (that's UC-015)
