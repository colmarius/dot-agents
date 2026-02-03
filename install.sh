#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="colmarius"
REPO_NAME="dot-agents"
DEFAULT_REF="main"

# Colors (only if terminal supports them)
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' BLUE='' NC=''
fi

REF="$DEFAULT_REF"
DRY_RUN=false
FORCE=false
YES=false
SHOW_HELP=false
UNINSTALL=false
INTERACTIVE=false
SHOW_VERSION=false
DIFF_ONLY=false

usage() {
    cat <<EOF
Usage: install.sh [OPTIONS]

Install dot-agents into the current project.

Options:
  --dry-run         Show what would happen without making changes
  --diff            Show unified diff for conflicts without creating files
  --force           Overwrite conflicts (creates backup first)
  --ref <ref>       Git ref to install (branch, tag, commit). Default: main
  --yes             Skip confirmation prompts
  --uninstall       Remove dot-agents
  --interactive     Prompt for each conflict
  --version         Show version and installation info
  --help            Show this help message

Examples:
  # Basic install
  curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash

  # Install specific version
  curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v1.0.0

  # Preview changes first
  curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --dry-run

  # Force update (backup + overwrite)
  curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --force
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --diff)
                DIFF_ONLY=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --ref)
                if [[ -z "${2:-}" ]]; then
                    log_error "--ref requires a value"
                    exit 1
                fi
                REF="$2"
                shift 2
                ;;
            --yes)
                YES=true
                shift
                ;;
            --help|-h)
                SHOW_HELP=true
                shift
                ;;
            --uninstall)
                UNINSTALL=true
                shift
                ;;
            --interactive|-i)
                INTERACTIVE=true
                shift
                ;;
            --version)
                SHOW_VERSION=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

do_version() {
    local metadata_file=".agents/.dot-agents.json"

    echo "dot-agents"
    echo "  Upstream: https://github.com/${REPO_OWNER}/${REPO_NAME}"
    echo "  Default ref: ${DEFAULT_REF}"

    if [[ -f "$metadata_file" ]]; then
        local ref installed_at last_synced_at
        ref=$(sed -n 's/.*"ref"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$metadata_file")
        installed_at=$(sed -n 's/.*"installedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$metadata_file")
        last_synced_at=$(sed -n 's/.*"lastSyncedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$metadata_file")

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

do_uninstall() {
    log_info "Uninstalling dot-agents..."
    log_info ""

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "${YELLOW}DRY RUN - no changes will be made${NC}"
        log_info ""
    fi

    local removed=0

    # Remove AGENTS.md
    if [[ -f "AGENTS.md" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "${RED}[REMOVE]${NC} AGENTS.md"
        else
            rm "AGENTS.md"
            log_info "${RED}[REMOVE]${NC} AGENTS.md"
        fi
        removed=$((removed + 1))
    fi

    # Remove .agents/
    if [[ -d ".agents" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "${RED}[REMOVE]${NC} .agents/"
        else
            rm -rf ".agents"
            log_info "${RED}[REMOVE]${NC} .agents/"
        fi
        removed=$((removed + 1))
    fi

    log_info ""
    if [[ $removed -eq 0 ]]; then
        log_info "Nothing to uninstall."
    else
        log_info "Uninstall complete."
    fi
}

installed_count=0
skipped_count=0
conflict_count=0
backup_count=0
BACKUP_DIR=""

create_backup_dir() {
    if [[ -z "$BACKUP_DIR" ]]; then
        local timestamp
        timestamp="$(date -u +%Y-%m-%dT%H%M%SZ)"
        BACKUP_DIR=".dot-agents-backup/${timestamp}"
        if [[ "$DRY_RUN" != "true" ]]; then
            mkdir -p "$BACKUP_DIR"
        fi
    fi
}

backup_file() {
    local file="$1"
    create_backup_dir
    local backup_path="${BACKUP_DIR}/${file}"
    local backup_dir
    backup_dir="$(dirname "$backup_path")"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "  ${BLUE}[BACKUP]${NC} $file → $backup_path"
    else
        mkdir -p "$backup_dir"
        cp "$file" "$backup_path"
        log_info "  ${BLUE}[BACKUP]${NC} $file"
    fi
    backup_count=$((backup_count + 1))
}

detect_stack() {
    local detected=""

    if [[ -f "package.json" ]]; then
        detected="${detected}# Detected: Node.js project (package.json)\n"
        detected="${detected}# npm install | pnpm install | yarn install\n"
        detected="${detected}# npm run dev | npm run build | npm test\n\n"
    fi

    if [[ -f "Cargo.toml" ]]; then
        detected="${detected}# Detected: Rust project (Cargo.toml)\n"
        detected="${detected}# cargo build | cargo run | cargo test | cargo clippy\n\n"
    fi

    if [[ -f "go.mod" ]]; then
        detected="${detected}# Detected: Go project (go.mod)\n"
        detected="${detected}# go build ./... | go run . | go test ./...\n\n"
    fi

    if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]]; then
        detected="${detected}# Detected: Python project\n"
        detected="${detected}# pip install -r requirements.txt | pip install -e .\n"
        detected="${detected}# python main.py | pytest | ruff check . | mypy .\n\n"
    fi

    echo -e "$detected"
}

write_metadata() {
    local metadata_file=".agents/.dot-agents.json"
    local timestamp
    timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "${GREEN}[METADATA]${NC} Would write $metadata_file"
        return
    fi

    mkdir -p .agents

    # Check if this is an update (metadata file already exists)
    if [[ -f "$metadata_file" ]]; then
        # Preserve existing installedAt, add/update lastSyncedAt
        local installed_at
        installed_at=$(sed -n 's/.*"installedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$metadata_file")
        if [[ -z "$installed_at" ]]; then
            installed_at="$timestamp"
        fi
        cat > "$metadata_file" <<EOF
{
  "upstream": "https://github.com/${REPO_OWNER}/${REPO_NAME}",
  "ref": "${REF}",
  "installedAt": "${installed_at}",
  "lastSyncedAt": "${timestamp}"
}
EOF
    else
        # Fresh install - only set installedAt
        cat > "$metadata_file" <<EOF
{
  "upstream": "https://github.com/${REPO_OWNER}/${REPO_NAME}",
  "ref": "${REF}",
  "installedAt": "${timestamp}"
}
EOF
    fi
    log_info "${GREEN}[METADATA]${NC} $metadata_file"
}

log_install() { echo -e "${GREEN}[INSTALL]${NC} $1"; }
log_skip() { echo -e "${BLUE}[SKIP]${NC} $1"; }
log_conflict() { echo -e "${YELLOW}[CONFLICT]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_info() { echo -e "$1"; }

INTERACTIVE_SKIP_ALL=false
INTERACTIVE_OVERWRITE_ALL=false

prompt_conflict() {
    local src="$1"
    local dest="$2"

    if [[ "$INTERACTIVE_SKIP_ALL" == "true" ]]; then
        echo "skip"
        return
    fi
    if [[ "$INTERACTIVE_OVERWRITE_ALL" == "true" ]]; then
        echo "overwrite"
        return
    fi

    echo ""
    echo -e "${YELLOW}CONFLICT:${NC} $dest differs from upstream"
    if command -v diff >/dev/null 2>&1; then
        echo "--- $dest (yours)"
        echo "+++ upstream"
        diff -u "$dest" "$src" 2>/dev/null | head -20 || true
        echo ""
    fi
    echo -n "[k]eep / [o]verwrite / [n]ew file / [s]kip all / [O]verwrite all? "
    read -r response

    case "$response" in
        k|K) echo "keep" ;;
        o) echo "overwrite" ;;
        n|N) echo "new" ;;
        s|S) INTERACTIVE_SKIP_ALL=true; echo "skip" ;;
        O) INTERACTIVE_OVERWRITE_ALL=true; echo "overwrite" ;;
        *) echo "new" ;;
    esac
}

files_identical() {
    local file1="$1"
    local file2="$2"
    if command -v md5sum >/dev/null 2>&1; then
        [[ "$(md5sum "$file1" | cut -d' ' -f1)" == "$(md5sum "$file2" | cut -d' ' -f1)" ]]
    elif command -v md5 >/dev/null 2>&1; then
        [[ "$(md5 -q "$file1")" == "$(md5 -q "$file2")" ]]
    else
        diff -q "$file1" "$file2" >/dev/null 2>&1
    fi
}

atomic_copy() {
    local src="$1"
    local dest="$2"
    local tmp="${dest}.tmp.$$"
    cp -p "$src" "$tmp"
    mv -f "$tmp" "$dest"
}

install_file() {
    local src="$1"
    local dest="$2"
    local dest_dir
    dest_dir="$(dirname "$dest")"

    if [[ ! -e "$dest" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_install "$dest"
        else
            mkdir -p "$dest_dir"
            atomic_copy "$src" "$dest"
            log_install "$dest"
        fi
        installed_count=$((installed_count + 1))
        return 0
    fi

    if files_identical "$src" "$dest"; then
        log_skip "$dest (identical)"
        skipped_count=$((skipped_count + 1))
        return 0
    fi

    if [[ "$FORCE" == "true" ]]; then
        backup_file "$dest"
        if [[ "$DRY_RUN" == "true" ]]; then
            log_install "$dest (force overwrite)"
        else
            atomic_copy "$src" "$dest"
            log_install "$dest (force overwrite)"
        fi
        installed_count=$((installed_count + 1))
        return 0
    fi

    # Interactive mode
    if [[ "$INTERACTIVE" == "true" ]] && [[ "$DRY_RUN" != "true" ]]; then
        local action
        action="$(prompt_conflict "$src" "$dest")"
        case "$action" in
            keep|skip)
                log_skip "$dest (kept yours)"
                skipped_count=$((skipped_count + 1))
                return 0
                ;;
            overwrite)
                backup_file "$dest"
                atomic_copy "$src" "$dest"
                log_install "$dest (overwritten)"
                installed_count=$((installed_count + 1))
                return 0
                ;;
        esac
    fi

    # Diff-only mode: show unified diff, no file creation
    if [[ "$DIFF_ONLY" == "true" ]]; then
        log_conflict "$dest"
        diff -u "$dest" "$src" 2>/dev/null || true
        echo ""
        conflict_count=$((conflict_count + 1))
        return 0
    fi

    local conflict_file
    if [[ "$dest" == *.md ]]; then
        conflict_file="${dest%.md}.dot-agents.md"
    else
        conflict_file="${dest}.dot-agents.new"
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log_conflict "$dest (would write ${conflict_file})"
    else
        cp -p "$src" "$conflict_file"
        log_conflict "$dest differs. Wrote ${conflict_file} for review."
    fi
    conflict_count=$((conflict_count + 1))
    return 0
}

process_directory() {
    local src_dir="$1"
    local dest_dir="$2"

    while IFS= read -r -d '' file; do
        local rel_path="${file#$src_dir/}"
        local dest_path="${dest_dir}/${rel_path}"

        # Skip *.md files in user content directories (research, plans, prds)
        if [[ "$rel_path" == research/*.md || "$rel_path" == plans/*.md || "$rel_path" == plans/**/*.md || "$rel_path" == prds/*.md ]]; then
            continue
        fi

        # Skip metadata file in diff mode (it's auto-generated and will always differ)
        if [[ "$DIFF_ONLY" == "true" ]] && [[ "$rel_path" == ".dot-agents.json" ]]; then
            continue
        fi

        if [[ -f "$file" ]]; then
            install_file "$file" "$dest_path"
        fi
    done < <(find "$src_dir" -type f -print0 2>/dev/null || true)
}

cleanup() {
    if [[ -n "${TMP_DIR:-}" ]] && [[ -d "$TMP_DIR" ]]; then
        rm -rf "$TMP_DIR"
    fi
}

main() {
    local archive_url="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/${REF}.tar.gz"
    TMP_DIR="$(mktemp -d)"
    trap cleanup EXIT

    log_info "Installing dot-agents (ref: ${REF})..."
    log_info ""

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "${YELLOW}DRY RUN - no changes will be made${NC}"
        log_info ""
    fi

    if ! curl -fsSL "$archive_url" | tar -xz -C "$TMP_DIR" 2>/dev/null; then
        log_error "Failed to download from $archive_url"
        exit 1
    fi

    local extracted_dir
    extracted_dir="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -1)"

    if [[ ! -d "$extracted_dir" ]]; then
        log_error "Failed to extract archive"
        exit 1
    fi

    # Install AGENTS.md from template (fresh install only)
    local template_src=""
    if [[ -f "${extracted_dir}/AGENTS.template.md" ]]; then
        template_src="${extracted_dir}/AGENTS.template.md"
    elif [[ -f "${extracted_dir}/AGENTS.md" ]]; then
        # Fallback for older versions
        template_src="${extracted_dir}/AGENTS.md"
    fi

    if [[ -n "$template_src" ]]; then
        if [[ -e "./AGENTS.md" ]]; then
            log_skip "AGENTS.md (user content, skipped on sync)"
            skipped_count=$((skipped_count + 1))
        else
            install_file "$template_src" "./AGENTS.md"
        fi
    fi

    if [[ -d "${extracted_dir}/.agents" ]]; then
        process_directory "${extracted_dir}/.agents" "./.agents"
    fi

    # Skip metadata write in diff-only mode
    if [[ "$DIFF_ONLY" != "true" ]]; then
        write_metadata
    fi

    log_info ""
    log_info "Summary:"
    log_info "  Installed: ${installed_count}"
    log_info "  Skipped:   ${skipped_count}"
    log_info "  Conflicts: ${conflict_count}"

    if [[ $backup_count -gt 0 ]]; then
        log_info "  Backed up: ${backup_count}"
        log_info ""
        log_info "Backup location: ${BACKUP_DIR}/"
    fi

    if [[ $conflict_count -gt 0 ]]; then
        log_info ""
        if [[ "$DIFF_ONLY" == "true" ]]; then
            log_info "Use --force to overwrite conflicts, or resolve manually."
        else
            log_info "Review conflicts with: find . -name '*.dot-agents.new' -o -name '*.dot-agents.md'"
        fi
    fi

    # In diff mode, exit 1 if conflicts exist
    if [[ "$DIFF_ONLY" == "true" ]] && [[ $conflict_count -gt 0 ]]; then
        return 1
    fi
}

_main() {
    parse_args "$@"

    if [[ "$SHOW_HELP" == "true" ]]; then
        usage
        exit 0
    fi

    if [[ "$SHOW_VERSION" == "true" ]]; then
        do_version
        exit 0
    fi

    if [[ "$UNINSTALL" == "true" ]]; then
        if [[ "$YES" != "true" ]]; then
            echo -n "Remove dot-agents from this project? [y/N] "
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                echo "Aborted."
                exit 0
            fi
        fi
        do_uninstall
        exit 0
    fi

    main
}

# Only run if script is executed, not sourced
# Empty BASH_SOURCE means stdin (piped), must still run. Only skip when sourced.
if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == "$0" ]]; then
    _main "$@"
fi
