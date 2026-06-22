> **📝 TEMPLATE:** This is the dot-agents `AGENTS.md` template.
> Customize it for your project, then delete this banner.

# Project Instructions

## Overview

[Brief project description - update this for your project]

## Tech Stack

- Language: [e.g., TypeScript, Rust, Go, Python]
- Framework: [e.g., React, Express, Axum, FastAPI]
- Database: [e.g., PostgreSQL, SQLite, MongoDB]

## Workflow

```text
Work Item → Context as needed → Plan → Handoff Prompt → Implement → Record Progress
```

1. **Work Item:** Create durable context in `.agents/work/<category>/<slug>/`.
2. **Context:** Add `research.md` or `research/` for technical facts, or `prd.md` as a short requirements brief only when needed.
3. **Plan:** Break work into implementation-ready tasks in the active plan file (`plan.md` by default, or `plans/<name>.md` for focused plans).
4. **Handoff Prompt:** Generate a paste-ready prompt for a fresh implementation thread.
5. **Progress:** Implementation threads update `progress.md`, task checkboxes, and `index.md`.

## Project Structure

```text
project/
├── AGENTS.md                    # This file - project instructions
├── .agents/
│   ├── work/                    # Durable work items
│   │   └── <category>/<slug>/
│   │       ├── index.md         # Required entrypoint
│   │       ├── research.md      # Optional work-specific findings
│   │       ├── research/        # Optional focused research notes
│   │       ├── prd.md           # Optional requirements brief
│   │       ├── plan.md          # Optional primary implementation plan
│   │       ├── plans/           # Optional focused implementation plans
│   │       ├── progress.md      # Optional implementation log
│   │       └── decisions/       # Optional durable decisions
│   ├── research/                # Reusable cross-work research notes
│   ├── references/              # External repos or docs checkouts (gitignored)
│   ├── scripts/                 # dot-agents helper scripts
│   └── skills/                  # Agent skills
│       ├── adapt/
│       ├── agent-work/
│       ├── feature-planning/
│       ├── research/
│       └── tmux/
└── src/                         # Source code
```

## Using Skills

| Command | Effect |
| --- | --- |
| `Run adapt` | Analyze project and fill in `AGENTS.md` sections |
| `Create a new work item for ...` | Create durable `.agents/work/` context |
| `Research [topic]` | Investigate and save work-local or reusable findings |
| `Create a plan for ...` | Produce implementation-ready tasks in the active plan file |
| `Write a handoff prompt for ...` | Produce a paste-ready prompt for a new implementation thread |

Skills are loaded via natural language. See each skill's `SKILL.md` in `.agents/skills/` for details.

## Work Items

Work items live at:

```text
.agents/work/<category>/<slug>/
```

Every work item has `index.md` with:

```markdown
Status: researching | planned | in-progress | blocked | completed
Category: feature | bugfix | tech-debt | docs | tooling | research | other
Updated: YYYY-MM-DD
```

Use optional files only when useful:

- `research.md` - work-specific investigation notes
- `research/` - optional indexed folder for multiple focused research notes
- `prd.md` - short requirements brief when alignment is needed
- `plan.md` - primary implementation-ready task checklist
- `plans/` - optional indexed folder for multiple focused plans
- `progress.md` - implementation log, verification, blockers, and next action
- `decisions/` - durable decision records

Do not create empty support folders by default. Add `research/`, `plans/`, or `decisions/` only when they hold useful files.

### Task Format

```markdown
- [ ] **Task N: Short descriptive title**
  - Scope: `path/to/affected/files` or module name
  - Depends on: Task M or `none`
  - Acceptance:
    - Specific, verifiable criterion 1
    - Specific, verifiable criterion 2
  - Notes: Optional implementation hints
```

## Commands

```bash
# Add your project-specific commands here
# Examples:
# npm install / npm run dev / npm test
# cargo build / cargo test
# go build / go test
```

## Git Workflow

```bash
git status
git add -A
git commit -m "Description of changes"
git push
```

### Commit Guidelines

- Write clear, descriptive commit messages.
- Commit after each logical step.
- Do not push directly to the default branch unless project policy allows it.

## Maintenance

After making changes:

1. **Update AGENTS.md** - Keep project commands and conventions current.
2. **Update work items** - Keep `index.md`, the active plan file, and `progress.md` in sync with implementation state.
3. **Update docs** - Reflect user-facing behavior changes.

## Conventions

- [Naming conventions]
- [Code style preferences]
- [Commit message format]

## Architecture Notes

[Brief description of project structure and key components]
