#!/usr/bin/env bash
set -euo pipefail

# Lint shell scripts with ShellCheck and syntax validation
# Usage: ./scripts/lint.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

echo "==> Syntax check (bash -n)"
bash -n install.sh
bash -n .agents/scripts/sync.sh
echo "    ✓ Syntax OK"

echo ""
echo "==> ShellCheck"
if command -v shellcheck &> /dev/null; then
    shellcheck --severity=warning install.sh .agents/scripts/sync.sh
    echo "    ✓ ShellCheck passed"
else
    echo "    ⚠ ShellCheck not installed (brew install shellcheck)"
    exit 1
fi
