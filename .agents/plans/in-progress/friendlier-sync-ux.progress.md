# Progress: Friendlier Sync UX

## Session 1

### Task 1: Add `--diff` flag to show changes without creating files
**Started**: 2026-02-03

**Status**: Completed

**Changes**:
- Added `DIFF_ONLY` flag variable
- Added `--diff` option to argument parser
- Modified `install_file()` to print unified diff instead of creating conflict files when `--diff` is set
- Modified `main()` to skip metadata write and return exit code 1 when conflicts exist
- Added skip for `.dot-agents.json` in diff mode (auto-generated, always differs)
- Updated help text with `--diff` option
- Added 3 tests: diff shows output, exits 0 when clean, doesn't write metadata

### Task 2: Add `--force` flag to overwrite conflicts
**Status**: Already complete (pre-existing)

**Notes**:
- `--force` flag was already implemented in install.sh
- Creates backup before overwriting
- Tests already exist for this functionality

### Task 3: Change default sync behavior to show diff instead of creating files
**Status**: Completed

**Changes**:
- Added `WRITE_CONFLICTS` flag variable
- Added `--write-conflicts` option for old behavior
- Auto-enable diff mode on sync (when .agents exists) unless --force, --write-conflicts, or --interactive
- Updated test for old behavior to use --write-conflicts
- Added test for new default diff behavior on sync
- Updated CHANGELOG with breaking change notice
