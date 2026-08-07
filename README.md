# dot-agents

AI-ready `.agents/` workspace for any project — durable work items, reusable research, execution-ready plans, verification evidence, and optional handoffs across threads.

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

- **[Quickstart](./QUICKSTART.md)** — Install, choose conversational or durable work, and execute a plan
- **[Full Docs](./docs/README.md)** — Concepts, skills, and migration notes
- **[Website](https://dot-agents.dev)** — Landing page (source: [site/](./site/))

Develop the Astro landing page locally:

```bash
npm install
npm run dev
```

Inside an Amp Orb, start the repository's supervised development service and print its authenticated portal URL:

```bash
amp orb services ensure
```

The service uses Amp's assigned `$PORT` and accepts the generated `.e2b.app` and `.onamp.dev` portal hosts.

## Agent Support

dot-agents works with any AI coding agent that reads Markdown instructions. When a project already has a `.claude/` directory, install/sync also links dot-agents skills into `.claude/skills/` so Claude Code can discover them as project skills.

If an agent does not auto-discover skills, ask it to read the relevant `.agents/skills/<skill>/SKILL.md` file before starting that workflow.

## Workflow

```text
Request or change
       │
       ├─ Self-contained ───────────────▶ Plan and execute in this conversation
       │                                               │
       │                                               ▼
       │                                      Verify and report
       │
       └─ Continuity has value ─────────▶ Work Item (`index.md`)
                                                  │
                                                  ▼
                              Context as needed → Plan → Execute → Verify and record
                                                   ├──────── Hand off when useful
                                                   ▼
                            Promote reusable lessons → Commit final snapshot → Remove
```

For a small, self-contained change, keep the plan and execution in the current conversation, verify the result, and report it without creating repository artifacts.

Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit request makes repository context valuable. Start at `index.md`, add research or a requirements brief only when needed, execute in the current thread by default, record observed evidence, and hand off only when another worker or environment genuinely helps. At completion, promote reusable outcomes, commit the final snapshot, and remove the work item from the current tree; git history remains the archive.

The authoritative work-item artifact and lifecycle rules live in [`.agents/work/AGENTS.md`](./.agents/work/AGENTS.md).

## Next Steps

After install:

1. Customize `AGENTS.md` for your project — run `adapt` to auto-fill or edit manually.
2. For self-contained work, ask for a plan and implementation in the current conversation.
3. When continuity has value, create a work item under `.agents/work/<category>/<slug>/`.
4. Ask for research or requirements only when needed, then plan and implement in the current thread by default.
5. Use `agent-browser` for real-browser proof when relevant, or create a handoff when another thread or environment helps.
6. Close completed durable work with `close-work.sh` after its reusable outcomes and final snapshot are preserved.
7. Sync updates later with `.agents/scripts/sync.sh`.

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

## Credits

Skills inspired by [amp-contrib](https://github.com/ampcode/amp-contrib). The `agent-browser` discovery pattern follows [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser).

## License

MIT
