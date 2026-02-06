# PRD: Post-Sync Integration Verification for Claude Code Skills

**Date:** 2026-02-06
**Status:** Ready for Testing
**Epic:** Claude Code Native Skill Discovery
**Related:** feature/skill-registry PR

## Problem Statement

When projects sync dot-agents files (especially via `sync-local.sh` which uses rsync), the Claude Code skill discovery integration step is skipped. This means:

- Skills are synced to `.agents/skills/`
- But symlinks aren't created in `.claude/skills/`
- Claude Code can't discover the skills via the `/` menu
- Users must manually run the install.sh integration step

This breaks the "works out-of-the-box" experience for Claude Code integration.

## Solution Overview

Add a post-sync verification and completion script that ensures Claude Code integration is always properly set up after syncing, regardless of which sync method is used.

### Components

1. **`post-sync.sh`** - Verification script that:
   - Detects `.claude/` directory (auto-detects Claude Code projects)
   - Creates symlinks from `.claude/skills/` → `.agents/skills/`
   - Cleans up stale symlinks from removed skills
   - Maintains proper `.gitignore` for symlinks
   - Supports `--dry-run` mode for preview

2. **Updated sync scripts** that automatically call `post-sync.sh`:
   - `sync.sh` - Syncs from GitHub upstream
   - `sync-local.sh` - Syncs from local repository

3. **Integration documentation** (`.agents/INTEGRATION.md`) in consuming projects

## Acceptance Criteria

### Automatic Integration (Primary)
- [ ] `sync-local.sh` automatically runs post-sync after rsync
- [ ] `sync.sh` automatically runs post-sync after upstream install.sh
- [ ] Skills are available in Claude Code `/` menu after fresh sync
- [ ] Running sync twice doesn't cause issues (idempotent)
- [ ] `--dry-run` mode shows what would be created without making changes

### Manual Verification
- [ ] `post-sync.sh` can be run standalone without arguments
- [ ] `post-sync.sh --dry-run` previews changes safely
- [ ] Symlinks point to correct relative paths
- [ ] `.claude/skills/.gitignore` properly configured

### Edge Cases
- [ ] Skips if `.claude/` directory doesn't exist (non-Claude-Code projects)
- [ ] Cleans up symlinks when skills are removed upstream
- [ ] Doesn't overwrite user-created skills (non-symlink files)
- [ ] Works on systems without symlink support (falls back to copy)

### Project Integration
- [ ] New projects syncing dot-agents get working Claude Code integration
- [ ] Existing projects with stale integration can recover by running post-sync

## Testing Strategy

### Phase 1: dot-agents Feature Branch Testing
1. Feature branch has new commit with post-sync.sh and updated sync.sh
2. Test in wcs-video-extractor by syncing from feature branch

### Phase 2: End-to-End in Clean Environment
1. **Clean up wcs-video-extractor:**
   - Reset to before recent sync changes
   - Remove post-sync.sh and integration files
   - Remove .claude/ symlinks

2. **Sync from feature/skill-registry:**
   - Run `.agents/scripts/sync.sh --ref feature/skill-registry`
   - Verify post-sync runs automatically
   - Confirm skills appear in Claude Code

3. **Test idempotency:**
   - Run sync again without changes
   - Verify no errors or unnecessary recreation

### Phase 3: Merge and Production
1. Merge feature/skill-registry to dot-agents main
2. Update wcs-video-extractor to sync from main
3. Verify integration still works

## Files

### Created
- `.agents/scripts/post-sync.sh` - Integration verification script
- `.agents/INTEGRATION.md` - Integration documentation (wcs-video-extractor only)

### Modified
- `.agents/scripts/sync.sh` - Added post-sync call
- `.agents/scripts/sync-local.sh` - Added post-sync call (wcs-video-extractor only)

### Auto-Generated During Sync
- `.claude/skills/<skill-name>/SKILL.md` - Symlinks (or copies)
- `.claude/skills/.gitignore` - Generated with dot-agents marker

## Success Metrics

- ✓ New projects using dot-agents get working Claude Code integration automatically
- ✓ Skills are discoverable immediately after sync without manual steps
- ✓ No errors or warnings in normal usage
- ✓ Dry-run mode accurately previews changes
- ✓ Integration survives multiple sync cycles

## Implementation Details

### Post-Sync Script Logic
```
1. Check if .claude/ exists (auto-detect)
2. For each skill in .agents/skills/:
   - Create symlink in .claude/skills/<skill>/SKILL.md
   - Update gitignore tracking
3. Clean stale symlinks (skills removed upstream)
4. Write .claude/skills/.gitignore
5. Report results
```

### Sync Script Changes
- Changed from `exec bash <(...)` to subshell `bash <(...)`
- Allows post-sync.sh to run after upstream script completes
- Maintains same command-line interface and flag passthrough

### Relative Symlink Path
- Source: `.agents/skills/<skill>/SKILL.md`
- Target: `.claude/skills/<skill>/SKILL.md`
- Relative path: `../../../.agents/skills/<skill>/SKILL.md`

## Rollback Plan

If post-sync causes issues:
1. Run: `rm -rf .claude/skills/ && .agents/scripts/post-sync.sh` (to clean and rebuild)
2. Or manually remove `.claude/skills/` and re-run sync

## Next Steps

1. **Create and review PRD** (this document) ✓
2. **Test in feature branch** - Sync wcs-video-extractor from feature/skill-registry
3. **Verify all skills appear** - Check `/adapt`, `/ralph`, `/research`, `/tmux`
4. **Test with --dry-run** - Ensure preview mode works
5. **Merge PR** - Add to main when ready
6. **Deploy** - Update wcs-video-extractor sync source if needed

## Notes

- The post-sync.sh script mirrors the `setup_claude_code_integration()` function from install.sh
- It's separate from install.sh to be callable independently for verification
- Works with both symlinks and copy fallback for compatibility
- Idempotent - safe to run multiple times
- Only runs if `.claude/` directory exists (respects project choice)
