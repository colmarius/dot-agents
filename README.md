# dot-agents

dot-agents adds plain-Markdown agent instructions and a `.agents/` workspace to any repository. Work one thread can finish stays in the current AI conversation. Work that people need to review, or that must outlive the conversation, gets a work item: one shared record of why, what is done and what remains, decisions, and the next action, plus a dated progress log any thread can resume from.

## Install

Run the installer from the root of the repository you want to equip with dot-agents:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

Pin a version:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/v0.6.0/install.sh | bash -s -- --ref v0.6.0
```

## Documentation

- **[Quickstart](./QUICKSTART.md)** — Install, choose conversational or durable work, and take the next action
- **[How dot-agents works](./docs/concepts.md)** — When to use a work item, and how to start, continue, and finish work
- **[Documentation Index](./docs/README.md)** — Skills, contract, and migration notes
- **[Website](https://dot-agents.dev)** — Overview, installation, and the rendered docs (source: [site/](./site/))

## Agent Support

dot-agents works with any AI coding agent that reads Markdown instructions. When a project already has a `.claude/` directory, install/sync also links dot-agents skills into `.claude/skills/` so Claude Code can discover them as project skills.

If an agent does not auto-discover skills, ask it to read the relevant `.agents/skills/<skill>/SKILL.md` file before starting that workflow.

## Workflow

```text
Request
├─ One thread can finish it ──▶ Work in the conversation ──▶ Verify and report
└─ People must review it, or ──▶ Work item (index.md) ──▶ Research, propose, plan, or build as needed
   it must outlive this thread        │                         │
                                      └── checkpoint: index.md now, log.md history
                                                                 │
                                            Promote outcomes → Commit snapshot → Remove
```

Keep work in the conversation when one thread can finish it: plan as needed, implement, verify, and report without repository artifacts.

Create a work item when people need a durable record to review or decide direction, when the work must resume in another session, thread, or worker, or when you ask for one. `index.md` is the shared record of current state and `log.md` its dated history; together they are the recovery checkpoint. Add `research.md`, a `proposal.md` with contracts and diagrams, or a `plan.md` only when someone will read it. When you ask to close it, the agent promotes what should last, commits the final snapshot, and removes the item in a separate commit (a later change with squash merges); git history is the archive.

The contract lives in [`.agents/work/AGENTS.md`](./.agents/work/AGENTS.md). [How dot-agents works](./docs/concepts.md) covers starting, continuing, and finishing work.

## Next Steps

After installing, ask the agent to `Run adapt` so `AGENTS.md` reflects your project. For self-contained work, ask it to implement and verify directly. For durable work, ask it to `Create a new work item for ...`. The [Quickstart](./QUICKSTART.md) covers optional research, proposals, plans, handoffs, and closeout. Sync updates later with `.agents/scripts/sync.sh`.

## Sync Behavior

Re-running `install.sh` updates dot-agents from upstream while preserving your work:

| What | Behavior |
| --- | --- |
| Skills, scripts, `.agents/work/AGENTS.md` | Updated from upstream |
| Retired upstream skills, templates, and references | Backed up and removed on sync |
| `AGENTS.md` | Created if missing; existing root guidance is preserved |
| Work items | Preserved by sync under `.agents/work/<category>/<slug>/`; explicit closeout removes completed items |
| Reusable research | Preserved under `.agents/research/` |
| Legacy plan/PRD documents | Preserved if present |

The installer copies `AGENTS.template.md` → `AGENTS.md` whenever the root file is missing, including during sync.

Sync never closes work items automatically. The guarded `agent-work` helper validates a committed completed snapshot and stages only that work item's removal for a separate commit.

Uninstall is different: `install.sh --uninstall` deletes root `AGENTS.md` and all `.agents/` content, including user work, research, and backups. Use `--uninstall --dry-run` to preview; `--uninstall --diff` is rejected.

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
