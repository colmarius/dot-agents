#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

# Path to release.sh from test directory
RELEASE_SCRIPT="$BATS_TEST_DIRNAME/../../scripts/release.sh"

setup() {
    # Create isolated test directory with git repo
    TEST_DIR="$(mktemp -d)"
    REMOTE_DIR=""
    cd "$TEST_DIR" || exit 1

    # Initialize git repo
    git init --quiet
    git config user.email "test@test.com"
    git config user.name "Test User"
    git config commit.gpgsign false

    # Create VERSION file
    echo "1.0.0" > VERSION

    # Create minimal CHANGELOG.md
    cat > CHANGELOG.md <<'EOF'
# Changelog

## [Unreleased]

## [1.0.0] - 2025-01-01

### Added

- Initial release

[Unreleased]: https://github.com/test/test/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/test/test/releases/tag/v1.0.0
EOF

    # Create scripts directory and copy release script
    mkdir -p scripts
    cp "$RELEASE_SCRIPT" scripts/release.sh

    # Commit everything
    git add -A
    git commit -m "Initial commit" --quiet
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
    if [[ -n "$REMOTE_DIR" ]]; then
        rm -rf "$REMOTE_DIR"
    fi
}

configure_upstream() {
    REMOTE_DIR="$(mktemp -d)"
    git init --bare --quiet "$REMOTE_DIR"
    git branch -M main
    git remote add origin "$REMOTE_DIR"
    git push --quiet --set-upstream origin main
}

@test "--help shows usage and exits 0" {
    run bash scripts/release.sh --help
    assert_success
    assert_output --partial "Usage: release.sh"
    assert_output --partial "--dry-run"
    assert_output --partial "--push"
}

@test "--dry-run shows version and tag without creating" {
    run bash scripts/release.sh --dry-run
    assert_success
    assert_output --partial "Version: 1.0.0"
    assert_output --partial "Tag: v1.0.0"
    assert_output --partial "[DRY-RUN] Would create tag: v1.0.0"

    # Tag should not exist
    run git tag -l "v1.0.0"
    assert_output ""
}

@test "--push refuses release without an upstream branch" {
    cat > install.sh <<'EOF'
#!/usr/bin/env bash
# Example: bash -s -- --ref v0.0.1
EOF
    git add install.sh
    git commit -m "Add stale version reference" --quiet
    local head_before
    head_before=$(git rev-parse HEAD)

    run bash scripts/release.sh --dry-run --push
    assert_failure
    assert_output --partial "Current branch has no configured upstream"

    [ "$(git rev-parse HEAD)" = "$head_before" ]
    run grep -- "--ref v0.0.1" install.sh
    assert_success
    [ -z "$(git status --porcelain=v1 --untracked-files=all)" ]

    run git tag -l "v1.0.0"
    assert_output ""
}

@test "--push refuses release when HEAD does not match upstream" {
    configure_upstream
    echo "Local release change" >> CHANGELOG.md
    cat > install.sh <<'EOF'
#!/usr/bin/env bash
# Example: bash -s -- --ref v0.0.1
EOF
    git add CHANGELOG.md install.sh
    git commit -m "Local release change" --quiet
    local head_before
    head_before=$(git rev-parse HEAD)

    run bash scripts/release.sh --dry-run --push
    assert_failure
    assert_output --partial "HEAD does not match upstream branch origin/main"

    [ "$(git rev-parse HEAD)" = "$head_before" ]
    run grep -- "--ref v0.0.1" install.sh
    assert_success
    [ -z "$(git status --porcelain=v1 --untracked-files=all)" ]

    run git tag -l "v1.0.0"
    assert_output ""
}

@test "--push proceeds when HEAD matches upstream" {
    configure_upstream

    run bash scripts/release.sh --dry-run --push
    assert_success
    assert_output --partial "Verified HEAD matches upstream branch origin/main"
    assert_output --partial "[DRY-RUN] Would push tag to origin"
}

@test "fails when VERSION file is missing" {
    rm VERSION
    git add -A && git commit -m "Remove VERSION" --quiet

    run bash scripts/release.sh --dry-run
    assert_failure
    assert_output --partial "VERSION file not found"
}

@test "fails when VERSION file is empty" {
    echo "" > VERSION
    git add -A && git commit -m "Empty VERSION" --quiet

    run bash scripts/release.sh --dry-run
    assert_failure
    assert_output --partial "VERSION file is empty"
}

@test "fails with invalid semver format" {
    echo "1.0" > VERSION
    git add -A && git commit -m "Invalid version" --quiet

    run bash scripts/release.sh --dry-run
    assert_failure
    assert_output --partial "Invalid version format"
}

@test "accepts valid semver with prerelease" {
    echo "1.0.0-beta.1" > VERSION
    git add -A && git commit -m "Prerelease version" --quiet

    run bash scripts/release.sh --dry-run
    assert_success
    assert_output --partial "Version: 1.0.0-beta.1"
    assert_output --partial "Tag: v1.0.0-beta.1"
}

@test "fails when tag already exists" {
    # Create the tag first
    git tag -a "v1.0.0" -m "Existing tag"

    run bash scripts/release.sh --dry-run
    assert_failure
    assert_output --partial "Tag v1.0.0 already exists"
}

@test "uncommitted files block release without changing HEAD" {
    echo "new content" > newfile.txt
    local head_before
    head_before=$(git rev-parse HEAD)

    run bash scripts/release.sh --dry-run
    assert_failure
    assert_output --partial "Repository has uncommitted changes"

    [ "$(git rev-parse HEAD)" = "$head_before" ]
    [ -f newfile.txt ]
    run git tag -l "v1.0.0"
    assert_output ""
}

@test "creates tag without --push" {
    run bash scripts/release.sh
    assert_success
    assert_output --partial "Tag v1.0.0 created locally"

    # Tag should exist
    run git tag -l "v1.0.0"
    assert_output "v1.0.0"
}

@test "extracts release notes from CHANGELOG" {
    run bash scripts/release.sh --dry-run
    assert_success
    assert_output --partial "Initial release"
}

@test "handles missing changelog section gracefully" {
    # Update VERSION to a version not in CHANGELOG
    echo "2.0.0" > VERSION
    git add -A && git commit -m "Bump version" --quiet

    run bash scripts/release.sh --dry-run
    assert_success
    assert_output --partial "No changelog entry found"
    assert_output --partial "Release 2.0.0"
}

@test "stale static version references fail without modifying the repository" {
    cat > install.sh <<'EOF'
#!/usr/bin/env bash
# Example: bash -s -- --ref v0.0.1
echo "installer"
EOF

    git add -A && git commit -m "Add file with version ref" --quiet
    configure_upstream
    local head_before
    head_before=$(git rev-parse HEAD)

    run bash scripts/release.sh --dry-run --push
    assert_failure
    assert_output --partial "Version references do not match v1.0.0 in: install.sh"

    [ "$(git rev-parse HEAD)" = "$head_before" ]
    run grep -- "--ref v0.0.1" install.sh
    assert_success
    [ -z "$(git status --porcelain=v1 --untracked-files=all)" ]
    run git tag -l "v1.0.0"
    assert_output ""
}

@test "matching static version references pass validation unchanged" {
    cat > install.sh <<'EOF'
#!/usr/bin/env bash
# Example: bash -s -- --ref v1.0.0
EOF

    git add -A && git commit -m "Add install.sh" --quiet
    local head_before
    head_before=$(git rev-parse HEAD)

    run bash scripts/release.sh --dry-run
    assert_success
    assert_output --partial "[DRY-RUN] Would create tag: v1.0.0"

    run grep -- "--ref v1.0.0" install.sh
    assert_success
    [ "$(git rev-parse HEAD)" = "$head_before" ]
    [ -z "$(git status --porcelain=v1 --untracked-files=all)" ]
}
