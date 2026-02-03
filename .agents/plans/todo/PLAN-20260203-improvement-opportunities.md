# Plan: dot-agents Improvement Opportunities

| Field | Value |
|-------|-------|
| PRD | N/A (based on research) |
| Research | `../../research/improvement-opportunities.md` |
| Status | todo |
| Created | 2026-02-03 |

## Overview

Implement improvements identified in the dot-agents framework analysis to enhance developer experience, fix bugs, and add missing documentation/templates.

## Tasks

- [ ] **Task 1: Fix BASH_SOURCE install script execution guard**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - Guard uses pattern: `if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == "$0" ]]`
    - `cat install.sh | bash -s -- --dry-run` succeeds (piped execution)
    - `./install.sh --dry-run` succeeds (direct execution)
    - `source ./install.sh` does not output "Installing..." (sourced, no execution)
  - Notes: Empty BASH_SOURCE means stdin (piped), must still run. Only skip when sourced.

- [ ] **Task 2: Fix installer skip logic for plans/TEMPLATE.md**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - Skip logic changed to only skip `plans/todo/*.md`, `plans/in-progress/*.md`, `plans/completed/*.md`
    - `plans/TEMPLATE.md` is NOT skipped
    - Fresh install includes `.agents/plans/TEMPLATE.md`
  - Notes: Current `plans/*.md` glob incorrectly skips TEMPLATE.md at plans root

- [ ] **Task 3: Add plan TEMPLATE.md**
  - Scope: `.agents/plans/TEMPLATE.md`
  - Depends on: Task 2
  - Acceptance:
    - Template exists at `.agents/plans/TEMPLATE.md`
    - Includes metadata table (PRD, Status, Created)
    - Includes Ralph-ready task format with Scope, Depends on, Acceptance, Notes
    - Consistent with format documented in root AGENTS.md
  - Notes: Mirror structure from research doc recommendations

- [ ] **Task 4: Add .agents/.gitignore**
  - Scope: `.agents/.gitignore`
  - Depends on: none
  - Acceptance:
    - File exists at `.agents/.gitignore`
    - Contains line: `reference/`
    - Contains comment explaining purpose
  - Notes: Keep simple, don't ignore progress files by default

- [ ] **Task 5: Add skill invocation documentation to AGENTS.md**
  - Scope: `AGENTS.md`
  - Depends on: none
  - Acceptance:
    - New "## Using Skills" section exists after "## Project Structure"
    - Contains table with columns: Command, Effect
    - Documents: adapt, ralph, research skills
  - Notes: Keep to essential commands only

- [ ] **Task 6: Add --version flag to install.sh**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - `--version` added to `parse_args()` function
    - `--version` documented in `usage()` function
    - Outputs: upstream URL, default ref
    - If `.agents/.dot-agents.json` exists: also outputs installedAt, lastSyncedAt, ref
    - If not installed: outputs "dot-agents not installed in this directory"
    - Exit code 0
  - Notes: Read metadata from .dot-agents.json when available

- [ ] **Task 7: Create QUICKSTART.md**
  - Scope: `QUICKSTART.md` (root)
  - Depends on: Task 5
  - Acceptance:
    - File exists at `QUICKSTART.md`
    - Contains numbered steps: install, adapt, research, PRD, plan, ralph
    - Each step includes example prompt text
    - Links to <https://dot-agents.dev> for detailed docs
  - Notes: Focus on actionable examples

- [ ] **Task 8: Clarify librarian scope in research skill**
  - Scope: `.agents/skills/research/SKILL.md`
  - Depends on: none
  - Acceptance:
    - Blockquote note added explaining librarian only accesses GitHub repos
    - Note placed near librarian tool usage instructions
  - Notes: Distinguish from finder/Grep which work on local code

## Verification

After all tasks complete, run:

```bash
./scripts/test.sh
```

This runs:

1. `./scripts/lint.sh` - ShellCheck + bash syntax validation
2. BATS tests in `test/` directory

All checks must pass before marking plan complete.
