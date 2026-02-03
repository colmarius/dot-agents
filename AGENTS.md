> **📝 TEMPLATE:** This is the dot-agents AGENTS.md template.
> Customize it for your project by filling in the sections below.
> Delete this banner when done.

# Project Instructions

## Overview

[Brief project description - update this for your project]

## Tech Stack

- Language: [e.g., TypeScript, Rust, Go, Python]
- Framework: [e.g., React, Express, Axum, FastAPI]
- Database: [e.g., PostgreSQL, SQLite, MongoDB]

## PRD → Plan → Execute Workflow

```text
Research → PRD → Plan → Ralph executes
```

1. **Create PRD**: `Create a PRD for [feature] based on .agents/research/[doc].md`
2. **Generate Plan**: PRD acceptance criteria → Ralph task format
3. **Execute**: `Run ralph on .agents/plans/in-progress/[plan].md`

PRD template and rules in `.agents/prds/AGENTS.md`.

## Project Structure

```text
project/
├── AGENTS.md                    # This file - project instructions
├── .agents/
│   ├── reference/               # External repos (gitignored)
│   ├── research/                # Research and reference material
│   ├── prds/                    # Product requirements documents
│   ├── plans/                   # Implementation plans
│   │   ├── todo/                # Planned but not started
│   │   ├── in-progress/         # Currently being worked on
│   │   └── completed/           # Finished and verified
│   └── skills/                  # Agent skills
│       ├── adapt/               # Project analysis and AGENTS.md setup
│       ├── ralph/               # Autonomous implementation loops
│       ├── research/            # Deep research workflow
│       └── tmux/                # Background process management
└── src/                         # Source code
```

## Using Skills

| Command | Effect |
|---------|--------|
| `Run adapt` | Analyze project and fill in AGENTS.md sections |
| `Research [topic]` | Deep investigation, saves to `.agents/research/` |
| `Run ralph on [plan.md]` | Autonomous execution of plan tasks |

## Plan Management

Plans in `.agents/plans/` follow this workflow:

| Status | Location |
|--------|----------|
| **TODO** | `plans/todo/` |
| **IN-PROGRESS** | `plans/in-progress/` |
| **COMPLETED** | `plans/completed/` |

**Completing plans:** When moving a plan to `completed/`, also move its corresponding `.progress.md` file if one exists.

**Archive command:** When asked to "archive completed plans", delete each plan from `completed/` with its own commit. Git history preserves them.

### Writing Ralph-Ready Plans

```markdown
- [ ] **Task N: Short descriptive title**
  - Scope: `path/to/affected/files` or module name
  - Depends on: Task M (or "none")
  - Acceptance:
    - Specific, verifiable criterion 1
    - Specific, verifiable criterion 2
  - Notes: Optional implementation hints
```

**Task markers:**

| Marker | Meaning |
|--------|---------|
| `- [ ]` | Not started |
| `- [x]` | Completed |
| `- [ ] (blocked)` | Blocked, needs intervention |
| `- [ ] (manual-verify)` | Requires manual verification |

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

- Write clear, descriptive commit messages
- Reference plan numbers in commits (e.g., "Plan 001: Initial setup")
- Commit after each logical step

## Maintenance

After making changes:

1. **Update AGENTS.md** - Keep project structure and commands current
2. **Update README.md** - Reflect user-facing changes
3. **Update plan status** - Move completed plans to `completed/`

## Conventions

- [Naming conventions]
- [Code style preferences]
- [Commit message format]

## Architecture Notes

[Brief description of project structure and key components]
