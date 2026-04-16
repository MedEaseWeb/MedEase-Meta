# ADR-007: Remove Legacy Routes, Services, and Frontend Pages

> Date: 2026-04-15
> Status: Accepted (Resolved)
> Decided by: Rolf

## Context

A full audit of MedEase-App routes and frontend pages was conducted on 2026-04-15. Three
features — medication management, caregiver dashboard, and report simplification — were
built during early prototype development and have since been hidden from the UI (routes
removed from `App.jsx`, not linked from any navigation). Their backend routes, services,
models, and frontend files remain in the codebase.

Additionally, the Google OAuth route file (`google.py`) implements a manual token management
layer that ADR-006 explicitly replaces with Firebase Auth. It contains hardcoded
`localhost:5173` and `localhost:8081` callback URLs and is not functional in production.

Together these account for approximately:
- **Backend:** 5 route files, 3 service files, 1 utility file (`s3Connection.py`),
  1 LLM wrapper (`ChatGPT.py`), 7 model files
- **Frontend:** 3 page directories, 13 component files
- **External dependencies removed:** AWS S3 (caregiver photo uploads), BART-MNLI
  zero-shot classifier (report simplification)

Keeping dead code creates maintenance surface (every dependency upgrade, every lint pass,
every new developer reading the codebase). The features are not in the roadmap, not in
the feature registry, and not needed for the Firestore migration.

## Decision

**Delete all legacy routes, services, frontend pages, and their associated models and
external dependencies in a single cleanup PR, prior to the Firestore migration.**

Sequencing before the Firestore migration (ADR-006) is intentional: a smaller codebase
is easier to migrate, and removing the Google OAuth file avoids migrating dead code.

## What is removed

### Backend

| File | Reason |
|---|---|
| `src/routes/medication.py` | Medication feature hidden from UI; no active callers |
| `src/routes/caregiver.py` | Caregiver feature hidden from UI; uses AWS S3 |
| `src/routes/google.py` | Manual OAuth token management replaced by Firebase Auth (ADR-006); localhost-hardcoded callbacks |
| `src/routes/simplify.py` | Simplify feature hidden from UI; has `TODO: DELETE` comment |
| `src/services/simplify_service.py` | Only consumed by `/simplify` routes |
| `src/services/dummy_simplify_service.py` | Only consumed by `/simplify/dummy-stream` |
| `src/services/classifier_service.py` | Only consumed by `/simplify/classify`; BART-MNLI dependency |
| `src/LLMmodel/ChatGPT.py` | Only consumed by `/medication/extract-medication` |
| `src/utils/s3Connection.py` | Only consumed by `/caregiver` AWS S3 endpoints |
| `src/models/medicationModel.py` | Only `/medication` routes |
| `src/models/diaryModel.py` | Only `/caregiver/diary-entry-upload` |
| `src/models/gmailModel.py` | Only `/google` Gmail routes |
| `src/models/googleCalendarModel.py` | Only `/google` Calendar routes |
| `src/models/patientDataModel.py` | Only `/caregiver/patient-data` |
| `src/models/careGiverModel.py` | Only caregiver feature |
| `src/models/simplificationModel.py` | Only `/simplify` routes |
| `src/models/request_model.py` | Only `SimplifyRequest` for `/simplify` routes |

`main.py` — remove the 4 router imports and `include_router` calls for medication,
caregiver, google, and simplify.

`requirements.txt` — remove `boto3` (AWS S3), `torch` / `transformers` (BART),
`anthropic` or other unused LLM client packages if present.

### Frontend

| Directory | Files | Reason |
|---|---|---|
| `src/pages/careGiver/` | 6 files | Routes removed from App.jsx |
| `src/pages/medication/` | 4 files | Routes removed from App.jsx |
| `src/pages/reportsimplification/` | 3 files | Routes removed from App.jsx |

### What is NOT removed yet

| File | Reason to keep |
|---|---|
| `src/routes/auth.py` | Still used by `/dev/login`, `/dev/signup`; replaced in ADR-006 migration |
| `src/routes/general.py` | `GET /email` used by SettingsPage; `generate-key` / `resolve-user-id` deferred to caregiver feature deletion (low risk, harmless) |
| `src/utils/jwtUtils.py` | Still used by all protected routes; replaced in ADR-006 migration |
| `src/models/userModel.py` | Still used by `/auth` and `/general`; replaced in ADR-006 migration |
| `src/routes/waitlist.py` | Active — landing page waitlist join |

`general.py`'s two caregiver-only endpoints (`/generate-key`, `/resolve-user-id`) can be
removed in the same PR or deferred — they are harmless but dead.

## Consequences

**Easier:**
- Firestore migration (ADR-006) targets a smaller, cleaner codebase.
- AWS S3 vendor relationship eliminated — no BAA concern, no credentials to rotate.
- BART-MNLI model dependency removed — Cloud Run Docker image shrinks significantly;
  eliminates the lazy-load workaround in `classifier_service.py`.
- `torch` and `transformers` removed from `requirements.txt` — faster `pip install`,
  smaller container image.
- No more dead route surface for security scanning, lint errors, or confused future readers.

**Harder / trade-offs:**
- These features cannot be trivially recovered from the working directory after deletion.
  Git history preserves them; recovery is possible but intentional.
- If medication or caregiver features are ever rebuilt, they will be rebuilt against
  Firestore + Firebase Auth (not MongoDB + custom JWT) — this is the correct target
  architecture anyway.

**Follow-up actions required:**
1. Delete the 17 backend files listed above
2. Remove the 4 router `include_router` calls from `main.py`
3. Remove `boto3`, `torch`, `transformers` from `requirements.txt` (verify no other consumer first)
4. Delete the 3 frontend page directories
5. Redeploy backend to Cloud Run — image should be materially smaller
6. Update `MedEase-App/CLAUDE.md` to remove stale references to these features

---

*Related: [[adr-006-firestore-firebase-auth-migration]] · [[feature-registry]] · [[short-term]]*
