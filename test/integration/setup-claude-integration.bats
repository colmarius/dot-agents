#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

SCRIPT="$BATS_TEST_DIRNAME/../../.agents/scripts/setup-claude-integration.sh"

setup() {
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR" || exit 1

    # Create .agents/skills/ with sample skills
    mkdir -p .agents/skills/adapt
    cat > .agents/skills/adapt/SKILL.md <<'EOF'
---
name: adapt
description: "Analyze project"
---

# Adapt
EOF

    mkdir -p .agents/skills/research
    cat > .agents/skills/research/SKILL.md <<'EOF'
---
name: research
description: "Deep research"
---

# Research
EOF
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
}

@test "--help shows usage" {
    run bash "$SCRIPT" --help
    assert_success
    assert_output --partial "Usage: setup-claude-integration.sh"
    assert_output --partial "--dry-run"
    assert_output --partial "--quiet"
}

@test "creates symlinks when .claude/ exists" {
    mkdir -p .claude

    run bash "$SCRIPT"
    assert_success

    # Symlinks should exist
    [ -L ".claude/skills/adapt/SKILL.md" ]
    [ -L ".claude/skills/research/SKILL.md" ]

    # Symlinks should resolve to correct content
    run cat ".claude/skills/adapt/SKILL.md"
    assert_success
    assert_output --partial "adapt"
}

@test "skips when no .claude/ directory" {
    run bash "$SCRIPT"
    assert_success
    assert_output --partial "No .claude/ directory"

    [ ! -d ".claude/skills" ]
}

@test "--dry-run makes no changes" {
    mkdir -p .claude

    run bash "$SCRIPT" --dry-run
    assert_success
    assert_output --partial "Would create"

    # Should not create symlinks
    [ ! -L ".claude/skills/adapt/SKILL.md" ]
}

@test "--quiet suppresses informational output" {
    mkdir -p .claude

    run bash "$SCRIPT" --quiet
    assert_success

    # Should not contain informational messages
    refute_output --partial "Setting up Claude Code"
    refute_output --partial "No .claude/ directory"
}

@test "--quiet suppresses skip message when no .claude/" {
    run bash "$SCRIPT" --quiet
    assert_success
    assert_output ""
}

@test "creates .gitignore with dot-agents header" {
    mkdir -p .claude

    bash "$SCRIPT"

    [ -f ".claude/skills/.gitignore" ]
    run cat ".claude/skills/.gitignore"
    assert_output --partial "dot-agents"
    assert_output --partial "adapt/"
    assert_output --partial "research/"
}

@test "preserves user-created skills (non-symlink files)" {
    mkdir -p .claude/skills/my-custom
    echo "# My Custom Skill" > .claude/skills/my-custom/SKILL.md

    # Also create .agents counterpart with same name to test skip behavior
    mkdir -p .agents/skills/my-custom
    echo "# Upstream version" > .agents/skills/my-custom/SKILL.md

    run bash "$SCRIPT"
    assert_success
    assert_output --partial "not a symlink"

    # User's file should be preserved
    [ ! -L ".claude/skills/my-custom/SKILL.md" ]
    run cat ".claude/skills/my-custom/SKILL.md"
    assert_output "# My Custom Skill"
}

@test "cleans stale symlinks" {
    mkdir -p .claude/skills/old-skill
    # Create a symlink that points to a non-existent skill
    ln -sf "../../../.agents/skills/old-skill/SKILL.md" .claude/skills/old-skill/SKILL.md

    run bash "$SCRIPT"
    assert_success

    # Stale symlink should be removed
    [ ! -L ".claude/skills/old-skill/SKILL.md" ]
    [ ! -d ".claude/skills/old-skill" ]
}

@test "symlinks use correct relative path" {
    mkdir -p .claude

    bash "$SCRIPT"

    local target
    target="$(readlink .claude/skills/adapt/SKILL.md)"
    [ "$target" = "../../../.agents/skills/adapt/SKILL.md" ]
}

@test "is idempotent (running twice produces same result)" {
    mkdir -p .claude

    bash "$SCRIPT"
    [ -L ".claude/skills/adapt/SKILL.md" ]

    # Run again
    run bash "$SCRIPT"
    assert_success
    [ -L ".claude/skills/adapt/SKILL.md" ]

    # Content should still be readable
    run cat ".claude/skills/adapt/SKILL.md"
    assert_success
    assert_output --partial "adapt"
}
