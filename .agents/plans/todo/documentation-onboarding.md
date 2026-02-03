# Plan: QUICKSTART Onboarding Improvements

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/documentation-onboarding.md` |
| Status | todo |
| Created | 2026-02-03 |

## Overview

Improve QUICKSTART.md with prerequisites, expected outputs, installation verification, and a golden path example so new users can succeed on first install.

## Tasks

- [ ] **Task 1: Add Prerequisites section to QUICKSTART.md**
  - Scope: `QUICKSTART.md`
  - Depends on: none
  - Acceptance:
    - Prerequisites section appears after title, before "1. Install"
    - Lists bash 4.0+ (5.0+ recommended), git, curl requirements
    - Lists supported OS: macOS, Linux, WSL
    - Includes security note about reviewing install script before running
    - Includes example command to review script with `less`
  - Notes: See research file for exact content

- [ ] **Task 2: Add Expected Outputs section to QUICKSTART.md**
  - Scope: `QUICKSTART.md`
  - Depends on: Task 1
  - Acceptance:
    - "What Gets Installed" section appears after install command
    - Shows directory tree of `.agents/` structure
    - Lists key files: AGENTS.md, plans/, prds/, research/, skills/
    - Includes verification commands (`ls -la .agents/`, `cat AGENTS.md | head -20`)
  - Notes: Directory tree should match actual installed structure

- [ ] **Task 3: Add Golden Path example to QUICKSTART.md**
  - Scope: `QUICKSTART.md`
  - Depends on: Task 2
  - Acceptance:
    - "Example: Adding User Authentication" section at end of file
    - Shows complete workflow: Research → PRD → Plan → Execute
    - Each step shows example prompt AND resulting file path
    - Sample filenames match the example (jwt-authentication-patterns.md, user-authentication.md)
  - Notes: Use JWT authentication as concrete example per research

## Verification

After all tasks complete:

```bash
# Verify QUICKSTART.md has new sections
grep -q "Prerequisites" QUICKSTART.md
grep -q "What Gets Installed" QUICKSTART.md
grep -q "Example:" QUICKSTART.md
```

All checks must pass before marking plan complete.
