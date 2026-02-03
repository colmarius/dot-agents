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
