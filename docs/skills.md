# Skills

Skills are specialized instructions that agents load for specific workflows. dot-agents keeps them under `.agents/skills/` and, for Claude Code projects, links them into `.claude/skills/` when `.claude/` already exists.

## Available Skills

| Skill | Trigger | Purpose |
| --- | --- | --- |
| [adapt](#adapt) | `Run adapt` | Analyze project, fill in `AGENTS.md` |
| [agent-browser](#agent-browser) | `Use agent-browser to verify...` | Load current real-browser automation guidance |
| [agent-work](#agent-work) | `Create a work item`, `refine this plan` | Manage durable requirements, plans, execution, and handoffs |
| [research](#research) | `Research [topic]` | Investigate and save work-local or reusable findings |

## adapt

Analyzes your project and fills in `AGENTS.md` with:

- Project overview and tech stack
- Build/test/lint commands
- Code conventions
- Project structure
- dot-agents work-item workflow guidance

**Invoke:** `Run adapt`

**Details:** [.agents/skills/adapt/SKILL.md](../.agents/skills/adapt/SKILL.md)

## agent-browser

Provides a small discovery workflow for the external `agent-browser` CLI. It asks the installed CLI for version-current instructions rather than copying a command catalog into dot-agents.

Use it for:

- Real-browser navigation and form workflows
- Browser smoke tests and exploratory QA
- Screenshots, traces, and other reviewable UI evidence
- Data extraction or application-specific browser automation

The CLI and browser runtime are optional external prerequisites; dot-agents does not install either automatically.

**Invoke:** `Use agent-browser to verify the checkout flow`

**Details:** [.agents/skills/agent-browser/SKILL.md](../.agents/skills/agent-browser/SKILL.md)

## agent-work

Creates and curates durable work item folders:

```text
.agents/work/<category>/<slug>/index.md
```

Use it to decide when durable context is warranted, create or list work items, manage requirements and plans, refine or stress-test planned work, execute in the current thread, coordinate bounded workers, produce optional handoffs, and safely close completed work.

Small, self-contained planning remains in the current conversation without a work item. Detailed artifact and lifecycle rules come from `.agents/work/AGENTS.md`; focused references under the skill cover plan execution, handoffs, and coordinated workers. `close-work.sh` verifies a clean repository and committed final snapshot, then stages only the work-item deletion for a separate commit.

**Invoke:** `Create a new work item for user authentication`

**Details:** [.agents/skills/agent-work/SKILL.md](../.agents/skills/agent-work/SKILL.md)

## research

Investigates technical questions using available local, web, and repository evidence. The answer may remain conversational; save it only when resumption, auditability, durable decisions, or future reuse makes an artifact worthwhile.

Research is saved:

- Work-locally at `.agents/work/<category>/<slug>/research.md` or `.agents/work/<category>/<slug>/research/<topic>.md` when it supports one work item
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

Custom skills in `.agents/skills/` are preserved during `sync.sh` updates. Only upstream core skills are updated or retired by dot-agents.

## Claude Code Project Skill Discovery

Claude Code discovers project skills in `.claude/skills/<skill>/SKILL.md`. dot-agents keeps `.agents/skills/` as the source of truth, so when `install.sh` or `sync.sh` detects an existing `.claude/` directory it creates directory symlinks such as:

```text
.claude/skills/adapt -> ../../.agents/skills/adapt
.claude/skills/agent-browser -> ../../.agents/skills/agent-browser
.claude/skills/agent-work -> ../../.agents/skills/agent-work
```

Directory symlinks expose the whole skill, including optional supporting files like `assets/`, `references/`, and `scripts/`. The installer skips user-owned Claude Code skills and only removes dot-agents-managed symlinks during uninstall or retired-skill cleanup.
