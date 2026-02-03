# Plan: Documentation and CLI Consistency

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/improvement-opportunities.md` |
| Status | completed |
| Created | 2026-02-03 |

## Overview

Follow-up improvements identified after completing the initial improvement-opportunities plan. Focus on documentation discoverability, CLI consistency between install.sh and sync.sh, and establishing a minimal versioning scheme.

## Tasks

- [x] **Task 1: Link QUICKSTART.md from README.md**
  - Scope: `README.md`
  - Depends on: none
  - Acceptance:
    - README contains prominent link to QUICKSTART.md in early section
    - Link uses relative path `./QUICKSTART.md`
    - Brief description of what quickstart provides
  - Notes: Highest impact, lowest effort - discovery is everything

- [x] **Task 2: Add --version flag to sync.sh**
  - Scope: `.agents/scripts/sync.sh`
  - Depends on: none
  - Acceptance:
    - `--version` flag added to argument parsing
    - `--version` documented in usage/help text
    - Outputs same format as install.sh: upstream URL, ref, installedAt, lastSyncedAt
    - If `.agents/.dot-agents.json` missing: outputs "dot-agents not installed"
    - Exit code 0
  - Notes: Mirror install.sh's do_version() behavior for consistency

- [x] **Task 3: Add --help flag to sync.sh**
  - Scope: `.agents/scripts/sync.sh`
  - Depends on: Task 2
  - Acceptance:
    - `--help` and `-h` flags show usage information
    - Documents all available flags including `--version`
    - Consistent style with install.sh usage output
  - Notes: Users expect similar CLI UX across scripts

- [x] **Task 4: Document sync behavior in README**
  - Scope: `README.md`
  - Depends on: none
  - Acceptance:
    - Section explains what sync.sh does
    - Documents what gets overwritten vs skipped
    - Mentions conflict handling strategy (skip user files)
  - Notes: Currently README just says "run sync.sh" without explaining behavior

- [x] **Task 5: Add CHANGELOG.md**
  - Scope: `CHANGELOG.md` (root)
  - Depends on: none
  - Acceptance:
    - File exists at root
    - Uses Keep a Changelog format
    - Documents current state as initial release
    - Includes sections: Added, Changed, Fixed
  - Notes: Foundation for versioning scheme

- [x] **Task 6: Document versioning scheme in README**
  - Scope: `README.md`
  - Depends on: Task 5
  - Acceptance:
    - Section explains SemVer tags (vMAJOR.MINOR.PATCH)
    - Documents how to pin to specific version: `--ref v1.0.0`
    - Links to CHANGELOG.md
  - Notes: Makes --ref usage a supported workflow

## Verification

After all tasks complete, run:

```bash
./scripts/test.sh
```

Also manually verify:

```bash
# sync.sh CLI
.agents/scripts/sync.sh --help
.agents/scripts/sync.sh --version

# From non-installed directory
cd /tmp && /path/to/sync.sh --version  # Should show "not installed"
```

All checks must pass before marking plan complete.
