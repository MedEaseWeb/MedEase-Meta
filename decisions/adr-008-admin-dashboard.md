# ADR-008: Admin Dashboard

> Date: 2026-04-18
> Status: Accepted
> Decided by: Rolf

## Context

MedEase-App has internal operational surfaces that are not user-facing but need
visibility: scraper run status, corpus freshness, indexing state, and potentially
other system-health signals as the product grows. Currently there is no place to
observe these — a scraper run succeeds or fails silently, and corpus state is only
inspectable by SSHing into Cloud Run or querying Firestore directly.

The admin dashboard provides a dedicated internal surface for operational monitoring,
scoped initially to scraper runs, with a defined extension path for future signals.

**Principle:** This surface is internal-only (Rolf / Annie) and is never exposed to
end users. It is not a product feature — it is an operational tool.

## Options Considered

**Option A: No dashboard — use GCP Console + Firestore Console directly**
Pros: Zero build cost; GCP Console already shows Cloud Run logs and Firestore data.
Cons: Fragmented across multiple GCP tabs; no at-a-glance corpus freshness view;
not usable by Annie without GCP IAM access; no custom aggregation or status signals.

**Option B: Embedded admin panel inside MedEase-App (route-gated)**
Pros: Single codebase; reuses existing auth session.
Cons: Ships admin UI to the same origin as the user-facing app; complicates
deployment and access control; risk of accidental exposure.

**Option C: Standalone admin dashboard (separate frontend, same backend)**
Pros: Clean separation from user-facing app; can be deployed independently (e.g.,
Cloudflare Pages on a separate subdomain); access gated at the route/deploy level
without touching user-facing auth flows.
Cons: Second frontend to maintain; requires its own deployment config.

## Decision

**Build a standalone admin dashboard** — separate frontend, same MedEase-App backend.

**Initial scope (V1):** Scraper monitor only.
- Display scraper run history: timestamp, source URL, status (success/error), record count, duration
- Show current corpus state: total chunks indexed, last index timestamp
- Firestore real-time listeners power live updates — no polling required (ADR-006 noted
  this as a free benefit of the Firestore migration)

**Extension path:** Additional panels (user metrics, RAG quality signals, error rates)
can be added as separate sections without touching V1 scraper monitor.

**Deployment:** Cloudflare Pages, separate project from `medease.pages.dev`.
Access restricted by obscurity for now (no public link); formal auth gate (Firebase
Auth admin role or allowlist) added before any sensitive data is surfaced.

## Consequences

**Easier:**
- Scraper run outcomes are visible without GCP Console access
- Annie can monitor corpus state without needing GCP IAM
- Firestore real-time listeners make live status updates trivial to implement
- Clear extension path for future operational signals

**Harder / ruled out:**
- Second frontend to maintain and deploy
- Admin auth (Firebase custom claims or allowlist) must be implemented before
  surfacing any data beyond run metadata

**Follow-up actions:**
- Define Firestore schema for scraper run records (written by MedEase-Utils after each run)
- Build V1 admin frontend (React/Vite, mirrors MedEase-App stack)
- Deploy to Cloudflare Pages on separate subdomain (e.g., `admin.medease.pages.dev`)
- Sequence after ADR-006 Firestore migration is complete

---

*Related: [[adr-006-firestore-firebase-auth-migration]] · [[adr-005-utils-hosted-architecture]] · [[feature-registry]]*
