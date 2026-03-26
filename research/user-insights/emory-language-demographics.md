# Emory University Language Demographics Research

> Compiled: 2026-03-24
> Purpose: Inform i18n language prioritization for MedEase
> See also: `ideation/concepts/i18n-multilingual-support.md`

---

## 1. International Student Enrollment — By Country of Origin

Emory hosts approximately **3,400 international students** from over 100 countries (ISSS
Facts & Figures, Fall 2024). The three officially stated leading nations are China, India,
and South Korea.

Most granular country-level breakdown (CollegeFActual via IPEDS; ~2018 cohort, directionally
corroborated by current ISSS statements):

| Rank | Country | Est. Students | Primary Language |
|------|---------|--------------|-----------------|
| 1 | China | ~1,100 | Mandarin Chinese |
| 2 | South Korea | ~306 | Korean |
| 3 | India | ~215 | Hindi / regional (Tamil, Telugu, Bengali) |
| 4 | Canada | ~60 | English |
| 5 | Taiwan | ~32 | Mandarin Chinese (Traditional) |
| 6 | Japan | ~31 | Japanese |
| 7 | Brazil | ~23 | Portuguese |
| 8 | Turkey | ~22 | Turkish |
| 9 | Nigeria | ~21 | English + Yoruba/Igbo/Hausa |
| 10 | United Kingdom | ~20 | English |
| 11 | Saudi Arabia | ~18 | Arabic |
| 12 | Hong Kong | ~16 | Cantonese / Mandarin |
| 13 | Colombia | ~16 | Spanish |
| 14 | Iran | ~14 | Farsi/Persian |
| 15 | France | ~14 | French |
| 16 | Thailand | ~12 | Thai |
| 17 | Mexico | ~12 | Spanish |
| 18 | Germany | ~11 | German |
| 19 | Singapore | ~10 | English + Mandarin |
| 20 | Vietnam | ~9 | Vietnamese |
| — | Pakistan | ~8 | Urdu |
| — | Bangladesh | ~7 | Bengali |

**Growth note:** Current total (~3,400) is substantially higher than the CollegeFActual
cohort (~2,164). IIE Open Doors 2024/25 shows India now surpassing China nationally
(363k vs. 266k) — Emory's Indian enrollment likely higher than the ~215 figure above.

---

## 2. Home Languages Across All Emory Students (Domestic + International)

| Data Point | Value | Source |
|-----------|-------|--------|
| Languages spoken at home besides English (Class of 2029, Emory College) | 60 | Emory admissions |
| Languages spoken at home besides English (Class of 2028, Emory College) | 61 | Emory admissions |
| Languages spoken at home besides English (Class of 2029, Oxford College) | 38 | Emory admissions |
| Domestic Asian/Asian American enrollment (Class of 2029) | **43%** of domestic undergrad | Emory admissions |

The 43% domestic Asian enrollment is the most important signal. A large share of these
students are children of Chinese, Korean, Indian, and Vietnamese immigrants — they may
be English-dominant but their families speak those languages at home. This makes
family-facing localization (caregiver dashboards, documentation explanations) a distinct
and high-value i18n use case beyond student-facing UI.

### Inferred top non-English home languages (international + domestic combined):

| Language | Signal |
|----------|--------|
| Mandarin Chinese | ~1,100+ Chinese international + large domestic Chinese-American cohort within 43% |
| Korean | ~306+ Korean international + large Korean-American community in Atlanta metro |
| Spanish | ~10–11% domestic Hispanic/Latinx enrollment; Atlanta metro: #1 non-English language |
| Hindi / Indian regional | ~215+ Indian international (growing); large domestic Indian-American cohort |
| Vietnamese | ~9 international + Atlanta metro ~36,554 Vietnamese residents; fastest-growing in GA |
| Cantonese | Hong Kong students + older-generation Chinese-American households |
| Arabic | ~55+ combined Gulf/MENA international students |
| Portuguese | ~23 Brazilian international; Brazilian community growing in Atlanta |
| Japanese | ~31 Japanese international |
| Farsi/Persian | ~14 Iranian international |

---

## 3. Language Barriers in Disability Services Access

No institution-specific Emory DAS multilingual data found. National research findings:

- **Intersectional underservice:** ESL students with disabilities face compounded barriers.
  Accommodation processes are self-advocacy-heavy — language barriers amplify this significantly.
  *(Frontiers in Education, 2023)*

- **K-12 proxy:** ~518,088 K-12 students with disabilities classified as limited English
  proficient (~8.5% of all students with disabilities). College-level equivalent is
  unmeasured but comparable. *(IDEA child count data)*

- **Immigrant students with learning disabilities:** Enter university with unrecognized
  disabilities; digital tools assume "native-level English proficiency and neurotypical
  learning patterns." *(Canadian higher education study, 2025)*

- **Cultural stigma amplified by language:** International students from Gulf, East Asian,
  and South Asian cultures often face cultural stigma around disability disclosure; language
  barriers make it harder to research options, understand forms, and communicate nuanced
  conditions to case workers.

- **No competing tool offers multilingual support** in the accessibility services assistant
  space as of 2026.

---

## 4. Per-Language Technical Profile

| Language | Script | Dir | Translation API quality | i18n complexity |
|----------|--------|-----|------------------------|-----------------|
| Mandarin (Simplified) `zh-CN` | Hanzi | LTR | Excellent (Google, DeepL, Azure, GPT-4) | Low — Noto Sans SC font |
| Mandarin (Traditional) `zh-TW` | Hanzi | LTR | Excellent | Minimal incremental over zh-CN |
| Korean `ko` | Hangul | LTR | Excellent (DeepL competitive with Google) | Low — Noto Sans KR font |
| Spanish `es` | Latin | LTR | Excellent (DeepL rated highest) | Trivial — widest ecosystem |
| Hindi `hi` | Devanagari | LTR | Good (Google/Azure; DeepL does **not** support Hindi) | Medium — Noto Sans Devanagari |
| Vietnamese `vi` | Latin + diacritics | LTR | Good (Google strong) | Low — standard Latin |
| Arabic `ar` | Arabic | **RTL** | Good (Google, Azure; DeepL limited) | High — full RTL layout mirroring |
| Farsi `fa` | Perso-Arabic | **RTL** | Good (Google, Azure) | Low incremental over Arabic RTL |
| Japanese `ja` | Mixed (Hiragana/Katakana/Kanji) | LTR | Excellent (DeepL full support) | Low — well-supported |
| Portuguese (BR) `pt-BR` | Latin | LTR | Excellent (DeepL, Google) | Trivial once Spanish base exists |

---

## 5. Georgia and Atlanta Metro Language Context

- 16% of Georgians speak a language other than English at home (2025 ACS)
- Top non-English languages in Georgia: Spanish, Hindi, French
- Atlanta metro: Spanish #1 non-English language; Vietnamese fastest-growing; large Korean
  and Chinese-American communities
- 78,980 Indian residents in Atlanta metro (2020 Census)
- 36,554 Vietnamese residents in Atlanta metro (2020 Census)

The Atlanta metro context matters for two reasons:
1. Domestic students from Atlanta-area immigrant families are part of the Emory student body
2. Family members (caregivers) often live locally and may be more comfortable in their
   home language than the student

---

## Sources

- Emory ISSS Facts and Figures: https://isss.emory.edu/about/facts-figures
- CollegeFActual — International Students at Emory: https://www.collegefactual.com/colleges/emory-university/student-life/international/chart-international.html
- Emory Common Data Set 2024-2025: https://provost.emory.edu/planning-administration/_includes/documents/sections/institutional-data/emory-common-data-set-2024-2025.pdf
- IIE Open Doors 2025: https://www.iie.org/news/open-doors-2025-press-release/
- Meet Emory's Class of 2029: https://news.emory.edu/features/2025/08/er_meet_the_class_29-08-2025/index.html
- Emory Admitted Students Class of 2029: https://apply.emory.edu/discover/about/first-year.html
- Axios Atlanta — Georgia languages 2023: https://www.axios.com/local/atlanta/2023/09/11/georgia-census-languages-immigration
- Axios Atlanta — 16% Georgians non-English 2025: https://www.axios.com/local/atlanta/2025/03/10/roughly-16-of-georgians-speak-a-language-other-than-english-at-home
- Frontiers in Education — disability accommodation barriers 2023: https://www.frontiersin.org/journals/education/articles/10.3389/feduc.2023.1218120/full
- Bridging Digital Accessibility Gap (ESL + disabilities, 2025): https://pressbooks.pub/alttexts2025/chapter/bridging-the-digital-accessibility-gap/
- MIUSA — ESL accommodations: https://miusa.org/resource/tip-sheets/eslaccommodations/
- DeepL vs Google vs Azure comparison 2025: https://taia.io/resources/blog/deepl-vs-google-translate-vs-microsoft-translator-2025/
