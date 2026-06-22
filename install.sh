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
WRITE_CONFLICTS=false
IS_FRESH_INSTALL=true

usage() {
    cat <<EOF
Usage: install.sh [OPTIONS]

Install dot-agents into the current project.

Options:
  --dry-run         Show what would happen without making changes
  --diff            Preview pending changes without writing; exit 1 if pending
  --force           Overwrite conflicts (creates backup first, default on sync)
  --write-conflicts Create file.dot-agents.md/file.ext.dot-agents.new conflicts
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
  curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v0.3.0

  # Preview changes first
  curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --diff

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
            --write-conflicts)
                WRITE_CONFLICTS=true
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

    remove_claude_code_skill_symlinks
    removed=$((removed + CLAUDE_SKILL_SYMLINKS_REMOVED))

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
pending_change_count=0
backup_count=0
BACKUP_DIR=""
CLAUDE_SKILL_SYMLINKS_REMOVED=0
AGENTS_GITIGNORE_PENDING=false

is_agents_gitignore_path() {
    local path="${1#./}"
    [[ "$path" == ".agents/.gitignore" ]]
}

mark_agents_gitignore_pending() {
    if is_agents_gitignore_path "$1"; then
        AGENTS_GITIGNORE_PENDING=true
    fi
}

is_dot_agents_claude_skill_symlink() {
    local path="$1"
    local link_target

    [[ -L "$path" ]] || return 1
    link_target="$(readlink "$path" 2>/dev/null || true)"
    [[ "$link_target" == ../../.agents/skills/* ]]
}

remove_claude_code_skill_symlinks() {
    local claude_skills_dir=".claude/skills"
    local skill_link

    CLAUDE_SKILL_SYMLINKS_REMOVED=0

    [[ -e "$claude_skills_dir" || -L "$claude_skills_dir" ]] || return 0
    if [[ -L "$claude_skills_dir" ]]; then
        log_info "${YELLOW}[SKIP]${NC} $claude_skills_dir (user-owned symlink)"
        return 0
    fi
    [[ -d "$claude_skills_dir" ]] || return 0

    for skill_link in "$claude_skills_dir"/*; do
        [[ -L "$skill_link" ]] || continue
        is_dot_agents_claude_skill_symlink "$skill_link" || continue

        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "${RED}[REMOVE]${NC} $skill_link"
        else
            rm -f "$skill_link"
            log_info "${RED}[REMOVE]${NC} $skill_link"
        fi
        CLAUDE_SKILL_SYMLINKS_REMOVED=$((CLAUDE_SKILL_SYMLINKS_REMOVED + 1))
    done

    if [[ "$DRY_RUN" != "true" ]]; then
        rmdir "$claude_skills_dir" 2>/dev/null || true
    fi
}

create_backup_dir() {
    if [[ -z "$BACKUP_DIR" ]]; then
        local timestamp
        timestamp="$(date -u +%Y-%m-%dT%H%M%SZ)"
        BACKUP_DIR=".agents/.dot-agents-backup/${timestamp}"
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
        if [[ -L "$file" ]]; then
            cp -Pp "$file" "$backup_path"
        else
            cp -p "$file" "$backup_path"
        fi
        log_info "  ${BLUE}[BACKUP]${NC} $file"
    fi
    backup_count=$((backup_count + 1))
}

backup_item() {
    local path="$1"
    create_backup_dir
    local backup_path="${BACKUP_DIR}/${path}"
    local backup_dir
    backup_dir="$(dirname "$backup_path")"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "  ${BLUE}[BACKUP]${NC} $path → $backup_path"
    else
        mkdir -p "$backup_dir"
        if [[ -d "$path" && ! -L "$path" ]]; then
            cp -Rp "$path" "$backup_path"
        elif [[ -L "$path" ]]; then
            cp -Pp "$path" "$backup_path"
        else
            cp -p "$path" "$backup_path"
        fi
        log_info "  ${BLUE}[BACKUP]${NC} $path"
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
PROMPT_ACTION=""

prompt_conflict() {
    local src="$1"
    local dest="$2"
    local response=""

    if [[ "$INTERACTIVE_SKIP_ALL" == "true" ]]; then
        PROMPT_ACTION="skip"
        return
    fi
    if [[ "$INTERACTIVE_OVERWRITE_ALL" == "true" ]]; then
        PROMPT_ACTION="overwrite"
        return
    fi

    echo "" >&2
    echo -e "${YELLOW}CONFLICT:${NC} $dest differs from upstream" >&2
    if command -v diff >/dev/null 2>&1; then
        echo "--- $dest (yours)" >&2
        echo "+++ upstream" >&2
        diff -u "$dest" "$src" 2>/dev/null | head -20 >&2 || true
        echo "" >&2
    fi

    echo -n "[k]eep / [o]verwrite / [n]ew file / [s]kip all / [O]verwrite all? " >&2
    if [[ -n "${DOT_AGENTS_INTERACTIVE_RESPONSE:-}" ]]; then
        response="$DOT_AGENTS_INTERACTIVE_RESPONSE"
        DOT_AGENTS_INTERACTIVE_RESPONSE=""
    elif [[ -r /dev/tty ]]; then
        read -r response < /dev/tty || response=""
    else
        echo "" >&2
        log_info "  ${YELLOW}[SKIP]${NC} no terminal available; writing conflict file for manual review"
        PROMPT_ACTION="new"
        return
    fi

    case "$response" in
        k|K) PROMPT_ACTION="keep" ;;
        o) PROMPT_ACTION="overwrite" ;;
        n|N) PROMPT_ACTION="new" ;;
        s|S) INTERACTIVE_SKIP_ALL=true; PROMPT_ACTION="skip" ;;
        O) INTERACTIVE_OVERWRITE_ALL=true; PROMPT_ACTION="overwrite" ;;
        *) PROMPT_ACTION="new" ;;
    esac
}

files_identical() {
    local file1="$1"
    local file2="$2"

    [[ -f "$file1" && -f "$file2" ]] || return 1

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

format_version_string() {
    local ref="$1"
    local extracted_dir="${2:-}"

    # For tags (vX.Y.Z format), show as version
    if [[ "$ref" =~ ^v[0-9]+\.[0-9]+ ]]; then
        echo "dot-agents ${ref}"
        return
    fi

    # For branches/commits, try to get short SHA from directory name
    local short_sha=""
    if [[ -n "$extracted_dir" ]]; then
        local dir_name
        dir_name="$(basename "$extracted_dir")"
        # Directory format: repo-name-REF (e.g., dot-agents-main or dot-agents-abc123f)
        short_sha="${dir_name##*-}"
        # Only use if it looks like a SHA (7+ hex chars)
        if [[ ! "$short_sha" =~ ^[0-9a-f]{7,}$ ]]; then
            short_sha=""
        fi
    fi

    if [[ -n "$short_sha" ]]; then
        echo "dot-agents (${ref} @ ${short_sha:0:7})"
    else
        echo "dot-agents (ref: ${ref})"
    fi
}

# Core skills that come from upstream
CORE_SKILLS="adapt agent-work feature-planning research tmux"
RETIRED_CORE_SKILLS="ralph"
RETIRED_LEGACY_GUIDANCE_FILES=".agents/plans/AGENTS.md .agents/prds/AGENTS.md .agents/plans/TEMPLATE.md .agents/prds/TEMPLATE.md"

is_retired_core_skill() {
    local skill_name="$1"
    local retired

    for retired in $RETIRED_CORE_SKILLS; do
        if [[ "$skill_name" == "$retired" ]]; then
            return 0
        fi
    done

    return 1
}

detect_custom_skills() {
    local skills_dir=".agents/skills"
    local custom_skills=()

    if [[ ! -d "$skills_dir" ]]; then
        return
    fi

    for skill_dir in "$skills_dir"/*/; do
        [[ -d "$skill_dir" ]] || continue
        local skill_name
        skill_name="$(basename "$skill_dir")"

        # Skip if it's a core skill
        local is_core=false
        for core in $CORE_SKILLS $RETIRED_CORE_SKILLS; do
            if [[ "$skill_name" == "$core" ]]; then
                is_core=true
                break
            fi
        done

        if [[ "$is_core" == "false" ]]; then
            custom_skills+=("$skill_name")
        fi
    done

    if [[ ${#custom_skills[@]} -gt 0 ]]; then
        printf '%s\n' "${custom_skills[@]}"
    fi
}

report_custom_skills() {
    local custom_skills
    custom_skills="$(detect_custom_skills)"

    if [[ -n "$custom_skills" ]]; then
        log_info ""
        log_info "${BLUE}Custom skills preserved:${NC}"
        while IFS= read -r skill; do
            log_info "  - $skill"
        done <<< "$custom_skills"
    fi
}

cleanup_retired_core_skills() {
    local retired skill_dir

    [[ -d ".agents/skills" ]] || return 0

    for retired in $RETIRED_CORE_SKILLS; do
        skill_dir=".agents/skills/$retired"
        [[ -e "$skill_dir" || -L "$skill_dir" ]] || continue

        if [[ "$DIFF_ONLY" == "true" ]]; then
            log_info "  ${RED}[REMOVE]${NC} $skill_dir (retired core skill, preview only)"
            pending_change_count=$((pending_change_count + 1))
            continue
        fi

        backup_item "$skill_dir"
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "  ${RED}[REMOVE]${NC} $skill_dir (retired core skill)"
        else
            rm -rf "$skill_dir"
            log_info "  ${RED}[REMOVE]${NC} $skill_dir (retired core skill)"
        fi
    done
}

cleanup_retired_legacy_guidance() {
    local path

    for path in $RETIRED_LEGACY_GUIDANCE_FILES; do
        [[ -e "$path" || -L "$path" ]] || continue

        if [[ "$DIFF_ONLY" == "true" ]]; then
            log_info "  ${RED}[REMOVE]${NC} $path (retired legacy guidance, preview only)"
            pending_change_count=$((pending_change_count + 1))
            continue
        fi

        backup_item "$path"
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "  ${RED}[REMOVE]${NC} $path (retired legacy guidance)"
        else
            rm -rf "$path"
            log_info "  ${RED}[REMOVE]${NC} $path (retired legacy guidance)"
        fi
    done
}

cleanup_stale_claude_code_skill_symlinks() {
    local agents_skills_dir="$1"
    local claude_skills_dir="$2"
    local skill_link skill_name

    [[ ! -L "$claude_skills_dir" ]] || return 0
    [[ -d "$claude_skills_dir" ]] || return 0

    for skill_link in "$claude_skills_dir"/*; do
        [[ -L "$skill_link" ]] || continue
        is_dot_agents_claude_skill_symlink "$skill_link" || continue

        skill_name="$(basename "$skill_link")"
        if [[ -f "$agents_skills_dir/$skill_name/SKILL.md" ]] && ! is_retired_core_skill "$skill_name"; then
            continue
        fi

        if [[ "$DRY_RUN" == "true" || "$DIFF_ONLY" == "true" ]]; then
            log_info "  ${RED}[REMOVE]${NC} $skill_link (stale)"
            if [[ "$DIFF_ONLY" == "true" ]]; then
                pending_change_count=$((pending_change_count + 1))
            fi
        else
            rm -f "$skill_link"
            log_info "  ${RED}[REMOVE]${NC} $skill_link (stale)"
        fi
    done
}

setup_claude_code_integration() {
    local source_agents_skills_dir="${1:-.agents/skills}"
    local agents_skills_dir=".agents/skills"
    local claude_skills_dir=".claude/skills"
    local linked=0
    local skipped=0
    local skill_dir skill_name dest link_target existing_target

    [[ -d ".claude" ]] || return 0
    if [[ "$DRY_RUN" == "true" || "$DIFF_ONLY" == "true" ]]; then
        agents_skills_dir="$source_agents_skills_dir"
    fi
    [[ -d "$agents_skills_dir" ]] || return 0

    log_info ""
    log_info "Detected ${BLUE}.claude/${NC} directory — linking dot-agents skills for Claude Code..."

    if [[ -L "$claude_skills_dir" ]]; then
        log_info "  ${YELLOW}[SKIP]${NC} $claude_skills_dir (user-owned symlink)"
        return 0
    fi

    if [[ ( -e "$claude_skills_dir" || -L "$claude_skills_dir" ) && ! -d "$claude_skills_dir" ]]; then
        log_info "  ${YELLOW}[SKIP]${NC} $claude_skills_dir (user-owned)"
        return 0
    fi

    if [[ "$DRY_RUN" != "true" && "$DIFF_ONLY" != "true" ]]; then
        if ! mkdir -p "$claude_skills_dir"; then
            log_info "  ${YELLOW}[SKIP]${NC} $claude_skills_dir (could not create directory)"
            return 0
        fi
    fi

    for skill_dir in "$agents_skills_dir"/*/; do
        [[ -d "$skill_dir" ]] || continue
        [[ -f "$skill_dir/SKILL.md" ]] || continue

        skill_name="$(basename "$skill_dir")"
        if is_retired_core_skill "$skill_name"; then
            continue
        fi

        dest="$claude_skills_dir/$skill_name"
        link_target="../../.agents/skills/$skill_name"

        if [[ -L "$dest" ]]; then
            existing_target="$(readlink "$dest" 2>/dev/null || true)"
            if [[ "$existing_target" == "$link_target" ]]; then
                continue
            fi
            if is_dot_agents_claude_skill_symlink "$dest"; then
                if [[ "$DRY_RUN" == "true" || "$DIFF_ONLY" == "true" ]]; then
                    log_info "  ${GREEN}[LINK]${NC} $dest → $link_target (preview only)"
                    linked=$((linked + 1))
                    if [[ "$DIFF_ONLY" == "true" ]]; then
                        pending_change_count=$((pending_change_count + 1))
                    fi
                    continue
                fi
                rm -f "$dest"
            else
                log_info "  ${YELLOW}[SKIP]${NC} $dest (user-owned symlink)"
                skipped=$((skipped + 1))
                continue
            fi
        elif [[ -e "$dest" ]]; then
            log_info "  ${YELLOW}[SKIP]${NC} $dest (user-owned)"
            skipped=$((skipped + 1))
            continue
        fi

        if [[ "$DRY_RUN" == "true" || "$DIFF_ONLY" == "true" ]]; then
            log_info "  ${GREEN}[LINK]${NC} $dest → $link_target (preview only)"
            linked=$((linked + 1))
            if [[ "$DIFF_ONLY" == "true" ]]; then
                pending_change_count=$((pending_change_count + 1))
            fi
            continue
        fi

        if ln -s "$link_target" "$dest"; then
            log_info "  ${GREEN}[LINK]${NC} $dest"
            linked=$((linked + 1))
        else
            log_info "  ${YELLOW}[SKIP]${NC} $dest (could not create symlink)"
            skipped=$((skipped + 1))
        fi
    done

    cleanup_stale_claude_code_skill_symlinks "$agents_skills_dir" "$claude_skills_dir"

    if [[ $linked -gt 0 || $skipped -gt 0 ]]; then
        log_info "  Claude Code skills linked: $linked, skipped: $skipped"
    fi
}

ensure_gitignore_entry() {
    local gitignore_file=".agents/.gitignore"
    local backup_entry=".dot-agents-backup/"

    if [[ "$AGENTS_GITIGNORE_PENDING" == "true" ]]; then
        return 0
    fi

    if [[ "$DRY_RUN" == "true" || "$DIFF_ONLY" == "true" ]]; then
        if [[ ! -f "$gitignore_file" ]]; then
            log_info "  ${GREEN}[CREATE]${NC} $gitignore_file"
            if [[ "$DIFF_ONLY" == "true" ]]; then
                pending_change_count=$((pending_change_count + 1))
            fi
        elif ! grep -qxF "$backup_entry" "$gitignore_file" 2>/dev/null; then
            log_info "  ${GREEN}[UPDATE]${NC} $gitignore_file (add backup entry)"
            if [[ "$DIFF_ONLY" == "true" ]]; then
                pending_change_count=$((pending_change_count + 1))
            fi
        fi
        return 0
    fi

    mkdir -p ".agents"

    if [[ ! -f "$gitignore_file" ]]; then
        echo "$backup_entry" > "$gitignore_file"
        log_info "  ${GREEN}[CREATE]${NC} $gitignore_file"
    elif ! grep -qxF "$backup_entry" "$gitignore_file" 2>/dev/null; then
        echo "$backup_entry" >> "$gitignore_file"
        log_info "  ${GREEN}[UPDATE]${NC} $gitignore_file (add backup entry)"
    fi
}

install_file() {
    local src="$1"
    local dest="$2"
    local dest_dir
    dest_dir="$(dirname "$dest")"

    if [[ ! -e "$dest" && ! -L "$dest" ]]; then
        if [[ "$DIFF_ONLY" == "true" ]]; then
            log_install "$dest (would install)"
            installed_count=$((installed_count + 1))
            pending_change_count=$((pending_change_count + 1))
            mark_agents_gitignore_pending "$dest"
            return 0
        fi

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
        prompt_conflict "$src" "$dest"
        action="$PROMPT_ACTION"
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
        pending_change_count=$((pending_change_count + 1))
        mark_agents_gitignore_pending "$dest"
        return 0
    fi

    local conflict_file
    if [[ "$dest" == *.md ]]; then
        conflict_file="${dest%.md}.dot-agents.md"
    else
        conflict_file="${dest}.dot-agents.new"
    fi
    mark_agents_gitignore_pending "$dest"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_conflict "$dest (would write ${conflict_file})"
    elif [[ -e "$conflict_file" || -L "$conflict_file" ]]; then
        log_conflict "$dest differs. Kept existing ${conflict_file}; remove it to regenerate."
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

        # Skip user content directories. Fresh installs get guidance files, not sample work.
        if [[ "$rel_path" == research/*.md || "$rel_path" == research/**/*.md || "$rel_path" == work/*/*/* || "$rel_path" == plans/* || "$rel_path" == prds/* ]]; then
            continue
        fi

        # Metadata is generated locally by write_metadata.
        if [[ "$rel_path" == ".dot-agents.json" ]]; then
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

    # Detect fresh install vs sync
    if [[ -d ".agents" ]]; then
        IS_FRESH_INSTALL=false
        # Auto-enable force mode on sync unless diff or write-conflicts is set
        if [[ "$DIFF_ONLY" != "true" ]] && [[ "$WRITE_CONFLICTS" != "true" ]] && [[ "$INTERACTIVE" != "true" ]]; then
            FORCE=true
        fi
    fi

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

    local version_string
    version_string="$(format_version_string "$REF" "$extracted_dir")"
    log_info "Installing ${version_string}..."
    log_info ""

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

    if [[ "$IS_FRESH_INSTALL" != "true" ]]; then
        cleanup_retired_core_skills
        cleanup_retired_legacy_guidance
    fi

    # Ensure .agents/.gitignore includes backup directory
    ensure_gitignore_entry

    # Link dot-agents skills into Claude Code's project skill directory when present.
    setup_claude_code_integration "${extracted_dir}/.agents/skills"

    # Skip metadata write in diff-only mode
    if [[ "$DIFF_ONLY" != "true" ]]; then
        write_metadata
    fi

    log_info ""
    log_info "Summary:"
    log_info "  Installed: ${installed_count}"
    log_info "  Skipped:   ${skipped_count}"
    log_info "  Conflicts: ${conflict_count}"
    if [[ "$DIFF_ONLY" == "true" ]]; then
        log_info "  Pending changes: ${pending_change_count}"
    fi

    if [[ $backup_count -gt 0 ]]; then
        log_info "  Backed up: ${backup_count}"
        log_info ""
        log_info "Backup location: ${BACKUP_DIR}/"
    fi

    # Report custom skills that were preserved (on sync only)
    if [[ "$IS_FRESH_INSTALL" != "true" ]]; then
        report_custom_skills
    fi

    if [[ $conflict_count -gt 0 ]]; then
        log_info ""
        if [[ "$DIFF_ONLY" == "true" ]]; then
            log_info "Use --force to overwrite conflicts, or resolve manually."
        else
            log_info "Review conflicts with: find . -name '*.dot-agents.new' -o -name '*.dot-agents.md'"
        fi
    fi

    # In diff mode, exit 1 if any change would be applied.
    if [[ "$DIFF_ONLY" == "true" ]] && [[ $pending_change_count -gt 0 ]]; then
        return 1
    fi

    # Show post-install guidance for fresh installs
    if [[ "$IS_FRESH_INSTALL" == "true" ]] && [[ "$DRY_RUN" != "true" ]]; then
        log_info ""
        log_info "${GREEN}Next steps:${NC}"
        log_info "  1. Run 'adapt' to customize AGENTS.md for your project"
        log_info "  2. Read the quickstart: https://github.com/${REPO_OWNER}/${REPO_NAME}/blob/main/QUICKSTART.md"
    fi

    # Show sync update hint on sync (not fresh install)
    if [[ "$IS_FRESH_INSTALL" != "true" ]] && [[ "$DRY_RUN" != "true" ]]; then
        log_info ""
        log_info "To update again: curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/install.sh | bash"
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
