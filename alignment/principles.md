# Product & Design Principles

> These govern trade-off decisions when priorities conflict.
> Last updated: 2026-04-17

1. **Accessibility is the product, not a feature.** Every design decision
   should ask: does this make the experience more or less accessible?

2. **Students over systems.** When a technical constraint conflicts with
   a user need, the user need wins unless the constraint is fundamental.

3. **Clarity over completeness.** A response that answers 80% of a question
   clearly is better than one that answers 100% confusingly.

4. **Scope discipline.** V1 is Emory DAS. Resist expanding scope until
   the core use case is excellent.

5. **Honest about limitations.** The system should tell users what it
   can't answer and where to go instead — not hallucinate an answer.

6. **Resource-first agent design.** Agent workflows and behaviors are
   reverse-engineered from the finite set of institutional resources
   available (Emory DAS, Student Health, Counseling, etc.) — not
   bottom-up from an exhaustive list of possible user needs. When
   defining agent scope, tuning behavior, or adding use cases, ask:
   what can our sources actually support? Design to that ceiling.

7. **Separate institutional and user narratives.** MedEase operates
   B2B2C: institutions (Emory DAS, university health systems) are
   buyers and partners; students are end users. These audiences have
   different motivations and trust signals. Institution-facing
   communication emphasizes reliability, sourcing, and administrative
   value. User-facing communication emphasizes ease, guidance, and
   feeling supported. Never conflate them in the same pitch, doc, or
   feature rationale.

8. **Browse first, search as the upgrade.** Users navigating unfamiliar
   domains (which most DAS-navigating students are) often lack the
   vocabulary to form a precise search query. Lead with a browsable
   resource structure — it lowers friction and builds institutional
   trust. AI-powered search is the differentiator that makes the hub
   better than a static directory, not the primary entry point. Design
   so browsing and search reinforce each other.

---

*Related: [[north-star]] · [[feature-registry]] · [[roadmap]]*
