---
name: adapt
description: "Analyzes a project and fills in AGENTS.md. Use after installing dot-agents or when project commands and conventions change. Triggers on: adapt, setup AGENTS, customize AGENTS."
---

# Adapt

Fill in `AGENTS.md` with verified, project-specific facts: what the project is, its stack, the commands that build, test, and lint it, its conventions, and its architecture.

## Workflow

1. **Read before editing.** Read the current `AGENTS.md`, any ancestor guidance, and the nested `AGENTS.md` files the edit affects. Keep intentional project guidance: architecture, commands, conventions, safety rules, and custom workflows.
2. **Analyze the project.** Read manifests and task runners (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, `Makefile`, `justfile`, CI workflows), linter and formatter configs, and test layout.
3. **Verify, then write.** Run or inspect each command before documenting it. Fill placeholders and fix stale facts; prefer pointers to canonical docs over copied inventories or file trees.
4. **Keep the agent-work section current.** It should say to keep self-contained work in the conversation, create a work item when people need to review direction or the work must outlive the conversation, and follow `.agents/work/AGENTS.md` for the rest. Replace older generic dot-agents text with that short section: work-item file trees or artifact lists (`prd.md`, `progress.md`, `decisions/`, `plans/`, `handoff-*.md`), copied task-field formats, workflow diagrams, and references to `feature-planning`, `tmux`, mandatory plans, or mandatory handoffs. Leave project-specific workflows alone.
5. **Report** what changed, which commands you verified, and any section you left unchanged because its intent was unclear.

## Example

````markdown
## Overview

my-app - A Next.js web application with a PostgreSQL backend.

## Tech Stack

- TypeScript, Next.js 14, PostgreSQL with Prisma, Jest and Playwright

## Commands

```bash
pnpm install       # install
pnpm dev           # develop
pnpm test          # unit tests
pnpm test:e2e      # browser tests
pnpm lint          # lint and format check
```

## Conventions

- kebab-case file names; components in `src/components/`; API routes in `src/app/api/`
````
