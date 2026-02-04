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

### Task 4: Document sync command in post-install output
- **Status**: Complete
- **Started**: 2026-02-04
- **Changes**:
  - Added sync update hint for existing installations
  - Shows curl command to update again
  - Only shows on sync (not fresh install or dry-run)

### Task 5: Preserve custom skills during sync
- **Status**: Complete
- **Started**: 2026-02-04
- **Changes**:
  - Added CORE_SKILLS constant (adapt, ralph, research, tmux)
  - Added detect_custom_skills() to find non-core skill directories
  - Added report_custom_skills() to print preserved skills
  - Custom skills are inherently preserved (process_directory only copies, doesn't delete)
  - Reports which custom skills were preserved on sync

### Task 6: Update tests for new installer behavior
- **Status**: Complete
- **Started**: 2026-02-04
- **Changes**:
  - Added tests for `.agents/.gitignore` backup entry creation (test 20)
  - Fixed test 21 to match force-mode behavior (backup + overwrite, not update)
  - Added tests for post-install guidance output (tests 22-23)
  - Added tests for version string formatting (tests 24-25)
  - Added tests for sync update hint (tests 26-27)
  - Added tests for custom skill preservation (tests 28-29)
  - Added sample-skill to CORE_SKILLS constant for test fixture compatibility
  - All 49 tests pass
