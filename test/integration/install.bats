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
    [ -f ".agents/work/AGENTS.md" ]
    [ -d ".agents/references" ]
    [ -f ".agents/references/.gitkeep" ]
    [ -f ".agents/skills/adapt/SKILL.md" ]
    [ -f ".agents/skills/agent-work/SKILL.md" ]
    [ -f ".agents/skills/feature-planning/SKILL.md" ]
    [ -f ".agents/skills/research/SKILL.md" ]
    [ -f ".agents/skills/tmux/SKILL.md" ]
    [ ! -d ".agents/skills/ralph" ]
    [ ! -d ".agents/plans" ]
    [ ! -d ".agents/prds" ]
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
    refute_output --partial "bogus-archive-metadata"
    refute_output --partial "example/bogus-dot-agents"
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
    echo "# Modified skill" > .agents/skills/research/SKILL.md

    # Force re-install
    run bash "$INSTALL_SCRIPT" --force --yes
    assert_success

    # Should create backup directory
    run find . -type d -name ".dot-agents-backup*"
    assert_output --partial ".dot-agents-backup"
    [ -d ".agents/.dot-agents-backup" ]
    [ ! -d ".dot-agents-backup" ]
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

@test "user content samples are not installed" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Skills should be installed
    [ -f ".agents/skills/agent-work/SKILL.md" ]
    [ -f ".agents/work/AGENTS.md" ]

    # User content directories should NOT have md files from upstream
    [ ! -f ".agents/research/example.md" ]
    [ ! -f ".agents/work/feature/example-work/index.md" ]
    [ ! -f ".agents/plans/todo/plan-001.md" ]
    [ ! -f ".agents/prds/feature.md" ]
    [ ! -d ".agents/plans" ]
    [ ! -d ".agents/prds" ]
}

@test "agent-work helpers create and list work items" {
    bash "$INSTALL_SCRIPT" --yes

    run .agents/skills/agent-work/scripts/new-work.sh \
        --category feature \
        --slug demo-work \
        --title "Demo work" \
        --status planned
    assert_success
    assert_output ".agents/work/feature/demo-work/index.md"

    [ -f ".agents/work/feature/demo-work/index.md" ]
    [ ! -d ".agents/work/feature/demo-work/decisions" ]

    run .agents/skills/agent-work/scripts/list-work.sh --status planned
    assert_success
    assert_output --partial "Demo work"
    assert_output --partial "planned"

    run .agents/skills/agent-work/scripts/list-work.sh --status blocked
    assert_success
    refute_output --partial "Demo work"
}

@test "agent-work helper rejects invalid status" {
    bash "$INSTALL_SCRIPT" --yes

    run .agents/skills/agent-work/scripts/new-work.sh \
        --category feature \
        --slug invalid-status \
        --title "Invalid status" \
        --status unknown
    assert_failure
    assert_output --partial "Invalid status"
}

@test "agent-work helper rejects invalid category" {
    bash "$INSTALL_SCRIPT" --yes

    run .agents/skills/agent-work/scripts/new-work.sh \
        --category custom-category \
        --slug invalid-category \
        --title "Invalid category"
    assert_failure
    assert_output --partial "Invalid category"
    assert_output --partial "Expected one of"
}

@test "sync preserves existing work item content" {
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p .agents/work/feature/demo-work
    echo "# Demo Work" > .agents/work/feature/demo-work/index.md
    echo "- [ ] Keep this task" > .agents/work/feature/demo-work/plan.md
    echo "progress stays" > .agents/work/feature/demo-work/progress.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    run cat .agents/work/feature/demo-work/index.md
    assert_output "# Demo Work"

    run cat .agents/work/feature/demo-work/plan.md
    assert_output "- [ ] Keep this task"

    run cat .agents/work/feature/demo-work/progress.md
    assert_output "progress stays"
}

@test "sync preserves legacy plans and PRDs as user content" {
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p .agents/plans/in-progress .agents/prds
    echo "# Legacy plan" > .agents/plans/in-progress/demo.md
    echo "# Legacy PRD" > .agents/prds/demo.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    run cat .agents/plans/in-progress/demo.md
    assert_output "# Legacy plan"

    run cat .agents/prds/demo.md
    assert_output "# Legacy PRD"
}

@test "sync removes retired legacy guidance and templates with backup" {
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p .agents/plans .agents/prds
    echo "Use Ralph for plans" > .agents/plans/AGENTS.md
    echo "# Old plan template" > .agents/plans/TEMPLATE.md
    echo "Use Ralph for PRDs" > .agents/prds/AGENTS.md
    echo "# Old PRD template" > .agents/prds/TEMPLATE.md
    echo "# Real PRD" > .agents/prds/demo.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "retired legacy guidance"
    assert_output --partial "BACKUP"

    [ ! -e ".agents/plans/AGENTS.md" ]
    [ ! -e ".agents/plans/TEMPLATE.md" ]
    [ ! -e ".agents/prds/AGENTS.md" ]
    [ ! -e ".agents/prds/TEMPLATE.md" ]
    [ -f ".agents/prds/demo.md" ]

    run find .agents/.dot-agents-backup -path '*/.agents/prds/AGENTS.md' -type f
    assert_output --partial ".agents/prds/AGENTS.md"

    run find .agents/.dot-agents-backup -path '*/.agents/plans/TEMPLATE.md' -type f
    assert_output --partial ".agents/plans/TEMPLATE.md"
}

@test "--write-conflicts creates .dot-agents.md files for Markdown conflicts" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file to create conflict
    echo "# Modified skill" > .agents/skills/research/SKILL.md

    # Re-install with --write-conflicts should create conflict files
    run bash "$INSTALL_SCRIPT" --write-conflicts --yes
    assert_success
    assert_output --partial "CONFLICT"

    # Should create conflict file for the skill
    [ -f ".agents/skills/research/SKILL.dot-agents.md" ]
}

@test "--write-conflicts creates .dot-agents.new files for non-Markdown conflicts" {
    bash "$INSTALL_SCRIPT" --yes

    printf '# Custom ignore\n.dot-agents-backup/\n' > .agents/.gitignore

    run bash "$INSTALL_SCRIPT" --write-conflicts --yes
    assert_success
    assert_output --partial "CONFLICT"

    [ -f ".agents/.gitignore.dot-agents.new" ]
}

@test "--write-conflicts does not mutate conflicted .agents/.gitignore" {
    bash "$INSTALL_SCRIPT" --yes

    printf '# Custom ignore\n' > .agents/.gitignore
    local original_gitignore
    original_gitignore=$(cat .agents/.gitignore)

    run bash "$INSTALL_SCRIPT" --write-conflicts --yes
    assert_success
    assert_output --partial "CONFLICT"

    [ -f ".agents/.gitignore.dot-agents.new" ]
    run cat .agents/.gitignore
    assert_output "$original_gitignore"
}

@test "--write-conflicts preserves an existing conflict sidecar" {
    bash "$INSTALL_SCRIPT" --yes

    echo "# Modified skill" > .agents/skills/research/SKILL.md
    echo "review notes stay" > .agents/skills/research/SKILL.dot-agents.md

    run bash "$INSTALL_SCRIPT" --write-conflicts --yes
    assert_success
    assert_output --partial "Kept existing ./.agents/skills/research/SKILL.dot-agents.md"

    run cat .agents/skills/research/SKILL.dot-agents.md
    assert_output "review notes stay"
}

@test "--interactive overwrite applies selected conflict action" {
    bash "$INSTALL_SCRIPT" --yes

    echo "# Modified skill" > .agents/skills/research/SKILL.md

    run env DOT_AGENTS_INTERACTIVE_RESPONSE=o bash "$INSTALL_SCRIPT" --interactive --yes
    assert_success
    assert_output --partial "overwritten"
    assert_output --partial "BACKUP"

    run head -1 .agents/skills/research/SKILL.md
    assert_output "---"
    [ ! -f ".agents/skills/research/SKILL.dot-agents.md" ]
}

@test "--interactive keep preserves selected local conflict" {
    bash "$INSTALL_SCRIPT" --yes

    echo "# Modified skill" > .agents/skills/research/SKILL.md

    run env DOT_AGENTS_INTERACTIVE_RESPONSE=k bash "$INSTALL_SCRIPT" --interactive --yes
    assert_success
    assert_output --partial "kept yours"

    run cat .agents/skills/research/SKILL.md
    assert_output "# Modified skill"
    [ ! -f ".agents/skills/research/SKILL.dot-agents.md" ]
}

@test "sync defaults to force mode (overwrites with backup)" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file to create conflict
    echo "# Modified skill" > .agents/skills/research/SKILL.md

    # Re-install (sync) should default to force mode
    run bash "$INSTALL_SCRIPT"
    assert_success
    assert_output --partial "force overwrite"
    assert_output --partial "BACKUP"

    # Should create backup directory
    run find . -type d -name ".dot-agents-backup*"
    assert_output --partial ".dot-agents-backup"
}

@test "sync backs up symlinked managed files without following them" {
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p external
    echo "custom skill link target" > external/research-skill.md
    rm .agents/skills/research/SKILL.md
    ln -s ../../../external/research-skill.md .agents/skills/research/SKILL.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success
    assert_output --partial "force overwrite"
    assert_output --partial "BACKUP"

    [ ! -L ".agents/skills/research/SKILL.md" ]
    local backup_link
    backup_link=$(find .agents/.dot-agents-backup -path '*/.agents/skills/research/SKILL.md' -type l | head -1)
    [ -n "$backup_link" ]

    local target
    target="$(readlink "$backup_link")"
    [ "$target" = "../../../external/research-skill.md" ]
}

@test "sync backs up broken symlinked managed files without following them" {
    bash "$INSTALL_SCRIPT" --yes

    rm .agents/skills/research/SKILL.md
    ln -s ../../../missing-research-skill.md .agents/skills/research/SKILL.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success
    assert_output --partial "force overwrite"
    assert_output --partial "BACKUP"

    [ ! -L ".agents/skills/research/SKILL.md" ]
    local backup_link
    backup_link=$(find .agents/.dot-agents-backup -path '*/.agents/skills/research/SKILL.md' -type l | head -1)
    [ -n "$backup_link" ]

    local target
    target="$(readlink "$backup_link")"
    [ "$target" = "../../../missing-research-skill.md" ]
}

@test "--diff shows unified diff for conflicts" {
    # First install
    bash "$INSTALL_SCRIPT" --yes

    # Modify a skill file to create conflict
    echo "# Modified skill" > .agents/skills/research/SKILL.md

    # --diff should show diff output
    run bash "$INSTALL_SCRIPT" --diff
    assert_failure  # Exit code 1 when conflicts exist
    assert_output --partial "CONFLICT"
    assert_output --partial "---"  # Diff header
    assert_output --partial "+++"  # Diff header

    # Should NOT create conflict files
    [ ! -f ".agents/skills/research/SKILL.dot-agents.md" ]
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
    echo "# Modified skill" > .agents/skills/research/SKILL.md

    # --diff should not update metadata
    run bash "$INSTALL_SCRIPT" --diff
    assert_failure

    # Metadata should be unchanged
    run cat .agents/.dot-agents.json
    assert_output "$original_meta"
}

@test "--diff exits 1 when core files are missing without installing them" {
    bash "$INSTALL_SCRIPT" --yes

    rm -rf .agents/skills/agent-work

    local original_meta
    original_meta=$(cat .agents/.dot-agents.json)

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial "would install"
    assert_output --partial "Pending changes:"

    [ ! -d ".agents/skills/agent-work" ]
    [ ! -d ".agents/.dot-agents-backup" ]

    run cat .agents/.dot-agents.json
    assert_output "$original_meta"
}

@test "--diff exits 1 for retired Ralph without removing it" {
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p .agents/skills/ralph
    echo "# Legacy Ralph" > .agents/skills/ralph/SKILL.md

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial "retired core skill, preview only"
    assert_output --partial "Pending changes:"

    [ -f ".agents/skills/ralph/SKILL.md" ]
    [ ! -d ".agents/.dot-agents-backup" ]
}

@test "--diff exits 1 for retired legacy guidance without removing it" {
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p .agents/prds
    echo "Use Ralph" > .agents/prds/AGENTS.md

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial "retired legacy guidance, preview only"
    assert_output --partial "Pending changes:"

    [ -f ".agents/prds/AGENTS.md" ]
    [ ! -d ".agents/.dot-agents-backup" ]
}

@test "--diff counts .agents/.gitignore once when the file is missing" {
    bash "$INSTALL_SCRIPT" --yes
    rm .agents/.gitignore

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial "./.agents/.gitignore (would install)"
    assert_output --partial "Pending changes: 1"
}

@test "--diff exits 1 for pending Claude Code skill links without creating them" {
    bash "$INSTALL_SCRIPT" --yes
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial "Claude Code skills linked"
    assert_output --partial ".claude/skills/agent-work"
    assert_output --partial "Pending changes:"

    [ ! -e ".claude/skills" ]
}

@test "--diff previews Claude Code skill links on fresh install without creating them" {
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial "Claude Code skills linked"
    assert_output --partial ".claude/skills/agent-work"
    assert_output --partial "Pending changes:"

    [ ! -e ".claude/skills" ]
    [ ! -d ".agents" ]
}

@test "--dry-run previews Claude Code skill links on fresh install without creating them" {
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --dry-run
    assert_success
    assert_output --partial "Claude Code skills linked"
    assert_output --partial ".claude/skills/agent-work"

    [ ! -e ".claude/skills" ]
    [ ! -d ".agents" ]
}

@test "--diff exits 1 for stale retired Ralph Claude Code symlink without removing it" {
    mkdir -p .claude
    bash "$INSTALL_SCRIPT" --yes

    mkdir -p .agents/skills/ralph
    echo "# Legacy Ralph" > .agents/skills/ralph/SKILL.md
    ln -s ../../.agents/skills/ralph .claude/skills/ralph

    run bash "$INSTALL_SCRIPT" --diff
    assert_failure
    assert_output --partial ".claude/skills/ralph (stale)"
    assert_output --partial "Pending changes:"

    [ -L ".claude/skills/ralph" ]
}

@test "clean sync does not create backup for generated metadata" {
    bash "$INSTALL_SCRIPT" --yes

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    [ ! -d ".agents/.dot-agents-backup" ]
}

@test "sync drops deprecated singular reference ignore but preserves content" {
    bash "$INSTALL_SCRIPT" --yes
    mkdir -p .agents/reference/legacy-repo
    echo "legacy" > .agents/reference/legacy-repo/file.txt

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Sync never deletes user files; the legacy checkout stays on disk.
    [ -f ".agents/reference/legacy-repo/file.txt" ]

    # The deprecated singular path is no longer ignored; only references/ is.
    run cat .agents/.gitignore
    refute_line "reference/"
    assert_line "references/*"
    assert_line "!references/.gitkeep"
}

# ===== Task 1: .gitignore entry tests =====

@test "fresh install creates .agents/.gitignore with backup entry" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # .gitignore should exist and contain backup entry
    [ -f ".agents/.gitignore" ]
    run cat ".agents/.gitignore"
    assert_output --partial ".dot-agents-backup/"
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
    assert_output --partial ".dot-agents-backup/"
}

# ===== Task 2: Post-install guidance tests =====

@test "fresh install shows next steps guidance" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    # Should show next steps
    assert_output --partial "Next steps:"
    assert_output --partial "Run 'adapt'"
    assert_output --partial "https://github.com/colmarius/dot-agents/blob/main/QUICKSTART.md"
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

# ===== Task 6: Claude Code skill discovery tests =====

@test "install creates Claude Code skill directory symlinks when .claude exists" {
    mkdir -p .claude

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "Claude Code skills linked"

    [ -L ".claude/skills/adapt" ]
    [ -L ".claude/skills/agent-work" ]
    [ -L ".claude/skills/feature-planning" ]
    [ -L ".claude/skills/research" ]
    [ -L ".claude/skills/tmux" ]

    local target
    target="$(readlink .claude/skills/adapt)"
    [ "$target" = "../../.agents/skills/adapt" ]

    # Directory symlinks expose supporting skill files, not just SKILL.md.
    [ -f ".claude/skills/agent-work/assets/plan-template.md" ]
}

@test "install does not create .claude when absent" {
    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    [ ! -d ".claude" ]
}

@test "install skips Claude Code integration when .claude/skills is user-owned file" {
    mkdir -p .claude
    echo "user file" > .claude/skills

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial ".claude/skills (user-owned)"
    run cat .claude/skills
    assert_output "user file"
}

@test "install skips Claude Code integration when .claude/skills is user-owned symlink" {
    mkdir -p .claude external-skills
    ln -s ../external-skills .claude/skills

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial ".claude/skills (user-owned symlink)"
    [ -L ".claude/skills" ]

    run find external-skills -mindepth 1 -maxdepth 1 -print
    assert_output ""
}

@test "install preserves existing Claude Code user skill directory" {
    mkdir -p .claude/skills/adapt
    echo "# User adapt skill" > .claude/skills/adapt/SKILL.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "SKIP"
    assert_output --partial ".claude/skills/adapt (user-owned)"

    [ ! -L ".claude/skills/adapt" ]
    run cat .claude/skills/adapt/SKILL.md
    assert_output "# User adapt skill"
}

@test "install preserves existing Claude Code user symlink" {
    mkdir -p .claude/skills
    ln -s ../../elsewhere/adapt .claude/skills/adapt

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "user-owned symlink"

    local target
    target="$(readlink .claude/skills/adapt)"
    [ "$target" = "../../elsewhere/adapt" ]
}

@test "sync removes stale dot-agents Claude Code skill symlinks" {
    mkdir -p .claude

    bash "$INSTALL_SCRIPT" --yes
    ln -s ../../.agents/skills/old-skill .claude/skills/old-skill

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    [ ! -L ".claude/skills/old-skill" ]
}

@test "sync preserves symlinked Claude Code skills directory" {
    mkdir -p .claude external-skills
    ln -s ../external-skills .claude/skills

    bash "$INSTALL_SCRIPT" --yes
    ln -s ../../.agents/skills/old-skill external-skills/old-skill

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial ".claude/skills (user-owned symlink)"
    [ -L ".claude/skills" ]
    [ -L "external-skills/old-skill" ]
}

@test "sync removes retired Ralph Claude Code skill symlink" {
    mkdir -p .claude

    bash "$INSTALL_SCRIPT" --yes
    mkdir -p .agents/skills/ralph
    echo "# Legacy Ralph" > .agents/skills/ralph/SKILL.md
    ln -s ../../.agents/skills/ralph .claude/skills/ralph

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    [ ! -L ".claude/skills/ralph" ]
}

@test "sync removes retired ralph core skill with backup" {
    bash "$INSTALL_SCRIPT" --yes
    mkdir -p .agents/skills/ralph
    echo "# Legacy Ralph" > .agents/skills/ralph/SKILL.md

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "retired core skill"
    assert_output --partial "BACKUP"
    [ ! -d ".agents/skills/ralph" ]

    run find .agents/.dot-agents-backup -path '*/.agents/skills/ralph/SKILL.md' -type f
    assert_output --partial ".agents/skills/ralph/SKILL.md"

    local backup_file
    backup_file=$(find .agents/.dot-agents-backup -path '*/.agents/skills/ralph/SKILL.md' -type f | head -1)
    run cat "$backup_file"
    assert_output "# Legacy Ralph"
}

@test "sync backs up symlinked retired ralph core skill without following it" {
    bash "$INSTALL_SCRIPT" --yes
    ln -s ../missing-ralph .agents/skills/ralph

    run bash "$INSTALL_SCRIPT" --yes
    assert_success

    assert_output --partial "retired core skill"
    assert_output --partial "BACKUP"
    [ ! -L ".agents/skills/ralph" ]

    local backup_link
    backup_link=$(find .agents/.dot-agents-backup -path '*/.agents/skills/ralph' -type l | head -1)
    [ -n "$backup_link" ]

    local target
    target="$(readlink "$backup_link")"
    [ "$target" = "../missing-ralph" ]
}

@test "--uninstall removes only dot-agents Claude Code skill symlinks" {
    mkdir -p .claude

    bash "$INSTALL_SCRIPT" --yes
    mkdir -p .claude/skills/my-custom-skill
    echo "# My Custom" > .claude/skills/my-custom-skill/SKILL.md

    run bash "$INSTALL_SCRIPT" --uninstall --yes
    assert_success

    [ ! -L ".claude/skills/adapt" ]
    [ ! -L ".claude/skills/agent-work" ]
    [ ! -L ".claude/skills/feature-planning" ]
    [ -f ".claude/skills/my-custom-skill/SKILL.md" ]
}

@test "--uninstall preserves symlinked Claude Code skills directory" {
    mkdir -p .claude external-skills
    ln -s ../external-skills .claude/skills

    bash "$INSTALL_SCRIPT" --yes
    ln -s ../../.agents/skills/adapt external-skills/adapt

    run bash "$INSTALL_SCRIPT" --uninstall --yes
    assert_success

    assert_output --partial ".claude/skills (user-owned symlink)"
    [ -L ".claude/skills" ]
    [ -L "external-skills/adapt" ]
}
