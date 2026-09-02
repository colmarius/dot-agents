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
Request or change
├─ Self-contained ───────────▶ Plan as needed and execute here ───────▶ Verify and report
└─ Continuity has value ─────▶ Work Item → Context and plan as needed → Execute → Verify
                                                                         ├─ Hand off when useful
                                                                         └─ Promote → Commit snapshot → Remove
```

Keep work conversational when one thread is enough. Create a work item when its status, decisions, or next action must survive this conversation — for later resumption, coordination, handoff, or auditability — or when the user explicitly asks. For durable work, add context or a saved plan only when it helps, implement in the current thread by default, and hand off only when another worker or environment genuinely helps.

The canonical artifact, status, and completion contract lives in `.agents/work/AGENTS.md`.

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
│   │       ├── progress.md      # Optional living execution summary
│   │       ├── decisions/       # Optional durable decisions
│   │       └── handoff-*.md     # Optional reusable transition prompts
│   ├── research/                # Reusable cross-work research notes
│   ├── references/              # External repos or docs checkouts (gitignored)
│   ├── scripts/                 # dot-agents helper scripts
│   └── skills/                  # Agent skills
│       ├── adapt/
│       ├── agent-browser/
│       ├── agent-work/
│       └── research/
└── src/                         # Source code
```

## Using Skills

| Command | Effect |
| --- | --- |
| `Run adapt` | Analyze project and fill in `AGENTS.md` sections |
| `Use agent-browser to verify ...` | Load current real-browser automation guidance from the installed CLI |
| `Create a new work item for ...` | Create durable `.agents/work/` context |
| `Continue the work item at ...` | Resume from `index.md` and implement the next action |
| `Research [topic]` | Investigate and save work-local or reusable findings |
| `Create/execute a plan for ...` | Produce implementation-ready tasks and implement in the current thread |
| `Write a handoff prompt for ...` | Produce a paste-ready prompt for a new implementation thread |
| `Complete and close the work item at ...` | Promote outcomes, commit the final snapshot, and stage removal |

Skills are loaded via natural language. See each skill's `SKILL.md` in `.agents/skills/` for details.

## Work Items

Work items live at:

```text
.agents/work/<category>/<slug>/
```

Every work item has `index.md` as the entrypoint and canonical current state. Add research, a requirements brief, plans, progress evidence, decisions, or a separately named `handoff-*.md` only when they hold durable value. Persisted handoffs are optional; do not create one by default or treat it as a second plan.

Follow `.agents/work/AGENTS.md` for the authoritative status, artifact ownership, handoff, and completion rules. When a saved plan is useful, follow `.agents/skills/agent-work/assets/plan-template.md` for task fields, acceptance criteria, and verification. At closeout, promote reusable outcomes, commit the final `completed` snapshot, then use `close-work.sh` to stage removal for a separate commit; git history is the archive.

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

1. **Update AGENTS.md** - Keep concise, verified project commands and conventions current. Preserve intentional project guidance and prefer pointers to canonical detail over copied inventories.
2. **Update work items** - Keep `index.md`, the active plan file, and living `progress.md` in sync with implementation state when needed.
3. **Update docs** - Reflect user-facing behavior changes.
4. **Close completed work** - Promote reusable outcomes and remove completed work items only after their final snapshot is committed.

## Conventions

- [Naming conventions]
- [Code style preferences]
- [Commit message format]

## Architecture Notes

[Brief description of project structure and key components]
