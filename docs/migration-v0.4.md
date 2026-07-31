# Migrating to v0.4

dot-agents v0.4.0 evolves work items from a handoff-centered workflow to current-thread execution with optional coordinated workers. It also adds `agent-browser` as a core discovery skill, opens work-item categories, and strengthens durable intent and verification evidence.

## Preview the Sync

From an existing installation, preview changes before updating:

```bash
.agents/scripts/sync.sh --diff
```

Sync continues to preserve user content under `.agents/work/`, `.agents/research/`, and legacy plan or PRD paths. Upstream-owned guidance and core skills are updated with backups when conflicts exist.

## Workflow Changes

### Implement in the current thread by default

The default flow is now:

```text
Work Item → Context as needed → Plan → Execute → Record Evidence
                                      └─ Hand off when useful
```

Existing handoff prompts remain valid. Generate one when another thread, worker, or execution environment is useful; it is no longer a mandatory lifecycle stage.

### Use open categories

`new-work.sh` now accepts any lowercase kebab-case category. Existing categories remain valid, and no directory migration is required.

Examples:

```text
feature
tech-debt
platform
security
payments-api
```

### Preserve intent in `Why`

New work-item indexes include:

- `Why`: stable original intent, problem, and importance.
- `Summary`: evolving current state and scope.

Do not mechanically add `Why` to existing work items. Add it only when recovering original intent would materially improve an active item.

### Keep `progress.md` as a living summary

No file rename is required. For work spanning sessions or workers, keep `progress.md` focused on the current slice, observed verification evidence, blockers, and next action. Replace superseded detail instead of accumulating a chat transcript.

The existing `plans/` and `research/` paths also remain. Add `plans/index.md` or `research/index.md` when a folder contains multiple durable files.

## New Core `agent-browser` Skill

v0.4 adds `.agents/skills/agent-browser/SKILL.md` as an upstream-owned core skill. It is a small discovery stub for the optional external `agent-browser` CLI; dot-agents does not install the CLI, Chromium, or a project dependency.

If your project already has a custom skill named `agent-browser`, run `--diff` before syncing. Sync treats the v0.4 skill as upstream-owned and backs up a conflicting local file before updating it. Rename a substantially different project-specific skill if you need to keep both.

## No Artifact Renames or Automatic Deletion

v0.4 deliberately keeps:

- `plans/` rather than renaming it to `plan/`;
- `progress.md` rather than renaming it to `plan.progress.md`;
- completed work items in the current tree unless the project adopts its own archival policy.

The release changes workflow semantics without forcing user-content migration or automatic deletion.
