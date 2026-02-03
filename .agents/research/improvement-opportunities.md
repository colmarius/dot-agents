# Research: dot-agents Improvement Opportunities

**Date:** 2026-02-03
**Status:** Complete
**Tags:** dot-agents, tooling, developer-experience

## Summary

Analysis of the dot-agents setup framework (<https://dot-agents.dev/>) after installation, identifying gaps and improvement opportunities to enhance the developer experience and robustness.

## Key Learnings

- Install script has bash compatibility issues with strict mode
- Missing templates and gitignore entries create friction
- Documentation gaps around skill invocation and quickstart flow

## Details

### Install Script Robustness

The install script fails when piped directly to bash due to unguarded `BASH_SOURCE[0]` access with strict mode (`set -u`).

**Current behavior:**

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
# Error: bash: line 477: BASH_SOURCE[0]: unbound variable
```

**Fix:** Guard with default value:

```bash
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    # script is being executed
fi
```

### Missing .gitignore

The `.agents/` directory lacks a `.gitignore` file. External repos in `reference/` should be ignored, and optionally progress files.

**Recommended `.agents/.gitignore`:**

```gitignore
# External repositories (cloned for reference)
reference/

# Optional: ephemeral progress tracking
# *.progress.md
```

### Missing Plan Template

PRDs have `TEMPLATE.md` but plans don't, forcing users to copy from documentation.

**Recommended `.agents/plans/TEMPLATE.md`:**

```markdown
# Plan: <Title>

| Field | Value |
|-------|-------|
| PRD | `../prds/PRD-XXX.md` |
| Status | todo / in-progress / completed |
| Created | YYYY-MM-DD |

## Overview

Brief description of what this plan accomplishes.

## Tasks

- [ ] **Task 1: Short descriptive title**
  - Scope: `path/to/affected/files`
  - Depends on: none
  - Acceptance:
    - Specific, verifiable criterion 1
    - Specific, verifiable criterion 2
  - Notes: Optional implementation hints

- [ ] **Task 2: Next task title**
  - Scope: `path/to/files`
  - Depends on: Task 1
  - Acceptance:
    - Criterion
```

### Skill Invocation Documentation

Root `AGENTS.md` references skills but doesn't explain how to invoke them.

**Add to AGENTS.md:**

```markdown
## Using Skills

Invoke skills with natural language:

| Command | Effect |
|---------|--------|
| `adapt this project` | Analyze and fill in AGENTS.md |
| `run ralph on .agents/plans/in-progress/my-plan.md` | Execute plan autonomously |
| `research [topic]` | Deep research, saves to .agents/research/ |
```

### Version Flag

Install and sync scripts lack `--version` flag for debugging.

**Suggested output:**

```bash
$ .agents/scripts/sync.sh --version
dot-agents v1.0.0 (installed: 2026-01-31, upstream: main)
```

### Research Skill Librarian Clarification

The research skill references `librarian` tool without clarifying its scope.

**Add note:**

```markdown
> **Note:** The `librarian` tool only has access to GitHub repositories
> (public repos and private repos you've authorized). Use it for exploring
> open-source implementations, not local code.
```

### Quickstart Guide

New users lack a clear end-to-end path. A `QUICKSTART.md` would help.

**Outline:**

1. Install: `curl ... | bash`
2. Adapt: `adapt this project` (fills AGENTS.md)
3. Research: `research [topic]` (optional)
4. PRD: Create from template
5. Plan: Generate Ralph-ready tasks
6. Execute: `run ralph on [plan]`

## Example Prompts

### Setup Prompt (after install)

```text
Setup: https://dot-agents.dev/

Then adapt this project - analyze the codebase and fill in AGENTS.md with:
- Project overview and tech stack
- Build/test/lint commands from package.json
- Code conventions you observe
- Project structure
```

### Usage Prompts

**Research a topic:**

```text
Research React Server Components - focus on data fetching patterns
and when to use them vs client components. Save to .agents/research/
```

**Create a PRD:**

```text
Create a PRD for user authentication using the template in .agents/prds/TEMPLATE.md.
Requirements: email/password login, session management, password reset flow.
```

**Generate a plan from PRD:**

```text
Generate a Ralph-ready plan from .agents/prds/PRD-20260203-user-auth.md
Break it into small tasks with clear scopes and acceptance criteria.
Save to .agents/plans/todo/
```

**Execute a plan:**

```text
Run ralph on .agents/plans/in-progress/PLAN-20260203-user-auth.md
```

**Resume from a specific task:**

```text
Continue ralph from Task 4 on .agents/plans/in-progress/PLAN-20260203-user-auth.md
```

**Check progress:**

```text
Show ralph progress for .agents/plans/in-progress/PLAN-20260203-user-auth.md
```

**Archive completed plans:**

```text
Archive completed plans - delete each from .agents/plans/completed/ with its own commit
```

## Recommendations

| Priority | Improvement | Effort |
|----------|-------------|--------|
| High | Fix BASH_SOURCE install bug | Low |
| High | Add plan TEMPLATE.md | Low |
| Medium | Add .agents/.gitignore | Low |
| Medium | Add skill invocation docs to AGENTS.md | Low |
| Medium | Add QUICKSTART.md | Medium |
| Low | Add --version flag | Low |
| Low | Clarify librarian scope in research skill | Low |

## Sources

- [dot-agents.dev](https://dot-agents.dev/) - Landing page and install instructions
- [GitHub repo](https://github.com/colmarius/dot-agents) - Source code
- Local installation analysis - Hands-on testing

## Open Questions

- [ ] Should progress files be gitignored by default?
- [ ] Is there a versioning scheme planned for dot-agents releases?
- [ ] Should skills be installable independently (à la plugins)?

## Related Research

- None yet
