#!/usr/bin/env bash
set -euo pipefail

# sync-local.sh - Sync updates from local dot-agents repository
#
# Similar to sync.sh but uses a local repository path instead of fetching from GitHub.
# Useful for development and offline syncing.

SOURCE_REPO="${DOT_AGENTS_DEV_REPO:-}"
METADATA_FILE=".agents/.dot-agents.json"

# Colors (only if terminal supports them)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' NC=''
fi

log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

do_version() {
    echo "dot-agents (local sync)"
    echo "  Source repo: ${SOURCE_REPO}"

    if [[ -f "$METADATA_FILE" ]]; then
        local ref installed_at last_synced_at synced_commit
        ref=$(sed -n 's/.*"ref"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        installed_at=$(sed -n 's/.*"installedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        last_synced_at=$(sed -n 's/.*"lastSyncedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        synced_commit=$(sed -n 's/.*"syncedFromCommit"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")

        echo ""
        echo "Installation:"
        echo "  Ref: ${ref:-unknown}"
        echo "  Installed at: ${installed_at:-unknown}"
        if [[ -n "$last_synced_at" ]]; then
            echo "  Last synced at: ${last_synced_at}"
        fi
        if [[ -n "$synced_commit" ]]; then
            echo "  Synced from commit: ${synced_commit}"
        fi
    else
        echo ""
        echo "dot-agents not installed in this directory"
    fi
}

usage() {
    cat <<EOF
Usage: sync-local.sh [OPTIONS] [SOURCE_REPO]

Sync dot-agents from a local repository (for development).

Arguments:
  SOURCE_REPO   Path to local dot-agents repository (or set \$DOT_AGENTS_DEV_REPO)

Options:
  --dry-run     Show what would be changed without making changes
  --yes         Skip confirmation prompts
  --version     Show version and installation info
  --help        Show this help message

Examples:
  # Sync from default location
  .agents/scripts/sync-local.sh

  # Sync from specific path
  .agents/scripts/sync-local.sh /path/to/dot-agents

  # Preview changes
  .agents/scripts/sync-local.sh --dry-run

  # Skip confirmation
  .agents/scripts/sync-local.sh --yes
EOF
}

_main() {
    local dry_run=false yes=false
    local source_repo="${DOT_AGENTS_DEV_REPO:-}"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                usage
                exit 0
                ;;
            --version)
                do_version
                exit 0
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --yes)
                yes=true
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                source_repo="$1"
                shift
                ;;
        esac
    done

    # Require source repo
    if [[ -z "$source_repo" ]]; then
        log_error "Source repository path is required."
        log_error "Pass as argument or set \$DOT_AGENTS_DEV_REPO."
        echo ""
        usage
        exit 1
    fi

    # Validate source repository
    if [[ ! -d "$source_repo/.agents" ]]; then
        log_error "Source .agents directory not found: $source_repo/.agents"
        exit 1
    fi

    if [[ ! -d ".agents" ]]; then
        log_error "Target .agents directory not found in current directory"
        exit 1
    fi

    log_info "Syncing from: $source_repo"
    echo ""

    # Get source commit info (use subshell to avoid cd side effects)
    local latest_commit="" commit_date=""
    if latest_commit=$(cd "$source_repo" && git rev-parse HEAD 2>/dev/null); then
        commit_date=$(cd "$source_repo" && git log -1 --format='%aI' 2>/dev/null)
        log_info "Source commit: ${latest_commit:0:8} ($commit_date)"
    else
        log_warn "Source is not a git repository, continuing without commit info"
        latest_commit=""
        commit_date=""
    fi

    if [[ "$dry_run" == true ]]; then
        log_info "Running in DRY-RUN mode"
        rsync -av --dry-run "$source_repo/.agents/" ".agents/"
        exit 0
    fi

    # Confirm before syncing
    if [[ "$yes" != true ]]; then
        echo ""
        read -p "Proceed with sync? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_warn "Sync cancelled"
            exit 1
        fi
    fi

    # Perform sync using rsync (without --delete to preserve local scripts)
    log_info "Syncing files..."
    rsync -av "$source_repo/.agents/" ".agents/"

    # Update metadata (preserve existing installedAt)
    log_info "Updating metadata..."
    local now
    now=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
    local installed_at="$now"
    if [[ -f "$METADATA_FILE" ]]; then
        local existing
        existing=$(sed -n 's/.*"installedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        if [[ -n "$existing" ]]; then
            installed_at="$existing"
        fi
    fi

    local commit_fields=""
    if [[ -n "$latest_commit" ]]; then
        commit_fields=",
  \"syncedFromCommit\": \"$latest_commit\",
  \"commitDate\": \"$commit_date\""
    fi

    cat > "$METADATA_FILE" << METADATA
{
  "upstream": "https://github.com/colmarius/dot-agents",
  "ref": "main",
  "installedAt": "$installed_at",
  "lastSyncedAt": "$now"$commit_fields
}
METADATA

    # Run post-sync integrations
    if [[ -f ".agents/scripts/setup-claude-integration.sh" ]]; then
        log_info "Running post-sync integrations..."
        bash .agents/scripts/setup-claude-integration.sh --quiet
    fi

    echo ""
    log_info "✓ Sync complete!"
    if [[ -n "$latest_commit" ]]; then
        echo "  Latest commit: $latest_commit"
        echo "  Commit date: $commit_date"
    fi
    echo "  Synced at: $now"
}

# Only run if script is executed, not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    _main "$@"
fi
