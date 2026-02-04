# Plan: Installer Improvements

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/improvement-suggestions.md` |
| Status | todo |
| Created | 2026-02-04 |

## Overview

Address high and medium priority improvements from user feedback after installing dot-agents on existing projects. Focus on better UX, safer defaults, and clearer guidance.

## Tasks

- [x] **Task 1: Add backup directory to gitignore**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - `.agents/.gitignore` includes `.dot-agents-backup/` entry (relative path `../.dot-agents-backup/`)
    - Entry added during fresh install and sync
    - Existing `.gitignore` content preserved
  - Notes: Create `.agents/.gitignore` if it doesn't exist

- [x] **Task 2: Add post-install guidance with next steps**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - After install summary, print actionable next steps
    - Include: "Run 'adapt' to customize AGENTS.md"
    - Include: link to QUICKSTART.md
    - Only show on fresh install (not sync)
  - Notes: Use existing color formatting for consistency

- [ ] **Task 3: Show version/commit in install message**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - For tags: show `Installing dot-agents v1.2.0...`
    - For branches: show `Installing dot-agents (main @ abc123f)...`
    - Commit SHA available from extracted archive directory name
  - Notes: Parse short SHA from extracted directory or use git API

- [ ] **Task 4: Document sync command in post-install output**
  - Scope: `install.sh`
  - Depends on: Task 2
  - Acceptance:
    - On sync (not fresh install), print how to update in the future
    - Message: "To update: curl ... | bash" or reference local script
  - Notes: Keep it concise, single line

- [ ] **Task 5: Preserve custom skills during sync**
  - Scope: `install.sh`, `.agents/skills/`
  - Depends on: none
  - Acceptance:
    - Detect non-core skills in `.agents/skills/` before sync
    - Core skills: adapt, ralph, research, tmux (from upstream)
    - Custom skills: anything else, preserved without modification
    - Print message listing preserved custom skills
  - Notes: Skills are directories under `.agents/skills/`

- [ ] **Task 6: Update tests for new installer behavior**
  - Scope: `test/integration/install.bats`
  - Depends on: Task 1, Task 2, Task 3, Task 4, Task 5
  - Acceptance:
    - Tests verify `.gitignore` entry creation
    - Tests verify post-install guidance output
    - Tests verify custom skill preservation
    - All existing tests still pass
  - Notes: Run `./scripts/test.sh` to verify

## Verification

After all tasks complete, run:

```bash
# Lint shell scripts (ShellCheck + syntax)
./scripts/lint.sh

# Run all tests (lint + BATS)
./scripts/test.sh

# Manual verification
./install.sh --dry-run
```

All checks must pass before marking plan complete.
