# Stateless Architecture — Thought Experiment

> Date: 2026-03-23
> Origin: Conversation between Rolf and Claude Code
> Status: Rejected — full stateless conflicts with product vision; middle-ground ideas (client-side storage, federated identity) preserved in memory

---

**The case for it is real — mainly on compliance.**

Going stateless eliminates Pillar 1 almost entirely. If you don't store user data, there's no PHI at rest, no BAA needed for storage, and the MongoDB compliance question goes away. It's the strongest possible privacy posture. For a healthcare-adjacent app trying to avoid HIPAA exposure before incorporation, there's a genuine argument here.

**But it cuts directly against your product vision.**

Look at the 2026-03-22 ideation entry — virtually everything valuable in there requires state:

- DAS registration state machine (Applied → Docs submitted → Letters sent)
- Follow-up threads ("Last time you asked about your DAS appeal...")
- Semester-start nudges, deadline proximity alerts
- "Summarize everything MedEase helped me with this semester"
- Accommodation letter tracker

These aren't nice-to-haves. They're the things that make MedEase a *tool* rather than a wrapper around ChatGPT. Full stateless gives you a better-branded chatbot, not the product you're building.

**The more interesting version of this question is: where can you minimize server-side state?**

Two specific ideas worth exploring:

1. **Client-side conversation history.** Store chat history in `localStorage` rather than MongoDB. The server stays stateless; the data stays on the user's device. HIPAA obligations are significantly reduced — if PHI never leaves the client, server-side exposure drops sharply. Tradeoff: no cross-device continuity, data lost if browser is cleared.

2. **Federated identity only.** Don't store user profiles yourself — consume identity claims from the institution's SSO (Emory uses Shibboleth) at login time only. You get "this is a verified Emory student" without holding name/email in your own database. This actually fits the B2B2C model well: the institution already owns that identity data.

**The real tension:**

The features that differentiate MedEase — continuity, longitudinal tracking, proactive nudges — are exactly the ones that require the most state. You can't have both "we store nothing" and "we know you haven't submitted your accommodation letters yet." You'll need to make a deliberate choice about *what* to store and *where*, rather than storing everything by default or nothing at all.

Full stateless is probably the wrong destination, but using it as a forcing function to minimize server-side state is a good design discipline.
