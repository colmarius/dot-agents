# Skills Development Guide

Guidelines for creating and maintaining agent skills in this workspace.

## Structure

Each skill is a folder containing:

- `SKILL.md` - Skill definition with frontmatter (required)
- `scripts/` - Executable code helpers (optional)
- `references/` - Documentation loaded on-demand (optional)
- `assets/` - Templates and output files (optional)

## SKILL.md Format

```markdown
---
name: skill-name
description: "Brief description. Use when [context]. Triggers on: keyword1, keyword2."
---

# Skill Title

[Main content with workflows, patterns, examples]
```

## Description Best Practices

The description determines when the skill gets loaded:

| Element | Purpose | Example |
|---------|---------|---------|
| What it does | First sentence | "Database migrations and data transformations." |
| Use when | Context triggers | "Use when creating migrations, working with schema changes" |
| Triggers on | Keyword phrases | "Triggers on: migrate, schema change, transform data" |

**Constraints:**

- Keep under 250 characters
- Use kebab-case for skill names
- Start with action verb or noun describing capability
- **Always quote description values** - Required for YAML parsing when values contain colons (`:`)

## Writing Good Skills

1. **Be specific** - Detailed instructions beat vague guidance
2. **Include examples** - Show commands and code patterns
3. **Define workflows** - Step-by-step processes work best
4. **Add checklists** - Help ensure nothing is missed
5. **Reference patterns** - Point to existing code/files

## Testing Skills

Verify your skill by loading it and checking:

- Triggers fire on expected phrases
- Instructions are clear and actionable
- Examples cover common use cases
- Workflows produce expected outputs

## Available Skills

| Skill | Purpose |
| ----- | ------- |
| `adapt` | Analyze project and fill in PROJECT.md after installation |
| `ralph` | Autonomous multi-iteration implementation using handoff loops |
| `research` | Deep research on technical topics, saves to `.agents/research/` |
| `tmux` | Manage background processes using tmux windows for servers and long-running tasks |
