---
name: adapt
description: "Analyzes a project and fills in AGENTS.md. Use after installing dot-agents or when project commands and conventions change. Triggers on: adapt, setup AGENTS, customize AGENTS."
---

# Adapt Skill

Analyze the current project and fill in `AGENTS.md` with project-specific information (tech stack, commands, conventions).

## When to Use

Run this skill after installing dot-agents into a new project, after project commands or conventions change, or after a dot-agents migration changes generic workflow guidance.

## Workflow

1. **Analyze project structure**
   - Scan for configuration files (package.json, Cargo.toml, go.mod, pyproject.toml, etc.)
   - Identify frameworks, libraries, and tools in use
   - Find existing scripts/commands in config files

2. **Detect conventions**
   - Look at code style (naming, formatting)
   - Check for existing linter/formatter configs
   - Identify testing patterns

3. **Preserve project-specific guidance**
   - Read the current `AGENTS.md` before editing it
   - Keep project architecture, commands, conventions, safety rules, and intentional custom workflows
   - Change only sections that are placeholders, stale project facts, or outdated generic dot-agents guidance
   - Prefer concise pointers to canonical detail over copied inventories, and verify commands and paths before documenting them

4. **Update AGENTS.md**
   - Fill in project name/overview
   - List detected tech stack
   - Extract commands from package.json scripts, Cargo.toml, Makefile, etc.
   - Note any project-specific conventions observed
   - Keep the current `.agents/work/` execution, coordination, evidence, and optional handoff model intact
   - Point detailed work-item rules to [the canonical work-item contract](../../work/AGENTS.md) instead of copying it

5. **Repair stale generic workflow references**
   - Replace generic references to the retired `.agents/skills/feature-planning/` skill with `agent-work` for durable requirements, planning, refinement, execution, and handoffs
   - Remove generic `tmux` skill references; use the project's or execution environment's current process-management guidance instead
   - Replace old diagrams that make a work item or handoff mandatory with the current conversational-versus-durable branch
   - Keep small, self-contained planning conversational and reserve work items for continuity, coordination, handoff, auditability, durable decisions, or explicit requests
   - Describe completion as promotion, a committed final snapshot, and removal through `close-work.sh`; do not imply that sync deletes work items
   - Preserve any clearly project-specific skill or workflow that happens to use similar wording; do not mechanically rewrite unrelated instructions

## Example Output

After running, AGENTS.md should have these sections filled in:

````markdown
## Overview

my-awesome-app - A Next.js web application with PostgreSQL backend

## Tech Stack

- Language: TypeScript
- Framework: Next.js 14
- Database: PostgreSQL with Prisma
- Testing: Jest, Playwright

## Commands

```bash
# Install
pnpm install

# Development
pnpm dev

# Build
pnpm build

# Test
pnpm test
pnpm test:e2e

# Lint/Format
pnpm lint
pnpm format
```

## Conventions

- Use kebab-case for file names
- Components in src/components/
- API routes in src/app/api/

## Agent Work

- Keep self-contained work in the current conversation
- Durable work lives in `.agents/work/<category>/<slug>/` when continuity has value
- Use `.agents/research/` only for reusable findings
- Implement in the current thread by default; ask for a handoff prompt when another thread is useful
- Promote reusable outcomes, commit the final completed snapshot, then remove the work item from the current tree
````

## Checklist

- [ ] Read package.json/Cargo.toml/go.mod for project name and scripts
- [ ] Identify main framework from dependencies
- [ ] Find test commands and test file patterns
- [ ] Check for Makefile, Justfile, or task runners
- [ ] Look for .eslintrc, .prettierrc, rustfmt.toml for style configs
- [ ] Preserve project-specific guidance and intentional custom workflows
- [ ] Prefer concise canonical pointers and verify commands and paths before documenting them
- [ ] Replace stale generic `feature-planning`, `tmux`, mandatory-handoff, or completed-item retention references when present
- [ ] Update AGENTS.md with findings
- [ ] Preserve intentional project-specific workflow; otherwise refresh stale generic dot-agents guidance
- [ ] If workflow intent is unclear, leave that section unchanged and report the ambiguity
