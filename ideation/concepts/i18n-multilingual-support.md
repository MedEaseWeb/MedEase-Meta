# Concept: Internationalization (i18n) — Multilingual UI and AI Responses

> Status: Concept (promoted from inbox 2026-03-24)
> Research grounding: `research/user-insights/emory-language-demographics.md`
> Next step: Alignment review → graduate to `planning/short-term.md` backlog

---

## The Problem

Emory students speak 60+ languages at home (Class of 2029 data). The DAS accommodation
process is already described as "complex, uncomfortable, and riddled with barriers" for
native English speakers. For non-native speakers — particularly international students
from China, Korea, and India — the language barrier compounds an already-difficult
self-advocacy process. Research on ESL students with disabilities in higher education
consistently finds they face an intersectional access gap that goes unmeasured and
unaddressed. No competing accessibility assistant in higher ed currently offers
multilingual support.

MedEase has an opportunity to be the first.

---

## Language Priority Tiers

Based on Emory enrollment data, Atlanta metro demographics, and implementation complexity.
Full data and citations in `research/user-insights/emory-language-demographics.md`.

### P1 — Launch with (high volume, low engineering risk)

| Language | Est. Emory speakers | Script | Dir | Notes |
|----------|-------------------|--------|-----|-------|
| Mandarin Chinese (Simplified) | 1,100–1,300+ | Hanzi | LTR | Add `zh-TW` (Traditional) as a low-cost follow-on for Taiwan/HK cohort |
| Korean | 306–500+ | Hangul | LTR | DeepL quality competitive with Google for Korean |
| Spanish | 700–800+ | Latin | LTR | Largest non-English language in Georgia; high domestic + family relevance |

### P2 — Follow-on release (meaningful volume, slightly higher complexity)

| Language | Est. Emory speakers | Script | Dir | Notes |
|----------|-------------------|--------|-----|-------|
| Hindi | 215+ (growing fast) | Devanagari | LTR | India surpassed China as #1 source country nationally in 2024/25; font loading required |
| Vietnamese | ~9 intl + large Atlanta metro community | Latin | LTR | Latin script = minimal extra complexity; fastest-growing in Georgia |

### P3 — Planned but separate RTL workstream

| Language | Est. Emory speakers | Script | Dir | Notes |
|----------|-------------------|--------|-----|-------|
| Arabic | ~55+ combined Gulf/MENA | Arabic | RTL | High cultural stigma around disability disclosure — high-impact cohort |
| Farsi/Persian | ~14 | Perso-Arabic | RTL | Shares RTL engineering work with Arabic; low incremental cost once Arabic is built |
| Japanese | ~31 | Mixed (Hiragana/Katakana/Kanji) | LTR | Excellent DeepL support |
| Portuguese (Brazilian) | ~23 | Latin | LTR | Low cost once Spanish Latin base is built; use `pt-BR` locale key |

---

## Two Layers of i18n

This feature has two distinct translation surfaces that require different approaches:

### Layer 1: UI Strings
Static labels, navigation, buttons, form fields, error messages, onboarding copy.

- **Library:** `react-i18next` (de facto standard for React; integrates with Vite)
- **Locale files:** `public/locales/{lang}/translation.json` per language
- **Language detection:** Browser preference → user settings → fallback to `en`
- **Font loading:** Noto Sans family covers all target scripts (SC, KR, Devanagari, Arabic)
- **RTL (P3):** `i18n.dir()` sets `dir` attribute on `<html>`; CSS layout mirroring required

### Layer 2: AI Response Language
The LLM generates natural-language responses — these cannot be covered by static string files.

- **Approach:** Pass the active locale to the backend; inject a system prompt directive
  instructing the model to respond in the target language
- **Example directive:** `"Respond in {language}. Maintain medical accuracy and tone."`
- **Fallback:** If the model cannot reliably produce a target language (rare for P1 langs),
  fall back to English with a UI-level notice
- **Quality consideration:** For P1 languages, GPT-4 class models have strong multilingual
  capability. For P3 languages, consider a human review pass on AI-generated content before
  the locale ships.

---

## What Changes in the Product

1. **Language selector** — user can set preferred language in `/settings`; persists to their
   profile in MongoDB
2. **UI renders in selected language** — all static strings translated
3. **AI responds in selected language** — system prompt includes locale directive
4. **Caregiver/family content** — especially relevant for Spanish and Chinese; family members
   who speak less English than the student benefit from translated explanations
5. **RTL layout** (P3) — full CSS mirroring for Arabic/Farsi

---

## What This Is Not

- Not real-time machine translation of arbitrary user inputs (user types in any language,
  we translate before processing) — this is a separate and more complex feature
- Not sign language or ASL support (separate accessibility consideration)
- Not localization of Emory DAS content itself (that is Emory's responsibility)

---

## Open Questions for Alignment Review

1. **Scope:** UI-only in V1, or must AI response language ship together?
   (Recommendation: both, since UI-only without AI language is a half-experience)
2. **Translation source:** Human-translated strings vs. machine-translated + human review?
   Machine-first is faster; human review matters most for medical/legal accuracy.
3. **RTL timeline:** Is P3 a V2 commitment or a "when resources allow" item?
4. **Traditional Chinese:** Add `zh-TW` alongside `zh-CN` at P1, or defer?
   (Minimal incremental cost; meaningful to Taiwan/HK cohort)
5. **Family-facing scope:** Should language preference apply to a caregiver view, or just
   the student's own session?

---

## Alignment Check

- **North star fit:** Directly serves Emory students who find the DAS process confusing —
  especially compounded for non-native English speakers. No conflict.
- **Feature registry:** Not yet in registry. Propose adding to "Proposed" section pending
  Alignment review.
- **Compliance:** AI responses in non-English languages do not change PHI handling —
  the de-identification pipeline operates before LLM calls regardless of output language.
  No new compliance surface.
