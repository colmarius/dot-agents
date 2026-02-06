# Skills

Skills are specialized instructions that agents load for specific workflows. When you invoke a skill, the agent receives detailed guidance for that particular task type.

## Available Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| [adapt](#adapt) | `Run adapt` | Analyze project, fill in AGENTS.md |
| [ralph](#ralph) | `Run ralph on [plan]` | Autonomous task execution |
| [research](#research) | `Research [topic]` | Deep investigation workflow |
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

- Start from specific task: `Continue ralph from Task 5 on [plan]`
- Default max tasks per session: 5

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

- Spawns long-running processes (servers, watchers)
- Captures output for review
- Auto-loaded by other skills when needed

**Note:** This skill is typically loaded automatically when background processes are required.

**Details:** [.agents/skills/tmux/SKILL.md](../.agents/skills/tmux/SKILL.md)

## Adding Custom Skills

Create a new skill by adding a directory under `.agents/skills/`:

```
.agents/skills/my-skill/
└── SKILL.md
```

### SKILL.md Format

```markdown
---
name: my-skill
description: "Brief description for skill discovery"
triggers: deploy, push to production, release
keywords: deployment, CI/CD, infrastructure
invocation: "Deploy [target]"
---

# My Skill

Instructions for the agent when this skill is loaded...
```

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Skill identifier (kebab-case) |
| `description` | Yes | When to use; agents match this against user input |
| `triggers` | No | Comma-separated phrases that should activate this skill |
| `keywords` | No | Comma-separated domain tags for search/categorization |
| `invocation` | No | How to invoke (shown in documentation and UIs) |

The `name` and `description` are used for skill discovery. The agent matches user requests against skill descriptions to determine which skill to load.

The optional `triggers`, `keywords`, and `invocation` fields provide structured metadata for programmatic discovery. These are used by `generate-registry.sh` to build `REGISTRY.json`.

**Invocation:** Skills are loaded via natural language matching. If your description mentions "deploy" or "deployment", saying "help me deploy" will load your skill.

### Preserving Custom Skills

Custom skills in `.agents/skills/` are preserved during `sync.sh` updates. Only upstream skills (adapt, ralph, research, tmux) are updated—your custom skills remain untouched.

## Skill Registry

The skill registry (`REGISTRY.json`) provides a machine-readable index of all available skills. It enables programmatic skill discovery by any agent system without walking the filesystem.

### Location

```
.agents/skills/REGISTRY.json
```

### Generating the Registry

After adding or modifying skills, regenerate the registry:

```bash
.agents/scripts/generate-registry.sh
```

The script scans all `.agents/skills/*/SKILL.md` files, extracts frontmatter, and writes `REGISTRY.json`.

### Registry Format

```json
{
  "version": "1.0",
  "generated": "2026-02-06T12:00:00Z",
  "skills": [
    {
      "id": "my-skill",
      "name": "my-skill",
      "description": "Brief description...",
      "triggers": ["deploy", "push to production"],
      "keywords": ["deployment", "CI/CD"],
      "path": ".agents/skills/my-skill/SKILL.md",
      "invocation": "Deploy [target]"
    }
  ]
}
```

### Using the Registry

Agent systems can parse `REGISTRY.json` to discover skills programmatically:

```python
import json

with open(".agents/skills/REGISTRY.json") as f:
    registry = json.load(f)

for skill in registry["skills"]:
    print(f"{skill['name']}: {skill['description']}")
```

The registry is agent-system agnostic—it works with Claude Code, ampcode, Cursor, or any tool that reads JSON.
