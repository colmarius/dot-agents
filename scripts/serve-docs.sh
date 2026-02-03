#!/usr/bin/env bash
#
# Serve site or docs locally for preview
# Usage: ./scripts/serve-docs.sh [port] [--docs]
#
# Examples:
#   ./scripts/serve-docs.sh          # Serve site on port 8000
#   ./scripts/serve-docs.sh 3000     # Serve site on port 3000
#   ./scripts/serve-docs.sh --docs   # Serve docs on port 8000
#

set -e

PORT="8000"
DIR="site"

for arg in "$@"; do
  case "$arg" in
    --docs)
      DIR="docs"
      ;;
    [0-9]*)
      PORT="$arg"
      ;;
  esac
done

SERVE_DIR="$(dirname "$0")/../$DIR"

echo "Serving $DIR at http://localhost:${PORT}"
echo "Press Ctrl+C to stop"
echo

python3 -m http.server "$PORT" -d "$SERVE_DIR" -b localhost 2>/dev/null
