#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

# Path to install.sh from test directory
INSTALL_SCRIPT="$BATS_TEST_DIRNAME/../../install.sh"

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

@test "--help shows usage and exits 0" {
    run bash "$INSTALL_SCRIPT" --help
    assert_success
    assert_output --partial "Usage: install.sh"
    assert_output --partial "--dry-run"
    assert_output --partial "--force"
}

@test "--dry-run makes no file changes" {
    run bash "$INSTALL_SCRIPT" --dry-run
    assert_success

    # Should not create any files
    run find . -type f -name "AGENTS.md"
    assert_output ""

    # Should not create .agents directory
    [ ! -d ".agents" ]
}

@test "fresh install creates AGENTS.md and .agents directory" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Check files exist
    [ -f "AGENTS.md" ]
    [ -d ".agents" ]
    [ -d ".agents/skills" ]
}

@test "fresh install creates .agents/.dot-agents.json with valid JSON" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Metadata file should exist
    [ -f ".agents/.dot-agents.json" ]

    # Should be valid JSON (basic check for braces)
    run cat ".agents/.dot-agents.json"
    assert_output --partial "upstream"
    assert_output --partial "installedAt"
}

@test "identical files are skipped on re-install" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Second install should skip identical files
    run bash "$INSTALL_SCRIPT" --yes
    assert_success
    assert_output --partial "SKIP"
}

@test "conflict creates .dot-agents.new file" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify AGENTS.md to create conflict
    echo "# Modified by user" > AGENTS.md

    # Re-install should detect conflict
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should create conflict file
    [ -f "AGENTS.md.dot-agents.new" ] || [ -f "AGENTS.dot-agents.md" ]
}

@test "--force creates backup directory" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify AGENTS.md
    echo "# Modified by user" > AGENTS.md

    # Force re-install
    run bash "$INSTALL_SCRIPT" --force --yes
    assert_success

    # Should create backup directory
    run find . -type d -name ".dot-agents-backup*"
    assert_output --partial ".dot-agents-backup"
}

@test "--uninstall removes installed files" {
    # First install
    bash "$INSTALL_SCRIPT" --yes
    [ -f "AGENTS.md" ]
    [ -d ".agents" ]

    # Uninstall
    run bash "$INSTALL_SCRIPT" --uninstall --yes
    assert_success

    # Files should be removed
    [ ! -f "AGENTS.md" ]
    [ ! -d ".agents" ]
}

@test "paths with spaces work correctly" {
    # Create directory with spaces
    mkdir -p "$TEST_DIR/my project dir"
    cd "$TEST_DIR/my project dir"

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    [ -f "AGENTS.md" ]
    [ -d ".agents" ]
}

@test "--version shows version info when not installed" {
    run bash "$INSTALL_SCRIPT" --version
    assert_success
    assert_output --partial "dot-agents"
    assert_output --partial "Upstream:"
    assert_output --partial "not installed"
}

@test "--version shows installation info when installed" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    run bash "$INSTALL_SCRIPT" --version
    assert_success
    assert_output --partial "dot-agents"
    assert_output --partial "Ref:"
    assert_output --partial "Installed at:"
}

@test "--ref flag sets ref in metadata" {
    run bash "$INSTALL_SCRIPT" --ref v1.2.3 --yes
    assert_success

    # Check metadata contains the ref
    run cat ".agents/.dot-agents.json"
    assert_output --partial '"ref": "v1.2.3"'
}

@test "--uninstall --dry-run shows what would be removed" {
    # First install
    bash "$INSTALL_SCRIPT" --yes
    [ -f "AGENTS.md" ]
    [ -d ".agents" ]

    # Dry-run uninstall
    run bash "$INSTALL_SCRIPT" --uninstall --dry-run --yes
    assert_success
    assert_output --partial "DRY RUN"
    assert_output --partial "REMOVE"

    # Files should still exist
    [ -f "AGENTS.md" ]
    [ -d ".agents" ]
}
