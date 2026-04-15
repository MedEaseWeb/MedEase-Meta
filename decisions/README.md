# Decisions

Architecture Decision Records (ADRs) — one file per significant decision.

## Naming convention

`adr-NNN-short-title.md`

NNN is zero-padded (001, 002, ...). Short title is kebab-case.

## What counts as a significant decision?

- Technology choices (stack, vendor, protocol)
- Architecture changes that affect multiple sub-projects
- Explicit decisions to *not* build something and why
- Resolutions of disagreements between Rolf and Annie

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [ADR-001](adr-001-corpus-handoff.md) | Corpus handoff — manual sync + GCS migration path | Accepted |
| [ADR-002](adr-002-phi-deidentification-strategy.md) | PHI de-identification strategy | Accepted |
| [ADR-003](adr-003-i18n-multilingual-strategy.md) | i18n multilingual strategy | Accepted |
| [ADR-004](adr-004-demo-uiux-layout.md) | Demo UI/UX layout | Accepted |
| [ADR-005](adr-005-utils-hosted-architecture.md) | Utils hosted architecture — Cloud Run Jobs, GCS corpus, MongoDB run metadata | Accepted |
| [ADR-006](adr-006-firestore-firebase-auth-migration.md) | Migrate from MongoDB + custom JWT to Firestore + Firebase Auth | Accepted |
| [ADR-007](adr-007-legacy-route-cleanup.md) | Remove legacy routes, services, and frontend pages (medication, caregiver, simplify, google OAuth) | Accepted |

## Claude Code's responsibility

Draft the ADR in the same session the decision is made.
Don't let it drift to memory only.
