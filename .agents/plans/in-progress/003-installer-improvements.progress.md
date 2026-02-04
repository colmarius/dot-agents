# Progress: 003-installer-improvements

## Session: 2026-02-04

### Task 1: Add backup directory to gitignore
- **Status**: Complete
- **Started**: 2026-02-04
- **Changes**:
  - Added `ensure_gitignore_entry()` function to install.sh
  - Function creates/updates `.agents/.gitignore` with `../.dot-agents-backup/` entry
  - Added backup entry to upstream `.agents/.gitignore` for fresh installs
  - Preserves existing gitignore content

### Task 2: Add post-install guidance with next steps
- **Status**: Complete
- **Started**: 2026-02-04
- **Changes**:
  - Added IS_FRESH_INSTALL variable to track install type
  - Added "Next steps" section after summary for fresh installs
  - Includes guidance to run 'adapt' and see QUICKSTART.md
  - Only shows on fresh install, not sync or dry-run

### Task 3: Show version/commit in install message
- **Status**: Complete
- **Started**: 2026-02-04
- **Changes**:
  - Added `format_version_string()` function
  - For tags (vX.Y.Z): shows "dot-agents v1.2.0"
  - For branches: shows "dot-agents (ref: main)"
  - For commits with SHA in directory: shows "dot-agents (main @ abc123f)"
  - Moved install message after archive extraction to access directory name
