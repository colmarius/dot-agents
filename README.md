# dot-agents

dot-agents adds plain-Markdown agent instructions and a `.agents/` workspace to any repository. Small changes stay in the current AI conversation. Work that must survive it gets a work item with a status, an exact next action, and optional research, plans, and verification evidence so the next thread can continue.

## Install

Run the installer from the root of the repository you want to equip with dot-agents:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

Pin a version:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v0.5.0
```

## Documentation

- **[Quickstart](./QUICKSTART.md)** — Install, choose conversational or durable work, and take the next action
- **[Documentation Index](./docs/README.md)** — Workflow guides, concepts, skills, and migration notes
- **[Website](https://dot-agents.dev)** — Overview, installation, and rendered workflow guides (source: [site/](./site/))

## Agent Support

dot-agents works with any AI coding agent that reads Markdown instructions. When a project already has a `.claude/` directory, install/sync also links dot-agents skills into `.claude/skills/` so Claude Code can discover them as project skills.

If an agent does not auto-discover skills, ask it to read the relevant `.agents/skills/<skill>/SKILL.md` file before starting that workflow.

## Workflow

```text
Request or change
       │
       ├─ Self-contained ───────────────▶ Plan as needed and execute here
       │                                                │
       │                                                ▼
       │                                       Verify and report
       │
       └─ Continuity has value ─────────▶ Work Item (`index.md`)
                                                  │
                                                  ▼
                              Context and plan as needed → Execute → Verify and record
                                                      ├───── Hand off when useful
                                                      ▼
                            Promote reusable lessons → Commit final snapshot → Remove
```

Keep work conversational when one thread is enough: plan as needed, implement, verify, and report without creating repository artifacts.

Create a work item when its status, decisions, or next action must survive this conversation — for later resumption, coordination, handoff, or auditability — or when you explicitly ask for one. Start at `index.md`. Add research, a requirements brief, or a saved plan only when it helps the next action. Implement in the current thread by default and hand off only when another worker or environment genuinely helps. At completion, promote reusable outcomes, commit the final snapshot, and remove the work item from the current tree; git history remains the archive.

The authoritative work-item artifact and lifecycle rules live in [`.agents/work/AGENTS.md`](./.agents/work/AGENTS.md). The [workflow guides](./docs/README.md#workflow-guides) cover starting uncertain work, continuing durable work, and finishing and preserving outcomes.

## Next Steps

After installing, ask the agent to `Run adapt` so `AGENTS.md` reflects your project. For self-contained work, ask it to implement and verify directly. For durable work, ask it to `Create a new work item for ...`. The [Quickstart](./QUICKSTART.md) covers optional research, planning, handoffs, and closeout. Sync updates later with `.agents/scripts/sync.sh`.

## Sync Behavior

Re-running `install.sh` updates dot-agents from upstream while preserving your work:

| What | Behavior |
| --- | --- |
| Skills, scripts, `.agents/work/AGENTS.md` | Updated from upstream |
| Retired upstream skills and legacy guidance/templates | Backed up and removed on sync |
| `AGENTS.md` | Skipped after fresh install |
| Work items | Preserved by sync under `.agents/work/<category>/<slug>/`; explicit closeout removes completed items |
| Reusable research | Preserved under `.agents/research/` |
| Legacy plan/PRD documents | Preserved if present |

The installer copies `AGENTS.template.md` → `AGENTS.md` on fresh install only.

Sync never closes work items automatically. The guarded `agent-work` helper validates a committed completed snapshot and stages only that work item's removal for a separate commit.

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

Skills inspired by [amp-contrib](https://github.com/ampcode/amp-contrib). The `agent-browser` discovery pattern follows [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser).

## License

MIT
