#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

# Path to sync.sh from test directory
SYNC_SCRIPT="$BATS_TEST_DIRNAME/../../.agents/scripts/sync.sh"

setup() {
    # Create isolated test directory
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR" || exit 1

    # Prepend mock curl to PATH
    export PATH="$BATS_TEST_DIRNAME/../mocks:$PATH"

    # Set fixtures directory for mock curl
    export FIXTURES_DIR="$BATS_TEST_DIRNAME/../fixtures"

    # Clear mock log
    export MOCK_LOG="$TEST_DIR/curl-mock.log"
    : > "$MOCK_LOG"
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
}

@test "--help shows usage" {
    run bash "$SYNC_SCRIPT" --help
    assert_success
    assert_output --partial "Usage: sync.sh"
    assert_output --partial "--dry-run"
    assert_output --partial "--force"
}

@test "missing metadata file shows error" {
    run bash "$SYNC_SCRIPT"
    assert_failure
    assert_output --partial "Metadata file not found"
    assert_output --partial ".dot-agents.json"
}

@test "valid metadata triggers install.sh with correct args" {
    # Create metadata file
    mkdir -p .agents
    cat > .agents/.dot-agents.json <<EOF
{
  "upstream": "https://github.com/colmarius/dot-agents",
  "ref": "main",
  "installedAt": "2025-01-01T00:00:00Z"
}
EOF

    # Run sync - it will exec into install.sh via mock curl
    run bash "$SYNC_SCRIPT" --dry-run

    # Check that curl was called with the right URL
    run cat "$MOCK_LOG"
    assert_output --partial "raw.githubusercontent.com"
    assert_output --partial "colmarius/dot-agents"
    assert_output --partial "install.sh"
}

@test "flags pass through correctly" {
    # Create metadata file
    mkdir -p .agents
    cat > .agents/.dot-agents.json <<EOF
{
  "upstream": "https://github.com/colmarius/dot-agents",
  "ref": "v1.0.0"
}
EOF

    # Run sync with --dry-run flag
    run bash "$SYNC_SCRIPT" --dry-run

    # The output should show syncing from the correct ref
    assert_output --partial "ref: v1.0.0"
}

@test "--version shows version info when not installed" {
    run bash "$SYNC_SCRIPT" --version
    assert_success
    assert_output --partial "dot-agents"
    assert_output --partial "Upstream:"
    assert_output --partial "not installed"
}

@test "--version shows installation info when installed" {
    # Create metadata file
    mkdir -p .agents
    cat > .agents/.dot-agents.json <<EOF
{
  "upstream": "https://github.com/colmarius/dot-agents",
  "ref": "v2.0.0",
  "installedAt": "2025-06-01T12:00:00Z"
}
EOF

    run bash "$SYNC_SCRIPT" --version
    assert_success
    assert_output --partial "Ref: v2.0.0"
    assert_output --partial "Installed at: 2025-06-01"
}

@test "invalid upstream URL shows error" {
    # Create metadata with invalid URL
    mkdir -p .agents
    cat > .agents/.dot-agents.json <<EOF
{
  "upstream": "https://gitlab.com/someone/repo",
  "ref": "main"
}
EOF

    run bash "$SYNC_SCRIPT"
    assert_failure
    assert_output --partial "must be a GitHub repository"
}
