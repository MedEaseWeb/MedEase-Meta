# MedEase Pivot Research Plan

**Date:** 2026-04-17  
**Window:** Now → 4:00 PM (2 sessions × 30 min)  
**Goal:** Determine if the hospital reimbursement penalty model applies to MedEase at universities — and if not, identify the lowest-liability pivot.

---

## Session 1 · Now – 2:30 PM
### Can the reimbursement penalty model apply to MedEase at universities?

**Core analogy to stress-test:**  
Hospitals lose CMS reimbursement for missing metrics (readmission rates, HCAHPS scores). Can universities lose something measurable if student health outcomes are poor — and does MedEase plug that gap?  
Think: accreditation pressure, Title IX/ADA compliance costs, mental health mandate reporting, student retention revenue tied to health utilization.

---

### Q1 — Is there a "penalty" mechanism?
Do schools face financial or reputational consequences tied to student health metrics?

Research targets:
- Accreditation bodies (SACSCOC, HLC, WASC) — do health service standards affect reaccreditation?
- Federal compliance: Title IX, ADA, Section 504 — measurable enforcement actions or cost triggers?
- Mental health mandates: state-level laws (e.g. CA SB 768, NY campus mental health bills) — reporting requirements with teeth?
- Rankings: NSSE, Princeton Review, U.S. News — do health/wellness scores affect enrollment demand?

---

### Q2 — Is the metric measurable + attributable?
Can MedEase plausibly claim to move one of these metrics?

| Metric | Measurability | MedEase Attribution | Notes |
|---|---|---|---|
| Medical leave / withdrawal rate | High (registrar data) | Indirect | Long lag, confounders |
| ER diversion rate | High (insurance/health center) | Moderate | Cleaner if tied to on-campus utilization |
| Insurance claim frequency | High (student health plan) | Moderate | Requires insurer partnership |
| Time-to-care (appointment wait) | High (EHR/scheduling) | Direct | Easiest to show before/after |
| Mental health utilization rate | Medium (CCMH benchmark) | Indirect | HIPAA considerations |

**Target:** Identify the single metric with the cleanest data story and lowest attribution risk.

---

### Q3 — Who controls the budget MedEase would tap?

Likely buyers:
- **Student Affairs VP** — owns wellness mandate, close to retention narrative
- **Health Center Director** — operational buyer, cost-savings angle (ER diversion, staff time)
- **CFO / Provost** — only if ROI on retention revenue is quantified ($X per student retained)
- **IT / EdTech procurement** — if positioned as SaaS platform, not health service

Research target: find 2–3 published case studies of health-tech or wellness-tech sold to universities — who signed the contract?

---

### Session 1 Output

**Verdict:** ☐ Yes / ☐ No / ☐ Conditional

If **Conditional** — specify:
- The one metric that makes it work: ___
- The one buyer who controls that budget: ___
- The minimum evidence MedEase needs to claim the metric: ___

If **No** — proceed to Session 2.

---

## Session 2 · 2:30 – 4:00 PM
### If healthcare is too risky, what's the lowest-liability pivot?

*(Enter only if Session 1 verdict = No or Conditional)*

---

### Pre-check (first 10 min): Does a strong incumbent already own academic navigation?

Incumbents to evaluate:

| Product | Funding / Scale | Core Use Case | Weakness / Wedge? |
|---|---|---|---|
| EAB Navigate | Large, enterprise | Advisor workflow, early alerts | Advisor-facing, not student-facing |
| Civitas Learning | Mid-market | Predictive analytics | Backend tool, no student UI |
| Stellic | VC-backed | Degree audit, 4-year planning | Limited agentic / conversational layer |
| Coursicle | Consumer | Course scheduling, waitlists | No institutional contracts |
| Degree Planner (Ellucian, etc.) | ERP bundle | Degree audit | Locked in legacy ERP, bad UX |

**Decision gate:** If a well-funded incumbent owns the exact wedge → move on. If UX gap or agentic layer is missing → continue.

---

### If gap exists — what's the actual use case?

Candidates ranked by student pain × willingness to pay:

1. **Waitlist navigation** — high urgency, time-sensitive, clear outcome
2. **Major exploration / what-if planning** — high engagement, lower urgency
3. **Course selection + prerequisite mapping** — moderate pain, solved partially by incumbents
4. **Degree audit Q&A** — high value for advisors, lower for students directly

**MedEase stack reuse check:**
- RAG over course catalog, degree requirements, prerequisite chains → direct reuse
- Agentic scheduling / form-fill → reuse with new domain adapters
- Health-specific compliance layer → can be stripped or repurposed for FERPA context

---

### Session 2 Output

**One-line pivot hypothesis:**  
> MedEase becomes ___ [use case] for ___ [buyer/user] by doing ___ [unique wedge] that ___ [incumbent] doesn't do.

**Competitive landscape verdict:** ☐ Clear gap / ☐ Crowded, move on / ☐ Needs more research

**Week 2 decision:** ☐ Pursue academic nav pivot / ☐ Return to healthcare with refined model

---

## Decision Tree Summary

```
Session 1 verdict
    │
    ├── YES → Stay in healthcare, refine metric + buyer, build data story
    │
    ├── CONDITIONAL → Define the specific metric + buyer combo; de-risk before week 2
    │
    └── NO → Session 2
              │
              ├── Incumbent gap found → Build pivot hypothesis, test in week 2
              │
              └── No gap → Back to healthcare with refined model or new vertical
```

---

## Open Questions (carry forward)

- [ ] Does MedEase have IRB or HIPAA exposure at universities vs. hospitals?
- [ ] What's the student data ownership model under FERPA for academic nav?
- [ ] Are there any university pilots or LOIs already in place that constrain the pivot?
