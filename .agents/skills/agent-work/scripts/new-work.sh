#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  new-work.sh --category <category> --slug <work-slug> --title <title> [--status <status>]

Creates .agents/work/<category>/<work-slug>/index.md from the work index template.
Default status: researching
Categories: feature, bugfix, tech-debt, docs, tooling, research, other
USAGE
}

category=""
slug=""
title=""
status="researching"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --category)
      category="${2:-}"
      shift 2
      ;;
    --slug)
      slug="${2:-}"
      shift 2
      ;;
    --title)
      title="${2:-}"
      shift 2
      ;;
    --status)
      status="${2:-}"
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

if [[ -z "$category" || -z "$slug" || -z "$title" ]]; then
  usage >&2
  exit 2
fi

case "$status" in
  researching|planned|in-progress|blocked|completed) ;;
  *)
    echo "Invalid status: $status" >&2
    echo "Expected one of: researching, planned, in-progress, blocked, completed" >&2
    exit 2
    ;;
esac

is_kebab_case() {
  [[ "$1" =~ ^[abcdefghijklmnopqrstuvwxyz0123456789]+(-[abcdefghijklmnopqrstuvwxyz0123456789]+)*$ ]]
}

if ! is_kebab_case "$category"; then
  echo "Invalid category: $category" >&2
  echo "Expected one of: feature, bugfix, tech-debt, docs, tooling, research, other" >&2
  exit 2
fi

case "$category" in
  feature|bugfix|tech-debt|docs|tooling|research|other) ;;
  *)
    echo "Invalid category: $category" >&2
    echo "Expected one of: feature, bugfix, tech-debt, docs, tooling, research, other" >&2
    exit 2
    ;;
esac

if ! is_kebab_case "$slug"; then
  echo "Invalid slug: $slug" >&2
  echo "Use lowercase kebab-case." >&2
  exit 2
fi

work_dir=".agents/work/$category/$slug"
index_file="$work_dir/index.md"
template=".agents/skills/agent-work/assets/work-index-template.md"

if [[ -e "$index_file" ]]; then
  echo "Work item index already exists: $index_file" >&2
  exit 1
fi

if [[ ! -f "$template" ]]; then
  echo "Missing template: $template" >&2
  exit 1
fi

mkdir -p "$work_dir"

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'
}

escaped_title=$(escape_sed_replacement "$title")
escaped_category=$(escape_sed_replacement "$category")
escaped_status=$(escape_sed_replacement "$status")
updated=$(date +%F)

sed \
  -e "s|{{TITLE}}|$escaped_title|g" \
  -e "s|{{STATUS}}|$escaped_status|g" \
  -e "s|{{CATEGORY}}|$escaped_category|g" \
  -e "s|{{UPDATED}}|$updated|g" \
  "$template" > "$index_file"

echo "$index_file"
