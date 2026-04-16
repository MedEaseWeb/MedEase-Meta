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

**Note:** ADR-007 (legacy cleanup, 2026-04-16) removed `google.py`, `caregiver.py`,
`medication.py`, and `simplify.py`. This eliminates the `googleCalendar`, `gmail`,
`medication`, `medicalReport`, `patientData`, and `patientDiary` collections from
scope. Only `userInfo`, `waitlist`, and `patientKeys` remain active.

---

## Step-by-Step Migration Guide

Work on branch `feat/firestore-migration`. All steps below are in sequence.

---

### Phase 1 — GCP + Firebase Console Setup

**Step 1 — Enable Firebase on the existing GCP project**
- Go to [console.firebase.google.com](https://console.firebase.google.com)
- Click "Add project" → select existing GCP project `medease-491604`
- This links Firebase to the project without creating a new one

**Step 2 — Enable Firestore in native mode**
- Firebase Console → Build → Firestore Database → Create database
- Choose **Native mode** (not Datastore)
- Region: `us-central1` (matches Cloud Run)

**Step 3 — Enable Firebase Auth**
- Firebase Console → Build → Authentication → Get started
- Enable **Email/Password** provider
- Enable **Google** provider (use existing OAuth client ID + secret from GCP — same credentials as the old `google.py` stack)

**Step 4 — Generate a service account key for the backend**
- Firebase Console → Project Settings (gear icon) → Service accounts
- Click "Generate new private key" → download `firebase-service-account.json`
- **Do not commit this file** — add to `.gitignore`
- Store it as a Cloud Run secret (see Step 13)

**Step 5 — Sign the GCP BAA**
- Cloud Console → IAM & Admin → Compliance → accept the BAA
- Self-service, no cost, covers Cloud Run + Firestore + GCS

---

### Phase 2 — Backend: Firebase Admin SDK

**Step 6 — Install Firebase Admin SDK**
```bash
pip install firebase-admin
pip freeze > requirements.txt
```

**Step 7 — Create `src/firebase.py`**
```python
import os
import firebase_admin
from firebase_admin import credentials, firestore, auth as firebase_auth

_cred = credentials.Certificate(os.environ["FIREBASE_SERVICE_ACCOUNT_PATH"])
firebase_admin.initialize_app(_cred)

db = firestore.AsyncClient()          # async Firestore client
firebase_auth = firebase_auth         # re-export for route use
```
In Cloud Run, `FIREBASE_SERVICE_ACCOUNT_PATH` points to the mounted secret file.
Locally, point it at the downloaded JSON.

**Step 8 — Replace `src/database.py`**
Remove the Motor/MongoDB connection entirely. Replace all `motor_collection` references
with Firestore collection references imported from `src/firebase.py`. Active collections
after ADR-007:
- `waitlist` → `db.collection("waitlist")`
- `patientKeys` → `db.collection("patientKeys")`

Keep `src/database.py` as the import point (so route files don't need path changes):
```python
from src.firebase import db
waitlist_collection   = db.collection("waitlist")
patient_key_collection = db.collection("patientKeys")
```

**Step 9 — Rewrite `src/utils/jwtUtils.py` → `src/utils/firebaseAuth.py`**
Replace the custom JWT decode with Firebase ID token verification:
```python
from firebase_admin import auth as firebase_auth
from fastapi import HTTPException, Request

async def get_current_user(request: Request) -> str:
    token = request.cookies.get("access_token")
    if not token:
        raise HTTPException(status_code=401, detail="Not authenticated")
    try:
        decoded = firebase_auth.verify_id_token(token)
        return decoded["uid"]          # Firebase UID replaces custom user_id
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
```
Update all `Depends(get_current_user)` imports in `auth.py` and `general.py`.

**Step 10 — Rewrite `src/routes/auth.py`**

*Registration* (`POST /auth/register`):
```python
user = firebase_auth.create_user(email=email, password=password)
# No Firestore doc needed — Firebase Auth owns identity
```

*Login* (`POST /auth/login`):
Firebase Admin SDK cannot verify passwords server-side. Use the Firebase REST API:
```
POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_WEB_API_KEY}
Body: { email, password, returnSecureToken: true }
```
On success, set the returned `idToken` as an `httponly` cookie (same pattern as current).
Add `FIREBASE_WEB_API_KEY` to `.env` (found in Firebase Console → Project Settings → General → Web API Key).

*Logout* (`POST /auth/logout`): delete the cookie — unchanged.

*Refresh* (`POST /auth/refresh`): Firebase ID tokens expire after 1 hour. The Firebase
JS SDK handles refresh automatically on the client. Remove the server-side refresh
endpoint or make it a no-op (cookie is refreshed client-side and re-sent on next request).

*Get user* (`GET /auth/user`):
```python
user = firebase_auth.get_user(uid)
return { "user_id": uid, "email": user.email }
```

**Step 11 — Update `src/routes/general.py`**

- `GET /general/email`: call `firebase_auth.get_user(uid).email` instead of MongoDB lookup
- `POST /general/generate-key`: write to `db.collection("patientKeys").document(user_id).set({...})`
- `POST /general/resolve-user-id`: use `firebase_auth.get_user_by_email(email).uid`

**Step 12 — Update `src/routes/waitlist.py`**
Firestore write instead of MongoDB insert:
```python
doc_ref = db.collection("waitlist").document()
await doc_ref.set({ "email": entry.email, "created_at": firestore.SERVER_TIMESTAMP })
```
Duplicate check: `db.collection("waitlist").where("email", "==", entry.email).get()`

**Step 13 — Add env vars to Cloud Run**

```bash
# Store service account JSON as a Cloud Run secret
gcloud secrets create firebase-service-account --data-file=firebase-service-account.json
gcloud run services update medease-backend \
  --region us-central1 \
  --set-secrets FIREBASE_SERVICE_ACCOUNT_PATH=firebase-service-account:latest \
  --set-env-vars FIREBASE_WEB_API_KEY=<your-web-api-key>
```

Remove from `.env`: `MONGO_URI`, `JWT_SECRET`, all collection name vars.
Add to `.env`: `FIREBASE_SERVICE_ACCOUNT_PATH`, `FIREBASE_WEB_API_KEY`.

---

### Phase 3 — Frontend: Firebase JS SDK

**Step 14 — Install Firebase JS SDK**
```bash
cd frontend && npm install firebase
```

**Step 15 — Create `src/firebase.js`**
```js
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: "medease-491604.firebaseapp.com",
  projectId: "medease-491604",
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
```
Add `VITE_FIREBASE_API_KEY` to `frontend/.env` and to the Cloudflare Pages env vars.

**Step 16 — Rewrite `src/context/AuthContext.jsx`**
Replace custom JWT fetch with Firebase SDK:
```js
import { signInWithEmailAndPassword, createUserWithEmailAndPassword,
         signOut, onAuthStateChanged } from "firebase/auth";
import { auth } from "../firebase";

// Login: signInWithEmailAndPassword(auth, email, password)
//        → on success, getIdToken() → send to backend to set httponly cookie
// Register: createUserWithEmailAndPassword(auth, email, password)
// Sign out: signOut(auth) + call POST /auth/logout to clear cookie
// Auth state: onAuthStateChanged(auth, user => ...) replaces polling /auth/user
```

**Step 17 — Update `src/pages/auth/Login.jsx` and `SignUp.jsx`**
Wire to Firebase SDK methods from Step 16. Remove direct calls to `POST /auth/login`
and `POST /auth/register` (or keep them as the bridge that sets the httponly cookie).

---

### Phase 4 — Decommission MongoDB

**Step 18 — Remove MongoDB packages**
```bash
pip uninstall motor pymongo
pip freeze > requirements.txt
```
Remove from `requirements.txt`: `motor`, `pymongo`, `dnspython`.

**Step 19 — Delete `src/database.py`** (after Step 8 replacement is live)

**Step 20 — Cancel MongoDB Atlas**
- Atlas dashboard → Project → Pause/terminate cluster
- Revoke `MONGO_URI` credentials

---

### Phase 5 — Verification

**Step 21 — Local smoke test**
```bash
./dev.sh backend
# Register a new user → check Firebase Console → Authentication → Users
# Join waitlist → check Firebase Console → Firestore → waitlist collection
# Login → verify httponly cookie is set with Firebase ID token
# Hit /dashboard → verify protected route works with new token verification
```

**Step 22 — Deploy to Cloud Run**
```bash
gcloud run deploy medease-backend --source . --region us-central1 \
  --allow-unauthenticated --port 8080
```
Verify Firebase secrets are mounted correctly (Step 13).

---

*Related: [[adr-007-legacy-route-cleanup]] · [[adr-005-utils-hosted-architecture]] · [[hipaa-overview]] · [[adr-002-phi-deidentification-strategy]] · [[feature-registry]]*

---

*Related: [[adr-005-utils-hosted-architecture]] · [[hipaa-overview]] · [[adr-002-phi-deidentification-strategy]] · [[feature-registry]]*
