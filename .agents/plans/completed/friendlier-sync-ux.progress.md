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

### Task 3: Change default sync behavior
**Status**: Completed

**Changes**:
- Added `WRITE_CONFLICTS` flag variable
- Added `--write-conflicts` option for creating conflict files
- Auto-enable force mode on sync (when .agents exists) unless --diff, --write-conflicts, or --interactive
- Updated tests for new default force behavior
- Updated CHANGELOG with breaking change notice

**Revised behavior** (per user feedback):
- Default sync: force overwrite with backup
- `--diff`: show diffs only, no file changes
- `--write-conflicts`: create .dot-agents.new files

### Task 4: Update tests for new flags
**Status**: Completed (covered by Tasks 1 and 3)

**Notes**:
- Tests for --diff added in Task 1
- Tests for --force already existed
- Conflict tests updated in Task 3

### Task 5: Update documentation
**Status**: Completed

**Changes**:
- Updated README.md with sync options table
- docs/ did not need updates (no conflict-specific content)
