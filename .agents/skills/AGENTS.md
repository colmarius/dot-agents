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

## Workflow

1. Step one
2. Step two

## Verification

- How to confirm the workflow succeeded
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
- Match the `name` to the parent directory exactly
- Start with action verb or noun describing capability
- **Always quote description values** - Required for YAML parsing when values contain colons (`:`)
- Include `Triggers on:` in every description

## Writing Good Skills

1. **Be specific** - Detailed instructions beat vague guidance
2. **Include examples** - Show commands and code patterns
3. **Define workflows** - Step-by-step processes work best
4. **Add checklists** - Help ensure nothing is missed
5. **Reference patterns** - Point to existing code/files
6. **Keep workflow skills durable** - Put reusable templates in `assets/` and runnable helpers in `scripts/`
7. **Avoid runner-specific concepts** - Prefer work items and handoff prompts over assuming a specific agent runtime
8. **Keep the entrypoint concise** - Move detailed background or command catalogs into `references/`
9. **Do not create a skill for an interaction style alone** - Add an explicit opt-in mode to the closest existing skill

## Where Guidance Belongs

| Information | Location |
| --- | --- |
| Always-relevant project map, commands, and safety rules | Root `AGENTS.md` |
| Directory-local conventions | Closest nested `AGENTS.md` |
| Triggered multi-step procedure | Skill |
| Deterministic invariant | Script, test, or check |
| Current task state and evidence | Work item |

Keep root guidance pointer-driven. A skill owns the procedure; a script or test owns anything that can be enforced deterministically.

## Volatile External Tools

Prefer a thin discovery skill when an external CLI or service changes faster than this repository:

1. Detect the installed tool and version.
2. Ask the tool or its authoritative source for current instructions.
3. Execute the version-matched workflow.
4. Persist commands and evidence, not copied runtime documentation.

The core `agent-browser` skill follows this pattern.

## Testing Skills

Verify your skill by loading it and checking:

- Triggers fire on expected phrases
- Instructions are clear and actionable
- Examples cover common use cases
- Workflows produce expected outputs
- Referenced scripts, assets, and relative links exist

In the dot-agents source repository, run `./scripts/skills-lint.sh` to validate core skill metadata and links.

## Available Skills

| Skill | Purpose |
| ----- | ------- |
| `adapt` | Analyze project and fill in AGENTS.md after installation |
| `agent-browser` | Discover current real-browser automation workflows from the installed CLI |
| `agent-work` | Manage durable work from requirements and plans through execution and handoffs |
| `research` | Research technical topics, saving work-local or reusable findings |
