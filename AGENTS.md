# Project Instructions

## Overview

dot-agents is an AI-ready `.agents/` workspace scaffold for any project. It provides durable work items, reusable research, and skills for planning, handoff prompts, and agent-assisted development across threads.

## Tech Stack

- Language: Bash (install/sync scripts), Markdown (documentation, skills)
- Testing: Bats (Bash Automated Testing System)

## Workflow

```text
Request or change
├─ Self-contained ───────────▶ Plan and execute in this conversation ─▶ Verify and report
└─ Continuity has value ─────▶ Work Item → Context as needed → Plan → Execute → Verify
                                                                    ├─ Hand off when useful
                                                                    └─ Promote → Commit snapshot → Remove
```

Keep small, self-contained planning and execution in the current conversation. Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit request justifies repository context. For durable work, add context only when needed, implement in the current thread by default, and hand off only when another worker or environment genuinely helps.

The canonical artifact, status, and completion contract lives in `.agents/work/AGENTS.md`.

## Project Structure

```text
dot-agents/
├── AGENTS.md                    # This file - contributor instructions
├── AGENTS.template.md           # Template copied to user projects
├── install.sh                   # Main installation script
├── .agents/
│   ├── work/                    # Work-item guidance installed into projects
│   ├── skills/                  # adapt, agent-browser, agent-work, research
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
| `Use agent-browser to verify ...` | Load current real-browser automation guidance from the installed CLI |
| `Create a new work item for ...` | Create durable `.agents/work/` context |
| `Research ...` | Investigate and save work-local or reusable findings |
| `Create/refine/execute a plan for ...` | Produce implementation-ready tasks and implement in the current thread |
| `Write a handoff prompt for ...` | Produce a paste-ready prompt for a new implementation thread |

Skills are loaded via natural language. See each skill's `SKILL.md` in `.agents/skills/` for details.

## Work Item Management

Work items live under:

```text
.agents/work/<category>/<slug>/
```

Every work item has `index.md` with stable intent, current status and summary, category, updated date, artifact links, next action, and open questions. Categories are an open lowercase kebab-case namespace. Optional artifacts include `research.md`, indexed `research/`, `prd.md`, `plan.md`, indexed `plans/`, living `progress.md`, `decisions/` records, and separately named `handoff-*.md` files.

Use work items only when durable context earns its maintenance cost. Follow `.agents/work/AGENTS.md` as the source of truth for artifact ownership and lifecycle rules, including promotion, the committed final snapshot, and removal from the current tree.

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

# Install dependencies and develop the Astro landing page
npm install
npm run dev

# Start declared Orb services and print the authenticated portal URL
amp orb services ensure

# Build the landing page for production
npm run build

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
# 1. Update VERSION and pinned --ref examples with the new version
echo "0.5.0" > VERSION

# 2. Update CHANGELOG.md - move [Unreleased] items to new version section

# 3. Commit changes
git add -A && git commit -m "Release v0.5.0"

# 4. Push the reviewed release commit and verify the remote branch matches
git push origin main
test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)"

# 5. Create and push release
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

Orb lifecycle hooks install and validate the pinned development environment. `.amp/services.yaml` declares the supervised Astro service; it listens on `$PORT`, and Vite accepts only Amp's `.e2b.app` and `.onamp.dev` portal host suffixes.
