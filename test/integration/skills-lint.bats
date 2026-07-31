#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

SKILLS_LINT="$BATS_TEST_DIRNAME/../../scripts/skills-lint.sh"
CORE_SKILLS="$BATS_TEST_DIRNAME/../../.agents/skills"

setup() {
    TEST_DIR="$(mktemp -d)"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "core skills pass metadata and link lint" {
    run bash "$SKILLS_LINT" "$CORE_SKILLS"
    assert_success
    assert_output "Skill lint passed: 6 file(s)"
}

@test "skill lint rejects metadata that does not match its folder" {
    mkdir -p "$TEST_DIR/.agents/skills/example-skill"
    cat > "$TEST_DIR/.agents/skills/example-skill/SKILL.md" <<'EOF'
---
name: wrong-name
description: "Does example work. Triggers on: example."
---
EOF

    run bash "$SKILLS_LINT" "$TEST_DIR/.agents/skills"
    assert_failure
    assert_output --partial "must match folder 'example-skill'"
}

@test "skill lint rejects missing relative links" {
    mkdir -p "$TEST_DIR/.agents/skills/example-skill"
    cat > "$TEST_DIR/.agents/skills/example-skill/SKILL.md" <<'EOF'
---
name: example-skill
description: "Does example work. Triggers on: example."
---

[Missing reference](references/missing.md)
EOF

    run bash "$SKILLS_LINT" "$TEST_DIR/.agents/skills"
    assert_failure
    assert_output --partial "missing relative target 'references/missing.md'"
}
