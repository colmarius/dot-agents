#!/usr/bin/env bash
# Usage: setup-scenario.sh <s1..s9> <dest-dir>
# Creates a fresh git repository with the notes-api project, the bundled
# guidance in ./guidance, and the scenario's seed state.
set -euo pipefail

scenario="$1"
dest="$2"
here="$(cd "$(dirname "$0")" && pwd)"

[[ -d "$here/guidance" ]] || { echo "missing $here/guidance; run build-bundle.sh" >&2; exit 2; }
[[ ! -e "$dest" ]] || { echo "destination exists: $dest" >&2; exit 2; }

mkdir -p "$dest"
cp -R "$here/project/." "$dest/"
cp -R "$here/guidance/." "$dest/"

cd "$dest"
git init -q -b main
git config user.name "Eval Owner"
git config user.email "owner@example.com"
git add -A
git commit -q -m "Initial notes-api with dot-agents guidance"

seed_item() {
  local name="$1" slug="$2"
  mkdir -p ".agents/work/feature/$slug"
  cp "$here/seeds/$name/"*.md ".agents/work/feature/$slug/"
}

case "$scenario" in
  s3|s5|s7)
    cp "$here/seeds/pagination/src/store.js" src/store.js
    seed_item pagination notes-pagination
    git add -A
    git commit -q -m "Add store pagination and pagination work item"
    if [[ "$scenario" == "s7" ]]; then
      cp "$here/seeds/pagination-task2/src/app.js" src/app.js
      cp "$here/seeds/pagination-task2/test/app.test.js" test/app.test.js
      git add -A
      git commit -q -m "Parse limit and offset in GET /notes"
    fi
    ;;
  s4)
    seed_item note-tags note-tags
    git add -A
    git commit -q -m "Add note tags work item"
    ;;
  s8)
    cp "$here/seeds/patch-wip/src/store.js" src/store.js
    ;;
  s9)
    seed_item user-accounts user-accounts
    git add -A
    git commit -q -m "Add user accounts research and proposal work item"
    ;;
  s1|s2|s6) ;;
  *) echo "unknown scenario: $scenario" >&2; exit 2 ;;
esac

git log --oneline
