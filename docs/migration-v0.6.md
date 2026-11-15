# Migrating to v0.6

v0.6 makes the work item a lean shared record between people and agents, and a recovery checkpoint for work that outlives one conversation. Existing work items stay valid; nothing needs to be rewritten.

## What Changed

| Area | v0.5 | v0.6 |
| --- | --- | --- |
| When to create a work item | Status, decisions, or next action must survive the conversation | People must review or decide direction, or the work must resume elsewhere; creating one late is fine |
| `index.md` sections | Why, Summary, Artifacts, Next Action, Open Questions | Why, Summary, Artifacts, Decisions, Next Action, Log |
| Progress | Optional `progress.md` | Short dated `## Log` in `index.md`; older entries move to `log.md` |
| Decisions | Optional `decisions/` records | One line each under `## Decisions`: `Open:`, `Proposed:`, or `Accepted:`; only a person accepts |
| Requirements | Optional `prd.md` and template | Optional `proposal.md` (or `design.md`) for what reviewers must decide |
| Plans | `plan.md` or `plans/` with required task fields | Optional `plan.md` with ordered checkbox tasks when order is not obvious or someone else executes |
| Handoffs | Optional persisted `handoff-*.md` | Generated in the conversation; not stored in the work item |
| `agent-work` references | Three reference files | Essentials inlined in `SKILL.md` |
| Statuses | `researching`, `planned`, `in-progress`, `blocked`, `completed` | Same values; `in-progress` covers research and proposals, `blocked` includes waiting on review, `completed` includes rejected or cancelled outcomes |
| Closeout | Snapshot commit, then removal commit | Same, and the removal commit names the snapshot; with squash merges, remove in a later change |

`close-work.sh` now reads `Status:` only from the metadata above the first `##` heading, so log lines cannot break closeout.

## What Sync Removes And Preserves

Sync backs up and removes these upstream files from installed skills:

- `.agents/skills/agent-work/assets/prd-template.md`
- `.agents/skills/agent-work/assets/work-decision-template.md`
- `.agents/skills/agent-work/references/coordinated-execution.md`
- `.agents/skills/agent-work/references/handoff-context.md`
- `.agents/skills/agent-work/references/plan-execution.md`

If you customized one of them, preview with `.agents/scripts/sync.sh --diff` and move your changes to a project skill or nested `AGENTS.md` first. Backups land in `.agents/.dot-agents-backup/`.

Sync preserves your root `AGENTS.md`, every work item, `.agents/research/`, and legacy plan and PRD documents.

## After Syncing

1. Ask your agent to `Run adapt`. It replaces generic v0.5 work-item text in `AGENTS.md`, such as artifact lists, copied task formats, and workflow diagrams, with a short agent-work section that points to `.agents/work/AGENTS.md`. Project-specific workflows stay.
2. Leave existing work items as they are. Their `progress.md`, `prd.md`, `decisions/`, `plans/`, and `handoff-*.md` files remain valid. When you next update one, you may add `## Decisions` and `## Log` and fold an `Open Questions` list into `Decisions` as `Open:` lines.
3. If your merges squash commits, close work items in a follow-up change after the completed snapshot is on the default branch.
