# Migrating to v0.6

v0.6 makes the work item a lean shared record between people and agents, and a recovery checkpoint for work that outlives one conversation. Existing work items stay valid; nothing needs to be rewritten.

## What Changed

| Area | v0.5 | v0.6 |
| --- | --- | --- |
| When to create a work item | Status, decisions, or next action must survive the conversation | People must review or decide direction, or the work must resume elsewhere; creating one late is fine |
| `index.md` metadata | `Status:`, `Category:`, `Updated:` | `Status:` only; category comes from the path and the last change from git |
| `index.md` sections | Why, Summary, Artifacts, Next Action, Open Questions | Why, Summary (done, remaining, scope), Artifacts, Decisions, Next Action |
| Progress | Optional `progress.md` | `log.md` beside `index.md`: dated entries, newest last; `new-work.sh` creates it |
| Decisions | Optional `decisions/` records | One line each under `## Decisions`: `Open:`, `Proposed:`, or `Accepted:`; only the named decider or their delegate accepts; agents record acceptances |
| Requirements | Optional `prd.md` and template | Optional `proposal.md` (or `design.md`) for what reviewers must decide |
| Plans | `plan.md` or `plans/` with required task fields | Optional `plan.md` with ordered checkbox tasks when order is not obvious or someone else executes |
| Handoffs | Optional persisted `handoff-*.md` | Generated in the conversation; not stored in the work item |
| Contract and skill | Contract plus three `agent-work` reference files | The contract holds what every reader needs; closing, handoff, and coordination live in the `agent-work` skill |
| Skills | `adapt`, `agent-browser`, `agent-work`, `research` | `adapt`, `agent-work`, `research`; use `agent-browser skills list` from the installed CLI for browser guidance. The skill-authoring guide is `.agents/skills/README.md`, so harnesses no longer load it as instructions |
| Statuses | `researching`, `planned`, `in-progress`, `blocked`, `completed` | `researching`, `in-progress`, `blocked`, `completed`. `planned` is dropped and read as `in-progress`; `researching` covers proposals, `in-progress` needs an accepted direction, `blocked` includes waiting on review and the close request |
| Closeout | Snapshot commit, then removal commit | Same, and the removal commit names the snapshot; with squash merges, remove in a later change |

`close-work.sh` now reads `Status:` only from the metadata above the first `##` heading, and refuses a snapshot that still lists `Open:` or `Proposed:` decisions. `list-work.sh` takes the category from the path and the date from git, and flags items that are stale, uncommitted, or completed but not yet removed. `new-work.sh` no longer accepts `planned`.

## What Sync Removes And Preserves

Sync backs up and removes these upstream files:

- `.agents/skills/agent-browser/` (retired core skill)
- `.agents/skills/AGENTS.md` (replaced by `.agents/skills/README.md`)
- `.agents/skills/agent-work/assets/prd-template.md`
- `.agents/skills/agent-work/assets/work-decision-template.md`
- `.agents/skills/agent-work/references/coordinated-execution.md`
- `.agents/skills/agent-work/references/handoff-context.md`
- `.agents/skills/agent-work/references/plan-execution.md`

If you customized one of them, preview with `.agents/scripts/sync.sh --diff` and move your changes to a project skill or nested `AGENTS.md` first. Backups land in `.agents/.dot-agents-backup/`.

Sync preserves your root `AGENTS.md`, every work item, `.agents/research/`, and legacy plan and PRD documents.

## After Syncing

1. Ask your agent to `Run adapt`. It replaces generic v0.5 work-item text in `AGENTS.md`, such as artifact lists, copied task formats, and workflow diagrams, with a short agent-work section that points to `.agents/work/AGENTS.md`. Project-specific workflows stay.
2. Leave existing work items as they are. Their `Category:` and `Updated:` lines, `planned` status, `progress.md`, `prd.md`, `decisions/`, `plans/`, and `handoff-*.md` files remain valid. When you next update one, you may add `## Decisions`, keep using its progress file or start `log.md` and link it, and fold an `Open Questions` list into `Decisions` as `Open:` lines.
3. If your merges squash commits, close work items in a follow-up change after the completed snapshot is on the default branch.
