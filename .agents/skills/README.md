# Skills Development Guide

Guidelines for creating and maintaining agent skills in this workspace. Read them only when creating or editing a skill; using a skill does not need them. This file is named `README.md` so agent harnesses do not load it as instructions.

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

1. **State what the model cannot infer** - Project facts, exact commands, paths, contracts, and safety rules; skip generic advice a capable model already follows
2. **Be specific** - Show real commands and point to existing code or files
3. **Keep the entrypoint short** - Put templates in `assets/`, runnable helpers in `scripts/`, and rarely needed detail in `references/`
4. **Enforce invariants with scripts** - A check that can fail beats a rule that can be skipped
5. **Avoid runner-specific concepts** - Prefer work items and handoff prompts over assuming a specific agent runtime
6. **Do not create a skill for an interaction style alone** - Add an explicit opt-in mode to the closest existing skill

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

For example, a browser-automation skill can run `agent-browser skills list` and load the guidance the installed CLI ships.

## Testing Skills

Check discovery and behavior separately:

- Load the skill and confirm its metadata and references are available; this alone does not prove automatic trigger selection.
- Exercise a representative task and check its actual output against the intended workflow.
- Report workflows or trigger behavior that were not exercised.
- Check that referenced scripts, assets, and relative links exist.

In the dot-agents source repository, run `./scripts/skills-lint.sh` to validate core skill metadata and links.

Use each skill's `SKILL.md` metadata as the current inventory rather than maintaining a second list here.
