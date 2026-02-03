# Research: Skills Documentation

**Date:** 2026-02-03
**Status:** Complete
**Tags:** documentation, skills, customization
**Parent:** documentation-improvements.md

## Summary

Skills have SKILL.md files for agent consumption, but users lack overview documentation explaining what each skill does, when to use it, and how to customize or extend.

## Current State

### Skills Directory

```
.agents/skills/
├── adapt/SKILL.md      # Project analysis
├── ralph/SKILL.md      # Autonomous execution
├── research/SKILL.md   # Deep research workflow
├── tmux/SKILL.md       # Background processes
└── AGENTS.md           # Skills directory instructions
```

### Coverage Gaps

| Skill | Agent Docs | User Docs |
|-------|------------|-----------|
| adapt | ✓ SKILL.md | ✗ Missing |
| ralph | ✓ SKILL.md | ✗ Missing |
| research | ✓ SKILL.md | ✗ Missing |
| tmux | ✓ SKILL.md | ✗ Missing |

Users don't know:
- What each skill does (high-level)
- When to use which skill
- How to invoke skills
- How to add custom skills

## Recommendations

### 1. Create docs/skills.md

```markdown
# Skills

Skills are specialized instructions that agents load for specific workflows.

## Available Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| [adapt](#adapt) | "Run adapt" | Analyze project, fill in AGENTS.md |
| [ralph](#ralph) | "Run ralph on [plan]" | Autonomous task execution |
| [research](#research) | "Research [topic]" | Deep investigation workflow |
| [tmux](#tmux) | (auto-loaded) | Background process management |

## adapt

Analyzes your project and fills in AGENTS.md with:
- Project overview and tech stack
- Build/test/lint commands
- Code conventions
- Project structure

**Invoke:** `Run adapt`

**Details:** [.agents/skills/adapt/SKILL.md](../.agents/skills/adapt/SKILL.md)

## ralph

Executes plans autonomously, iterating through tasks:
- Reads plan from `.agents/plans/`
- Completes tasks one by one
- Commits after each task
- Hands off to new thread when context fills

**Invoke:** `Run ralph on .agents/plans/in-progress/my-plan.md`

**Options:**
- `--max-tasks 5` — Limit tasks per iteration (default: 5)
- `--start-from 3` — Resume from specific task

**Details:** [.agents/skills/ralph/SKILL.md](../.agents/skills/ralph/SKILL.md)

## research

Deep investigation workflow:
- Web search and documentation reading
- Explores libraries, APIs, patterns
- Saves findings to `.agents/research/`

**Invoke:** `Research [topic]`

**Details:** [.agents/skills/research/SKILL.md](../.agents/skills/research/SKILL.md)

## tmux

Background process management:
- Spawns long-running processes
- Captures output for review
- Used by other skills automatically

**Details:** [.agents/skills/tmux/SKILL.md](../.agents/skills/tmux/SKILL.md)
```

### 2. Add Customization Section

```markdown
## Adding Custom Skills

Create a new skill directory:

```
.agents/skills/my-skill/
└── SKILL.md
```

SKILL.md format:
```markdown
---
name: my-skill
description: Brief description for skill discovery
---

# My Skill

Instructions for the agent when this skill is loaded...
```

**Invocation:** Skills are loaded via natural language matching the description.

### Protecting Custom Skills from Sync

Custom skills in `.agents/skills/` are preserved during sync. Only upstream skills (adapt, ralph, research, tmux) are updated.
```

### 3. Link from AGENTS.md

Update "Using Skills" section to reference docs:

```markdown
## Using Skills

| Command | Effect |
|---------|--------|
| `Run adapt` | Analyze project and fill in AGENTS.md |
| `Research [topic]` | Deep investigation, saves to `.agents/research/` |
| `Run ralph on [plan.md]` | Autonomous execution of plan tasks |

See [docs/skills.md](./docs/skills.md) for full skill documentation.
```

## Risks & Guardrails

| Risk | Guardrail |
|------|-----------|
| docs/skills.md drifts from SKILL.md | Keep docs/skills.md as overview + links, SKILL.md as source of truth |
| Duplication of content | Only describe "what" and "when" in docs, link to SKILL.md for "how" |

## Implementation Tasks

- [ ] Create docs/skills.md with overview table
- [ ] Add section for each skill (adapt, ralph, research, tmux)
- [ ] Add "Adding Custom Skills" section
- [ ] Update AGENTS.md to link to docs/skills.md
- [ ] Add "Protecting from Sync" note

## Effort Estimate

~1-2 hours

## Sources

- Oracle review feedback
- Parent research: documentation-improvements.md
- Existing SKILL.md files
