# Research: Sync Feature for dot-agents

**Date:** 2026-02-03
**Status:** Draft

## Problem

Projects with dot-agents installed need an easy way to check for and pull updates from the source repository. Currently users must remember and re-run the full curl install command.

## Current State

- `install.sh` handles installs and updates (re-running works)
- `.agents/.dot-agents.json` stores: `upstream`, `ref`, `installedAt`
- Conflict resolution exists: identical files skipped, changed files create `.dot-agents.new`

## Decision: Add `--sync` to install.sh

**Chosen approach:** Option A - single flag addition to existing script.

| Alternative | Pros | Cons | Decision |
|-------------|------|------|----------|
| `--sync` flag | Simple, DRY, reuses all existing logic | Couples sync to install | ✅ Chosen |
| Separate sync.sh | Cleaner separation | Code duplication, drift | ❌ Rejected |

## Implementation Plan

### Phase 1: Core Sync (MVP)

1. **Add `--sync` flag to parse_args**
   - New variable `SYNC=false`
   - Update usage() with sync docs

2. **Read metadata in sync mode**
   - Path: `.agents/.dot-agents.json`
   - Parse with `sed`/`grep` (no jq dependency)
   - Error clearly if not installed

3. **Extract upstream URL → derive archive URL**
   - Support only `https://github.com/<owner>/<repo>` format
   - Error on unsupported upstream (GitLab, etc.)

4. **Update metadata tracking**
   - Keep `installedAt` as first install time
   - Add `lastSyncedAt` on sync operations

5. **Update README documentation**

### Edge Cases to Handle

| Case | Handling |
|------|----------|
| Missing `.dot-agents.json` | Error: "dot-agents not installed; run install first" |
| Non-GitHub upstream | Error: "Unsupported upstream; only github.com supported" |
| Malformed JSON | Error with helpful message |
| `--sync` + `--ref` | Allow `--ref` to override stored ref |

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

### After (with sync)

```bash
# Simple sync from within project
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --sync

# Or with options
curl -fsSL ... | bash -s -- --sync --dry-run
curl -fsSL ... | bash -s -- --sync --force
```

## Technical Notes

### Metadata parsing (no jq)

```bash
# Extract ref
sed -nE 's/.*"ref"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .agents/.dot-agents.json

# Extract upstream
sed -nE 's/.*"upstream"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .agents/.dot-agents.json
```

### GitHub URL parsing

```bash
# From: https://github.com/colmarius/dot-agents
# Extract: owner=colmarius, repo=dot-agents
upstream="https://github.com/colmarius/dot-agents"
if [[ "$upstream" =~ ^https://github\.com/([^/]+)/([^/]+)/?$ ]]; then
    owner="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]%.git}"
fi
```

## Effort Estimate

**Small-Medium (1-3 hours)**

- Add flag + metadata reading: 30 min
- GitHub URL parsing: 15 min
- Timestamp tracking: 15 min
- Testing (fresh, sync, conflicts): 1 hour
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
