#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  list-work.sh [--all] [--status <status>]

Lists all work items currently in .agents/work/. Completed entries are final snapshots awaiting removal.
The --all option remains available for compatibility and has no additional effect.
USAGE
}

status_filter=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      shift
      ;;
    --status)
      status_filter="${2:-}"
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

printf '%-12s %-14s %-12s %s\n' "Status" "Category" "Updated" "Work Item"
printf '%-12s %-14s %-12s %s\n' "------------" "--------------" "------------" "---------"

find .agents/work -mindepth 3 -maxdepth 3 -name index.md -type f | sort | while IFS= read -r index_file; do
  title=$(sed -n '1s/^# //p' "$index_file")
  status=$(sed -n 's/^Status: //p' "$index_file" | head -1)
  category=$(sed -n 's/^Category: //p' "$index_file" | head -1)
  updated=$(sed -n 's/^Updated: //p' "$index_file" | head -1)

  [[ -n "$status" ]] || status="unknown"
  [[ -n "$category" ]] || category="unknown"
  [[ -n "$updated" ]] || updated="unknown"
  [[ -n "$title" ]] || title="$(basename "$(dirname "$index_file")")"

  if [[ -n "$status_filter" && "$status" != "$status_filter" ]]; then
    continue
  fi

  printf '%-12s %-14s %-12s %s (%s)\n' "$status" "$category" "$updated" "$title" "$index_file"
done
