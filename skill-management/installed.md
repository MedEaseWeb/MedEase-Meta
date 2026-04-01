# Installed Skills — MedEase-Meta

Record of every skill installed, where it came from, why it was chosen, and what files it contains.
Last updated: 2026-04-01.

---

## web-design-guidelines

**Source:** `https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines`
**Author:** Vercel Engineering
**Why:** Accessibility audits against 100+ rules — directly relevant for MedEase's user base
(disability services). Covers aria-labels, semantic HTML, keyboard handlers, focus states,
reduced-motion, touch interaction, and i18n.
**Note:** This skill fetches its rule list from a live URL at runtime — always current.

**Files:**
```
.claude/skills/web-design-guidelines/
  SKILL.md
```

**Raw URL:**
```
https://raw.githubusercontent.com/vercel-labs/agent-skills/main/skills/web-design-guidelines/SKILL.md
```

**Invoke with:** `/web-design-guidelines <file-or-pattern>`

---

## react-best-practices

**Source:** `https://github.com/vercel-labs/agent-skills/tree/main/skills/react-best-practices`
**Author:** Vercel Engineering
**Why:** 40+ performance rules for the React/Vite frontend. Covers async waterfall elimination,
bundle size optimization, server-side performance, re-render optimization. Each rule is its
own file — granular and actionable.

**Files:**
```
.claude/skills/react-best-practices/
  SKILL.md
  rules/          # 70 individual rule files
    _sections.md
    _template.md
    async-*.md    # async/data-fetching rules
    bundle-*.md   # bundle optimization rules
    client-*.md   # client-side rules
    server-*.md   # SSR/server rules
    render-*.md   # rendering performance
    ... (64 more)
```

**Raw base URL:**
```
https://raw.githubusercontent.com/vercel-labs/agent-skills/main/skills/react-best-practices/
```

**Invoke with:** `/react-best-practices` (or triggered automatically when editing React files)

---

## modern-python

**Source:** `https://github.com/trailofbits/skills/tree/main/plugins/modern-python`
**Author:** Trail of Bits
**Why:** FastAPI backend uses Python. This skill enforces uv (package manager), ruff (linter),
ty (type checker), pytest best practices. Includes config templates for pyproject.toml,
pre-commit, dependabot.

**Path gotcha:** Nested under `plugins/modern-python/skills/modern-python/` not `plugins/modern-python/`.

**Files:**
```
.claude/skills/modern-python/
  SKILL.md
  references/
    dependabot.md
    migration-checklist.md
    pep723-scripts.md
    prek.md
    pyproject.md
    ruff-config.md
    security-setup.md
    testing.md
    uv-commands.md
  templates/
    dependabot.yml
    pre-commit-config.yaml
```

**Raw base URL:**
```
https://raw.githubusercontent.com/trailofbits/skills/main/plugins/modern-python/skills/modern-python/
```

**Invoke with:** `/modern-python`

---

## sharp-edges

**Source:** `https://github.com/trailofbits/skills/tree/main/plugins/sharp-edges`
**Author:** Trail of Bits
**Why:** Healthcare app handling sensitive user data. This skill flags dangerous APIs,
insecure configurations, and common pitfalls across languages. Python and JavaScript
reference files included; others (C, Rust, Go, etc.) skipped to keep it lean.

**Path gotcha:** Same Trail of Bits nesting — `plugins/sharp-edges/skills/sharp-edges/`.

**Files:**
```
.claude/skills/sharp-edges/
  SKILL.md
  references/
    auth-patterns.md
    case-studies.md
    config-patterns.md
    lang-javascript.md
    lang-python.md
    language-specific.md
```

**Raw base URL:**
```
https://raw.githubusercontent.com/trailofbits/skills/main/plugins/sharp-edges/skills/sharp-edges/
```

**Invoke with:** `/sharp-edges <file-or-pattern>`

---

## ask-questions-if-underspecified

**Source:** `https://github.com/trailofbits/skills/tree/main/plugins/ask-questions-if-underspecified`
**Author:** Trail of Bits
**Why:** Enforces clarification before acting on vague tasks. MedEase has nuanced medical/accessibility
domain requirements — charging ahead on an ambiguous prompt is higher risk here than in most projects.

**Files:**
```
.claude/skills/ask-questions-if-underspecified/
  SKILL.md
```

**Raw URL:**
```
https://raw.githubusercontent.com/trailofbits/skills/main/plugins/ask-questions-if-underspecified/skills/ask-questions-if-underspecified/SKILL.md
```

**Note:** This skill is passive — it shapes behavior rather than being explicitly invoked.

---

## audit-context-building

**Source:** `https://github.com/trailofbits/skills/tree/main/plugins/audit-context-building`
**Author:** Trail of Bits
**Why:** Deep architectural context-building via ultra-granular code analysis. Useful before
making significant changes to the multi-agent pipeline or RAG system — ensures full context
before touching interconnected components.

**Files:**
```
.claude/skills/audit-context-building/
  SKILL.md
  resources/
    COMPLETENESS_CHECKLIST.md
    FUNCTION_MICRO_ANALYSIS_EXAMPLE.md
    OUTPUT_REQUIREMENTS.md
```

**Raw base URL:**
```
https://raw.githubusercontent.com/trailofbits/skills/main/plugins/audit-context-building/skills/audit-context-building/
```

**Invoke with:** `/audit-context-building`

---

## code-review

**Source:** `https://github.com/getsentry/skills/tree/main/plugins/sentry-skills/skills/code-review`
**Author:** Sentry Engineering
**Why:** Structured PR review checklist covering security, performance, testing, and design.
Sentry's engineering standards are well-matched to a production web app.

**Files:**
```
.claude/skills/code-review/
  SKILL.md
```

**Raw URL:**
```
https://raw.githubusercontent.com/getsentry/skills/main/plugins/sentry-skills/skills/code-review/SKILL.md
```

**Invoke with:** `/code-review`

---

## Skills considered but not installed

| Skill | Reason skipped |
|-------|----------------|
| `vercel-labs/composition-patterns` | Useful but covered adequately by react-best-practices |
| `vercel-labs/react-native-guidelines` | No React Native in this stack |
| `vercel-labs/vercel-deploy-claimable` | Deployed on Cloud Run / Cloudflare, not Vercel |
| `supabase/postgres-best-practices` | Using MongoDB, not PostgreSQL |
| `hashicorp/terraform-*` | No Terraform in use |
| `stripe/stripe-best-practices` | No Stripe integration |
| `trailofbits/building-secure-contracts` | No blockchain/smart contracts |
| `callstackincubator/react-native-*` | No React Native |
