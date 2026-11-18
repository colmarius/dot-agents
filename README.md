# dot-agents

Pick up AI coding work where the last agent left off. dot-agents adds an `AGENTS.md` and a small `.agents/` folder to your repository. Most work needs no files: when one conversation can finish it, just ask. When people must review the direction, or the work continues in another session, your agent keeps a work item: one Markdown file with the why, what is done and left, the decisions, and the next step, plus a dated log any session can resume from.

Works with Amp, Codex, Claude Code, and any agent that reads `AGENTS.md`. See [dot-agents.dev](https://dot-agents.dev).

## Install

Run the installer from the root of the repository you want to equip with dot-agents:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

Pin a version:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/v0.6.0/install.sh | bash -s -- --ref v0.6.0
```

## Get Started

1. Install from your repository root (above).
2. Tell your agent `Run adapt` to fill `AGENTS.md` with your project's commands and conventions.
3. When work needs a durable record, ask: `Create a work item for ...`. In a later session: `Continue the work item at ...`. When it is done: `Close the work item at ...`.

## Documentation

- **[How dot-agents works](./docs/concepts.md)**: when to use a work item, the four asks, and what a work item holds
- **[Quickstart](./QUICKSTART.md)**: install, adapt, and your first work item
- **[Skills reference](./docs/skills.md)** and the **[work-item contract](./.agents/work/AGENTS.md)**
- **[Documentation index](./docs/README.md)**, including migration guides

## Agent Support

dot-agents works with any AI coding agent that reads Markdown instructions. When a project already has a `.claude/` directory, install and sync also link dot-agents skills into `.claude/skills/` so Claude Code discovers them as project skills.

If an agent does not discover skills on its own, ask it to read the relevant `.agents/skills/<skill>/SKILL.md` before starting.

## Sync Behavior

Re-running `install.sh` updates dot-agents from upstream while preserving your work:

| What | Behavior |
| --- | --- |
| Skills, scripts, `.agents/work/AGENTS.md` | Install missing files; skip identical files; preserve differing files and write conflict copies |
| Retired upstream skills, templates, references, and managed Claude links | Preserve and report pending removal; explicit `--force` backs up and removes them |
| `AGENTS.md` | Created if missing; existing root guidance is preserved |
| Work items | Preserved by sync under `.agents/work/<category>/<slug>/`; explicit closeout removes completed items |
| Reusable research | Preserved under `.agents/research/` |
| Legacy plan/PRD documents | Preserved if present |
| Non-colliding custom skills | Preserved |

The installer copies `AGENTS.template.md` → `AGENTS.md` whenever the root file is missing, including during sync.

**Changed default (unreleased): ordinary sync no longer forces replacement.** Without a stored baseline, an untouched older upstream file and a project customization both require review when they differ. See the [safe-sync migration notes](./docs/migration-safe-sync.md) before updating automation. Older tagged installers retain their old behavior; `sync.sh` downloads the installer from the ref recorded in metadata.

Sync never closes work items automatically. The guarded `agent-work` helper validates a committed completed snapshot and stages only that work item's removal for a separate commit.

Uninstall is different: `install.sh --uninstall` deletes root `AGENTS.md` and all `.agents/` content, including user work, research, and backups. Use `--uninstall --dry-run` to preview; `--uninstall --diff` is rejected.

**Sync options:**

| Flag | Behavior |
| --- | --- |
| default / `--write-conflicts` | Preserve local conflicts; write `file.dot-agents.md` for Markdown or `file.ext.dot-agents.new` for other files; never overwrite an existing conflict copy |
| `--force` | Back up and replace conflicting managed files, and remove retired managed content |
| `--interactive` | Ask about each conflict and separately about each removal; keep/skip leaves unresolved status |
| `--yes` | Skip general confirmations; does not authorize replacement or retired-content removal |
| `--diff` | Preview pending installs, updates, removals, and conflicts without modifying files; exits 1 if any change is pending |
| `--dry-run` | Show what would happen without changes; exits 1 if conflicts or removals would remain unresolved |

An unresolved update exits 1 and reports installed files, preserved conflicts, and pending removals separately. Non-conflicting additions may already be installed; this is not a rollback. Installation metadata stays unchanged until a run completes without unresolved items. Review conflict copies before removing or regenerating them; a later run keeps reporting differences. `--force --write-conflicts` is rejected. Preview flags never write project files, metadata, or backups, even with `--force` or `--interactive`.

## Versioning

dot-agents uses [Semantic Versioning](https://semver.org/). Releases are tagged as `vMAJOR.MINOR.PATCH`.

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## For Contributors

Run `./scripts/test.sh` for lint and Bats tests. See [AGENTS.md](./AGENTS.md) for the full contributor workflow.

Develop the Astro landing page locally:

```bash
npm install
npm run dev
```

Inside an Amp Orb, `amp orb services ensure` starts the supervised development service on Amp's assigned `$PORT` and prints its authenticated portal URL.

## Credits

Skills inspired by [amp-contrib](https://github.com/ampcode/amp-contrib).

## License

MIT
