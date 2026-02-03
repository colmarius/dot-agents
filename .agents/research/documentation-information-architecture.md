# Research: Documentation Information Architecture

**Date:** 2026-02-03
**Status:** Complete
**Tags:** documentation, information-architecture, navigation
**Parent:** documentation-improvements.md

## Summary

The docs/ directory is underutilized (only landing page). Need a docs hub, concepts page, and clear audience segmentation without adopting heavy tooling.

## Current State

```
docs/
├── .nojekyll      # GitHub Pages config
├── index.html     # Landing page (dot-agents.dev)
└── style.css      # Styling
```

No actual documentation content beyond marketing.

## Gaps

### 1. No Docs Hub

No central page linking to all documentation. Users must discover README, QUICKSTART, AGENTS.md separately.

### 2. No Concepts/Glossary

Terms used without definition:
- **adapt** - Project analysis skill
- **Ralph** - Autonomous execution loops
- **PRD** - Product Requirements Document
- **Plan** - Ralph-ready task list
- **Skills** - Agent instruction sets
- **sync** - Update from upstream

### 3. Audience Confusion

Three audiences, not clearly addressed:

| Audience | Needs | Current Coverage |
|----------|-------|------------------|
| New adopters | Install, first run | QUICKSTART (partial) |
| Existing users | Sync, troubleshoot | README (minimal) |
| Contributors | Release, testing | None |

## Recommendations

### 1. Create docs/README.md as Hub

```markdown
# dot-agents Documentation

## Getting Started

- [Installation](../README.md#install)
- [Quickstart Guide](../QUICKSTART.md)

## Concepts

- [Workflow Overview](./concepts.md#workflow)
- [Glossary](./concepts.md#glossary)

## Reference

- [Skills](./skills.md)
- [AGENTS.md Template](../AGENTS.md)
- [Troubleshooting](./troubleshooting.md)

## For Contributors

- [Changelog](../CHANGELOG.md)
- [Testing](./contributing.md)
```

### 2. Create docs/concepts.md

```markdown
# Concepts

## Workflow

```
Research → PRD → Plan → Execute
```

1. **Research:** Investigate problem space, save to `.agents/research/`
2. **PRD:** Define requirements and acceptance criteria
3. **Plan:** Break PRD into executable tasks with Ralph-ready format
4. **Execute:** Ralph runs tasks autonomously, commits after each

## Glossary

| Term | Definition |
|------|------------|
| adapt | Skill that analyzes your project and fills in AGENTS.md |
| Ralph | Autonomous execution skill that works through plans task-by-task |
| PRD | Product Requirements Document defining what to build |
| Plan | List of tasks in Ralph-ready format with scope, dependencies, acceptance criteria |
| Skills | Specialized agent instructions loaded via natural language |
| sync | Script that updates dot-agents from upstream while preserving your customizations |
```

### 3. Link Hub from README and QUICKSTART

Add to README.md:
```markdown
## Documentation

- **[Quickstart](./QUICKSTART.md)** — Step-by-step guide
- **[Full Docs](./docs/README.md)** — Concepts, skills, troubleshooting
```

### 4. Add "Docs on GitHub" to Landing Page

In docs/index.html, add link:
```html
<a href="https://github.com/colmarius/dot-agents/tree/main/docs">
  Full documentation on GitHub
</a>
```

## When to Adopt Docs Site Generator

**Defer until:**
- More than 8-12 pages
- Users complain about navigation/search
- Need versioned docs per release

**Current recommendation:** Stay with Markdown, GitHub-rendered.

## Implementation Tasks

- [ ] Create docs/README.md as hub page
- [ ] Create docs/concepts.md with workflow + glossary
- [ ] Update README.md to link to docs hub
- [ ] Update QUICKSTART.md to link to docs hub
- [ ] Add "Full docs on GitHub" link to docs/index.html

## Effort Estimate

~1-2 hours

## Sources

- Oracle review feedback
- Parent research: documentation-improvements.md
