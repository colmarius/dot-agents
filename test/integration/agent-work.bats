#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

CLOSE_WORK_SOURCE="$BATS_TEST_DIRNAME/../../.agents/skills/agent-work/scripts/close-work.sh"
LIST_WORK_SOURCE="$BATS_TEST_DIRNAME/../../.agents/skills/agent-work/scripts/list-work.sh"

setup() {
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR" || exit 1

    git init --quiet
    git config user.email "test@test.com"
    git config user.name "Test User"

    mkdir -p .agents/skills/agent-work/scripts
    cp "$CLOSE_WORK_SOURCE" .agents/skills/agent-work/scripts/close-work.sh
    cp "$LIST_WORK_SOURCE" .agents/skills/agent-work/scripts/list-work.sh
    chmod +x .agents/skills/agent-work/scripts/close-work.sh \
        .agents/skills/agent-work/scripts/list-work.sh

    mkdir -p .agents/work/tooling/demo-work
    cat > .agents/work/tooling/demo-work/index.md <<'EOF'
# Demo work

Status: completed
Category: tooling
Updated: 2026-08-07

## Next Action

- None.
EOF
    echo "- [x] Done" > .agents/work/tooling/demo-work/plan.md

    git add -A
    git commit -m "Complete demo work" --quiet
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
}

replace_in_file() {
    local expression="$1"
    local target="$2"
    local temporary

    temporary=$(mktemp)
    sed "$expression" "$target" > "$temporary"
    mv "$temporary" "$target"
}

@test "close-work help and argument validation are explicit" {
    run .agents/skills/agent-work/scripts/close-work.sh --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "--check"

    run .agents/skills/agent-work/scripts/close-work.sh --category --slug demo-work
    assert_failure 2
    assert_output --partial "Missing value for --category"

    run .agents/skills/agent-work/scripts/close-work.sh --category "Bad Category" --slug demo-work
    assert_failure 2
    assert_output --partial "Invalid category"

    run .agents/skills/agent-work/scripts/close-work.sh --category tooling --slug "../demo-work"
    assert_failure 2
    assert_output --partial "Invalid slug"
}

@test "list-work exposes completed snapshots awaiting removal" {
    run .agents/skills/agent-work/scripts/list-work.sh
    assert_success
    assert_output --partial "Demo work"
    assert_output --partial "completed"
}

@test "close-work rejects invocation outside the repository root" {
    mkdir subdirectory
    cd subdirectory

    run "$TEST_DIR/.agents/skills/agent-work/scripts/close-work.sh" \
        --category tooling --slug demo-work
    assert_failure
    assert_output --partial "must run from the repository root"
}

@test "close-work rejects a missing work item" {
    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug missing-work
    assert_failure
    assert_output --partial "Work item index not found"
}

@test "close-work rejects non-completed work and a non-empty next action" {
    replace_in_file 's/Status: completed/Status: in-progress/' \
        .agents/work/tooling/demo-work/index.md
    git add -A
    git commit -m "Resume work" --quiet

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work
    assert_failure
    assert_output --partial "exactly one 'Status: completed'"

    replace_in_file 's/Status: in-progress/Status: completed/' \
        .agents/work/tooling/demo-work/index.md
    replace_in_file 's/- None\./- Await review./' \
        .agents/work/tooling/demo-work/index.md
    git add -A
    git commit -m "Await review" --quiet

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work
    assert_failure
    assert_output --partial "exactly '- None.'"
}

@test "close-work rejects dirty repository and uncommitted final changes" {
    echo "dirty" > unrelated.txt

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work
    assert_failure
    assert_output --partial "Repository has uncommitted changes"

    rm unrelated.txt
    echo "Uncommitted evidence" >> .agents/work/tooling/demo-work/plan.md

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work
    assert_failure
    assert_output --partial "Repository has uncommitted changes"
}

@test "close-work rejects ignored files inside the work item" {
    echo ".agents/work/tooling/demo-work/private.log" > .gitignore
    git add .gitignore
    git commit -m "Ignore private work log" --quiet
    echo "do not delete" > .agents/work/tooling/demo-work/private.log

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work
    assert_failure
    assert_output --partial "contains ignored files"
    [ -f .agents/work/tooling/demo-work/private.log ]
}

@test "close-work check validates without changing repository state" {
    local before
    before=$(git status --porcelain=v1)

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work --check
    assert_success
    assert_output "Ready to close: .agents/work/tooling/demo-work"

    [ -f .agents/work/tooling/demo-work/index.md ]
    [ "$(git status --porcelain=v1)" = "$before" ]
}

@test "close-work stages only the work-item deletion without committing" {
    local head_before
    head_before=$(git rev-parse HEAD)

    run .agents/skills/agent-work/scripts/close-work.sh \
        --category tooling --slug demo-work
    assert_success
    assert_output --partial "Staged work-item removal"
    assert_output --partial "Commit this deletion separately"

    [ ! -e .agents/work/tooling/demo-work ]
    [ -f .agents/skills/agent-work/scripts/close-work.sh ]
    [ "$(git rev-parse HEAD)" = "$head_before" ]

    run git diff --cached --name-status
    assert_success
    assert_line $'D\t.agents/work/tooling/demo-work/index.md'
    assert_line $'D\t.agents/work/tooling/demo-work/plan.md'
    [ "${#lines[@]}" -eq 2 ]
}
