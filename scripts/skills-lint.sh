#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="${1:-$ROOT_DIR/.agents/skills}"

if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "Skills directory not found: $SKILLS_DIR" >&2
    exit 2
fi

errors=0
files=0

report_error() {
    local file="$1"
    local rule="$2"
    local details="$3"
    printf 'ERROR %s [%s] %s\n' "$file" "$rule" "$details" >&2
    errors=$((errors + 1))
}

while IFS= read -r -d '' file; do
    files=$((files + 1))
    skill_dir="$(dirname "$file")"
    expected_name="$(basename "$skill_dir")"
    display_file="${file#"$ROOT_DIR/"}"

    if ! frontmatter=$(awk '
        NR == 1 {
            if ($0 != "---") exit 2
            in_frontmatter = 1
            next
        }
        in_frontmatter && $0 == "---" {
            found_end = 1
            exit
        }
        in_frontmatter { print }
        END { if (!found_end) exit 3 }
    ' "$file"); then
        report_error "$display_file" "frontmatter" "missing or unterminated YAML frontmatter"
        continue
    fi

    name_value=$(printf '%s\n' "$frontmatter" | awk '/^name:[[:space:]]*/ { sub(/^name:[[:space:]]*/, ""); print; exit }')
    description_line=$(printf '%s\n' "$frontmatter" | awk '/^description:[[:space:]]*/ { print; exit }')

    if [[ -z "$name_value" ]]; then
        report_error "$display_file" "name" "missing name"
    else
        if ! [[ "$name_value" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
            report_error "$display_file" "name" "name must be lowercase kebab-case"
        fi
        if [[ "$name_value" != "$expected_name" ]]; then
            report_error "$display_file" "name" "name '$name_value' must match folder '$expected_name'"
        fi
    fi

    if [[ -z "$description_line" ]]; then
        report_error "$display_file" "description" "missing description"
    elif ! [[ "$description_line" =~ ^description:[[:space:]]*\".*\"[[:space:]]*$ ]]; then
        report_error "$display_file" "description" "description must be double quoted on one line"
    else
        description_value=$(printf '%s' "$description_line" | sed -E 's/^description:[[:space:]]*"(.*)"[[:space:]]*$/\1/')
        if (( ${#description_value} > 250 )); then
            report_error "$display_file" "description" "description exceeds 250 characters"
        fi
        if [[ "$description_value" != *"Triggers on:"* ]]; then
            report_error "$display_file" "description" "description must include 'Triggers on:'"
        fi
    fi

    if grep -n 'file://' "$file" >/dev/null; then
        report_error "$display_file" "links" "file:// links are not portable"
    fi

    while IFS= read -r target; do
        target="${target#](}"
        target="${target%)}"
        target="${target%%#*}"

        case "$target" in
            ''|http://*|https://*|mailto:*|mdc:*|\#*)
                continue
                ;;
        esac

        if [[ ! -e "$skill_dir/$target" ]]; then
            report_error "$display_file" "links" "missing relative target '$target'"
        fi
    done < <(grep -Eo '\]\([^)]*\)' "$file" || true)
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -type f -print0 | sort -z)

if (( files == 0 )); then
    echo "No SKILL.md files found under $SKILLS_DIR" >&2
    exit 2
fi

if (( errors > 0 )); then
    printf 'Skill lint failed: %d error(s) across %d file(s)\n' "$errors" "$files" >&2
    exit 1
fi

printf 'Skill lint passed: %d file(s)\n' "$files"
