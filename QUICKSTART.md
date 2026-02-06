# Quickstart

Get productive with dot-agents in 5 minutes.

## Prerequisites

- **bash** 4.0+ (5.0+ recommended)
- **git** for version control
- **curl** for installation
- **OS:** macOS, Linux, or WSL

> **Security:** Review the install script before running:
>
> ```bash
> curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | less
> ```

## 1. Install

**cmd:**
```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

### What Gets Installed

After running the install command, you'll have:

```
your-project/
├── AGENTS.md              # Template - customize for your project
└── .agents/
    ├── plans/
    │   ├── todo/
    │   ├── in-progress/
    │   └── completed/
    ├── prds/
    │   └── TEMPLATE.md
    ├── research/
    ├── reference/         # gitignored - for external repos
    ├── scripts/
    │   └── sync.sh
    └── skills/
        ├── adapt/
        ├── ralph/
        ├── research/
        └── tmux/
```

### Verify Installation

**cmd:**
```bash
ls -la .agents/
cat AGENTS.md | head -20
```

## 2. Adapt AGENTS.md

**prompt:**
```text
Run adapt
```

This analyzes your project and fills in the AGENTS.md template with your tech stack, commands, and conventions. You can also customize it manually.

## 3. Research

Before building, research the problem space:

**prompt:**
```text
Research authentication patterns for Express.js APIs
```

Findings are saved to `.agents/research/` for reference.

## 4. Create PRD

Turn research into a product requirements document:

**prompt:**
```text
Create a PRD for user authentication based on .agents/research/authentication-patterns.md
```

PRDs go to `.agents/prds/` with acceptance criteria.

## 5. Generate Plan

Convert PRD into implementation tasks:

**prompt:**
```text
Create a plan from .agents/prds/user-authentication.md
```

Plans use Ralph-ready task format with scope, dependencies, and acceptance criteria.

## 6. Execute with Ralph

Run autonomous implementation:

**prompt:**
```text
Run ralph on .agents/plans/in-progress/user-authentication.md
```

Ralph iterates through tasks, commits after each, and pauses for review.

---

**Next:** [Concepts](./docs/concepts.md) · [Skills Reference](./docs/skills.md) · [dot-agents.dev](https://dot-agents.dev)
