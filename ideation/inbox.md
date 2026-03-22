# Ideation Inbox

Append-only. Add ideas here as they occur — no polish required, no
commitment implied. Date-stamp every entry.

**Graduation path:**
- Stays here → idea wasn't worth developing (that's fine)
- Moves to `concepts/` → worth fleshing out before planning
- Moves to `planning/short-term.md` backlog → approved for development

---

<!-- Entries below, newest at top -->

## 2026-03-22 — Beyond-chatbot: agentic tools and active capabilities

MedEase should do things for users, not just answer questions. Three distinct jobs:
- **Remove a step** the student would otherwise do manually
- **Surface the right thing at the right time** (proactive, context-aware)
- **Bridge a gap** between what the student knows and what the system expects

Ideas grouped by category below. No commitment implied — all at ideation stage.

### Scheduling & Calendar
- Add accommodation deadlines and DAS intake prep to Google/Apple Calendar via function call
- Batch semester-start calendar events: submit letters to professors, testing scheduling windows, CAPS appointment
- Medication reminders (recurring calendar hook, no clinical involvement)
- Deadline awareness: if user mentions an upcoming exam in chat, flag if testing scheduling window is closing

### Site Triage & Navigation
- Preview exact relevant page inline (fetch + summarize specific section) rather than linking to a homepage
- Deep-link to exact form or page, not just the domain
- Rank 2–3 sources by relevance with one-line descriptions
- Flag potentially stale content ("this page was last updated in 2023")

### Document Generation & Drafting
- Professor email drafting (UC-006) as a structured tool: fill in [professor], [course], [accommodation] → ready-to-copy draft
- DAS appeal letter generator: student describes situation, MedEase drafts formal appeal
- Documentation request letter for providers: pre-formatted letter explaining what DAS needs, student brings to appointment
- Personalized DAS registration checklist based on stated condition(s)
- Rights card: one-paragraph plain-language ADA/504 summary the student can screenshot

### Document Understanding (User Uploads)
- Medical letter analyzer: parse uploaded PDF, flag which DAS requirements are met vs. missing
- Accommodation letter simplifier: translate dense DAS letter into plain language
- Medical bill explainer: parse EOB or bill, explain line items and next steps
- Photo of a document: user photographs a letter, prescription, or form; MedEase parses it

### Proactive / Push Interventions
- Semester-start nudge: "You have accommodations on file — have you submitted letters to professors?"
- Deadline proximity alert: detects exam mention + calculates if testing scheduling window is about to close
- Medication refill forecast based on stated supply + date
- Follow-up threads: "Last time you asked about appealing your DAS decision — want to continue?"

### Status & Progress Tracking
- DAS registration state machine: Applied → Docs submitted → Intake scheduled → Accommodations issued → Letters sent
- Accommodation letter tracker: which professors notified, which pending
- Action item extraction: end of any conversation, offer "here are your 3 next steps" as a saveable checklist
- Accommodation usage tracker: how many times each accommodation used this semester (useful for renewal)
- Gap detector: "You have a note-taking accommodation but haven't mentioned using it"

### Interactive Decision Trees
- "Where should I go right now?" wizard: symptom-driven step-by-step ending at a specific Emory resource with hours + map link
- "Which CAPS service fits me?" guided selector
- "Am I ready to register with DAS?" readiness check: walks through diagnosis, documentation, availability

### Provider & Resource Finder
- Documentation provider locator: find providers near Emory who can write DAS-eligible evaluations
- "What to say to your doctor" script generator: bridges what DAS needs and what students know to ask for
- Specialist referral context: what to bring to a referred appointment re: accommodations

### Live Campus Awareness
- Real-time hours check before telling a student to go somewhere (prevents "it was closed" situations)
- CAPS Let's Talk today: detect if a drop-in session is happening today, where, when
- Quiet/accessible space finder: library floors, study rooms, accessible buildings

### Smart Document Assembly
- "DAS packet" builder: persistent checklist of every required item with completion status
- Letter template for provider: formatted letter student can hand to their doctor
- Session summary: end of conversation → action items + optional calendar add

### Canvas / Academic System Awareness
- Syllabus parser: user uploads syllabus PDF, MedEase extracts exam dates and maps against DAS scheduling windows
- Course load advisor: flags if credit load may conflict with a stated accommodation
- Semester-long accommodation action plan from parsed syllabus

### Communication Hub
- Send email directly via mailto: link or email integration (one-click after draft)
- DAS communication log: structured record of all DAS interactions inferred from conversation history, exportable
- Follow-up email generator: "10 days since intake, no response — here's a polite follow-up"

### Peer Intelligence (Aggregated, Anonymous)
- "Students with similar situations asked..." — related questions surfaced from aggregate query patterns
- Common friction points by department or accommodation type
- Anonymized accommodation outcome patterns: "Students with ADHD documentation most commonly receive X, Y, Z"

### Health Timeline & Continuity
- Symptom log: structured timeline maintained across sessions, shareable with a provider
- "Bring this to your appointment" summary: concise history generated before a Student Health/CAPS visit
- Transition support: student leaving Emory gets a summary of accommodations, providers, and resources to take with them

### Multimodal Inputs
- Voice input as first-class mode (relevant for motor disabilities, dyslexia, anxiety)
- Paste a URL: MedEase fetches and summarizes it in context of the student's question

### Meta-MedEase
- Onboarding flow: 3 questions on first visit → routed to most relevant starting point instead of blank chat
- Export conversation history as PDF
- "Summarize everything MedEase helped me with this semester"

### Caregiver Mode Tools *(future — UC-014 deferred)*
- Student-controlled shared accommodation summary: student chooses what a caregiver can see
- Caregiver action guide: how to help without taking over

---

## 2026-03-22 — Multi-source RAG corpus expansion

Current corpus is DAS-only (`accessibility.emory.edu`). To handle broader student health
questions (e.g. "I have X condition, what Emory resources exist?", "ER vs. urgent care?"),
we need additional Emory public sources scraped into the RAG pipeline with source tagging.

**Verified Emory public sources and their coverage:**

| Source | URL | Covers | Priority |
|--------|-----|---------|----------|
| Student Health Services | `studenthealth.emory.edu` | Services, triage guidance, walk-in hours, referrals | High |
| CAPS (Counseling) | `counseling.emory.edu` | Mental health services, Let's Talk, crisis line, appointment types | High |
| Emory Healthcare Patient Resources | `emoryhealthcare.org/patients-visitors/patient-resources` | Patient portal, billing, condition-level patient education | High |
| Center for Student Wellbeing | `wellbeing.emory.edu` | Holistic wellness programs, non-clinical support | Medium |
| Student Wellbeing Portal | `studentwellbeing.emory.edu` | Crisis line, wellness resources hub | Medium |
| Health Promotion | `healthpromotion.emory.edu` | Wellness programming, health education | Low |
| Financial Aid | `studentaid.emory.edu` | Scholarships, emergency funds, FAFSA | Low |
| Student Accounts / Billing | `studentfinancials.emory.edu` | Tuition billing, health fee, insurance waiver | Low |

**Key design requirement:** each chunk in ChromaDB needs a `source` metadata tag
(e.g., `student-health`, `caps`, `emory-healthcare`) so agents can retrieve from the
right domain and responses can cite the source correctly.

**Worked example — "ER vs. urgent care?":**
`studenthealth.emory.edu` publishes triage guidance for exactly this question.
Scraping it means the Triage Agent can answer with Emory-specific resource names
and hours rather than generic advice.

**Candidate for:** MedEase-Utils V3 scope. Promote to `planning/short-term.md` backlog
once V2 end-to-end RAG test is complete.
