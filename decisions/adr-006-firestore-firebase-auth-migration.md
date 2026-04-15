# ADR-006: Migrate from MongoDB + Custom JWT Auth to Firestore + Firebase Auth

> Date: 2026-04-15
> Status: Accepted
> Decided by: Rolf

## Context

MedEase-App currently uses MongoDB Atlas (via Motor async driver) for all persistence
and a hand-rolled auth stack (bcrypt + HS256 JWT + httponly cookies). The backend is
hosted on GCP Cloud Run. This creates three compounding problems:

**1. Two-vendor BAA problem.**
HIPAA compliance requires a BAA with every vendor that touches PHI. MongoDB Atlas BAA
requires an M10+ dedicated cluster (~$57/month minimum spend) — a significant cost for
a pre-revenue product. GCP's BAA is self-service (accepted via Cloud Console, no minimum
spend) and covers Cloud Run, Firestore, GCS, and other GCP services. Running MongoDB
alongside GCP means two separate vendor relationships and two separate BAA negotiations.

**2. Google OAuth token management is manual and scattered.**
Two MongoDB collections (`googleCalendar`, `gmail`) exist solely to store and refresh
Google OAuth access tokens. Refresh logic is called ad-hoc inside individual route
handlers before each Calendar or Gmail API call — not centralized. This is brittle and
grows more complex as more Google services are added.

**3. Auth boilerplate.**
The current stack manually handles bcrypt password hashing, JWT minting, httponly cookie
management, 30-min expiry, and token refresh + Socket.IO session sync. This is working
but is maintenance surface with no unique value.

**Timing:** MedEase-App is pre-launch (waitlist only). No real user data exists in MongoDB.
The migration cost is purely code-level — no data migration burden.

## Options Considered

**Option A: Keep MongoDB Atlas**
Pros: Already integrated; Motor driver is mature; no migration cost.
Cons: Second vendor BAA required (M10+ floor); Google OAuth token management stays
scattered; auth boilerplate stays; data exits GCP infrastructure.

**Option B: Migrate to Firestore + Firebase Auth**
Pros: Single GCP vendor; one BAA covers everything (Cloud Run + Firestore + GCS);
Firebase Auth eliminates auth boilerplate and handles Google OAuth token storage/refresh
natively; Firestore document model is conceptually similar to MongoDB — migration is
mostly SDK call substitution, not schema redesign.
Cons: Motor → Firestore SDK rewrite across all route files; Firestore query model is
more restricted (composite indexes required for multi-field queries — low risk for current
data shapes); delegated Google API access (Calendar/Gmail scopes) still requires token
handling beyond pure identity, though Firebase Auth owns the storage and refresh.

**Option C: Migrate to Cloud SQL (PostgreSQL)**
Pros: Relational model, stronger query guarantees.
Cons: Schema migrations required; async driver setup (SQLAlchemy + asyncpg); greater
structural distance from current document model; no auth simplification benefit.

## Decision

**Migrate to Firestore + Firebase Auth.**

Storage: All MongoDB collections move to Firestore collections (1:1 document model
mapping). No schema redesign required.

Auth: Firebase Auth replaces the `userInfo` collection and the entire custom JWT stack
(bcrypt, JWT minting, cookie management). Firebase ID tokens replace the custom HS256
JWTs on protected routes.

Google OAuth: Firebase Auth with Google sign-in handles Calendar and Gmail scope
requests during the initial auth flow. Firebase manages access token storage and refresh.
The `googleCalendar` and `gmail` MongoDB collections are eliminated. Delegated API calls
(add calendar event, send Gmail) read tokens from Firebase Auth rather than MongoDB.

**Collection mapping:**

| MongoDB Collection | Firestore Path | Notes |
|---|---|---|
| `userInfo` | — | Replaced by Firebase Auth; no Firestore doc needed |
| `googleCalendar` | — | Replaced by Firebase Auth token management |
| `gmail` | — | Replaced by Firebase Auth token management |
| `waitlist` | `waitlist/{docId}` | Trivial 1:1 move |
| `medication` | `medications/{userId}/entries/{docId}` | Sub-collection per user |
| `medicalReport` | `medicalReports/{userId}/reports/{docId}` | Sub-collection per user |
| `patientData` | `patientData/{userId}` | 1:1 move |
| `patientDiary` | `patientDiary/{caregiverId}/entries/{docId}` | Sub-collection per caregiver |
| `patientKey` | `patientKeys/{userId}` | 1:1 move; see refactor note below |

**Patient access key refactor:** The current `patientKey` + custom validation logic in
`/caregiver/patient-data` can be replaced with Firestore security rules enforcing
key-based document access. Deferred to post-migration cleanup — initial migration does
a 1:1 collection move first.

## Consequences

**Easier:**
- Single GCP BAA covers all infrastructure (Cloud Run + Firestore + GCS). No MongoDB
  Atlas BAA negotiation, no M10+ minimum spend.
- Google OAuth token storage and refresh removed from application code entirely.
- Auth boilerplate (bcrypt, JWT, cookie management) removed — Firebase Auth SDK handles
  registration, login, token issuance, and refresh on both client and server.
- All data stays within GCP — simplifies compliance audits and data residency assertions.
- Firestore real-time listeners are available for free — useful for admin dashboard
  (scraper run metadata updates streamed live to browser without polling).

**Harder / ruled out:**
- Arbitrary multi-field queries require explicit composite indexes in Firestore.
  Current data access patterns are simple (lookup by `user_id`, sort by `created_at`)
  and are unlikely to hit this constraint.
- Motor async driver replaced by `google-cloud-firestore` async client — all route files
  require rewrite. Mechanical but non-trivial across 6 route files.
- Firebase Auth ID tokens have a 1-hour expiry (vs. current 30-min JWT). Client must
  handle token refresh (Firebase SDK does this automatically on the client side).
- Custom HS256 JWT payload (`user_id`, `email`) replaced by Firebase ID token claims.
  Backend auth middleware must verify Firebase ID tokens instead of custom JWTs.

**Follow-up actions required:**
1. Create Firebase project under GCP (same project as Cloud Run: `medease-491604`)
2. Enable Firestore in native mode (`us-central1`)
3. Enable Firebase Auth with Email/Password + Google providers
4. Replace Motor client (`src/database.py`) with Firestore async client
5. Rewrite `src/routes/auth.py` — registration/login delegate to Firebase Auth
6. Update protected route middleware — verify Firebase ID token instead of custom JWT
7. Rewrite `src/routes/google.py` — OAuth token reads from Firebase Auth; eliminate
   `googleCalendar` and `gmail` collections
8. Migrate remaining collections to Firestore (waitlist, medication, medicalReport,
   patientData, patientDiary, patientKey) — one route file at a time
9. Update frontend auth flow — use Firebase Auth SDK client-side
10. Add `FIREBASE_PROJECT_ID` + service account credentials to Cloud Run env / secrets
11. Sign GCP BAA (Cloud Console → IAM & Admin → Compliance)
12. Update ADR-005 consequences: MongoDB scraper run metadata → Firestore `scraperRuns`
    collection (already on GCP; no separate change required)

---

*Related: [[adr-005-utils-hosted-architecture]] · [[hipaa-overview]] · [[adr-002-phi-deidentification-strategy]] · [[feature-registry]]*
