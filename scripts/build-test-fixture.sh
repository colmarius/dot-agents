#!/usr/bin/env bash
set -euo pipefail

# Build the test fixture archive from current repo state
# Run this after modifying .agents/ or AGENTS.template.md

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
FIXTURES_DIR="$REPO_ROOT/test/fixtures"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Building test fixture..."

# Create archive structure (mimics GitHub archive format)
ARCHIVE_DIR="$TMP_DIR/dot-agents-main"
mkdir -p "$ARCHIVE_DIR"

# Copy AGENTS.template.md
if [[ -f "$REPO_ROOT/AGENTS.template.md" ]]; then
    cp "$REPO_ROOT/AGENTS.template.md" "$ARCHIVE_DIR/"
    echo "  Added: AGENTS.template.md"
fi

# Copy .agents directory
if [[ -d "$REPO_ROOT/.agents" ]]; then
    cp -r "$REPO_ROOT/.agents" "$ARCHIVE_DIR/"
    echo "  Added: .agents/"
fi

# Add sample files for testing user content preservation and skip rules
mkdir -p "$ARCHIVE_DIR/.agents/research"
mkdir -p "$ARCHIVE_DIR/.agents/plans/todo"
mkdir -p "$ARCHIVE_DIR/.agents/prds"
mkdir -p "$ARCHIVE_DIR/.agents/work/feature/example-work"

echo "# Example research" > "$ARCHIVE_DIR/.agents/research/example.md"
echo "# Example plan" > "$ARCHIVE_DIR/.agents/plans/todo/plan-001.md"
echo "# Example PRD" > "$ARCHIVE_DIR/.agents/prds/feature.md"
echo "# Example work item" > "$ARCHIVE_DIR/.agents/work/feature/example-work/index.md"
cat > "$ARCHIVE_DIR/.agents/.dot-agents.json" <<'EOF'
{
  "upstream": "https://github.com/example/bogus-dot-agents",
  "ref": "bogus-archive-metadata",
  "installedAt": "2000-01-01T00:00:00Z"
}
EOF
echo "  Added: sample user content files for testing"

# Create the archive
tar -czf "$FIXTURES_DIR/sample-archive.tar.gz" -C "$TMP_DIR" dot-agents-main

echo ""
echo "Created: test/fixtures/sample-archive.tar.gz"
echo ""
echo "Contents:"
tar -tzf "$FIXTURES_DIR/sample-archive.tar.gz"
