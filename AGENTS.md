# Project Instructions

## Overview

[Brief project description - update this for your project]

## Project Structure

```text
project/
├── AGENTS.md                    # This file - project instructions
├── .agents/
│   ├── research/                # Research and reference material
│   ├── plans/                   # Implementation plans
│   │   ├── todo/                # Planned but not started
│   │   ├── in-progress/         # Currently being worked on
│   │   └── completed/           # Finished and verified
│   └── skills/                  # Agent skills
│       ├── ralph/               # Autonomous implementation loops
│       ├── research/            # Deep research workflow
│       └── tmux/                # Background process management
└── src/                         # Source code
```

## Plan Management

Plans in `.agents/plans/` follow this workflow:

| Status | Location |
|--------|----------|
| **TODO** | `plans/todo/` |
| **IN-PROGRESS** | `plans/in-progress/` |
| **COMPLETED** | `plans/completed/` |

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
