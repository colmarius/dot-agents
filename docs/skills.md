# Skills

Skills are specialized instructions that agents load for specific workflows. dot-agents keeps them under `.agents/skills/` and, for Claude Code projects, links them into `.claude/skills/` when `.claude/` already exists.

## Available Skills

| Skill | Trigger | Purpose |
| --- | --- | --- |
| [adapt](#adapt) | `Run adapt` | Analyze project, fill in `AGENTS.md` |
| [agent-work](#agent-work) | `Create a work item for ...`, `Continue the work item at ...`, `Close the work item at ...` | Keep a shared record for review and resumption; hand off and close work |
| [research](#research) | `Research [topic]` | Investigate and save work-local or reusable findings |

## adapt

Analyzes your project and fills in `AGENTS.md` with:

- Project overview and tech stack
- Build/test/lint commands
- Code conventions
- Project structure
- A short agent-work section that points to `.agents/work/AGENTS.md`

**Invoke:** `Run adapt`

**Details:** [.agents/skills/adapt/SKILL.md](../.agents/skills/adapt/SKILL.md)

## agent-work

Creates, continues, hands off, and closes work items:

```text
.agents/work/<category>/<slug>/index.md
```

A work item is the shared record between people and agents and the recovery checkpoint for work that needs review or must outlive the conversation. `index.md` holds current state: why, what is done and remains, decisions, and the next action. `log.md` keeps the dated history. Support files such as `research.md`, `proposal.md`, and `plan.md` are added only when someone will read them.

The skill also writes handoff prompts, coordinates workers, and runs an opt-in stress-test of a plan. Self-contained work stays in the conversation without a work item. The rules come from `.agents/work/AGENTS.md`. `list-work.sh` shows each item's status and last change and flags stale or uncommitted items. `close-work.sh` verifies a clean repository, a committed `completed` snapshot, and no open decisions, then stages only the work-item deletion for a separate commit.

**Invoke:** `Create a work item for user authentication`

**Details:** [.agents/skills/agent-work/SKILL.md](../.agents/skills/agent-work/SKILL.md)

## research

Investigates technical questions using repository, documentation, and web evidence. The answer may stay in the conversation; it is saved only when people must review it, the work continues elsewhere, or the findings will be reused.

Research is saved:

- In the work item's `research.md` (or `research/<topic>.md`) when it supports one work item
- Reusably at `.agents/research/<topic>.md` when it should guide future unrelated work

**Invoke:** `Research authentication patterns for this work item`

**Details:** [.agents/skills/research/SKILL.md](../.agents/skills/research/SKILL.md)

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

Custom skills whose names do not collide with current or retired upstream skills are preserved during `sync.sh` updates. Colliding names can be overwritten or backed up and removed. Preview with `.agents/scripts/sync.sh --diff` and follow the [v0.5 migration warning](migration-v0.5.md#what-sync-removes-and-preserves) to rename customized retired skills before syncing.

## Claude Code Project Skill Discovery

Claude Code discovers project skills in `.claude/skills/<skill>/SKILL.md`. dot-agents keeps `.agents/skills/` as the source of truth, so when `install.sh` or `sync.sh` detects an existing `.claude/` directory it creates directory symlinks such as:

```text
.claude/skills/adapt -> ../../.agents/skills/adapt
.claude/skills/agent-work -> ../../.agents/skills/agent-work
```

Directory symlinks expose the whole skill, including optional supporting files like `assets/`, `references/`, and `scripts/`. The installer skips user-owned Claude Code skills and only removes dot-agents-managed symlinks during uninstall or retired-skill cleanup.
