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

usage() {
    cat <<EOF
Usage: install.sh [OPTIONS]

Install dot-agents into the current project.

Options:
  --dry-run         Show what would happen without making changes
  --force           Overwrite conflicts (creates backup first)
  --ref <ref>       Git ref to install (branch, tag, commit). Default: main
  --yes             Skip confirmation prompts
  --uninstall       Remove dot-agents
  --interactive     Prompt for each conflict
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
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
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
        ((removed++))
    fi
    
    # Remove .agents/
    if [[ -d ".agents" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "${RED}[REMOVE]${NC} .agents/"
        else
            rm -rf ".agents"
            log_info "${RED}[REMOVE]${NC} .agents/"
        fi
        ((removed++))
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
    ((backup_count++))
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
            cp -p "$src" "$dest"
            log_install "$dest"
        fi
        ((installed_count++))
        return 0
    fi

    if files_identical "$src" "$dest"; then
        log_skip "$dest (identical)"
        ((skipped_count++))
        return 0
    fi

    if [[ "$FORCE" == "true" ]]; then
        backup_file "$dest"
        if [[ "$DRY_RUN" == "true" ]]; then
            log_install "$dest (force overwrite)"
        else
            cp -p "$src" "$dest"
            log_install "$dest (force overwrite)"
        fi
        ((installed_count++))
        return 0
    fi

    # Interactive mode
    if [[ "$INTERACTIVE" == "true" ]] && [[ "$DRY_RUN" != "true" ]]; then
        local action
        action="$(prompt_conflict "$src" "$dest")"
        case "$action" in
            keep|skip)
                log_skip "$dest (kept yours)"
                ((skipped_count++))
                return 0
                ;;
            overwrite)
                backup_file "$dest"
                cp -p "$src" "$dest"
                log_install "$dest (overwritten)"
                ((installed_count++))
                return 0
                ;;
        esac
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
    ((conflict_count++))
    return 0
}

process_directory() {
    local src_dir="$1"
    local dest_dir="$2"
    local prefix="${3:-}"

    while IFS= read -r -d '' file; do
        local rel_path="${file#$src_dir/}"
        local dest_path="${dest_dir}/${rel_path}"
        
        # Skip .md files in plans/ directories (user's plan files)
        if [[ "$rel_path" == plans/*.md || "$rel_path" == plans/**/*.md ]]; then
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

    if [[ -f "${extracted_dir}/AGENTS.md" ]]; then
        install_file "${extracted_dir}/AGENTS.md" "./AGENTS.md"
    fi

    if [[ -d "${extracted_dir}/.agents" ]]; then
        process_directory "${extracted_dir}/.agents" "./.agents"
    fi

    write_metadata

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
        log_info "Review conflicts with: find . -name '*.dot-agents.new' -o -name '*.dot-agents.md'"
    fi
}

parse_args "$@"

if [[ "$SHOW_HELP" == "true" ]]; then
    usage
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
