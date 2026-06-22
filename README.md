# dot-agents

AI-ready `.agents/` workspace for any project — durable work items, reusable research, planning skills, and paste-ready handoff prompts for agent-assisted development across threads.

## Install

Run the installer from the root of the repository you want to equip with dot-agents:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

Pin a version:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v0.3.0
```

## Documentation

- **[Quickstart](./QUICKSTART.md)** — Install, create a work item, and generate a handoff prompt
- **[Full Docs](./docs/README.md)** — Concepts, skills, and migration notes
- **[Website](https://dot-agents.dev)** — Landing page (source: [site/](./site/))

## Agent Support

dot-agents works with any AI coding agent that reads Markdown instructions. When a project already has a `.claude/` directory, install/sync also links dot-agents skills into `.claude/skills/` so Claude Code can discover them as project skills.

If an agent does not auto-discover skills, ask it to read the relevant `.agents/skills/<skill>/SKILL.md` file before starting that workflow.

## Next Steps

After install:

1. Customize `AGENTS.md` for your project — run `adapt` to auto-fill or edit manually.
2. Create a work item under `.agents/work/<category>/<slug>/`.
3. Ask for research, a plan, or a paste-ready handoff prompt.
4. Sync updates later with `.agents/scripts/sync.sh`.

## Sync Behavior

Re-running `install.sh` updates dot-agents from upstream while preserving your work:

| What | Behavior |
| --- | --- |
| Skills, scripts, `.agents/work/AGENTS.md` | Updated from upstream |
| Retired upstream skills and legacy guidance/templates | Backed up and removed on sync |
| `AGENTS.md` | Skipped after fresh install |
| Work items | Preserved under `.agents/work/<category>/<slug>/` |
| Reusable research | Preserved under `.agents/research/` |
| Legacy plan/PRD documents | Preserved if present |

The installer copies `AGENTS.template.md` → `AGENTS.md` on fresh install only.

**Sync options:**

| Flag | Behavior |
| --- | --- |
| default | Overwrite upstream-owned conflicts with backup during sync |
| `--diff` | Preview pending installs, updates, removals, and conflicts without modifying files; exits 1 if any change is pending |
| `--write-conflicts` | Create conflict files for manual review: Markdown writes `file.dot-agents.md`; other files write `file.ext.dot-agents.new` |
| `--dry-run` | Show what would happen without changes |

## Versioning

dot-agents uses [Semantic Versioning](https://semver.org/). Releases are tagged as `vMAJOR.MINOR.PATCH`.

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## Credits

Skills inspired by [amp-contrib](https://github.com/ampcode/amp-contrib).

## License

MIT
