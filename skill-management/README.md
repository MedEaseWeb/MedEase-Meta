# Skill Management

This folder documents how Claude Code skills are found, evaluated, installed, and maintained
across projects. Use it as a runbook when setting up skills in a new sub-project or repo.

---

## What is a skill?

A skill is a set of packaged instructions (and optional scripts/references) that extend what
Claude Code can do when you invoke a slash command. Skills live in `.claude/skills/<skill-name>/`
and are loaded automatically by Claude Code at session start.

The format is defined at [agentskills.io](https://agentskills.io). Each skill minimally contains:

```
.claude/skills/
  <skill-name>/
    SKILL.md          # Required — instructions + trigger description
    scripts/          # Optional — helper scripts the skill runs
    references/       # Optional — supporting docs the skill reads
    templates/        # Optional — boilerplate the skill emits
```

`.claude/` is gitignored to prevent bloated commits and secrets leakage.
This folder serves as the durable record of what was installed and why.

---

## How to discover skills

**Primary index — community-curated, 1000+ skills:**
```
https://github.com/VoltAgent/awesome-agent-skills
```
Includes official skills from Anthropic, Vercel, Stripe, Trail of Bits, Sentry, Cloudflare,
Supabase, Hugging Face, Figma, HashiCorp, and many others.

**Official Anthropic skills:**
```
https://github.com/anthropics/skills
```
Word/Excel/PowerPoint document manipulation, co-authoring.

**Vercel engineering skills:**
```
https://github.com/vercel-labs/agent-skills
```
React best practices, web design/accessibility guidelines, deploy-to-Vercel.

**Trail of Bits security skills:**
```
https://github.com/trailofbits/skills
```
High-quality security-focused skills: sharp-edges, modern-python, audit workflows.

---

## How to evaluate a skill

Ask three questions:

1. **Does it match the stack?** Ignore skills for technologies not in use.
2. **Is it from a real engineering team or bulk-generated?** Trail of Bits, Vercel, Sentry = real.
   Random community repos with 50 skills added in a day = skip.
3. **Does the SKILL.md contain actual rules, or just vague instructions?**
   A good skill has concrete, enumerable rules. A bad one says "follow best practices."

---

## Installation procedure

### 1. Find the correct raw path

GitHub API paths don't always match raw URL paths. Use `gh api` to discover the real structure
before constructing raw URLs:

```bash
gh api "repos/<owner>/<repo>/contents/<path>" | grep '"name"'
```

**Common gotcha — Trail of Bits:** Their skills nest under `plugins/<name>/skills/<name>/SKILL.md`,
not `plugins/<name>/SKILL.md`.

```bash
# Wrong:
https://raw.githubusercontent.com/trailofbits/skills/main/plugins/modern-python/SKILL.md

# Correct:
https://raw.githubusercontent.com/trailofbits/skills/main/plugins/modern-python/skills/modern-python/SKILL.md
```

### 2. Create the skill directory

```bash
mkdir -p .claude/skills/<skill-name>
mkdir -p .claude/skills/<skill-name>/references   # if needed
```

### 3. Download SKILL.md and supplementary files

```bash
curl -s "<raw-url>/SKILL.md" -o .claude/skills/<skill-name>/SKILL.md
```

For supplementary reference/template files, list the directory first then loop:

```bash
gh api "repos/<owner>/<repo>/contents/<path>/references" | grep '"download_url"'
# then curl each file
```

### 4. Verify content size

A 14-byte SKILL.md means a 404 — the path was wrong.

```bash
wc -c .claude/skills/*/SKILL.md
```

---

## Skills installed in this workspace

See [installed.md](installed.md) for the full record with rationale and source URLs.

---

## Applying to a new project

1. Create `.claude/skills/` in the target project directory.
2. Copy the relevant skill directories from this workspace's `.claude/skills/`.
3. Or re-download from source using the URLs in `installed.md`.
4. Skills without scripts are portable as-is — just copy the directory.

For sub-projects (MedEase-App, MedEase-Utils), prefer copying rather than re-downloading
unless you want the latest version.

---

## Keeping skills current

Skills from official teams are updated occasionally. To refresh a single skill:

```bash
curl -s "<raw-url>/SKILL.md" -o .claude/skills/<skill-name>/SKILL.md
```

There is no automatic update mechanism. Check the source repo's commit history if behavior
seems stale.
