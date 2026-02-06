#!/usr/bin/env bash
# generate-registry.sh — Generate REGISTRY.json from SKILL.md frontmatter
#
# Creates a machine-readable index of all skills for programmatic discovery.
# Works with any agent system (Claude Code, ampcode, Cursor, etc.).
#
# Usage:
#   .agents/scripts/generate-registry.sh
#
# The script scans .agents/skills/*/SKILL.md, extracts frontmatter fields,
# and writes .agents/skills/REGISTRY.json.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$(cd "$SCRIPT_DIR/../skills" && pwd)"
REGISTRY_FILE="$SKILLS_DIR/REGISTRY.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Extract a frontmatter field from a SKILL.md file.
# Handles quoted and unquoted values. Returns empty string if not found.
get_field() {
  local file="$1" field="$2"
  local value
  value=$(sed -n '/^---$/,/^---$/p' "$file" \
    | grep "^${field}:" \
    | sed "s/^${field}:[[:space:]]*//" \
    | sed 's/^"//;s/"$//')
  echo "$value"
}

# Convert a comma-separated string to a JSON array.
# "a, b, c" → ["a", "b", "c"]
# Empty input → []
to_json_array() {
  local input="$1"
  if [ -z "$input" ]; then
    echo "[]"
    return
  fi
  local result="["
  local first=true
  while IFS= read -r -d ',' item || [ -n "$item" ]; do
    # Trim whitespace
    item="$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    if [ -z "$item" ]; then
      continue
    fi
    if [ "$first" = false ]; then
      result="$result, "
    fi
    result="$result\"$(json_escape "$item")\""
    first=false
  done <<< "$input"
  result="$result]"
  echo "$result"
}

# Escape a string for safe JSON embedding
json_escape() {
  local input="$1"
  input="${input//\\/\\\\}"   # backslash first
  input="${input//\"/\\\"}"   # double quote
  input="${input//$'\n'/\\n}" # newline
  input="${input//$'\t'/\\t}" # tab
  input="${input//$'\r'/\\r}" # carriage return
  echo "$input"
}

# --- Main ---

skill_count=0
json_skills=""

for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$skill_md" ] || continue

  skill_dir=$(dirname "$skill_md")
  skill_id=$(basename "$skill_dir")

  name=$(get_field "$skill_md" "name")
  description=$(get_field "$skill_md" "description")

  if [ -z "$name" ] || [ -z "$description" ]; then
    echo "Warning: Skipping $skill_md — missing name or description" >&2
    continue
  fi

  triggers_raw=$(get_field "$skill_md" "triggers")
  keywords_raw=$(get_field "$skill_md" "keywords")
  invocation=$(get_field "$skill_md" "invocation")

  triggers_json=$(to_json_array "$triggers_raw")
  keywords_json=$(to_json_array "$keywords_raw")

  # Use skill name as fallback invocation
  if [ -z "$invocation" ]; then
    invocation="$name"
  fi

  # Relative path from project root
  rel_path=".agents/skills/$skill_id/SKILL.md"

  # Add comma separator between entries
  if [ -n "$json_skills" ]; then
    json_skills="$json_skills,"
  fi

  json_skills="$json_skills
    {
      \"id\": \"$skill_id\",
      \"name\": \"$(json_escape "$name")\",
      \"description\": \"$(json_escape "$description")\",
      \"triggers\": $triggers_json,
      \"keywords\": $keywords_json,
      \"path\": \"$rel_path\",
      \"invocation\": \"$(json_escape "$invocation")\"
    }"

  skill_count=$((skill_count + 1))
done

# Write registry file
cat > "$REGISTRY_FILE" <<EOF
{
  "version": "1.0",
  "generated": "$TIMESTAMP",
  "description": "Machine-readable skill registry for programmatic discovery. Auto-generated from SKILL.md frontmatter by generate-registry.sh.",
  "skills": [$json_skills
  ]
}
EOF

# Validate the generated JSON
if command -v python3 >/dev/null 2>&1; then
  if ! python3 -m json.tool "$REGISTRY_FILE" >/dev/null 2>&1; then
    echo "ERROR: Generated $REGISTRY_FILE is not valid JSON" >&2
    exit 1
  fi
elif command -v jq >/dev/null 2>&1; then
  if ! jq . "$REGISTRY_FILE" >/dev/null 2>&1; then
    echo "ERROR: Generated $REGISTRY_FILE is not valid JSON" >&2
    exit 1
  fi
fi

echo "Generated $REGISTRY_FILE ($skill_count skills)"
