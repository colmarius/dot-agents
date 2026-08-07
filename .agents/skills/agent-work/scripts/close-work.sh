#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  close-work.sh --category <category> --slug <work-slug> [--check]

Validates a committed final work-item snapshot, then stages its deletion. Use --check to
validate without changing the index or worktree. Run from the repository root and commit
the staged deletion separately.
EOF
}

fail() {
  printf '%s\n' "$1" >&2
  exit "${2:-1}"
}

argument_error() {
  printf '%s\n' "$1" >&2
  usage >&2
  exit 2
}

require_value() {
  local option="$1"
  local value="${2:-}"

  if [[ -z "$value" || "$value" == --* ]]; then
    argument_error "Missing value for $option"
  fi
}

validate_path_component() {
  local label="$1"
  local value="$2"

  if [[ ! "$value" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    printf 'Invalid %s: %s\n' "$label" "$value" >&2
    fail "Use lowercase kebab-case." 2
  fi
}

validate_snapshot() {
  local label="$1"
  local content="$2"
  local status_count
  local completed_count
  local next_action_count
  local action_line_count
  local none_line_count

  read -r status_count completed_count next_action_count action_line_count none_line_count < <(
    printf '%s\n' "$content" | awk '
      /^Status: / {
        status_count += 1
        if ($0 == "Status: completed") completed_count += 1
      }
      $0 == "## Next Action" {
        next_action_count += 1
        in_next_action = 1
        next
      }
      in_next_action && /^## / { in_next_action = 0 }
      in_next_action && /[^[:space:]]/ {
        action_line_count += 1
        if ($0 == "- None.") none_line_count += 1
      }
      END {
        print status_count + 0, completed_count + 0, next_action_count + 0,
          action_line_count + 0, none_line_count + 0
      }
    '
  )

  if [[ "$status_count" -ne 1 || "$completed_count" -ne 1 ]]; then
    fail "$label must contain exactly one 'Status: completed' line: $index_file"
  fi

  if [[ "$next_action_count" -ne 1 || "$action_line_count" -ne 1 || "$none_line_count" -ne 1 ]]; then
    fail "$label must contain exactly '- None.' under '## Next Action': $index_file"
  fi
}

category=""
slug=""
check_only=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --category)
      require_value "$1" "${2:-}"
      category="$2"
      shift 2
      ;;
    --slug)
      require_value "$1" "${2:-}"
      slug="$2"
      shift 2
      ;;
    --check)
      check_only=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      argument_error "Unknown argument: $1"
      ;;
  esac
done

if [[ -z "$category" || -z "$slug" ]]; then
  argument_error "Both --category and --slug are required."
fi

validate_path_component "category" "$category"
validate_path_component "slug" "$slug"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || \
  fail "close-work.sh must run inside a git repository."
repo_root="$(cd "$repo_root" && pwd -P)"
current_dir="$(pwd -P)"

if [[ "$current_dir" != "$repo_root" ]]; then
  fail "close-work.sh must run from the repository root."
fi

work_dir=".agents/work/$category/$slug"
index_file="$work_dir/index.md"

if [[ ! -f "$index_file" ]]; then
  fail "Work item index not found: $index_file"
fi

validate_snapshot "Work item" "$(cat "$index_file")"

if [[ -n "$(git status --porcelain=v1 --untracked-files=all)" ]]; then
  fail "Repository has uncommitted changes. Commit them before closing the work item."
fi

if [[ -n "$(git ls-files --others --ignored --exclude-standard -- "$work_dir")" ]]; then
  fail "Work item contains ignored files. Preserve or remove them before closeout: $work_dir"
fi

if ! git cat-file -e "HEAD:$index_file" 2>/dev/null; then
  fail "Final work-item snapshot is not committed: $index_file"
fi

validate_snapshot "Committed work item" "$(git show "HEAD:$index_file")"

if [[ "$check_only" -eq 1 ]]; then
  printf 'Ready to close: %s\n' "$work_dir"
  exit 0
fi

git rm -r -q -- "$work_dir"

printf 'Staged work-item removal: %s\n' "$work_dir"
printf '%s\n' "Commit this deletion separately."
