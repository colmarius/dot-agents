# Plan: Fix install.sh Postfix Increment Failure

**Issue:** [GitHub Issue #1](https://github.com/colmarius/dot-agents/issues/1)
**Research:** [install-script-postfix-increment.md](../research/install-script-postfix-increment.md)

## Summary

Replace `((var++)) || true` patterns with `var=$((var + 1))` to fix script failures on bash 5.3.9 when `set -e` is enabled.

## Tasks

- [x] **Task 1: Replace postfix increment operators in install.sh**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - All `((var++)) || true` patterns replaced with `var=$((var + 1))`
    - Affected lines: 152, 163, 205, 346, 352, 364, 375, 382, 401
    - Script still functions correctly (dry-run test passes)
  - Notes: Variables to update: `removed`, `backup_count`, `installed_count`, `skipped_count`, `conflict_count`

- [x] **Task 2: Test the fix**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - `bash install.sh --dry-run` completes without error
    - `bash install.sh --help` works
    - `bash install.sh --version` works
  - Notes: Run in the dot-agents repo directory
