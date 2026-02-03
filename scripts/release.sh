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
  1. Update VERSION file with new version number
  2. Update CHANGELOG.md (move Unreleased to new version)
  3. Commit changes
  4. Run: ./scripts/release.sh --push

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

# Files containing version references to update
VERSION_FILES=(
    "$PROJECT_ROOT/install.sh"
    "$PROJECT_ROOT/site/index.html"
)

# Update version references in files
update_version_refs() {
    local new_tag="$1"
    local old_pattern='v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?'
    
    for file in "${VERSION_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            # Only update version refs in --ref examples
            if grep -qE -- "--ref $old_pattern" "$file" 2>/dev/null; then
                sed -i.bak -E "s/--ref $old_pattern/--ref $new_tag/g" "$file"
                rm -f "$file.bak"
                info "Updated version in $(basename "$file")"
            fi
        fi
    done
}

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    die "Tag $TAG already exists. Bump VERSION file first."
fi

# Update version references in example code
update_version_refs "$TAG"

# Check for uncommitted changes and commit version updates
if ! git diff --quiet HEAD 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    info "Committing version reference updates..."
    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY-RUN] Would commit version reference updates"
    else
        git add -A
        git commit -m "chore: Update version references to $TAG"
    fi
fi

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
