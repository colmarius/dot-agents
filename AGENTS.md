# Project Instructions

## Overview

dot-agents is an AI-ready `.agents/` workspace scaffold for any project. It provides durable work items, reusable research, and skills for planning, handoff prompts, and agent-assisted development across threads.

## Tech Stack

- Language: Bash (install/sync scripts), Markdown (documentation, skills)
- Testing: Bats (Bash Automated Testing System)

## Workflow

Keep work in the conversation when one thread can finish it. Create a work item when people need a durable record to review or decide direction, when the work must resume in another session, thread, or worker, or when the user asks. Its `index.md` is the shared record and recovery checkpoint; add research, a proposal, or a plan only when someone will read it.

The contract lives in `.agents/work/AGENTS.md`; this repository ships it to user projects, so keep it, the skills, and the docs consistent.

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
| `Continue the work item at ...` | Resume from `index.md` and implement the next action |
| `Research ...` | Investigate and save work-local or reusable findings |
| `Write a handoff prompt for ...` | Produce a paste-ready prompt for a new implementation thread |
| `Close the work item at ...` | Promote outcomes, commit the final snapshot, and stage removal |

Skills are loaded via natural language. See each skill's `SKILL.md` in `.agents/skills/` for details.

## Work Item Management

Work items live under:

```text
.agents/work/<category>/<slug>/
```

Every work item has `index.md` with metadata (`Status`, `Category`, `Updated`) and `Why`, `Summary`, optional `Artifacts` and `Decisions`, `Next Action`, and a short `Log`. Support files are named by content, such as `research.md`, `proposal.md`, `plan.md`, and `log.md`. Follow `.agents/work/AGENTS.md` for the rules, including promotion, the committed final snapshot, and removal.

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

Choose and confirm the new version before running this workflow. Update current pins in `install.sh` help and `README.md` (both installer URL and `--ref`), plus the changelog release section and comparison links. The site derives its current pin from `VERSION`. Preserve historical changelog text and version-specific migration examples. Rebuild the fixture if installable guidance changed, then run `./scripts/test.sh` and `npm run build`.

```bash
# 1. Set the explicitly approved, unreleased version
read -r -p "Approved new version (without v): " new_version
printf '%s\n' "${new_version:?A new version is required}" > VERSION

# 2. Update current pins and CHANGELOG.md as described above; verify the candidate

# 3. Review and commit only the intended release changes
git diff
git add VERSION install.sh README.md CHANGELOG.md
git commit -m "Release v$new_version"

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

- `AGENTS.template.md` → `./AGENTS.md` when missing; existing root guidance is preserved.
- Upstream-owned `.agents/` files such as skills, `.agents/work/AGENTS.md`, and `sync.sh`.

User content under `.agents/work/<category>/<slug>/`, `.agents/research/`, and legacy plan/PRD documents is preserved during sync. Retired upstream skills and stale legacy guidance/templates may be backed up and removed during sync.

Orb lifecycle hooks install and validate the pinned development environment. `.amp/services.yaml` declares the supervised Astro service; it listens on `$PORT`, and Vite accepts only Amp's `.e2b.app` and `.onamp.dev` portal host suffixes.
