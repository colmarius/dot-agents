---
name: adapt
description: "Analyze project and fill in PROJECT.md. Use when adapting dot-agents to a new project, after initial installation."
---

# Adapt Skill

Analyze the current project and fill in `.agents/PROJECT.md` with project-specific information.

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

3. **Update PROJECT.md**
   - Fill in project name from config
   - List detected tech stack
   - Extract commands from package.json scripts, Cargo.toml, Makefile, etc.
   - Note any project-specific conventions observed

4. **Suggest AGENTS.md updates**
   - Recommend project-specific commands to add
   - Suggest conventions to document

## Example Output

After running, PROJECT.md should look like:

```markdown
# Project Configuration

## Project Name

my-awesome-app

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
- [ ] Update PROJECT.md with findings
- [ ] Suggest any AGENTS.md additions
