#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  list-work.sh [--status <status>] [--stale-days <days>]

Lists work items in .agents/work/ with their status, category (from the path),
and last commit date. Notes flag items that need attention:
  close?      Status: completed, so the item awaits removal
  uncommitted the item has uncommitted or untracked changes
  stale       no commit touched the item for --stale-days days (default 30)
Older items may say `planned`; it is listed as in-progress.
USAGE
}

status_filter=""
stale_days=30

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      shift
      ;;
    --status)
      status_filter="${2:-}"
      shift 2
      ;;
    --stale-days)
      stale_days="${2:-}"
      if [[ ! "$stale_days" =~ ^[0-9]+$ ]]; then
        echo "Invalid --stale-days: $stale_days" >&2
        exit 2
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d .agents/work ]]; then
  exit 0
fi

in_git=false
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  in_git=true
fi
now=$(date +%s)

printf '%-12s %-14s %-11s %-18s %s\n' "Status" "Category" "Changed" "Notes" "Work Item"
printf '%-12s %-14s %-11s %-18s %s\n' "------------" "--------------" "-----------" "------------------" "---------"

find .agents/work -mindepth 3 -maxdepth 3 -name index.md -type f | sort | while IFS= read -r index_file; do
  work_dir=$(dirname "$index_file")
  category=$(basename "$(dirname "$work_dir")")
  title=$(sed -n '1s/^# //p' "$index_file")
  status=$(awk '/^## /{exit} /^Status: /{sub(/^Status: /, ""); print; exit}' "$index_file")

  [[ -n "$status" ]] || status="unknown"
  [[ "$status" == "planned" ]] && status="in-progress"
  [[ -n "$title" ]] || title="$(basename "$work_dir")"

  if [[ -n "$status_filter" && "$status" != "$status_filter" ]]; then
    continue
  fi

  changed="-"
  notes=()
  [[ "$status" == "completed" ]] && notes+=("close?")

  if [[ "$in_git" == "true" ]]; then
    last=$(git log -1 --format=%ct -- "$work_dir" 2>/dev/null || true)
    if [[ -n "$last" ]]; then
      changed=$(git log -1 --format=%cs -- "$work_dir")
      if (( (now - last) / 86400 >= stale_days )) && [[ "$status" != "completed" ]]; then
        notes+=("stale")
      fi
    fi
    if [[ -n "$(git status --porcelain -- "$work_dir" 2>/dev/null)" ]]; then
      notes+=("uncommitted")
    fi
  fi

  note_text="-"
  if [[ ${#notes[@]} -gt 0 ]]; then
    note_text=$(IFS=,; printf '%s' "${notes[*]}")
  fi

  printf '%-12s %-14s %-11s %-18s %s (%s)\n' "$status" "$category" "$changed" "$note_text" "$title" "$index_file"
done
