---
name: adapt
description: "Analyze project and fill in AGENTS.md. Use when adapting dot-agents to a new project, after initial installation."
triggers: run adapt, adapt the project, analyze project
keywords: project analysis, tech stack detection, configuration
invocation: "Run adapt"
---

# Adapt Skill

Analyze the current project and fill in `AGENTS.md` with project-specific information (tech stack, commands, conventions).

## When to Use

Run this skill after installing dot-agents into a new project to customize the configuration.

## Workflow

1. **Analyze project structure**
   - Scan for configuration files (package.json, Cargo.toml, go.mod, pyproject.toml, etc.)
   - Identify frameworks, libraries, and tools in use
   - Find existing scripts/commands in config files

2. **Detect conventions**
   - Look at code style (naming, formatting)
   - Check for existing linter/formatter configs
   - Identify testing patterns

3. **Update AGENTS.md**
   - Fill in project name/overview
   - List detected tech stack
   - Extract commands from package.json scripts, Cargo.toml, Makefile, etc.
   - Note any project-specific conventions observed

## Example Output

After running, AGENTS.md should have these sections filled in:

```markdown
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

## Checklist

- [ ] Read package.json/Cargo.toml/go.mod for project name and scripts
- [ ] Identify main framework from dependencies
- [ ] Find test commands and test file patterns
- [ ] Check for Makefile, Justfile, or task runners
- [ ] Look for .eslintrc, .prettierrc, rustfmt.toml for style configs
- [ ] Update AGENTS.md with findings
