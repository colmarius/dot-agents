# Plan 001: Bootstrap Installer for dot-agents

## Overview

Create a single-command installer that bootstraps `.agents/` and `AGENTS.md` into existing projects, with optional post-copy adaptation to project patterns.

## Goals

1. One-liner installation via `curl | bash`
2. Safe defaults (never overwrite without `--force`)
3. Update mechanism for pulling new versions
4. Optional project adaptation via overlay or skill

---

## Conflict Handling Strategy

**Default behavior: Safe merge (never lose user work)**

| Scenario | Action |
|----------|--------|
| Target file doesn't exist | Copy it |
| Target exists, identical content | Skip |
| Target exists, different content | Keep user's file, write ours as `*.dot-agents.new` |

**Flags modify behavior:**

- `--dry-run`: Show what would happen without making changes
- `--force`: Overwrite conflicts (creates backup first)
- `--interactive`: Prompt for each conflict

**Backup location:** `.dot-agents-backup/<timestamp>/`

---

## Tasks

- [ ] **Task 1: Create install.sh core script with safe merge**
  - Scope: `install.sh`
  - Depends on: none
  - Acceptance:
    - Script downloads tarball from GitHub (not full git clone)
    - Implements safe merge: copy missing files, skip identical, stage conflicts as `.dot-agents.new`
    - Works with bash + curl + tar only (no jq, rsync, python)
    - Prints clear summary of: installed, skipped, conflicts
  - Notes: Use GitHub archive URL pattern: `https://github.com/OWNER/REPO/archive/REF.tar.gz`

- [ ] **Task 2: Add CLI flags to install.sh**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - `--dry-run` shows what would happen without changes
    - `--force` overwrites conflicts (with backup)
    - `--ref <tag|branch>` specifies version (default: `main`)
    - `--help` shows usage
    - `--yes` skips confirmation prompts
  - Notes: Keep arg parsing simple (no getopt dependency)

- [ ] **Task 3: Add backup mechanism**
  - Scope: `install.sh`
  - Depends on: Task 2
  - Acceptance:
    - When `--force` is used, creates timestamped backup directory
    - Backup path: `.dot-agents-backup/YYYY-MM-DDTHHMMSSZ/`
    - Backs up all files that will be overwritten
    - Prints backup location to user
  - Notes: Only create backup dir if actually overwriting files

- [ ] **Task 4: Add metadata tracking**
  - Scope: `install.sh`, `.agents/.dot-agents.json`
  - Depends on: Task 1
  - Acceptance:
    - After install, writes `.agents/.dot-agents.json` with:

      ```json
      {
        "upstream": "https://github.com/colmarius/dot-agents",
        "ref": "main",
        "installedAt": "2025-01-31T12:00:00Z"
      }
      ```

    - File is created/updated on each install
  - Notes: Use `date -u +%Y-%m-%dT%H:%M:%SZ` for timestamp

- [ ] **Task 5: Create PROJECT.md template**
  - Scope: `.agents/PROJECT.md.template`
  - Depends on: none
  - Acceptance:
    - Template file with placeholders for project-specific info
    - Sections for: project name, tech stack, common commands, conventions
    - Installer copies this as `.agents/PROJECT.md` if it doesn't exist
  - Notes: Keep template minimal, users fill in details

- [ ] **Task 6: Add stack detection (optional enhancement)**
  - Scope: `install.sh`
  - Depends on: Task 5
  - Acceptance:
    - Detects `package.json` → suggests npm/pnpm/yarn commands
    - Detects `Cargo.toml` → suggests cargo commands
    - Detects `go.mod` → suggests go commands
    - Detects `pyproject.toml` / `requirements.txt` → suggests python commands
    - Pre-fills PROJECT.md with detected commands as comments
  - Notes: Keep detection simple (file existence only)

- [ ] **Task 7: Update README.md with installation instructions**
  - Scope: `README.md`
  - Depends on: Task 2
  - Acceptance:
    - Documents one-liner install command
    - Documents all CLI flags
    - Explains update workflow
    - Explains PROJECT.md customization
  - Notes: Keep README concise

- [ ] **Task 8: Add uninstall command**
  - Scope: `install.sh` or separate `uninstall.sh`
  - Depends on: Task 3
  - Acceptance:
    - `--uninstall` flag or separate script
    - Removes `.agents/` and `AGENTS.md`
    - Prompts for confirmation unless `--yes`
  - Notes: Consider keeping PROJECT.md on uninstall (user data)

- [ ] **Task 9: Add --interactive mode (optional enhancement)**
  - Scope: `install.sh`
  - Depends on: Task 1
  - Acceptance:
    - `--interactive` flag prompts for each conflict
    - Options: keep / overwrite / write .new / skip all / overwrite all
    - Shows diff preview if `diff` command available
  - Notes: Nice UX but not required for MVP

- [ ] **Task 10: Create "adapt" skill (future enhancement)** (manual-verify)
  - Scope: `.agents/skills/adapt/`
  - Depends on: Task 5, Task 6
  - Acceptance:
    - Skill that a coding agent can run post-install
    - Analyzes project structure and fills PROJECT.md
    - Optionally customizes AGENTS.md with project-specific sections
  - Notes: This is optional and can be deferred

---

## File Structure After Implementation

```text
dot-agents/
├── install.sh                      # Main installer script
├── README.md                       # Updated with install docs
├── AGENTS.md                       # Template (copied to projects)
├── .agents/
│   ├── PROJECT.md.template         # Template for project customization
│   ├── .dot-agents.json            # (created in target projects)
│   ├── plans/
│   ├── research/
│   └── skills/
│       ├── ralph/
│       ├── research/
│       ├── tmux/
│       └── adapt/                  # Future: adaptation skill
```

---

## Usage Examples

### Basic Installation

```bash
# Install into current project (safe merge by default)
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash

# Install specific version/tag
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v1.0.0

# Install from a specific branch
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref feature/new-skills
```

### Preview Before Installing

```bash
# Dry run - see what would happen without making changes
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --dry-run

# Example output:
# [INSTALL] .agents/skills/ralph/SKILL.md
# [INSTALL] .agents/skills/research/SKILL.md
# [SKIP]    AGENTS.md (identical)
# [CONFLICT] .agents/skills/tmux/SKILL.md (would write .dot-agents.new)
```

### Handling Conflicts

```bash
# Default behavior: conflicts are staged as .dot-agents.new files
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
# Output: CONFLICT: AGENTS.md differs. Wrote AGENTS.dot-agents.md for review.

# Force overwrite all conflicts (creates backup first)
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --force
# Output: Backed up to .dot-agents-backup/2026-01-31T120000Z/

# Interactive mode - choose for each conflict
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --interactive
# Prompts: AGENTS.md differs. [k]eep / [o]verwrite / [n]ew file / [s]kip all / [O]verwrite all?
```

### Updating Existing Installation

```bash
# Update to latest (safe merge - won't overwrite your changes)
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash

# Update to specific version with force (backup + overwrite)
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v2.0.0 --force

# Check what changed before updating
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v2.0.0 --dry-run
```

### Uninstall

```bash
# Remove dot-agents (prompts for confirmation)
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --uninstall

# Remove without confirmation
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --uninstall --yes
```

### Local Script Usage

```bash
# If you've cloned the repo, run directly
./install.sh

# With options
./install.sh --dry-run
./install.sh --force --ref v1.0.0
./install.sh --help
```

### Post-Install: Review Conflicts

```bash
# After install, review any .dot-agents.new files
find . -name "*.dot-agents.new" -o -name "*.dot-agents.md"

# Compare and merge manually
diff AGENTS.md AGENTS.dot-agents.md

# After merging, clean up
rm AGENTS.dot-agents.md
rm -f .agents/**/*.dot-agents.new
```

---

## Success Criteria

1. User can bootstrap dot-agents into any project with one command
2. Existing files are protected by default
3. Updates are possible without losing project customizations
4. Clear documentation for all options
