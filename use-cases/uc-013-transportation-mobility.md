# UC-013: Transportation & Mobility Access

## User Goal
Navigate campus transportation as a student with a mobility disability —
including accessible parking, shuttle services, or campus navigation support.

## Who Triggers This
A student with a mobility-related disability (physical disability, temporary
injury, chronic fatigue, etc.) who needs to get around campus and wants to
understand what Emory provides. May include students with invisible
disabilities who find long walks difficult.

## Intent Signals
- "accessible parking at Emory"
- "disability parking permit"
- "how do I get around campus with a wheelchair"
- "mobility shuttle"
- "I can't walk far, what are my options"
- "cart service for students with disabilities"
- "campus accessibility map"
- "I broke my leg, can I get transportation help"
- "golf cart service"

## Agent Workflow
1. **Guardrail** — passes.
2. **Intent Classifier** → routes to RAG Agent.
3. **RAG Agent** — queries DAS corpus for:
   - Campus mobility accommodation services (cart service, accessible routes)
   - Parking accommodation process (DAS + state disability parking permit)
   - Accessibility features of Emory's campus
   - Temporary vs. permanent mobility accommodations
4. **Response** — practical, location-specific guidance where possible.

## Actions
- **Generate a mobility accommodation request summary** — a structured card the student can reference or forward: accommodation type (cart service / accessible parking / campus route support), whether temporary or permanent, DAS as the initiating contact. Includes a "Submit Through DAS" CTA.
- **Generate a temporary accommodation fast-track card** — for students with recent injuries, produce a specific card noting that temporary accommodations typically process faster and what to bring to DAS (provider note, cast/brace documentation).
- **Render an ESA vs. Service Animal card** — if an animal-related request surfaces, immediately produce the two-column comparison card distinguishing rights and process (links to UC-007 for the full housing flow).
- **Inject DAS contact CTA** — "Request Mobility Accommodation" button to DAS portal; injected on every UC-013 response as the primary action.

## Information Sources
- DAS corpus: transportation and mobility services
- Note: real-time shuttle schedules or route updates are outside our scope

## Response Criteria
**Good response:**
- Distinguishes between DAS cart/mobility service and general accessible transit
- Notes that parking accommodations may require both a DAS accommodation
  AND a state-issued disability parking permit
- Addresses temporary injuries (broken leg, surgery recovery) — these can
  often get temporary accommodations quickly
- Points to DAS as the starting point for all of the above

**Bad response:**
- Assumes the student is using a wheelchair (mobility needs are diverse)
- Doesn't address temporary disability situations
- Gives static shuttle schedule info that may be outdated

## Edge Cases & Handoffs
- Student has a temporary injury (cast, post-surgery) → note that temporary
  accommodations exist, process is typically faster than permanent
- Student is asking about wheelchair accessibility of a specific building →
  we can note general campus accessibility resources but can't do building-by-
  building audits; direct to DAS or Facilities
- Student has an invisible disability (chronic fatigue, pain) that limits
  mobility → validate that mobility accommodations aren't only for visible
  disabilities; proceed as normal

## Out of Scope
- Real-time shuttle tracking
- Building-specific accessibility audits
- Off-campus transportation (Emory's obligations end at the campus boundary
  for most purposes)
