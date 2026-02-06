#!/usr/bin/env bash
set -euo pipefail

# Lint shell scripts with ShellCheck and syntax validation
# Usage: ./scripts/lint.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

# Collect all shell scripts
SCRIPTS=(
    install.sh
    .agents/scripts/sync.sh
    .agents/scripts/sync-local.sh
    .agents/scripts/setup-claude-integration.sh
    .agents/scripts/generate-registry.sh
    scripts/check-registry.sh
    scripts/lint.sh
    scripts/test.sh
    test/mocks/curl
)

# Collect all bats test files
BATS_FILES=()
while IFS= read -r -d '' file; do
    BATS_FILES+=("$file")
done < <(find test/integration -name '*.bats' -print0 2>/dev/null)

echo "==> Syntax check (bash -n)"
for script in "${SCRIPTS[@]}"; do
    bash -n "$script"
done
echo "    ✓ Syntax OK"

echo ""
echo "==> ShellCheck"
if command -v shellcheck &> /dev/null; then
    shellcheck --severity=warning "${SCRIPTS[@]}"
    # Lint bats files with shell=bats directive
    if [[ ${#BATS_FILES[@]} -gt 0 ]]; then
        shellcheck --severity=warning --shell=bash "${BATS_FILES[@]}"
    fi
    echo "    ✓ ShellCheck passed"
else
    echo "    ⚠ ShellCheck not installed (brew install shellcheck)"
    exit 1
fi
