# Skills

Skills are specialized instructions that agents load for specific workflows. dot-agents keeps them under `.agents/skills/` and, for Claude Code projects, links them into `.claude/skills/` when `.claude/` already exists.

## Available Skills

| Skill | Trigger | Purpose |
| --- | --- | --- |
| [adapt](#adapt) | `Run adapt` | Analyze project, fill in `AGENTS.md` |
| [agent-work](#agent-work) | `Create a work item` | Create and maintain `.agents/work/` context |
| [feature-planning](#feature-planning) | `Create a plan`, `write a handoff prompt` | Turn context into plans and new-thread prompts |
| [research](#research) | `Research [topic]` | Investigate and save work-local or reusable findings |
| [tmux](#tmux) | `tmux`, `background process` | Manage background processes |

## adapt

Analyzes your project and fills in `AGENTS.md` with:

- Project overview and tech stack
- Build/test/lint commands
- Code conventions
- Project structure
- dot-agents work-item workflow guidance

**Invoke:** `Run adapt`

**Details:** [.agents/skills/adapt/SKILL.md](../.agents/skills/adapt/SKILL.md)

## agent-work

Creates and curates durable work item folders:

```text
.agents/work/<category>/<slug>/index.md
```

Use it to create work items, list active work, place artifacts deliberately, and migrate legacy plans when requested.

**Invoke:** `Create a new work item for user authentication`

**Details:** [.agents/skills/agent-work/SKILL.md](../.agents/skills/agent-work/SKILL.md)

## feature-planning

Turns work-item context into implementation-ready plans and paste-ready handoff prompts.

Use it to:

- Create or refine a short requirements brief (`prd.md`) only when alignment is needed
- Create or refine the active plan file
- Validate stale assumptions before implementation
- Generate a new-thread handoff prompt
- Stress-test a plan when explicitly asked

**Invoke:** `Write a handoff prompt for .agents/work/feature/user-authentication`

**Details:** [.agents/skills/feature-planning/SKILL.md](../.agents/skills/feature-planning/SKILL.md)

## research

Investigates technical questions using available local, web, and repository evidence.

Research is saved:

- Work-locally at `.agents/work/<category>/<slug>/research.md` or `.agents/work/<category>/<slug>/research/<topic>.md` when it supports one work item
- Reusably at `.agents/research/<topic>.md` when it should guide future unrelated work

**Invoke:** `Research authentication patterns for this work item`

**Details:** [.agents/skills/research/SKILL.md](../.agents/skills/research/SKILL.md)

## tmux

Background process management:

- Spawns long-running processes such as servers or watchers
- Captures output for review
- Sends interrupts or kills background windows when needed

**Invoke:** `Use tmux to run the dev server in the background`

**Details:** [.agents/skills/tmux/SKILL.md](../.agents/skills/tmux/SKILL.md)

## Adding Custom Skills

Create a new skill by adding a directory under `.agents/skills/`:

```text
.agents/skills/my-skill/
└── SKILL.md
```

### `SKILL.md` Format

```markdown
---
name: my-skill
description: "Brief description. Use when relevant context applies. Triggers on: keyword1, keyword2."
---

# My Skill

Instructions for the agent when this skill is loaded.
```

The `name` and `description` fields are used for skill discovery. Keep descriptions quoted, concise, and trigger-rich.

### Preserving Custom Skills

Custom skills in `.agents/skills/` are preserved during `sync.sh` updates. Only upstream core skills are updated or retired by dot-agents.

## Claude Code Project Skill Discovery

Claude Code discovers project skills in `.claude/skills/<skill>/SKILL.md`. dot-agents keeps `.agents/skills/` as the source of truth, so when `install.sh` or `sync.sh` detects an existing `.claude/` directory it creates directory symlinks such as:

```text
.claude/skills/adapt -> ../../.agents/skills/adapt
.claude/skills/agent-work -> ../../.agents/skills/agent-work
```

Directory symlinks expose the whole skill, including optional supporting files like `assets/`, `references/`, and `scripts/`. The installer skips user-owned Claude Code skills and only removes dot-agents-managed symlinks during uninstall or retired-skill cleanup.
