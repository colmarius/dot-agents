# Plan: Sync Feature

**Research:** [.agents/research/sync-feature.md](../research/sync-feature.md)
**Created:** 2026-02-03

## Summary

Add `.agents/scripts/sync.sh` - a local wrapper script that allows projects to easily sync updates from the upstream dot-agents repository.

## Tasks

- [x] **Task 1: Create sync.sh script**
  - Scope: `.agents/scripts/sync.sh`
  - Depends on: none
  - Acceptance:
    - Script reads `.dot-agents.json` for upstream URL and ref
    - Parses GitHub URL to extract owner/repo
    - Fetches and executes upstream install.sh with passthrough flags
    - Errors clearly on missing metadata or non-GitHub upstream
    - Script is executable (`chmod +x`)
  - Notes: Use sed for JSON parsing (no jq dependency)

- [ ] **Task 2: Update install.sh to include scripts directory**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - `.agents/scripts/` directory is created during install
    - `sync.sh` is installed with other dot-agents files
    - Existing conflict/backup logic applies to scripts
  - Notes: May need to ensure executable bit is preserved

- [ ] **Task 3: Add lastSyncedAt metadata tracking**
  - Scope: `install.sh` (write_metadata function)
  - Depends on: none
  - Acceptance:
    - First install sets `installedAt` only
    - Subsequent runs add/update `lastSyncedAt`
    - Existing `installedAt` is preserved on updates
  - Notes: Detect if `.dot-agents.json` already exists to differentiate install vs sync

- [ ] **Task 4: Update README documentation**
  - Scope: `README.md`
  - Depends on: Task 1, Task 2
  - Acceptance:
    - New "Sync" section documents `.agents/scripts/sync.sh`
    - Examples show common usage (`--dry-run`, `--force`)
    - Structure section updated to show `scripts/` directory
  - Notes: Keep it concise, match existing doc style

- [ ] **Task 5: Test sync workflow**
  - Scope: Manual testing
  - Depends on: Task 1, Task 2, Task 3
  - Acceptance:
    - Fresh install creates sync.sh
    - Running sync.sh updates files correctly
    - Conflicts handled properly (creates .dot-agents.new)
    - `--dry-run` shows changes without applying
    - `--force` overwrites with backup
    - Error on missing .dot-agents.json
  - Notes: (manual-verify) - requires manual testing
