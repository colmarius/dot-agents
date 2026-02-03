# Research: Troubleshooting Documentation

**Date:** 2026-02-03
**Status:** Complete
**Tags:** documentation, troubleshooting, support
**Parent:** documentation-improvements.md

## Summary

Common issues are documented in CHANGELOG but not easily discoverable. Need a dedicated troubleshooting guide with top failure modes.

## Known Issues

### From CHANGELOG and Git History

| Issue | Cause | Fix | Commit |
|-------|-------|-----|--------|
| `BASH_SOURCE[0]: unbound variable` | Piped install with `set -u` | Guard with default value | `455019a` |
| Script exits on bash 5.3+ | Postfix increment with `set -e` | Use assignment instead | `4d97cce` |

### Common User Problems (Anticipated)

| Issue | Cause | Solution |
|-------|-------|----------|
| Skill not loading | Typo in invocation or missing skill | Check `.agents/skills/` exists |
| Sync conflicts | Modified upstream files | Use `--force` with backup |
| Ralph not finding tasks | Wrong plan path or format | Verify plan location and task format |
| Permission denied on scripts | Scripts not executable | `chmod +x .agents/scripts/*.sh` |

## Recommendations

### 1. Create docs/troubleshooting.md

```markdown
# Troubleshooting

## Installation Issues

### "BASH_SOURCE[0]: unbound variable"

**Cause:** Running install script in strict mode via pipe.

**Solution:** Fixed in latest version. If using older version:
```bash
# Download and run directly instead of piping
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh -o install.sh
bash install.sh
rm install.sh
```

### Script exits unexpectedly on bash 5.3+

**Cause:** Postfix increment operators (`i++`) cause exit with `set -e`.

**Solution:** Fixed in latest version. Update with:
```bash
.agents/scripts/sync.sh
```

## Skill Issues

### Skill not loading

**Symptoms:** Agent doesn't recognize skill commands.

**Checks:**
1. Verify `.agents/skills/` directory exists
2. Check skill directory has SKILL.md
3. Use exact trigger phrase (e.g., "Run adapt" not "adapt project")

### Custom skill not found

**Cause:** SKILL.md missing or malformed frontmatter.

**Solution:** Ensure SKILL.md has:
```yaml
---
name: my-skill
description: Brief description
---
```

## Sync Issues

### Sync overwrote my changes

**Cause:** Force sync or modified upstream-managed files.

**Solution:**
- Check `.agents/scripts/sync.sh.bak.*` for backups
- Your AGENTS.md, PRDs, plans, research are never overwritten

### Sync reports conflicts

**Solution:**
```bash
# Preview changes first
.agents/scripts/sync.sh --dry-run

# Force update (creates backups)
.agents/scripts/sync.sh --force
```

## Ralph Issues

### Ralph not finding tasks

**Checks:**
1. Plan is in `.agents/plans/in-progress/` (not todo/)
2. Tasks use correct format: `- [ ] **Task N: Title**`
3. File path in command matches actual location

### Ralph stops unexpectedly

**Cause:** Context window filled or blocking task.

**Solution:**
- Check plan for `(blocked)` markers
- Resume with: `Continue ralph from Task N on [plan]`

## Permission Issues

### "Permission denied" on scripts

**Solution:**
```bash
chmod +x .agents/scripts/*.sh
```

## Getting Help

- [GitHub Issues](https://github.com/colmarius/dot-agents/issues)
- [Changelog](../CHANGELOG.md) for known fixes
```

### 2. Add Quick Reference to QUICKSTART.md

```markdown
## Troubleshooting

Common issues:

| Problem | Quick Fix |
|---------|-----------|
| Install script fails | Pin version: `--ref v1.0.0` |
| Skill not loading | Check `.agents/skills/` exists |
| Ralph not finding tasks | Verify plan is in `in-progress/` |

See [docs/troubleshooting.md](./docs/troubleshooting.md) for details.
```

### 3. Link from Landing Page

Add to docs/index.html footer:
```html
<a href="https://github.com/colmarius/dot-agents/blob/main/docs/troubleshooting.md">
  Troubleshooting
</a>
```

## Implementation Tasks

- [ ] Create docs/troubleshooting.md
- [ ] Add installation issues section
- [ ] Add skill issues section
- [ ] Add sync issues section
- [ ] Add Ralph issues section
- [ ] Add quick reference to QUICKSTART.md
- [ ] Link from docs/index.html

## Effort Estimate

~1 hour

## Sources

- CHANGELOG.md
- Git history: `git log --oneline | head -30`
- Oracle review feedback
- Parent research: documentation-improvements.md
