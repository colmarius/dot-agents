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

# Add sample files for testing user content preservation
mkdir -p "$ARCHIVE_DIR/.agents/research"
mkdir -p "$ARCHIVE_DIR/.agents/plans/todo"
mkdir -p "$ARCHIVE_DIR/.agents/prds"

echo "# Example research" > "$ARCHIVE_DIR/.agents/research/example.md"
echo "# Example plan" > "$ARCHIVE_DIR/.agents/plans/todo/plan-001.md"
echo "# Example PRD" > "$ARCHIVE_DIR/.agents/prds/feature.md"
echo "  Added: sample user content files for testing"

# Add a sample skill for testing
mkdir -p "$ARCHIVE_DIR/.agents/skills/sample-skill"
cat > "$ARCHIVE_DIR/.agents/skills/sample-skill/SKILL.md" << 'EOF'
---
name: sample-skill
description: A sample skill for testing
---

# Sample Skill

This is a sample skill used for testing the installation process.
EOF
echo "  Added: sample-skill for testing"

# Create the archive
tar -czf "$FIXTURES_DIR/sample-archive.tar.gz" -C "$TMP_DIR" dot-agents-main

echo ""
echo "Created: test/fixtures/sample-archive.tar.gz"
echo ""
echo "Contents:"
tar -tzf "$FIXTURES_DIR/sample-archive.tar.gz"
