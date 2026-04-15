# RAG Corpus Registry

> Structured sitemap of all RAG knowledge sources: current, planned, and backlog.
> Last updated: 2026-04-15

This is the single source of truth for what's in the RAG vector store and what should be added.
Adding a source here is the first step before scraping or indexing.

---

## How to read this table

| Field | Meaning |
|-------|---------|
| **ID** | Sequential identifier — use when referencing a source in ADRs or issues |
| **Source** | Short name |
| **URL / Path** | Root URL scraped, or corpus path for static docs |
| **Category** | What kind of content this covers |
| **Priority** | P0 = already indexed · P1 = next sprint · P2 = near-term · P3 = backlog |
| **Status** | `live` / `planned` / `blocked` / `skipped` |
| **Chunks** | Approximate chunk count in ChromaDB (blank = not yet indexed) |
| **Notes** | Scraper version, gaps, caveats |

---

## Source Registry

| ID | Source | URL / Path | Category | Priority | Status | Chunks | Notes |
|----|--------|-----------|----------|----------|--------|--------|-------|
| C-001 | Emory DAS main site | `accessibility.emory.edu` | Disability accommodations | P0 | live | ~216 | V2 scraper; 51 records. Primary corpus. |
| C-002 | Emory Student Health | `studenthealth.emory.edu` | Healthcare navigation | P1 | planned | — | High-value for healthcare Q&A; complements C-001 |
| C-003 | Emory Counseling & Psych | `counseling.emory.edu` | Mental health | P1 | planned | — | Mental health resources, crisis support |
| C-004 | Emory Healthcare Financial Assistance | `emoryhealthcare.org/patients-visitors/patient-resources` | Financial/billing | P1 | planned | — | Motivated by UC-018; financial assistance programs, international student billing |
| C-005 | Emory ISSS | `isss.emory.edu` | International students | P2 | planned | — | Immigration + insurance info for international students |
| C-006 | Emory SDS (Student Disability Services) | `sds.emory.edu` | Disability accommodations | P2 | planned | — | Check for overlap with C-001; may have complementary content |
| C-007 | Emory HR Benefits | `hr.emory.edu/benefits` | Employee benefits/insurance | P3 | backlog | — | Relevant if we expand to staff/faculty users |
| C-008 | Emory Woodruff Health Sciences | `whsc.emory.edu` | Clinical research / patient info | P3 | backlog | — | Broader Emory Health network; assess scope before indexing |

---

## Metadata tagging (required for P1+)

When new sources are indexed, each ChromaDB chunk must include metadata fields:

```python
{
  "source_id": "C-002",          # Registry ID above
  "source_name": "Emory Student Health",
  "url": "https://studenthealth.emory.edu/...",
  "category": "healthcare_navigation",
  "scraped_date": "2026-04-XX",
}
```

This allows the RAG agent to:
- Filter retrieval by category if needed
- Surface source attribution in citations
- Track staleness per source

---

## Scraper notes

- MedEase-Utils V2 handled C-001 (`accessibility.emory.edu`).
- V3 should expand to C-002, C-003, C-004 in one pass.
- Each new source needs a scraper config block in MedEase-Utils (see `Scraping/config/` pattern).
- After scraping: copy JSON → `MedEase-App/backend/src/rag/corpus/` → `python -m src.rag.indexer`.
- See [[adr-001-corpus-handoff]] for the handoff protocol.

---

*Related: [[adr-001-corpus-handoff]] · [[feature-registry]] · [[short-term]] · use case [[use-cases/uc-018-financial-assistance|UC-018]]*
