# Plan 002: Testing Install Scripts (High-Value Focus)

## Goal

Add testing infrastructure for `install.sh` and `sync.sh` focused on maximum value with minimal overhead.

## Research Reference

See [.agents/research/testing-install-sync-scripts.md](../../research/testing-install-sync-scripts.md)

## Scope

Focus on the three highest-ROI approaches identified in research:

1. ShellCheck in CI (immediate value, zero test code)
2. Guard pattern refactor (enables testability)
3. BATS integration tests with mock curl (~10-15 tests)

Explicitly **out of scope**:

- Docker isolation tests
- Bach framework
- Extensive unit tests for pure functions
- Live network smoke tests

---

## Tasks

- [x] **Task 1: Add ShellCheck and syntax validation to CI**
  - Scope: `.github/workflows/test.yml`
  - Depends on: none
  - Acceptance:
    - GitHub Actions workflow runs on push/PR
    - Runs `bash -n install.sh .agents/scripts/sync.sh` (syntax check)
    - Runs ShellCheck on `install.sh` and `.agents/scripts/sync.sh`
    - Uses pinned action version (e.g., `ludeeus/action-shellcheck@2.0.0`)
    - CI fails if ShellCheck finds warnings or errors
  - Notes: Create `.github/workflows/test.yml` with `shellcheck` job

- [x] **Task 2: Fix any ShellCheck warnings**
  - Scope: `install.sh`, `.agents/scripts/sync.sh`
  - Depends on: Task 1
  - Acceptance:
    - `shellcheck --severity=warning install.sh .agents/scripts/sync.sh` passes
    - No suppressions unless absolutely necessary (document reason)
  - Notes: Run locally first before CI runs

- [x] **Task 3: Refactor install.sh with guard pattern**
  - Scope: `install.sh`
  - Depends on: Task 2
  - Acceptance:
    - All execution wrapped in `main()` function
    - Guard: `if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then main "$@"; fi`
    - Script still works identically when executed directly
    - Can be sourced without executing (for tests)
  - Notes: Move `parse_args` call inside `main()`

- [x] **Task 4: Refactor sync.sh with guard pattern**
  - Scope: `.agents/scripts/sync.sh`
  - Depends on: Task 2
  - Acceptance:
    - Same guard pattern as Task 3
    - Script still works identically when executed
  - Notes: Simpler script, should be quick

- [x] **Task 5: Create test directory structure**
  - Scope: `test/`
  - Depends on: none
  - Acceptance:
    - `test/test_helper/bats-support/` as git submodule from `https://github.com/bats-core/bats-support`
    - `test/test_helper/bats-assert/` as git submodule from `https://github.com/bats-core/bats-assert`
    - `test/mocks/` directory created
    - `test/fixtures/` directory created
    - `test/integration/` directory created
    - `.gitmodules` updated with submodule entries
  - Notes: CI must use `submodules: true` in checkout

- [x] **Task 6: Create mock curl script**
  - Scope: `test/mocks/curl`
  - Depends on: Task 5
  - Acceptance:
    - Executable bash script at `test/mocks/curl`
    - Handles `-o <file>` and `--output <file>` flags (writes to specified file)
    - Handles `-fsSL` and `-L` flags (ignores them, they're for real curl)
    - Returns pre-built archive for URLs matching `*github.com*archive*`
    - Returns install.sh content for URLs matching `*raw.githubusercontent.com*install.sh*`
    - Simulates 404 (exit 22) for URLs matching `*nonexistent*`
    - Logs all calls as `curl $*` to `$MOCK_LOG` (default `/tmp/curl-mock.log`)
    - Exits non-zero with error for unexpected calls
  - Notes: Check install.sh to confirm exact curl invocation patterns

- [x] **Task 7: Create test fixtures**
  - Scope: `test/fixtures/`
  - Depends on: Task 5
  - Acceptance:
    - `test/fixtures/sample-archive.tar.gz` created
    - Tarball has GitHub structure: top-level dir named `dot-agents-main/`
    - Contains `dot-agents-main/AGENTS.md`
    - Contains `dot-agents-main/.agents/skills/` directory with at least one skill
    - Readable by both GNU tar and BSD tar (use standard gzip compression)
  - Notes: Create via `tar -czf sample-archive.tar.gz dot-agents-main/`

- [x] **Task 8: Write core integration tests**
  - Scope: `test/integration/install.bats`
  - Depends on: Tasks 3, 5, 6, 7
  - Acceptance:
    - `--help` shows usage and exits 0
    - `--dry-run` makes no file changes (assert no files created with `find`)
    - Fresh install creates AGENTS.md and .agents/ directory
    - Fresh install creates `.agents/.dot-agents.json` with valid JSON
    - Identical files are skipped (output contains "SKIP" or similar)
    - Conflict creates .dot-agents.new file
    - `--force` creates backup directory (match pattern `.dot-agents-backup/*`)
    - `--uninstall` removes installed files
    - Paths with spaces work (run from temp dir with space in name)
  - Notes: Each test uses `$BATS_TEST_TMPDIR`, prepends mock PATH

- [x] **Task 9: Write sync.sh integration tests**
  - Scope: `test/integration/sync.bats`
  - Depends on: Tasks 4, 5, 6
  - Acceptance:
    - `--help` shows usage
    - Missing metadata file shows error
    - Valid metadata triggers install.sh with correct args
    - Flags pass through correctly
  - Notes: Simpler than install.sh tests

- [x] **Task 10: Add BATS to CI workflow**
  - Scope: `.github/workflows/test.yml`
  - Depends on: Task 5
  - Acceptance:
    - Adds `bats` job to existing `.github/workflows/test.yml`
    - Runs on matrix: `[ubuntu-latest, macos-latest]`
    - Uses `actions/checkout@v4` with `submodules: true`
    - Installs BATS (apt on Linux, brew on macOS)
    - Runs `bats test/`
  - Notes: Can be added early with minimal tests, expand as Task 8/9 complete

---

## Verification

After all tasks complete:

1. `shellcheck --severity=warning install.sh .agents/scripts/sync.sh` passes
2. `bats test/` passes locally on macOS
3. Both scripts still work correctly when run directly
4. CI passes on push

## Estimated Effort

~4-5 hours total (can be done incrementally)
