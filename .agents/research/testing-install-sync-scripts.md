# Testing Install & Sync Scripts

## Overview

This document explores strategies for testing `install.sh` and `.agents/scripts/sync.sh` in the dot-agents repository. These scripts are critical infrastructure that must work reliably across different environments.

## TL;DR

Use **BATS for black-box integration tests** + a small amount of **unit tests for pure functions**, add **ShellCheck** in CI, and refactor scripts with a **clean entrypoint guard**. Mock network calls by replacing `curl` in `PATH`. Bias toward ~10-15 integration tests over heavy function unit testing.

## Scripts Under Test

### install.sh (473 lines)

**Core behaviors to test:**

- Argument parsing (`--dry-run`, `--force`, `--ref`, `--yes`, `--uninstall`, `--interactive`)
- File downloading from GitHub (tar.gz archive)
- File installation with conflict detection
- Backup creation on force/overwrite
- Metadata file creation/update (`.agents/.dot-agents.json`)
- Uninstall functionality
- Stack detection (package.json, Cargo.toml, go.mod, pyproject.toml)
- Interactive conflict resolution

### sync.sh (94 lines)

**Core behaviors to test:**

- Metadata file parsing (upstream URL, ref)
- GitHub URL validation and extraction
- Passthrough of flags to install.sh
- Error handling for missing metadata
- Help display

---

## Static Analysis (Add First!)

### ShellCheck

**Required as first CI step.** ShellCheck catches many real-world bash issues (quoting, word-splitting, `set -u` pitfalls, unreachable code) with zero test maintenance.

```bash
# Install
brew install shellcheck  # macOS
apt-get install shellcheck  # Ubuntu

# Run
shellcheck install.sh .agents/scripts/sync.sh

# Or use in CI
shellcheck --severity=warning *.sh .agents/scripts/*.sh
```

### Syntax Validation

```bash
# Basic syntax check
bash -n install.sh
bash -n .agents/scripts/sync.sh
```

---

## Testing Approaches

### 1. BATS-Core (Bash Automated Testing System)

**Recommended as primary framework.**

```bash
# Install via Homebrew
brew install bats-core

# Or install from source
git clone https://github.com/bats-core/bats-core.git
./bats-core/install.sh /usr/local
```

**Advantages:**

- TAP-compliant output (integrates with CI)
- Simple `@test` syntax
- Built-in `run` helper for capturing output/status
- `setup`/`teardown` hooks
- Parallel test execution support

**Basic test structure:**

```bash
#!/usr/bin/env bats

setup() {
    # Create isolated test directory
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
}

teardown() {
    # Cleanup
    cd /
    rm -rf "$TEST_DIR"
}

@test "install.sh shows help with --help flag" {
    run bash /path/to/install.sh --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: install.sh"* ]]
}
```

### 2. Helper Libraries

**bats-support** - Common test helpers
**bats-assert** - Rich assertion functions
**bats-file** - File system assertions
**bats-mock** - Command mocking/stubbing

```bash
# Install helpers
git clone https://github.com/bats-core/bats-support.git test/test_helper/bats-support
git clone https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert
git clone https://github.com/bats-core/bats-file.git test/test_helper/bats-file
```

### 3. Bach Testing Framework

**Alternative for "dry-run" style testing.**

Bach intercepts all external command calls and compares expected vs actual command sequences. Useful for testing scripts that run dangerous commands.

```bash
source bach.sh

test-install-creates-backup() {
    # Test case
    FORCE=true
    backup_file "AGENTS.md"
}
test-install-creates-backup-assert() {
    # Expected commands
    mkdir -p .dot-agents-backup/...
    cp AGENTS.md .dot-agents-backup/.../AGENTS.md
}
```

**Limitations:**

- Cannot mock built-in commands
- Cannot intercept absolute path commands
- PATH is read-only during tests

---

## Testing Strategy for dot-agents

### Test Categories

#### A. Unit Tests (Individual Functions)

Extract testable functions and test in isolation:

```bash
# test/unit/install.bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Source just the functions without running main
setup() {
    TEST_DIR="$(mktemp -d)"

    # Extract functions from install.sh for testing
    # Create a testable version that doesn't execute main
    sed '/^parse_args/,/^main/!d; /^main/d' \
        "$BATS_TEST_DIRNAME/../../install.sh" > "$TEST_DIR/functions.sh"
}

@test "files_identical returns 0 for identical files" {
    echo "content" > "$TEST_DIR/file1"
    echo "content" > "$TEST_DIR/file2"

    source "$TEST_DIR/functions.sh"
    run files_identical "$TEST_DIR/file1" "$TEST_DIR/file2"
    assert_success
}

@test "files_identical returns 1 for different files" {
    echo "content1" > "$TEST_DIR/file1"
    echo "content2" > "$TEST_DIR/file2"

    source "$TEST_DIR/functions.sh"
    run files_identical "$TEST_DIR/file1" "$TEST_DIR/file2"
    assert_failure
}
```

#### B. Integration Tests (Script Execution)

Test full script execution with mocked network calls:

```bash
# test/integration/install.bats

setup() {
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    # Create mock GitHub tarball
    mkdir -p mock-repo/.agents/skills
    echo "# Mock AGENTS.md" > mock-repo/AGENTS.md
    tar -czf mock-archive.tar.gz mock-repo

    # Mock curl to return our archive
    export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
}

@test "install.sh creates AGENTS.md from archive" {
    run bash "$BATS_TEST_DIRNAME/../../install.sh" --dry-run
    assert_success
    assert_output --partial "[INSTALL] ./AGENTS.md"
}
```

#### C. Isolation Tests (Sandbox Environment)

Use Docker for fully isolated testing:

```dockerfile
# test/Dockerfile
FROM bash:5.2

RUN apk add --no-cache curl git coreutils

# Install bats
RUN git clone --depth 1 https://github.com/bats-core/bats-core.git /tmp/bats && \
    /tmp/bats/install.sh /usr/local

WORKDIR /test
COPY . .

CMD ["bats", "test/"]
```

---

## Recommended Test Directory Structure

```text
dot-agents/
├── install.sh
├── .agents/
│   └── scripts/
│       └── sync.sh
└── test/
    ├── test_helper/
    │   ├── bats-support/    # git submodule
    │   ├── bats-assert/     # git submodule
    │   └── common.bash      # shared test utilities
    ├── mocks/
    │   └── curl             # mock curl for network isolation
    ├── fixtures/
    │   ├── sample-archive/  # pre-built test archive
    │   └── metadata/        # sample .dot-agents.json files
    ├── unit/
    │   ├── install_functions.bats
    │   └── sync_functions.bats
    └── integration/
        ├── install.bats
        ├── sync.bats
        └── uninstall.bats
```

---

## Key Test Cases

### install.sh

| Test Case | Type | Description |
|-----------|------|-------------|
| `--help shows usage` | Unit | Verify help text output |
| `--dry-run prevents changes` | Integration | No files created/modified |
| `fresh install creates files` | Integration | AGENTS.md, .agents/ created |
| `skip identical files` | Unit | files_identical() works |
| `detect conflicts` | Integration | .dot-agents.new files created |
| `--force creates backup` | Integration | Backup dir with timestamp |
| `--interactive prompts` | Integration | Mock stdin responses |
| `--uninstall removes files` | Integration | Clean removal |
| `preserve executable bit` | Integration | `cp -p` preserves permissions |
| `metadata timestamps` | Unit | installedAt vs lastSyncedAt |
| `stack detection` | Unit | Detects package.json, etc. |
| `invalid ref fails` | Integration | Error on bad GitHub ref |
| `paths with spaces` | Integration | Install in dir with spaces |
| `corrupted download` | Integration | Handle truncated/invalid tar.gz |
| `non-interactive CI` | Integration | --uninstall --yes doesn't block |

### sync.sh

| Test Case | Type | Description |
|-----------|------|-------------|
| `--help shows usage` | Unit | Verify help text |
| `missing metadata errors` | Integration | Clear error message |
| `parses upstream URL` | Unit | Extracts owner/repo |
| `validates GitHub URL` | Unit | Rejects non-GitHub |
| `passes flags through` | Integration | --dry-run, --force passed |
| `uses ref from metadata` | Unit | Falls back to "main" |
| `metadata JSON variations` | Unit | Extra spaces, key ordering |
| `exec replaces process` | Integration | Still capture exit status |
| `404 on fetch` | Integration | Clear error message |

---

## Mocking Strategy

### Mock curl for Network Isolation (Primary Approach)

Replace `curl` in PATH for deterministic testing. The mock should:

- Respond based on URL + flags
- Log calls for assertions (verify correct URL/ref was requested)
- Handle success and failure modes

```bash
#!/usr/bin/env bash
# test/mocks/curl

MOCK_LOG="${MOCK_LOG:-/tmp/curl-mock.log}"
echo "curl $*" >> "$MOCK_LOG"

# Return pre-built archive for GitHub archive URLs
if [[ "$*" == *"github.com"*"archive"* ]]; then
    cat "$BATS_TEST_DIRNAME/../fixtures/sample-archive.tar.gz"
    exit 0
fi

# Return install.sh for raw content URLs
if [[ "$*" == *"raw.githubusercontent.com"*"install.sh"* ]]; then
    cat "$BATS_TEST_DIRNAME/../../install.sh"
    exit 0
fi

# Simulate 404 for specific test URLs
if [[ "$*" == *"nonexistent"* ]]; then
    echo "curl: (22) The requested URL returned error: 404" >&2
    exit 22
fi

# Fail for unexpected calls
echo "Mock curl: unexpected call: $*" >&2
exit 1
```

### Command Wrappers (Selective)

Wrap only commands where mocking pays off (curl, date). Keep filesystem operations real in sandbox.

```bash
# In install.sh, wrap for testability
_curl() { curl "$@"; }
_date() { date "$@"; }

# In tests, override for determinism
_curl() {
    cat test/fixtures/archive.tar.gz
}
_date() {
    echo "2025-01-15T00:00:00Z"
}
```

### Optional: Live Network Smoke Test

Add one real GitHub fetch test (non-blocking):

- Run only on schedule (nightly) or behind env flag (`RUN_LIVE_TESTS=1`)
- Tolerant of rate limits / transient failures
- Catches real-world breakage (URL changes, TLS issues)

---

## CI Integration

### GitHub Actions Workflow

```yaml
# .github/workflows/test.yml
name: Test Install Scripts

on: [push, pull_request]

jobs:
  shellcheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: ShellCheck
        uses: ludeeus/action-shellcheck@master
        with:
          scandir: '.'
          severity: warning

  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true

      - name: Install BATS
        run: |
          if [[ "$RUNNER_OS" == "Linux" ]]; then
            sudo apt-get update && sudo apt-get install -y bats
          else
            brew install bats-core
          fi

      - name: Run tests
        run: bats test/

  live-smoke-test:
    if: github.event_name == 'schedule' || github.event.inputs.run_live_tests == 'true'
    runs-on: ubuntu-latest
    continue-on-error: true  # Don't fail build on network issues
    steps:
      - uses: actions/checkout@v4
      - name: Run live network test
        run: |
          RUN_LIVE_TESTS=1 bats test/integration/live.bats
```

---

## Implementation Recommendations

### Phase 1: Static Analysis + Infrastructure (1-2h)

1. Add ShellCheck to CI (immediate wins with zero test code)
2. Create `test/` directory structure
3. Add BATS helpers as git submodules
4. Create mock curl script with logging
5. Write first integration test for `--help`

### Phase 2: Refactor for Testability (1h)

1. Add guard pattern to `install.sh` - wrap all execution in `main()`
2. Add guard pattern to `sync.sh`
3. Add `_date()` wrapper for deterministic timestamps
4. Verify scripts still work normally after refactor

### Phase 3: Core Integration Tests (2-3h)

1. Fresh install workflow in temp directory
2. Skip identical files
3. Conflict detection (creates .dot-agents.new)
4. `--force` creates backup
5. `--dry-run` makes no changes
6. `--uninstall` removes files
7. Paths with spaces work correctly

### Phase 4: Unit Tests for Pure Functions (1h)

1. `files_identical` with various file states
2. `detect_stack` with different project types
3. Metadata JSON parsing variations

### Phase 5: Edge Cases + Cross-Platform (1-2h)

1. Test on macOS and Linux in CI
2. Corrupted download handling
3. Missing/malformed metadata
4. Interactive prompts (mock stdin)

---

## Making Scripts Testable

### Current Challenge

The scripts execute immediately when sourced/run, making function isolation difficult.

### Solution: Guard Pattern (Recommended)

**Important:** Move ALL execution inside the guard, including `parse_args`. The pattern below ensures nothing runs when the script is sourced.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Define globals
REPO_OWNER="colmarius"
REPO_NAME="dot-agents"
# ... more globals ...

# Define all functions
usage() { ... }
parse_args() { ... }
main() {
    parse_args "$@"

    if [[ "$SHOW_HELP" == "true" ]]; then
        usage
        exit 0
    fi

    # ... rest of logic ...
}

# Only run main if script is executed, not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

This allows tests to `source` the script and call functions directly without triggering main execution.

### Avoid: sed-extraction approach

The document initially suggested extracting functions via `sed`. **Do not use this approach** - it's brittle, breaks on refactors, and high maintenance.

### Alternative: Split into library

For larger scripts, split into:

- `install.sh` (tiny entrypoint)
- `lib/install_lib.sh` (all functions)

For this project size, the guard pattern is sufficient.

---

## Key Gotchas

### set -euo pipefail in Tests

When you `source install.sh` in tests, `set -euo pipefail` affects the test process. Handle carefully:

- Tests may exit unexpectedly on any command failure
- Unset variables will cause immediate exit

### Timestamps in Tests

`write_metadata` and backup dirs use timestamps. Either:

- Assert patterns (regex match ISO timestamp) rather than exact values
- Inject a `_date()` wrapper so tests can fix time deterministically

### Glob Pattern in process_directory

The pattern `[[ "$rel_path" == plans/**/*.md ]]` may behave unexpectedly. Test that both `plans/foo.md` and `plans/nested/foo.md` are skipped as intended.

---

## References

- [BATS-Core Documentation](https://bats-core.readthedocs.io/)
- [BATS GitHub Repository](https://github.com/bats-core/bats-core)
- [bats-assert](https://github.com/bats-core/bats-assert)
- [bats-file](https://github.com/bats-core/bats-file)
- [Bach Testing Framework](https://bach.sh/)
- [ShellCheck](https://www.shellcheck.net/)
- [ShellSpec Alternative](https://shellspec.info/)

---

## Next Steps

1. Add ShellCheck to CI (immediate value, no test code required)
2. Create minimal test structure with one passing integration test
3. Refactor scripts with guard pattern for testability
4. Expand test coverage incrementally following the phases above
5. Add cross-platform CI (macOS + Linux)
