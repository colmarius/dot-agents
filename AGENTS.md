# Project Instructions

## Overview

dot-agents is an AI-ready `.agents/` workspace scaffold for any project. It provides plans, PRDs, research folders, and skills for agent-assisted development workflows.

## Tech Stack

- Language: Bash (install/sync scripts), Markdown (documentation, skills)
- Testing: Bats (Bash Automated Testing System)

## Workflow

```text
Research → PRD → Plan → Execute
```

1. **Research:** Investigate problem space, save findings to `.agents/research/`
2. **PRD:** Define requirements and acceptance criteria in `.agents/prds/`
3. **Plan:** Break PRD into executable tasks with Ralph-ready format
4. **Execute:** Ralph runs tasks autonomously, commits after each

## Project Structure

```text
dot-agents/
├── AGENTS.md                    # This file - project instructions
├── AGENTS.template.md           # Template copied to user projects
├── install.sh                   # Main installation script
├── .agents/
│   ├── skills/                  # Agent skills (adapt, ralph, research, tmux)
│   ├── plans/                   # Implementation plans
│   ├── prds/                    # Product requirements documents
│   └── research/                # Research and reference material
├── docs/                        # Full documentation
├── site/                        # Landing page source
├── scripts/                     # Development scripts
└── test/                        # Bats integration tests
    ├── integration/             # install.bats, sync.bats
    ├── fixtures/                # Test fixtures (sample-archive.tar.gz)
    ├── mocks/                   # Mock curl for offline testing
    └── test_helper/             # Bats support libraries
```

## Using Skills

| Command | Effect |
|---------|--------|
| `Run adapt` | Analyze project and fill in AGENTS.md sections |
| `Research [topic]` | Deep investigation, saves to `.agents/research/` |
| `Run ralph on [plan.md]` | Autonomous execution of plan tasks |

Skills are loaded via natural language. See each skill's SKILL.md in `.agents/skills/` for details.

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
# Run all tests (lint + BATS)
./scripts/test.sh

# Run tests with filter
./scripts/test.sh --filter "help"

# Lint shell scripts (ShellCheck + syntax)
./scripts/lint.sh

# Rebuild test fixture after changes to .agents/ or AGENTS.template.md
./scripts/build-test-fixture.sh

# Serve docs locally
./scripts/serve-docs.sh [port]

# Test installation locally
./install.sh --dry-run
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

### Release Workflow

```bash
# 1. Update VERSION file with new version
echo "1.0.0" > VERSION

# 2. Update CHANGELOG.md - move [Unreleased] items to new version section

# 3. Commit changes
git add -A && git commit -m "Release v1.0.0"

# 4. Create and push release
./scripts/release.sh --push
```

The release script:
- Reads version from `VERSION` file
- Extracts release notes from `CHANGELOG.md`
- Creates git tag `vX.Y.Z`
- Pushes tag and creates GitHub release (requires `gh` CLI)

## Maintenance

After making changes:

1. **Update AGENTS.md** - Keep project structure and commands current
2. **Update README.md** - Reflect user-facing changes
3. **Update plan status** - Move completed plans to `completed/`
4. **Rebuild test fixture** - Run `./scripts/build-test-fixture.sh` if `.agents/` or `AGENTS.template.md` changed

## Conventions

- Shell scripts use `set -euo pipefail`
- Skills use YAML frontmatter with `name` and `description`
- Documentation in Markdown

## Architecture Notes

The installer (`install.sh`) downloads a tarball from GitHub, extracts it to a temp directory, and copies:

- `AGENTS.template.md` → `./AGENTS.md` (only on fresh install, skipped on sync)
- `.agents/` contents (skills, empty directories for plans/prds/research)

User content in `.agents/research/`, `.agents/plans/`, and `.agents/prds/` is preserved during sync. The `AGENTS.md` file is treated as user content after initial install.
