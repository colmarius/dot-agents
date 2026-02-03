# Quickstart

Get productive with dot-agents in 5 minutes.

## 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

## 2. Adapt AGENTS.md

```text
Run adapt
```

This analyzes your project and fills in AGENTS.md with your tech stack, commands, and conventions.

## 3. Research

Before building, research the problem space:

```text
Research authentication patterns for Express.js APIs
```

Findings are saved to `.agents/research/` for reference.

## 4. Create PRD

Turn research into a product requirements document:

```text
Create a PRD for user authentication based on .agents/research/authentication-patterns.md
```

PRDs go to `.agents/prds/` with acceptance criteria.

## 5. Generate Plan

Convert PRD into implementation tasks:

```text
Create a plan from .agents/prds/user-authentication.md
```

Plans use Ralph-ready task format with scope, dependencies, and acceptance criteria.

## 6. Execute with Ralph

Run autonomous implementation:

```text
Run ralph on .agents/plans/in-progress/user-authentication.md
```

Ralph iterates through tasks, commits after each, and pauses for review.

---

For detailed documentation: <https://dot-agents.dev>
