#!/usr/bin/env bash
set -euo pipefail

# Run all tests (lint + BATS)
# Usage: ./scripts/test.sh [bats-args...]
#
# Examples:
#   ./scripts/test.sh                    # Run all tests
#   ./scripts/test.sh --filter "help"    # Run tests matching "help"
#   ./scripts/test.sh -t                 # Show timing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

# Run linting first
echo "==> Linting"
"$SCRIPT_DIR/lint.sh"
echo ""

# Run BATS tests
echo "==> BATS tests"
if command -v bats &> /dev/null; then
    if [[ -d "test" ]]; then
        bats "$@" test/
    else
        echo "    ⚠ No test/ directory yet (run plan tasks 5-9)"
    fi
else
    echo "    ⚠ BATS not installed (brew install bats-core)"
    exit 1
fi
