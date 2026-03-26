# ADR-003: Internationalization (i18n) Strategy — Library, Language Tiers, and AI Response Localization

> Date: 2026-03-24
> Status: Accepted
> Decided by: Rolf

## Context

Emory students speak 60+ languages at home. The largest non-English cohorts are Mandarin
Chinese (~1,100+ students), Korean (~306+), and Spanish (~700–800 domestic + international).
Research confirms that ESL students with disabilities face a documented intersectional access
gap — language barriers compound the already-difficult DAS self-advocacy process.
Full demographic data and citations: `research/user-insights/emory-language-demographics.md`.

MedEase has two distinct i18n surfaces:
1. **UI strings** — static labels, buttons, forms, onboarding copy
2. **AI response language** — the LLM generates natural-language answers; static string
   files cannot cover this

No competing accessibility assistant in higher ed currently offers multilingual support.

## Options Considered

**Option A: UI strings only (react-i18next, no AI language control)**
Pros: Simpler scope; no backend changes needed.
Cons: Half-experience — student reads Korean UI but receives English AI responses.
Rejected: The core value of MedEase is the AI answers, not the chrome around them.

**Option B: UI strings (react-i18next) + locale-aware system prompt injection**
Pros: Full experience in the student's language; minimal backend change (pass locale,
add directive to system prompt); works for all languages the underlying model supports.
Cons: Model output quality varies by language; requires QA per locale.
**Selected.**

**Option C: Separate translation microservice (post-process AI responses)**
Pros: Decouples LLM from output language; consistent quality.
Cons: Adds latency, infra cost, and an extra failure point; over-engineered for current scale.
Rejected: Premature complexity.

## Decision

**Use react-i18next for UI strings and locale-injected system prompt directives for AI responses.**

### UI layer
- Library: `react-i18next` + `i18next`
- Locale files: `public/locales/{lang}/translation.json`
- Language detection order: user profile setting → browser preference → `en` fallback
- Font loading: Noto Sans family (covers all target scripts: SC, KR, Devanagari, Arabic)
- Language selector: exposed in `/settings`, persisted to MongoDB user profile

### AI layer
- Active locale passed from frontend to backend with each chat request (existing Socket.IO
  message payload; add `locale` field)
- Backend injects directive into system prompt: `"Respond in {language}. Maintain medical
  accuracy and professional tone."`
- Fallback: if model cannot produce target language, respond in English with UI notice

### Language release tiers

**P1 — Ship together (zh-CN, ko, es):**
Mandarin Simplified, Korean, Spanish. All LTR, Latin or well-supported CJK scripts,
excellent translation API and model quality.

**P2 — Follow-on release (hi, vi):**
Hindi (Devanagari; requires font loading; Google/Azure only — DeepL does not support Hindi)
and Vietnamese (Latin script; minimal overhead).

**P3 — Separate RTL workstream (ar, fa, ja, pt-BR):**
Arabic and Farsi require architectural CSS changes (flex/grid mirroring, icon direction,
`dir="rtl"` on `<html>`). RTL is a discrete engineering effort and must not be bundled with
P1/P2. Japanese and Brazilian Portuguese are low-complexity additions once P1 base exists.

## Consequences

**Easier:**
- Students can use MedEase entirely in their strongest language
- Family members (caregivers) benefit from translated UI — especially relevant for
  Spanish and Chinese where parent involvement in DAS navigation is common
- P1 languages use the same LTR layout; no CSS architecture changes needed

**Harder / ruled out:**
- Real-time arbitrary-input translation (user types in any language, we translate before
  processing) is out of scope for this ADR — a different and more complex feature
- AI response quality must be QA'd per locale before shipping; medical accuracy in
  non-English output is a correctness risk
- RTL (Arabic/Farsi) deferred until dedicated workstream is scoped

**Follow-up actions:**
- [ ] Add `locale` field to MongoDB user schema
- [ ] Add `locale` to Socket.IO chat message payload
- [ ] Set up `public/locales/` directory structure in MedEase-App
- [ ] Source P1 translations (machine-first, human spot-check for medical accuracy)
- [ ] QA AI responses in zh-CN, ko, es before shipping
- [ ] Plan RTL workstream separately (P3)
