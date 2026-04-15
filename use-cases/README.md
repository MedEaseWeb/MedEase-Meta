# Use Cases — Agent Behavior Specifications

> Last updated: 2026-04-14

This folder defines the concrete use cases MedEase is designed to handle and
specifies expected agent behavior for each one. Each use case is a distinct
interaction pattern with a specific user goal, a defined agent workflow, and
explicit rules for what to do at the boundaries.

---

## Purpose

The [[feature-registry]] tracks *what* is built.
This folder tracks *how* each agent should behave for each specific scenario
a user might arrive with. These specs are the source of truth for:

- Intent classification logic (what triggers this use case)
- Which agents are invoked and in what order
- What a good response looks like vs. a bad one
- Where to escalate, redirect, or decline

---

## Domain Index

### DAS / Accommodations
| ID | Use Case |
|----|----------|
| [UC-001](uc-001-das-general-inquiry.md) | General DAS Accommodation Inquiry |
| [UC-002](uc-002-new-student-das-registration.md) | New Student Registration with DAS |
| [UC-003](uc-003-documentation-requirements.md) | Documentation Requirements |
| [UC-004](uc-004-accommodation-renewal.md) | Accommodation Renewal |
| [UC-005](uc-005-testing-exam-accommodations.md) | Testing & Exam Accommodations |
| [UC-006](uc-006-professor-communication.md) | Professor Communication Support |
| [UC-007](uc-007-housing-dining-accommodations.md) | Housing & Dining Accommodations |
| [UC-008](uc-008-grievance-appeals.md) | Grievance & Appeals Process |

### Healthcare / Clinical
| ID | Use Case |
|----|----------|
| [UC-009](uc-009-medication-management.md) | Medication Management Questions |
| [UC-010](uc-010-symptom-triage.md) | Symptom Triage |
| [UC-011](uc-011-mental-health-resources.md) | Mental Health Resources |

### Administrative / Financial
| ID | Use Case |
|----|----------|
| [UC-012](uc-012-billing-insurance.md) | Billing & Insurance Questions |
| [UC-013](uc-013-transportation-mobility.md) | Transportation & Mobility Access |
| [UC-018](uc-018-financial-assistance.md) | Emory Healthcare Financial Assistance |

### Caregiver
| ID | Use Case |
|----|----------|
| [UC-014](uc-014-caregiver-inquiry.md) | Caregiver Information Request *(deferred — V1 out of scope)* |

### App Self-Inquiry
| ID | Use Case |
|----|----------|
| [UC-017](uc-017-app-self-inquiry.md) | MedEase App Self-Inquiry |

### Safety & Edge Cases
| ID | Use Case |
|----|----------|
| [UC-015](uc-015-crisis-emergency.md) | Crisis & Emergency Detection |
| [UC-016](uc-016-out-of-scope-deflection.md) | Out-of-Scope Deflection |

---

## Use Case File Structure

Each file follows this template:

```
# UC-NNN: Title

## User Goal
One sentence: what the user is trying to accomplish.

## Who Triggers This
Who the user typically is, and what situation brought them here.

## Intent Signals
Keywords, phrases, or patterns that suggest this use case.

## Agent Workflow
Step-by-step: which agents are called, in what order, with what inputs.

## Actions
Concrete things the system does — artifacts generated, flows initiated, CTAs
surfaced, external-facing steps taken. These are not response descriptions;
they are system behaviors that produce outputs or trigger state changes.

## Information Sources
What the agent draws on to answer (corpus, user input, external resources).

## Response Criteria
What a good response looks like. What makes a response fail.

## Edge Cases & Handoffs
Where this use case bleeds into another, and how to handle it.

## Out of Scope
What this use case explicitly does NOT cover.
```

---

## Relationship to Agent Pipeline

The current agent pipeline in MedEase-App:

```
User message
  → Guardrail / Safety check
      → Intent Classifier
          → Route to agent(s):
              RAG Agent        ← DAS corpus
              Medication Agent ← medication context
              Triage Agent     ← symptom/urgency context
              Caregiver Agent  ← caregiver-specific framing
          → Synthesizer (if multi-agent)
              → Response to user
```

Each use case spec maps onto one or more nodes in this pipeline.

---

*Related: [[north-star]] · [[feature-registry]] · [[principles]]*
