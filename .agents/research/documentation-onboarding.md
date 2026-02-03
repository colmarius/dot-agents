# Research: Onboarding & Prerequisites Documentation

**Date:** 2026-02-03
**Status:** Complete
**Tags:** documentation, onboarding, developer-experience
**Parent:** documentation-improvements.md

## Summary

New users lack critical information to succeed on first install. QUICKSTART.md needs prerequisites, expected outputs, and a golden path example.

## Current Gaps

### 1. Missing Prerequisites

Users don't know before installing:
- Required tools: git, curl, bash
- Supported shells/OS (macOS, Linux, WSL)
- Bash version quirks (5.3+ compatibility issues)
- Security note for `curl | bash` pattern

### 2. Missing Expected Outputs

After install, users don't know:
- What files/directories were created
- What the `.agents/` structure looks like
- How to verify successful installation

### 3. Missing Golden Path Example

QUICKSTART shows commands but not:
- Example prompts with resulting file paths
- Sample filenames for each artifact
- End-to-end feature example (research → PRD → plan → Ralph)

## Recommendations

### Add Prerequisites Section to QUICKSTART.md

```markdown
## Prerequisites

- **bash** 4.0+ (5.0+ recommended)
- **git** for version control
- **curl** for installation
- **OS:** macOS, Linux, or WSL

> **Security:** Review the install script before running:
> ```bash
> curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | less
> ```
> Or pin a specific version with `--ref v1.0.0`.
```

### Add Expected Outputs Section

```markdown
## What Gets Installed

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

```bash
ls -la .agents/
cat AGENTS.md | head -20
```
```

### Add Golden Path Example

```markdown
## Example: Adding User Authentication

Here's a complete workflow from research to execution:

### 1. Research
```text
Research JWT authentication patterns for Express.js
```
Creates: `.agents/research/jwt-authentication-patterns.md`

### 2. Create PRD
```text
Create a PRD for user authentication based on .agents/research/jwt-authentication-patterns.md
```
Creates: `.agents/prds/user-authentication.md`

### 3. Generate Plan
```text
Create a plan from .agents/prds/user-authentication.md
```
Creates: `.agents/plans/todo/user-authentication.md`

### 4. Execute
```text
Run ralph on .agents/plans/in-progress/user-authentication.md
```
Ralph commits after each task, pauses for review.
```

## Implementation Tasks

- [ ] Add Prerequisites section to QUICKSTART.md
- [ ] Add Expected Outputs section with directory tree
- [ ] Add Verify Installation commands
- [ ] Add Golden Path example with sample filenames
- [ ] Add security note about reviewing install script

## Effort Estimate

~1-2 hours

## Sources

- Oracle review feedback
- Parent research: documentation-improvements.md
