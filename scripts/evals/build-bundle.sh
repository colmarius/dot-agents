#!/usr/bin/env bash
# Usage: build-bundle.sh <output.tar.gz> [<git-ref>]
# Run from the dot-agents repository root. Packs the guidance from the working
# tree, or from <git-ref> when given, with the eval project, seeds, and scripts.
set -euo pipefail

out="$(realpath -m "$1")"
ref="${2:-}"
evals="$(cd "$(dirname "$0")" && pwd)"
repo="$(git rev-parse --show-toplevel)"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

bundle="$stage/evals"
mkdir -p "$bundle/guidance"
cp -R "$evals/project" "$evals/seeds" "$evals/setup-scenario.sh" "$evals/scenarios.md" "$bundle/"

paths=(AGENTS.template.md .agents/.gitignore .agents/research/.gitkeep .agents/skills .agents/work/AGENTS.md)
if [[ -n "$ref" ]]; then
  git -C "$repo" archive "$ref" "${paths[@]}" | tar -x -C "$bundle/guidance"
else
  (cd "$repo" && tar -c "${paths[@]}") | tar -x -C "$bundle/guidance"
fi

python3 -I "$evals/fill_agents.py" "$bundle/guidance/AGENTS.template.md" > "$bundle/guidance/AGENTS.md"
rm "$bundle/guidance/AGENTS.template.md"

tar -czf "$out" -C "$stage" evals
echo "$out"
