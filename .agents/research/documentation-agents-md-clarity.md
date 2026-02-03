# Research: AGENTS.md Template Clarity

**Date:** 2026-02-03
**Status:** Complete
**Tags:** documentation, agents-md, user-experience
**Parent:** documentation-improvements.md

## Summary

The name `AGENTS.md` is used for both the template in the dot-agents repo and the user's customized project file. This causes confusion about purpose and ownership.

## The Problem

### Dual Usage

| Context | AGENTS.md Is... |
|---------|-----------------|
| dot-agents repo | Template with placeholders |
| User's project | Customized project instructions |

### User Confusion

Users may not realize:
- AGENTS.md is a template to customize, not instructions to follow
- Sync preserves their AGENTS.md (won't overwrite customizations)
- Placeholders like `[Brief project description]` should be replaced

### Current State

AGENTS.md opens with:
```markdown
# Project Instructions

## Overview

[Brief project description - update this for your project]
```

This is subtle. Users may miss that it's a template.

## Options Considered

### Option A: Rename to AGENTS.template.md

**Pros:**
- Clear it's a template
- Install script copies to AGENTS.md
- No confusion about purpose

**Cons:**
- Breaking change for existing users
- Adds complexity to install script
- Two files to maintain

### Option B: Add Prominent Banner

**Pros:**
- No breaking change
- Immediately visible
- Easy to implement

**Cons:**
- Banner stays after customization (unless removed)
- Less "clean" appearance

### Option C: HTML Comment + Documentation

**Pros:**
- Clean file appearance
- Comment hidden in rendered Markdown

**Cons:**
- Not visible in GitHub preview
- Easy to miss

## Recommendation

**Option B: Add Prominent Banner** with removal instruction.

```markdown
> **📝 TEMPLATE:** This is the dot-agents AGENTS.md template.
> Customize it for your project by filling in the sections below.
> Delete this banner when done.

# Project Instructions
...
```

Plus add clear documentation in:
- README.md: "Edit AGENTS.md for your project"
- QUICKSTART.md: "Run `adapt` to auto-fill AGENTS.md"
- docs/concepts.md: Explain repo docs vs project template

## Additional Clarifications Needed

### 1. Sync Behavior for AGENTS.md

Add to README or docs:
```markdown
### What Sync Updates

| File | Behavior |
|------|----------|
| Skills, scripts | Updated from upstream |
| **AGENTS.md** | **Skipped** (your customizations preserved) |
| PRDs, plans | Skipped (your content preserved) |
```

### 2. Upstream vs Your Workspace

Explain the distinction:
- **Upstream dot-agents:** The template repo (github.com/colmarius/dot-agents)
- **Your workspace:** The customized `.agents/` in your project

## Implementation Tasks

- [ ] Add prominent banner to top of AGENTS.md
- [ ] Include "delete when done" instruction in banner
- [ ] Update README.md to clarify "customize AGENTS.md"
- [ ] Update QUICKSTART.md to mention `adapt` fills in template
- [ ] Document sync behavior for AGENTS.md explicitly

## Effort Estimate

~30 minutes

## Sources

- Oracle review feedback
- Parent research: documentation-improvements.md
