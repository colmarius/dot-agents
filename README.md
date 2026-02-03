# dot-agents

AI-ready `.agents/` workspace for any project—plans, PRDs, research, and skills for agent-assisted workflows.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

Pin a version:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v1.0.0
```

## Documentation

- **[Quickstart](./QUICKSTART.md)** — Step-by-step guide from install to autonomous execution
- **[Full Docs](./docs/README.md)** — Concepts, skills reference
- **[Website](https://dot-agents.dev)** — Landing page (source: [site/](./site/))

## Next Steps

Then:

1. Customize `AGENTS.md` for your project — run `adapt` to auto-fill or edit manually
2. Sync updates later: `.agents/scripts/sync.sh`

## Sync Behavior

Re-running `install.sh` updates dot-agents from upstream while preserving your work:

| What | Behavior |
|------|----------|
| Skills, scripts | Updated from upstream |
| AGENTS.md | Skipped (your customizations preserved) |
| PRDs, plans | Skipped (your content preserved) |
| Research | Skipped (your content preserved) |

The installer copies `AGENTS.template.md` → `AGENTS.md` on fresh install only.

**Sync options:**

| Flag | Behavior |
|------|----------|
| (default) | Overwrite conflicts with backup |
| `--diff` | Preview changes without modifying files |
| `--write-conflicts` | Create `.dot-agents.new` files for manual review |
| `--dry-run` | Show what would happen without changes |

## Versioning

dot-agents uses [Semantic Versioning](https://semver.org/). Releases are tagged as `vMAJOR.MINOR.PATCH`. See [CHANGELOG.md](./CHANGELOG.md) for release history.

## License

MIT
