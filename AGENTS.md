# Project Instructions

## Overview

dot-agents is an AI-ready `.agents/` workspace scaffold for any project. It provides durable work items, reusable research, and skills for planning, handoff prompts, and agent-assisted development across threads.

## Tech Stack

- Language: Bash (install/sync scripts), Markdown (documentation, skills)
- Testing: Bats (Bash Automated Testing System)

## Workflow

```text
Work Item → Research/PRD as needed → Plan → Handoff Prompt → Implement → Record Progress
```

1. **Work Item:** Create `.agents/work/<category>/<slug>/index.md` as the durable entrypoint.
2. **Research/PRD:** Save task-specific findings and requirements beside the work item.
3. **Plan:** Break work into implementation-ready tasks in `plan.md`.
4. **Handoff Prompt:** Generate a paste-ready prompt for a fresh implementation thread.
5. **Progress:** Implementation threads update `progress.md`, task checkboxes, and `index.md`.

## Project Structure

```text
dot-agents/
├── AGENTS.md                    # This file - contributor instructions
├── AGENTS.template.md           # Template copied to user projects
├── install.sh                   # Main installation script
├── .agents/
│   ├── work/                    # Work-item guidance installed into projects
│   ├── skills/                  # adapt, agent-work, feature-planning, research, tmux
│   ├── research/                # Reusable research notes
│   ├── references/              # External reference repos (gitignored)
│   └── scripts/                 # sync.sh
├── docs/                        # Full documentation
├── site/                        # Landing page source
├── scripts/                     # Development scripts
└── test/                        # Bats integration tests
```

## Using Skills

| Command | Effect |
| --- | --- |
| `Run adapt` | Analyze project and fill in `AGENTS.md` sections |
| `Create a new work item for ...` | Create durable `.agents/work/` context |
| `Research ...` | Investigate and save work-local or reusable findings |
| `Create/refine a plan for ...` | Produce implementation-ready `plan.md` tasks |
| `Write a handoff prompt for ...` | Produce a paste-ready prompt for a new implementation thread |

Skills are loaded via natural language. See each skill's `SKILL.md` in `.agents/skills/` for details.

## Work Item Management

Work items live under:

```text
.agents/work/<category>/<slug>/
```

Every work item has `index.md` with status, category, updated date, artifact links, next action, and open questions. Optional files include `research.md`, `prd.md`, `plan.md`, `progress.md`, and `decisions/` records.

Legacy `.agents/plans/` and `.agents/prds/` paths may exist in older installs. Preserve legacy plan and PRD documents as user content, but allow sync to retire stale Ralph guidance/templates. Migrate one plan at a time into `.agents/work/` only when requested.

## Commands

```bash
# Run all tests (lint + Bats)
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

- Write clear, descriptive commit messages.
- Commit after each logical step.
- Do not push directly to the default branch unless the repository maintainer explicitly requests it.

### Release Workflow

```bash
# 1. Update VERSION file with new version
echo "0.3.0" > VERSION

# 2. Update CHANGELOG.md - move [Unreleased] items to new version section

# 3. Commit changes
git add -A && git commit -m "Release v0.3.0"

# 4. Create and push release
./scripts/release.sh --push
```

## Maintenance

After making changes:

1. **Update AGENTS.md** - Keep contributor structure and commands current.
2. **Update README.md / QUICKSTART.md / docs** - Reflect user-facing workflow changes.
3. **Update tests** - Preserve install/sync behavior in Bats.
4. **Rebuild test fixture** - Run `./scripts/build-test-fixture.sh` if `.agents/` or `AGENTS.template.md` changed.

## Conventions

- Shell scripts use `set -euo pipefail`.
- Skills use YAML frontmatter with quoted `description` values and `Triggers on:` phrases.
- Documentation uses Markdown with fenced code blocks.

## Architecture Notes

The installer (`install.sh`) downloads a tarball from GitHub, extracts it to a temp directory, and copies:

- `AGENTS.template.md` → `./AGENTS.md` on fresh install only.
- Upstream-owned `.agents/` files such as skills, `.agents/work/AGENTS.md`, and `sync.sh`.

User content under `.agents/work/<category>/<slug>/`, `.agents/research/`, and legacy plan/PRD documents is preserved during sync. Retired upstream skills and stale legacy guidance/templates may be backed up and removed during sync.
