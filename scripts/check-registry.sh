#!/usr/bin/env bash
# check-registry.sh — Verify REGISTRY.json is up-to-date with SKILL.md files
#
# Intended for CI or pre-commit hooks. Exits non-zero if the registry
# would change after regeneration (i.e., it's stale).
#
# Usage:
#   ./scripts/check-registry.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REGISTRY_FILE="$REPO_ROOT/.agents/skills/REGISTRY.json"
GENERATE_SCRIPT="$REPO_ROOT/.agents/scripts/generate-registry.sh"

if [[ ! -f "$GENERATE_SCRIPT" ]]; then
    echo "ERROR: generate-registry.sh not found at $GENERATE_SCRIPT" >&2
    exit 1
fi

if [[ ! -f "$REGISTRY_FILE" ]]; then
    echo "ERROR: REGISTRY.json not found at $REGISTRY_FILE" >&2
    echo "Run: .agents/scripts/generate-registry.sh" >&2
    exit 1
fi

# Helper to strip the "generated" timestamp for comparison
strip_timestamp() {
    sed '/"generated":/d'
}

# Save current registry
current=$(cat "$REGISTRY_FILE")

# Regenerate (this overwrites the file)
bash "$GENERATE_SCRIPT" >/dev/null

# Compare (ignoring the generated timestamp which changes each run)
regenerated=$(cat "$REGISTRY_FILE")

current_stripped=$(echo "$current" | strip_timestamp)
regenerated_stripped=$(echo "$regenerated" | strip_timestamp)

if [[ "$current_stripped" != "$regenerated_stripped" ]]; then
    echo "REGISTRY.json is out of date. Run:" >&2
    echo "  .agents/scripts/generate-registry.sh" >&2
    # Restore the original so git diff shows clearly
    echo "$current" > "$REGISTRY_FILE"
    exit 1
fi

# Restore original (preserve committed timestamp)
echo "$current" > "$REGISTRY_FILE"

echo "REGISTRY.json is up to date."
