# MedEase-Meta

This repository is the organizational brain of the MedEase project. It contains no product code. It exists so that the AI collaborator working on MedEase always has the full picture — not just the slice of the codebase currently open in an editor.

---

## Why This Exists

Software projects fail at the seams. Individual repos are self-consistent; the places where they break down are the boundaries between them — where one team's output becomes another team's input, where architectural decisions made in one context contradict assumptions made in another, where context that existed in someone's head quietly disappears.

MedEase-Meta exists to hold that boundary knowledge explicitly. It is the place where:

- Cross-project decisions are recorded and kept current
- Architectural intent outlives any single conversation or session
- The "why" behind the system is preserved alongside the "what"

The secondary motivation is continuity. This project is developed in collaboration with an AI (Claude). An AI has no persistent memory across sessions by default — every conversation starts from zero. MedEase-Meta is the solution to that problem. By maintaining a structured, always-current record of decisions, context, and project state, a new Claude instance opened in this workspace can orient itself and contribute meaningfully without needing to be re-briefed from scratch.

---

## Philosophy

**The AI is a collaborator, not a tool.** The working model here is that Claude operates as a high-context technical partner — aware of the full system, responsible for architectural consistency, and empowered to raise concerns across repo boundaries. The human stakeholder sets direction and makes final calls; Claude executes and maintains coherence.

**Decisions should be written down close to when they are made.** The worst time to document a decision is six months after it was made, when the reasoning has faded. Architecture docs here are updated in the same session where decisions are reached — not as an afterthought.

**The source of truth moves, but the pointer stays.** Key documents (architecture specs, scraping logs, planning notes) live in the repos where they are actively edited. MedEase-Meta holds symlinks to those files rather than copies, so the meta view is always current without requiring a sync step.

**No code lives here.** This repo is deliberately kept free of implementation. Mixing organizational context with product code creates the same problem it was meant to solve — important things get buried. The boundary is strict: decisions, architecture, documentation, and process live here; code lives in the sub-project repos.

---

## How It Works

### Repository Structure

```
MedEase-Meta/
├── CLAUDE.md              # Instructions and context for Claude when working in this workspace
├── README.md              # This file
├── .gitignore             # Excludes sub-project folders and local tooling (.claude/)
└── docs/                  # Live mirrors of key documents from sub-projects (symlinks)
    ├── agent-architecture.md      → MedEase-App/agent-architecture.md
    └── utils-logs/
        ├── scraping-meta-plan.md  → MedEase-Utils/log/scraping-meta-plan.md
        ├── v1_assessment.md       → MedEase-Utils/log/v1_assessment.md
        └── v2_assessment.md       → MedEase-Utils/log/v2_assessment.md
```

The sub-project folders (`MedEase-App/`, `MedEase-Utils/`, `MedEase-PoC-Eval/`) are checked out locally inside this directory for convenience but are gitignored here — they are tracked in their own repositories.

### The Symlink Convention

Documents that belong to a sub-project (because they are actively edited there) are symlinked into `docs/` so they are visible from the meta workspace without duplication. Editing the file in the sub-project instantly updates what Claude sees here. When a new important document is created in a sub-project, add a symlink:

```bash
# From the MedEase-Meta root
ln -s ../MedEase-App/some-new-doc.md docs/some-new-doc.md
```

### The Memory System

Claude maintains a persistent memory store at `.claude/projects/.../memory/` (local only, gitignored). This holds structured notes about the user, project state, prior decisions, and working preferences — things that are useful across sessions but too granular for the formal docs. This is separate from `CLAUDE.md`, which is the authoritative project guide committed to the repo.

### Cross-Project Data Flow

```
MedEase-Utils  →  MedEase-App  →  Users
(corpus)           (RAG pipeline)
```

The scraper in MedEase-Utils produces `output/emory_das_data_latest.json`. This file is the upstream input to the RAG pipeline in MedEase-App. The handoff is currently manual:

1. Copy `emory_das_data_latest.json` into `MedEase-App/backend/src/rag/corpus/`
2. Run `python -m src.rag.indexer` from `MedEase-App/backend/` to rebuild ChromaDB

---

## Stakeholder Manual

*This section is written for the human — for you, returning to this project after time away.*

### Opening the Meta Workspace

Open this folder (`MedEase-Meta/`) in Claude Code. Claude will load `CLAUDE.md` automatically and have full organizational context. From here you can ask about the state of any sub-project, make cross-project decisions, or direct work across repos.

For sub-project work, open the specific sub-project folder in a separate Claude Code session. Each has its own `CLAUDE.md` with build/run instructions and implementation detail.

### How to Direct Claude

Claude in this workspace is oriented toward the organization-level view. Useful prompts here:

- *"What's the current state of the RAG pipeline end-to-end?"* — Claude will read the architecture docs and code to give you a coherent answer
- *"We've decided to switch the vector store to Pinecone — update the architecture docs and tell me what changes"* — Claude will update `agent-architecture.md` and enumerate the code implications
- *"Summarize what needs to happen before we can demo the chat system"* — Claude will assess the current state against what's needed and give you a gap list

### When You've Been Away

If you return after a gap and need to reorient:

1. Ask Claude: *"Summarize the current state of MedEase — what's built, what's in progress, what's next."* Claude will read the architecture docs, logs, and memory to reconstruct the picture.
2. Check `docs/utils-logs/` for the latest scraper assessment — it tracks what phase the corpus work is in.
3. Check open PRs on MedEase-App for in-flight work.

### Making Architecture Decisions

When a significant decision is made in conversation with Claude:

- Claude should update the relevant architecture doc in the same session — don't let it drift into memory only
- The `agent-architecture.md` (mirrored at `docs/agent-architecture.md`) is the canonical record for the chat system
- For decisions that span repos, update `CLAUDE.md` in this workspace

### Adding a New Sub-Project

1. Check out the new repo inside this folder (e.g., `MedEase-Pipeline/`)
2. Add it to `.gitignore` in this repo
3. Add an entry to the sub-projects table in `CLAUDE.md`
4. Symlink any key architecture docs into `docs/`
5. Ensure the new repo has its own `CLAUDE.md`

### What Claude Will Not Do Without Your Input

- Push to `main` directly (it will create a branch and PR)
- Make product decisions (what features to build, what to cut, priorities)
- Spend money (API keys, cloud resources) — Claude can write the code but you control the credentials
- Merge PRs or make changes visible to other collaborators without confirmation

---

## Sub-Projects

| Repo | Purpose | Status |
|------|---------|--------|
| [MedEase-App](https://github.com/MedEaseWeb/MedEase-App) | Production application — React/Vite frontend, FastAPI backend, multi-agent chat | Active |
| [MedEase-Utils](https://github.com/MedEaseWeb/MedEase-Utils) | Web scraper producing the Emory DAS corpus for RAG | V2 complete; V3 planned |
| MedEase-PoC-Eval | Benchmarking and evaluation framework | Deprioritized |
