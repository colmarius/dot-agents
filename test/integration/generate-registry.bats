#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

GENERATE_SCRIPT="$BATS_TEST_DIRNAME/../../.agents/scripts/generate-registry.sh"

setup() {
    TEST_DIR="$(mktemp -d)"

    # Create a minimal skills directory structure
    mkdir -p "$TEST_DIR/skills/test-skill"
    cat > "$TEST_DIR/skills/test-skill/SKILL.md" <<'EOF'
---
name: test-skill
description: "A test skill for registry generation"
triggers: test, run test
keywords: testing, validation
invocation: "Run test-skill"
---

# Test Skill

This is a test skill.
EOF

    mkdir -p "$TEST_DIR/scripts"
    # Copy the generate script and patch SKILLS_DIR
    sed "s|SKILLS_DIR=.*|SKILLS_DIR=\"$TEST_DIR/skills\"|" "$GENERATE_SCRIPT" > "$TEST_DIR/scripts/generate-registry.sh"
    chmod +x "$TEST_DIR/scripts/generate-registry.sh"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "generates valid JSON output" {
    run bash "$TEST_DIR/scripts/generate-registry.sh"
    assert_success
    assert_output --partial "Generated"

    # Validate JSON with python3
    run python3 -m json.tool "$TEST_DIR/skills/REGISTRY.json"
    assert_success
}

@test "includes skill metadata in output" {
    bash "$TEST_DIR/scripts/generate-registry.sh"

    run cat "$TEST_DIR/skills/REGISTRY.json"
    assert_output --partial '"id": "test-skill"'
    assert_output --partial '"name": "test-skill"'
    assert_output --partial '"description": "A test skill for registry generation"'
    assert_output --partial '"invocation": "Run test-skill"'
}

@test "generates triggers array" {
    bash "$TEST_DIR/scripts/generate-registry.sh"

    run cat "$TEST_DIR/skills/REGISTRY.json"
    assert_output --partial '"triggers":'
    assert_output --partial '"test"'
    assert_output --partial '"run test"'
}

@test "generates keywords array" {
    bash "$TEST_DIR/scripts/generate-registry.sh"

    run cat "$TEST_DIR/skills/REGISTRY.json"
    assert_output --partial '"keywords":'
    assert_output --partial '"testing"'
    assert_output --partial '"validation"'
}

@test "skips skills missing required name field" {
    mkdir -p "$TEST_DIR/skills/no-name"
    cat > "$TEST_DIR/skills/no-name/SKILL.md" <<'EOF'
---
description: "Missing name field"
---

# No Name Skill
EOF

    run bash "$TEST_DIR/scripts/generate-registry.sh"
    assert_success
    assert_output --partial "Warning: Skipping"
    assert_output --partial "missing name or description"

    # Should still include the valid skill
    run cat "$TEST_DIR/skills/REGISTRY.json"
    assert_output --partial '"id": "test-skill"'
    refute_output --partial '"id": "no-name"'
}

@test "skips skills missing required description field" {
    mkdir -p "$TEST_DIR/skills/no-desc"
    cat > "$TEST_DIR/skills/no-desc/SKILL.md" <<'EOF'
---
name: no-desc
---

# No Description Skill
EOF

    run bash "$TEST_DIR/scripts/generate-registry.sh"
    assert_success
    assert_output --partial "Warning: Skipping"

    run cat "$TEST_DIR/skills/REGISTRY.json"
    refute_output --partial '"id": "no-desc"'
}

@test "handles skills with empty triggers and keywords" {
    mkdir -p "$TEST_DIR/skills/minimal"
    cat > "$TEST_DIR/skills/minimal/SKILL.md" <<'EOF'
---
name: minimal
description: "A minimal skill"
---

# Minimal Skill
EOF

    bash "$TEST_DIR/scripts/generate-registry.sh"

    run python3 -m json.tool "$TEST_DIR/skills/REGISTRY.json"
    assert_success

    run cat "$TEST_DIR/skills/REGISTRY.json"
    assert_output --partial '"id": "minimal"'
}

@test "handles descriptions with special characters" {
    mkdir -p "$TEST_DIR/skills/special"
    cat > "$TEST_DIR/skills/special/SKILL.md" <<'EOF'
---
name: special
description: "Handles \"quotes\" and backslash \\ chars"
---

# Special Skill
EOF

    bash "$TEST_DIR/scripts/generate-registry.sh"

    run python3 -m json.tool "$TEST_DIR/skills/REGISTRY.json"
    assert_success
}

@test "includes version and generated timestamp" {
    bash "$TEST_DIR/scripts/generate-registry.sh"

    run cat "$TEST_DIR/skills/REGISTRY.json"
    assert_output --partial '"version": "1.0"'
    assert_output --partial '"generated":'
}

@test "reports correct skill count" {
    mkdir -p "$TEST_DIR/skills/second-skill"
    cat > "$TEST_DIR/skills/second-skill/SKILL.md" <<'EOF'
---
name: second-skill
description: "Another test skill"
---

# Second Skill
EOF

    run bash "$TEST_DIR/scripts/generate-registry.sh"
    assert_success
    assert_output --partial "2 skills"
}
