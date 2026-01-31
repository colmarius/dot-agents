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

installed_count=0
skipped_count=0
conflict_count=0

log_install() { echo -e "${GREEN}[INSTALL]${NC} $1"; }
log_skip() { echo -e "${BLUE}[SKIP]${NC} $1"; }
log_conflict() { echo -e "${YELLOW}[CONFLICT]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_info() { echo -e "$1"; }

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
            cp "$src" "$dest"
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
        if [[ "$DRY_RUN" == "true" ]]; then
            log_install "$dest (force overwrite)"
        else
            cp "$src" "$dest"
            log_install "$dest (force overwrite)"
        fi
        ((installed_count++))
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
        cp "$src" "$conflict_file"
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

    log_info ""
    log_info "Summary:"
    log_info "  Installed: ${installed_count}"
    log_info "  Skipped:   ${skipped_count}"
    log_info "  Conflicts: ${conflict_count}"

    if [[ $conflict_count -gt 0 ]]; then
        log_info ""
        log_info "Review conflicts with: find . -name '*.dot-agents.new' -o -name '*.dot-agents.md'"
    fi
}

main "$@"
