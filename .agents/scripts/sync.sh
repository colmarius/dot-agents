#!/usr/bin/env bash
set -euo pipefail

# sync.sh - Sync updates from upstream dot-agents repository
#
# Reads .dot-agents.json for upstream URL and ref, then fetches and executes
# the upstream install.sh with passthrough flags.

METADATA_FILE=".agents/.dot-agents.json"
UPSTREAM_URL="https://github.com/colmarius/dot-agents"
DEFAULT_REF="main"

# Colors (only if terminal supports them)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    NC='\033[0m'
else
    RED='' NC=''
fi

log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

do_version() {
    echo "dot-agents"
    echo "  Upstream: ${UPSTREAM_URL}"
    echo "  Default ref: ${DEFAULT_REF}"
    
    if [[ -f "$METADATA_FILE" ]]; then
        local ref installed_at last_synced_at
        ref=$(sed -n 's/.*"ref"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        installed_at=$(sed -n 's/.*"installedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        last_synced_at=$(sed -n 's/.*"lastSyncedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
        
        echo ""
        echo "Installation:"
        echo "  Ref: ${ref:-unknown}"
        echo "  Installed at: ${installed_at:-unknown}"
        if [[ -n "$last_synced_at" ]]; then
            echo "  Last synced at: ${last_synced_at}"
        fi
    else
        echo ""
        echo "dot-agents not installed in this directory"
    fi
}

usage() {
    cat <<EOF
Usage: sync.sh [OPTIONS]

Sync dot-agents from upstream repository.

All options are passed through to the upstream install.sh script.

Options:
  --dry-run         Show what would happen without making changes
  --force           Overwrite conflicts (creates backup first)
  --interactive     Prompt for each conflict
  --yes             Skip confirmation prompts
  --version         Show version and installation info
  --help            Show this help message

Examples:
  # Preview changes
  .agents/scripts/sync.sh --dry-run

  # Force update with backup
  .agents/scripts/sync.sh --force

  # Interactive conflict resolution
  .agents/scripts/sync.sh --interactive
EOF
}

_main() {
    # Check for help/version flags early
    for arg in "$@"; do
        if [[ "$arg" == "--help" || "$arg" == "-h" ]]; then
            usage
            exit 0
        fi
        if [[ "$arg" == "--version" ]]; then
            do_version
            exit 0
        fi
    done

    # Check metadata file exists
    if [[ ! -f "$METADATA_FILE" ]]; then
        log_error "Metadata file not found: $METADATA_FILE"
        log_error "This project may not have dot-agents installed."
        log_error "Run the install script first."
        exit 1
    fi

    # Parse upstream URL using sed (no jq dependency)
    upstream=$(sed -n 's/.*"upstream"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")
    ref=$(sed -n 's/.*"ref"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$METADATA_FILE")

    if [[ -z "$upstream" ]]; then
        log_error "Could not parse 'upstream' from $METADATA_FILE"
        exit 1
    fi

    if [[ -z "$ref" ]]; then
        ref="main"
    fi

    # Validate GitHub URL and extract owner/repo
    if [[ ! "$upstream" =~ ^https://github\.com/([^/]+)/([^/]+)$ ]]; then
        log_error "Upstream URL must be a GitHub repository: $upstream"
        log_error "Expected format: https://github.com/owner/repo"
        exit 1
    fi

    owner="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]}"

    # Build install.sh URL
    install_url="https://raw.githubusercontent.com/${owner}/${repo}/${ref}/install.sh"

    echo "Syncing from: ${upstream} (ref: ${ref})"
    echo ""

    # Fetch and execute upstream install.sh with passthrough flags
    set +e
    bash <(curl -fsSL "$install_url") --ref "$ref" "$@"
    local rc=$?
    set -e

    if [[ $rc -eq 0 ]]; then
        # Run post-sync integrations
        if [[ -f ".agents/scripts/setup-claude-integration.sh" ]]; then
            bash .agents/scripts/setup-claude-integration.sh --quiet
        fi
    else
        exit $rc
    fi
}

# Only run if script is executed, not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    _main "$@"
fi
