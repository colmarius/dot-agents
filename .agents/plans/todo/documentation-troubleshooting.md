# Plan: Troubleshooting Documentation

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/documentation-troubleshooting.md` |
| Status | todo |
| Created | 2026-02-03 |

## Overview

Create a dedicated troubleshooting guide covering common issues from CHANGELOG and anticipated user problems, making solutions easily discoverable.

## Tasks

- [ ] **Task 1: Create docs/troubleshooting.md with installation issues**
  - Scope: `docs/troubleshooting.md`
  - Depends on: none
  - Acceptance:
    - File exists at docs/troubleshooting.md
    - Has "Installation Issues" section
    - Documents "BASH_SOURCE[0]: unbound variable" fix
    - Documents bash 5.3+ script exit issue
    - Each issue has: symptoms, cause, solution
  - Notes: Issues from CHANGELOG commits 455019a and 4d97cce

- [ ] **Task 2: Add skill issues section to troubleshooting**
  - Scope: `docs/troubleshooting.md`
  - Depends on: Task 1
  - Acceptance:
    - "Skill Issues" section exists
    - Documents "skill not loading" with checks
    - Documents "custom skill not found" with SKILL.md format requirements
    - Solutions include directory verification steps
  - Notes: Common anticipated issues

- [ ] **Task 3: Add sync issues section to troubleshooting**
  - Scope: `docs/troubleshooting.md`
  - Depends on: Task 1
  - Acceptance:
    - "Sync Issues" section exists
    - Documents "sync overwrote my changes" with backup locations
    - Documents "sync reports conflicts" with --dry-run and --force options
    - Clarifies what is/isn't overwritten
  - Notes: Sync behavior is confusing for users

- [ ] **Task 4: Add Ralph issues section to troubleshooting**
  - Scope: `docs/troubleshooting.md`
  - Depends on: Task 1
  - Acceptance:
    - "Ralph Issues" section exists
    - Documents "Ralph not finding tasks" with checklist
    - Documents "Ralph stops unexpectedly" with context/blocking explanations
    - Includes resume command example
  - Notes: Ralph issues are common for new users

- [ ] **Task 5: Add permission issues and getting help sections**
  - Scope: `docs/troubleshooting.md`
  - Depends on: Task 1
  - Acceptance:
    - "Permission Issues" section with chmod fix
    - "Getting Help" section with GitHub Issues link
    - Link to CHANGELOG for known fixes
  - Notes: Complete the troubleshooting guide

- [ ] **Task 6: Add quick troubleshooting reference to QUICKSTART.md**
  - Scope: `QUICKSTART.md`
  - Depends on: Task 5
  - Acceptance:
    - "Troubleshooting" section at end of QUICKSTART
    - Table with 3-4 common problems and quick fixes
    - Links to docs/troubleshooting.md for details
  - Notes: Keep brief, just top issues

- [ ] **Task 7: Link troubleshooting from docs/index.html**
  - Scope: `docs/index.html`
  - Depends on: Task 5
  - Acceptance:
    - Link to troubleshooting.md on GitHub
    - Placed in footer or support section
  - Notes: Helps users find help from landing page

## Verification

After all tasks complete:

```bash
# Verify troubleshooting.md exists with all sections
test -f docs/troubleshooting.md
grep -q "Installation Issues" docs/troubleshooting.md
grep -q "Skill Issues" docs/troubleshooting.md
grep -q "Sync Issues" docs/troubleshooting.md
grep -q "Ralph Issues" docs/troubleshooting.md

# Verify QUICKSTART links to troubleshooting
grep -q "troubleshooting" QUICKSTART.md
```

All checks must pass before marking plan complete.
