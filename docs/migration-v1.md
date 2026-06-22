# Migration Guide: Work Items and Handoff Prompts

dot-agents v0.3.0 replaces the old `.agents/plans/` / `.agents/prds/` / Ralph workflow with durable work items and paste-ready handoff prompts.

## What Changed

Fresh installs now create:

```text
.agents/work/
.agents/research/
.agents/references/
.agents/skills/{adapt,agent-work,feature-planning,research,tmux}/
```

Fresh installs no longer create:

```text
.agents/plans/
.agents/prds/
.agents/skills/ralph/
```

Existing legacy plan and PRD documents, `.agents/research/`, and legacy `.agents/reference/` content are preserved on sync. Retired Ralph support is backed up and removed so stale guidance does not conflict with the new workflow. This includes `.agents/skills/ralph`, `.agents/plans/AGENTS.md`, `.agents/prds/AGENTS.md`, and old plan/PRD templates. Any `.agents/skills/ralph` directory is treated as retired upstream content, even if it was locally edited; restore it from `.agents/.dot-agents-backup/` and rename it only if you intentionally want to keep a custom skill with that behavior.

v0.3.0 does not ship a Ralph compatibility layer, alias, or stub skill. Pin to `v0.2.0` only if you need the old runner workflow for an existing project.

Use `--diff` before syncing to preview pending installs, updates, removals, and conflicts without modifying files; it exits non-zero when any change is pending. Use `--write-conflicts` to write conflicts beside the original: Markdown conflicts use `file.dot-agents.md`, while other files use `file.ext.dot-agents.new`.

The preferred external-reference path is now `.agents/references/`. Existing `.agents/reference/` checkouts remain ignored so large local clones are not accidentally committed. Rename them manually when convenient.

## Migrate One Legacy Plan

Ask your agent:

```text
Migrate legacy plan .agents/plans/in-progress/<plan>.md into a new work item.

Create .agents/work/<category>/<slug>/index.md.
Copy the old plan to plan.md, preserving task checkboxes.
If there is a matching .progress.md file, copy it to progress.md.
If the plan links a PRD under .agents/prds/, copy or summarize it into prd.md.
Update index.md with Status, Artifacts, Next Action, and Open Questions.
Do not delete the legacy files unless I explicitly ask.
```

## Status Mapping

| Legacy location | New `index.md` status |
| --- | --- |
| `.agents/plans/todo/` | `planned` |
| `.agents/plans/in-progress/` | `in-progress` |
| `.agents/plans/completed/` | `completed` |
| PRD only | `researching` or `planned`, depending whether a plan exists |

## After Migration

Ask for a handoff prompt:

```text
Review .agents/work/<category>/<slug> and write a paste-ready handoff prompt for the next implementation thread.
```

Paste the generated prompt into a fresh thread. The implementation thread should update `plan.md`, `progress.md`, and `index.md` as it works.
