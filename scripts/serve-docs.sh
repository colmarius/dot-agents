#!/usr/bin/env bash
#
# Serve docs locally for preview
# Usage: ./scripts/serve-docs.sh [port]
#

set -e

PORT="${1:-8000}"
DOCS_DIR="$(dirname "$0")/../docs"

echo "Serving docs at http://localhost:${PORT}"
echo "Press Ctrl+C to stop"
echo

python3 -m http.server "$PORT" -d "$DOCS_DIR" -b localhost
