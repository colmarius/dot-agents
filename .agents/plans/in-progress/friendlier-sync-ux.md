# Plan: Friendlier Sync UX

## Problem

Running `sync` creates untracked conflict files (`.dot-agents.new`, `.dot-agents.md`) that clutter the workspace. Users with git can already diff changes—they just need to see what changed.

## Goals

- Reduce file clutter during sync
- Provide clear visibility into what changed
- Let users choose how to handle conflicts

## Tasks

- [x] **Task 1: Add `--diff` flag to show changes without creating files**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - `--diff` prints unified diff for each conflicting file
    - No `.dot-agents.new` or `.dot-agents.md` files created
    - Exit code indicates if conflicts exist (0=clean, 1=conflicts)
  - Notes: Use `diff -u` for familiar git-like output

- [x] **Task 2: Add `--force` flag to overwrite conflicts**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - `--force` overwrites local files with upstream versions
    - Warning printed for each overwritten file
    - Works with `--sync` mode
  - Notes: Already implemented - creates backup and overwrites

- [x] **Task 3: Change default sync behavior to show diff instead of creating files**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - Default sync shows diff output (no file creation)
    - Add `--write-conflicts` flag for old behavior (if needed)
    - Update help text and documentation
  - Notes: Breaking change—document in CHANGELOG

- [ ] **Task 4: Update tests for new flags**
  - Scope: `test/integration/install.bats`
  - Depends on: Task 1, Task 2, Task 3
  - Acceptance:
    - Tests for `--diff` flag behavior
    - Tests for `--force` flag behavior
    - Existing conflict tests updated for new defaults

- [ ] **Task 5: Update documentation**
  - Scope: `README.md`, `docs/`
  - Depends on: Task 3
  - Acceptance:
    - Document new flags in README
    - Update any sync workflow docs
