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

@test "AGENTS.md is skipped on re-install (sync scenario)" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify AGENTS.md (user customization)
    echo "# Modified by user" > AGENTS.md

    # Re-install should skip AGENTS.md entirely
    run bash "$INSTALL_SCRIPT" --yes
    assert_success
    assert_output --partial "AGENTS.md (user content, skipped on sync)"

    # User's modification should be preserved
    run cat AGENTS.md
    assert_output "# Modified by user"

    # Should NOT create conflict file
    [ ! -f "AGENTS.md.dot-agents.new" ]
    [ ! -f "AGENTS.dot-agents.md" ]
}

@test "--force creates backup directory" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file (not AGENTS.md which is skipped on sync)
    echo "# Modified skill" > .agents/skills/sample-skill/SKILL.md

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

@test "md files in research/plans/prds are not installed" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Skills should be installed
    [ -f ".agents/skills/sample-skill/SKILL.md" ]

    # User content directories should NOT have md files from upstream
    [ ! -f ".agents/research/example.md" ]
    [ ! -f ".agents/plans/todo/plan-001.md" ]
    [ ! -f ".agents/prds/feature.md" ]
}

@test "--write-conflicts creates .dot-agents.new files for conflicts" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file to create conflict
    echo "# Modified skill" > .agents/skills/sample-skill/SKILL.md

    # Re-install with --write-conflicts should create conflict files
    run bash "$INSTALL_SCRIPT" --write-conflicts --yes
    assert_success
    assert_output --partial "CONFLICT"

    # Should create conflict file for the skill
    [ -f ".agents/skills/sample-skill/SKILL.dot-agents.md" ]
}

@test "sync defaults to force mode (overwrites with backup)" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file to create conflict
    echo "# Modified skill" > .agents/skills/sample-skill/SKILL.md

    # Re-install (sync) should default to force mode
    run bash "$INSTALL_SCRIPT"
    assert_success
    assert_output --partial "force overwrite"
    assert_output --partial "BACKUP"

    # Should create backup directory
    run find . -type d -name ".dot-agents-backup*"
    assert_output --partial ".dot-agents-backup"
}

@test "--diff shows unified diff for conflicts" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file to create conflict
    echo "# Modified skill" > .agents/skills/sample-skill/SKILL.md

    # --diff should show diff output
    run bash "$INSTALL_SCRIPT" --diff
    assert_failure  # Exit code 1 when conflicts exist
    assert_output --partial "CONFLICT"
    assert_output --partial "---"  # Diff header
    assert_output --partial "+++"  # Diff header

    # Should NOT create conflict files
    [ ! -f ".agents/skills/sample-skill/SKILL.dot-agents.md" ]
}

@test "--diff exits 0 when no conflicts" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # --diff with no changes should exit 0
    run bash "$INSTALL_SCRIPT" --diff
    assert_success
    refute_output --partial "CONFLICT"
}

@test "--diff does not write metadata" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Record original metadata timestamp
    local original_meta
    original_meta=$(cat .agents/.dot-agents.json)

    # Modify a skill file
    echo "# Modified skill" > .agents/skills/sample-skill/SKILL.md

    # --diff should not update metadata
    run bash "$INSTALL_SCRIPT" --diff
    assert_failure

    # Metadata should be unchanged
    run cat .agents/.dot-agents.json
    assert_output "$original_meta"
}

# ===== Task 1: .gitignore entry tests =====

@test "fresh install creates .agents/.gitignore with backup entry" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # .gitignore should exist and contain backup entry
    [ -f ".agents/.gitignore" ]
    run cat ".agents/.gitignore"
    assert_output --partial "../.dot-agents-backup/"
}

@test "sync overwrites .agents/.gitignore and adds backup entry" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify .gitignore (will be overwritten by force mode, then backup entry added)
    echo "# Custom entry only" > .agents/.gitignore

    # Re-install (force mode) should overwrite then add backup entry
    run bash "$INSTALL_SCRIPT" --yes
    assert_success
    assert_output --partial "BACKUP"
    assert_output --partial ".agents/.gitignore"

    # Should contain backup entry (custom content overwritten by upstream)
    run cat ".agents/.gitignore"
    assert_output --partial "../.dot-agents-backup/"
}

# ===== Task 2: Post-install guidance tests =====

@test "fresh install shows next steps guidance" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should show next steps
    assert_output --partial "Next steps:"
    assert_output --partial "Run 'adapt'"
    assert_output --partial "QUICKSTART.md"
}

@test "sync does not show next steps guidance" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Re-install (sync)
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should NOT show next steps
    refute_output --partial "Next steps:"
    refute_output --partial "Run 'adapt'"
}

# ===== Task 3: Version string tests =====

@test "install shows version string for tag ref" {
    run bash "$INSTALL_SCRIPT" --ref v1.2.3 --yes
    assert_success

    # Should show version format for tags
    assert_output --partial "Installing dot-agents v1.2.3"
}

@test "install shows ref format for branch" {
    run bash "$INSTALL_SCRIPT" --ref main --yes
    assert_success

    # Should show ref format for branches
    assert_output --partial "Installing dot-agents (ref: main)"
}

# ===== Task 4: Sync update hint tests =====

@test "sync shows update command hint" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Re-install (sync)
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should show update hint
    assert_output --partial "To update again:"
    assert_output --partial "curl"
}

@test "fresh install does not show update hint" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should NOT show update hint on fresh install
    refute_output --partial "To update again:"
}

# ===== Task 5: Custom skills preservation tests =====

@test "sync reports custom skills preserved" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Create a custom skill
    mkdir -p .agents/skills/my-custom-skill
    echo "# My Custom Skill" > .agents/skills/my-custom-skill/SKILL.md

    # Re-install (sync)
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should report custom skill preserved
    assert_output --partial "Custom skills preserved:"
    assert_output --partial "my-custom-skill"

    # Custom skill should still exist
    [ -f ".agents/skills/my-custom-skill/SKILL.md" ]
}

@test "core skills are not reported as custom" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Re-install (sync)
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should NOT report core skills (they're from upstream)
    refute_output --partial "Custom skills preserved:"
}

# ===== Task 6: Claude Code native skill discovery tests =====

@test "install creates .claude/skills/ symlinks when .claude/ exists" {
    # Create .claude/ directory (simulates Claude Code project)
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should report Claude Code integration
    assert_output --partial "Claude Code"
    assert_output --partial "skill(s) available in / menu"

    # Symlinks should exist
    [ -L ".claude/skills/adapt/SKILL.md" ]
    [ -L ".claude/skills/ralph/SKILL.md" ]
    [ -L ".claude/skills/research/SKILL.md" ]
    [ -L ".claude/skills/tmux/SKILL.md" ]

    # Symlinks should resolve to actual content
    [ -s ".claude/skills/adapt/SKILL.md" ]
}

@test "install skips .claude/skills/ when no .claude/ directory" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should NOT mention Claude Code
    refute_output --partial "Claude Code"

    # .claude/skills/ should not exist
    [ ! -d ".claude/skills" ]
}

@test ".claude/skills/.gitignore is created with skill entries" {
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # .gitignore should exist
    [ -f ".claude/skills/.gitignore" ]

    # Should contain dot-agents header
    run cat ".claude/skills/.gitignore"
    assert_output --partial "dot-agents"
    assert_output --partial "adapt/"
}

@test "symlinks resolve correctly through relative path" {
    mkdir -p .claude

    bash "$INSTALL_SCRIPT" --yes

    # Read the symlink target
    local target
    target="$(readlink .claude/skills/adapt/SKILL.md)"

    # Should use relative path going up 3 levels
    [ "$target" = "../../../.agents/skills/adapt/SKILL.md" ]

    # Content should be readable through symlink
    run cat ".claude/skills/adapt/SKILL.md"
    assert_success
    assert_output --partial "adapt"
}

@test "sync recreates .claude/skills/ symlinks" {
    mkdir -p .claude

    # First install
    bash "$INSTALL_SCRIPT" --yes
    [ -L ".claude/skills/adapt/SKILL.md" ]

    # Remove a symlink manually
    rm .claude/skills/adapt/SKILL.md

    # Re-install (sync) should recreate it
    run bash "$INSTALL_SCRIPT" --yes
    assert_success
    [ -L ".claude/skills/adapt/SKILL.md" ]
}

@test "--uninstall removes .claude/skills/ symlinks" {
    mkdir -p .claude

    # Install
    bash "$INSTALL_SCRIPT" --yes
    [ -L ".claude/skills/adapt/SKILL.md" ]

    # Uninstall
    run bash "$INSTALL_SCRIPT" --uninstall --yes
    assert_success

    # Symlinks should be removed
    [ ! -L ".claude/skills/adapt/SKILL.md" ]
    [ ! -f ".claude/skills/.gitignore" ]
}

@test "--uninstall preserves non-dot-agents .claude/skills/" {
    mkdir -p .claude

    # Install
    bash "$INSTALL_SCRIPT" --yes

    # Create a user-owned skill (not a symlink)
    mkdir -p .claude/skills/my-custom-skill
    echo "# My Custom" > .claude/skills/my-custom-skill/SKILL.md

    # Uninstall
    run bash "$INSTALL_SCRIPT" --uninstall --yes
    assert_success

    # User's custom skill should be preserved
    [ -f ".claude/skills/my-custom-skill/SKILL.md" ]
}

@test "install skips existing non-symlink .claude/skills/ files" {
    mkdir -p .claude/skills/adapt

    # Create a user-owned file (not a symlink)
    echo "# User's adapt skill" > .claude/skills/adapt/SKILL.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should warn about skipping
    assert_output --partial "SKIP"
    assert_output --partial "not a symlink"

    # User's file should be preserved (not overwritten with symlink)
    [ ! -L ".claude/skills/adapt/SKILL.md" ]
    run cat ".claude/skills/adapt/SKILL.md"
    assert_output "# User's adapt skill"
}

@test "fresh install with .claude/ shows /adapt hint in next steps" {
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "/adapt"
    assert_output --partial "skills are now in the / menu"
}

@test "--dry-run shows Claude Code integration plan" {
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --dry-run
    assert_success

    assert_output --partial "Claude Code"
    assert_output --partial "CREATE"
    assert_output --partial ".claude/skills/"

    # Should not create any files
    [ ! -d ".claude/skills" ]
}
