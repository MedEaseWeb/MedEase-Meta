# Conversation History — Implementation Plan

> Planning artifact for persistent chat history in MedEase-App.
> Created: 2026-04-15

---

## Problem

Chat context is currently ephemeral — the Socket.IO connection holds it in memory only.
Each page reload loses all history. The sidebar placeholder exists in the UI but does nothing.

Two related sub-problems:
1. **Persistence** — turns must survive page reloads and session gaps.
2. **Context window management** — LLM context has a token ceiling; long conversations will eventually overflow or get expensive.

---

## Phase 1 — Persistence + Consistent Windowing

**Goal:** Users see their prior conversations; backend always has stable, bounded context.

### Backend changes

1. **MongoDB schema** — new `conversations` collection:
   ```json
   {
     "_id": ObjectId,
     "user_id": "...",
     "session_id": "uuid",
     "created_at": ISODate,
     "updated_at": ISODate,
     "turns": [
       { "role": "user" | "bot", "content": "...", "timestamp": ISODate }
     ]
   }
   ```
2. **Persist on every turn** — `socket_server.py` appends each `user_message` + `bot_response` to MongoDB after the agent returns.
3. **Fetch on session init** — on `connect`, load the last N turns for the user's active session.
4. **Fixed context window** — pass only the last 10 turns to the LLM on each call (controlled in `AgentContext` or `orchestrator.py`). Simple, predictable cost.

### Frontend changes

1. **Session sidebar** — the placeholder sidebar becomes a real list of sessions, fetched on load.
2. **Load history on session select** — clicking a session fetches its turns from a new `/chat/history/{session_id}` endpoint.
3. **New session button** — creates a new session UUID; clears the chat window.

---

## Phase 2 — Rolling Summarization (when history > 20 turns)

**Goal:** Support longer conversations without ballooning token costs.

### Strategy

- When a session exceeds 20 turns, replace the oldest 10 turns with a single GPT-generated summary chunk.
- Summary is stored back in MongoDB alongside raw turns (raw turns never deleted).
- On context rebuild: summary (as a `system` message) + recent 10 turns = bounded, coherent context.

### Trigger

- Run summarization lazily on turn 21 (first time threshold is crossed).
- Can be run async in a background task so it doesn't block the streaming response.

### Summary prompt

```
Summarize the following conversation turns concisely.
Preserve: the user's key questions, any accommodations discussed,
any commitments or action items the assistant made.
[turns 1–10 here]
```

---

## Decision criteria

- Phase 1 ships when conversation history is formally approved in the feature registry.
- Phase 2 ships when a real user session demonstrates the need (monitor turn counts post-launch).

---

## Open questions

- **Session model**: one session per login, or user-created named sessions? Start with one-per-login, promote to named sessions later.
- **Retention policy**: indefinite for now; add TTL index if storage cost becomes a concern.
- **BAA implication**: if conversations contain PHI (symptoms, diagnoses), they must be stored in a HIPAA-covered environment. MongoDB Atlas BAA must be signed before Phase 1 ships to institutional users. See [[hipaa-overview]].

---

*Related: [[feature-registry]] · [[short-term]] · [[adr-002-phi-deidentification-strategy]] · [[hipaa-overview]]*
