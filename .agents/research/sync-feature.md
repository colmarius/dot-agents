# Research: Sync Feature for dot-agents

**Date:** 2026-02-03
**Status:** Draft

## Problem

Projects with dot-agents installed need an easy way to check for and pull updates from the source repository. Currently users must remember and re-run the full curl install command.

## Current State

- `install.sh` handles installs and updates (re-running works)
- `.agents/.dot-agents.json` stores: `upstream`, `ref`, `installedAt`
- Conflict resolution exists: identical files skipped, changed files create `.dot-agents.new`

## Decision: Local Sync Script

**Chosen approach:** Local wrapper script for best UX.

| Component | Purpose |
|-----------|---------|
| `.agents/scripts/sync.sh` | Local wrapper script (primary UX) |
| `install.sh` | Underlying install/update logic (unchanged) |

### Why This Approach

| Alternative | Pros | Cons | Decision |
|-------------|------|------|----------|
| Local wrapper script | Discoverable, simple UX, self-updating | Adds a file | ✅ Chosen |
| `--sync` flag on install.sh | No new files | Users must remember curl command | ❌ Rejected |
| Separate sync.sh at root | Visible | Clutters project root | ❌ Rejected |

## Implementation Plan

### Phase 1: Local Sync Script (MVP)

1. **Create `.agents/scripts/sync.sh`**
   - Thin wrapper that fetches and runs upstream install.sh
   - Reads `.dot-agents.json` for upstream URL and ref
   - Passes through all user flags (`--dry-run`, `--force`, etc.)
   - Self-updating: always fetches latest install.sh from upstream

2. **Create `.agents/scripts/` directory structure**
   - Add to install.sh file processing
   - Ensure script is executable

3. **Update metadata tracking in install.sh**
   - Keep `installedAt` as first install time
   - Add `lastSyncedAt` on subsequent runs

4. **Update README documentation**

### Edge Cases to Handle

| Case | Handling |
|------|----------|
| Missing `.dot-agents.json` | Error: "dot-agents not installed" |
| Non-GitHub upstream | Error: "Only github.com upstreams supported" |
| Malformed JSON | Error with helpful message |
| Custom ref override | Support `--ref` flag passthrough |

### Scope Exclusions (v1)

- ❌ `--check` mode (detect updates without syncing)
- ❌ File pruning (removing files deleted upstream)
- ❌ `sync` skill (agent-triggered updates)
- ❌ Component-level sync (`--only skills`)
- ❌ Non-GitHub upstreams

## User Experience

### Before (current)

```bash
# User must remember/find the install command
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

### After (with sync script)

```bash
# Simple - run local script
.agents/scripts/sync.sh

# With options
.agents/scripts/sync.sh --dry-run
.agents/scripts/sync.sh --force
.agents/scripts/sync.sh --ref v2.0.0
```

## Technical Notes

### sync.sh Implementation

```bash
#!/usr/bin/env bash
set -euo pipefail

METADATA=".agents/.dot-agents.json"

if [[ ! -f "$METADATA" ]]; then
    echo "Error: dot-agents not installed (.dot-agents.json missing)" >&2
    exit 1
fi

upstream=$(sed -nE 's/.*"upstream"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$METADATA")
ref=$(sed -nE 's/.*"ref"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$METADATA")

if [[ ! "$upstream" =~ ^https://github\.com/([^/]+)/([^/]+)/?$ ]]; then
    echo "Error: Only github.com upstreams supported" >&2
    exit 1
fi

owner="${BASH_REMATCH[1]}"
repo="${BASH_REMATCH[2]%.git}"

curl -fsSL "https://raw.githubusercontent.com/${owner}/${repo}/${ref:-main}/install.sh" \
    | bash -s -- "$@"
```

### Key Design Points

| Aspect | Design |
|--------|--------|
| Self-updating | Fetches latest install.sh from upstream on each run |
| Passthrough | All flags go to install.sh (`--dry-run`, `--force`, `--ref`) |
| No duplication | Reuses all install.sh logic (conflicts, backups, etc.) |
| Portable | Pure bash, no dependencies beyond curl |

### Metadata Parsing (no jq)

```bash
# Extract ref
sed -nE 's/.*"ref"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .agents/.dot-agents.json

# Extract upstream
sed -nE 's/.*"upstream"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .agents/.dot-agents.json
```

### GitHub URL Parsing

```bash
# From: https://github.com/colmarius/dot-agents
# Extract: owner=colmarius, repo=dot-agents
if [[ "$upstream" =~ ^https://github\.com/([^/]+)/([^/]+)/?$ ]]; then
    owner="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]%.git}"
fi
```

## Effort Estimate

**Small (1-2 hours)**

- Create sync.sh script: 15 min
- Update install.sh to include scripts/: 15 min
- Add lastSyncedAt tracking: 15 min
- Testing (fresh, sync, conflicts): 45 min
- Documentation: 30 min

## Future Considerations

If demand emerges:

- `--check` mode for update detection without download
- Component-level sync (`--only skills`)
- GitLab/Gitea support
- Agent skill for trusted environments

## References

- Oracle consultation (2026-02-03)
- Current install.sh implementation
