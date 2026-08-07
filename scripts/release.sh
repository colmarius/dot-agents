#!/usr/bin/env bash
set -euo pipefail

# Release script for dot-agents
# Creates a git tag and GitHub release from the VERSION file

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$PROJECT_ROOT/VERSION"
CHANGELOG_FILE="$PROJECT_ROOT/CHANGELOG.md"

# Colors
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' NC=''
fi

DRY_RUN=false
PUSH=false

usage() {
    cat <<EOF
Usage: release.sh [OPTIONS]

Create a git tag and optionally push a GitHub release.

Options:
  --dry-run    Show what would happen without making changes
  --push       Push tag and create GitHub release (requires gh CLI)
  --help       Show this help message

Workflow:
  1. Update VERSION and pinned --ref examples with the new version
  2. Update CHANGELOG.md (move Unreleased to new version)
  3. Commit changes
  4. Push the reviewed branch and verify HEAD matches its upstream
  5. Run: ./scripts/release.sh --push

EOF
}

die() {
    echo -e "${RED}Error:${NC} $1" >&2
    exit 1
}

info() {
    echo -e "${GREEN}▸${NC} $1"
}

warn() {
    echo -e "${YELLOW}▸${NC} $1"
}

verify_upstream_release_commit() {
    local upstream
    local head_commit
    local upstream_commit

    if ! upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)"; then
        die "Current branch has no configured upstream. Push the reviewed branch before releasing."
    fi

    head_commit="$(git rev-parse HEAD)"
    upstream_commit="$(git rev-parse "$upstream")"
    if [[ "$head_commit" != "$upstream_commit" ]]; then
        die "HEAD does not match upstream branch $upstream. Push the reviewed branch and verify it before releasing."
    fi

    info "Verified HEAD matches upstream branch $upstream"
}

require_clean_release_tree() {
    if [[ -n "$(git status --porcelain=v1 --untracked-files=all)" ]]; then
        die "Repository has uncommitted changes. Commit or remove them before releasing."
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --push)
            PUSH=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            die "Unknown option: $1"
            ;;
    esac
done

# Validate VERSION file exists
[[ -f "$VERSION_FILE" ]] || die "VERSION file not found at $VERSION_FILE"

# Read version
VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')
[[ -n "$VERSION" ]] || die "VERSION file is empty"

# Validate version format (semver)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
    die "Invalid version format: $VERSION (expected semver like 1.2.3 or 1.2.3-beta.1)"
fi

TAG="v$VERSION"

info "Version: $VERSION"
info "Tag: $TAG"

# Files containing pinned version references
VERSION_FILES=(
    "$PROJECT_ROOT/install.sh"
)

# Require version references to be reviewed and committed before release
validate_version_refs() {
    local expected_tag="$1"
    local version_pattern='v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?'
    local file
    local reference
    local -a stale_files=()

    for file in "${VERSION_FILES[@]}"; do
        [[ -f "$file" ]] || continue

        while IFS= read -r reference; do
            if [[ "$reference" != "--ref $expected_tag" ]]; then
                stale_files+=("$(basename "$file")")
                break
            fi
        done < <(grep -Eo -- "--ref $version_pattern" "$file" 2>/dev/null || true)
    done

    if [[ ${#stale_files[@]} -gt 0 ]]; then
        die "Version references do not match $expected_tag in: ${stale_files[*]}. Update and commit them before releasing."
    fi
}

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    die "Tag $TAG already exists. Bump VERSION file first."
fi

require_clean_release_tree

if [[ "$PUSH" == true ]]; then
    verify_upstream_release_commit
fi

validate_version_refs "$TAG"

# Extract changelog section for this version
extract_changelog() {
    local version="$1"
    local in_section=false
    local content=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^##[[:space:]]+\[$version\] ]]; then
            in_section=true
            continue
        elif [[ "$line" =~ ^##[[:space:]]+\[ ]] && [[ "$in_section" == true ]]; then
            break
        elif [[ "$in_section" == true ]]; then
            content+="$line"$'\n'
        fi
    done < "$CHANGELOG_FILE"
    
    echo "$content"
}

# Try to get release notes from CHANGELOG
RELEASE_NOTES=$(extract_changelog "$VERSION")

if [[ -z "$RELEASE_NOTES" ]]; then
    warn "No changelog entry found for [$VERSION] in CHANGELOG.md"
    warn "Using default release notes"
    RELEASE_NOTES="Release $VERSION"
fi

echo ""
echo "Release notes:"
echo "─────────────────────────────────────"
echo "$RELEASE_NOTES"
echo "─────────────────────────────────────"
echo ""

if [[ "$DRY_RUN" == true ]]; then
    info "[DRY-RUN] Would create tag: $TAG"
    if [[ "$PUSH" == true ]]; then
        info "[DRY-RUN] Would push tag to origin"
        info "[DRY-RUN] Would create GitHub release"
    fi
    exit 0
fi

# Create tag
info "Creating tag $TAG..."
git tag -a "$TAG" -m "Release $VERSION"

if [[ "$PUSH" == true ]]; then
    # Push tag
    info "Pushing tag to origin..."
    git push origin "$TAG"
    
    # Create GitHub release (requires gh CLI)
    if command -v gh &>/dev/null; then
        info "Creating GitHub release..."
        echo "$RELEASE_NOTES" | gh release create "$TAG" \
            --title "$TAG" \
            --notes-file -
        info "GitHub release created: https://github.com/colmarius/dot-agents/releases/tag/$TAG"
    else
        warn "gh CLI not found. Push tag manually or install gh: https://cli.github.com"
        info "Tag $TAG created locally. Push with: git push origin $TAG"
    fi
else
    info "Tag $TAG created locally"
    info "To push and release: ./scripts/release.sh --push"
    info "Or manually: git push origin $TAG"
fi

echo ""
info "Done!"
