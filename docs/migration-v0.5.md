# Migrating to v0.5

dot-agents v0.5.0 consolidates durable planning and execution into `agent-work`, retires the separate `feature-planning` and `tmux` core skills, makes the choice between conversational and durable work explicit, and adds guarded removal after completed work's reusable outcomes and final snapshots are preserved.

## Preview The Sync

First check which ref the installation tracks:

```bash
.agents/scripts/sync.sh --version
```

If it reports `Ref: main`, preview and apply the update normally:

```bash
.agents/scripts/sync.sh --diff
.agents/scripts/sync.sh
```

If it reports a pinned ref such as `Ref: v0.4.0`, the installed sync script intentionally stays on that ref. Preview and apply v0.5.0 explicitly instead:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/v0.5.0/install.sh \
  | bash -s -- --ref v0.5.0 --diff

curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/v0.5.0/install.sh \
  | bash -s -- --ref v0.5.0
```

The selected installation remains pinned to `v0.5.0`. In both paths, the preview exits non-zero when changes are pending. A v0.5 upgrade may report removal of `.agents/skills/feature-planning/`, `.agents/skills/tmux/`, and their dot-agents-managed Claude skill symlinks.

Sync continues to preserve work items, reusable research, legacy plan/PRD documents, custom skills with non-colliding names, and the customized root `AGENTS.md`.

## Workflow Changes

The workflow now chooses between two paths:

```text
Request or change
├─ Self-contained ───────────▶ Plan and execute in this conversation ─▶ Verify and report
└─ Continuity has value ─────▶ Work Item → Context as needed → Plan → Execute → Verify
                                                                    ├─ Hand off when useful
                                                                    └─ Promote → Commit snapshot → Remove
```

Keep a small, self-contained change in the current conversation. Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit request makes repository context valuable.

Current-thread execution remains the default. A handoff is optional and should state its canonical context, bounded slice, evidence expectations, stop conditions, and exact delivery authority.

## `feature-planning` Is Now Part Of `agent-work`

The separate `.agents/skills/feature-planning/` core skill is retired. Use `agent-work` for:

- durable requirements briefs;
- execution-ready plans;
- pre-implementation refinement;
- explicit plan stress testing;
- current-thread execution and resumption;
- coordinated workers and reviewers;
- optional fresh-thread handoffs.

The behavior moved into focused references under `.agents/skills/agent-work/references/` rather than being copied into a larger monolithic skill.

Research remains a separate core skill because standalone technical questions do not necessarily need work-item machinery or a saved artifact.

## What Sync Removes And Preserves

The current core skills are:

```text
adapt
agent-browser
agent-work
research
```

On sync:

- `.agents/skills/feature-planning/` is treated as retired upstream content, backed up under `.agents/.dot-agents-backup/`, and removed;
- `.agents/skills/tmux/` is backed up and removed; use current project or execution-environment process-management guidance instead;
- dot-agents-managed `.claude/skills/feature-planning` and `.claude/skills/tmux` symlinks are removed;
- a user-owned Claude skill directory or unrelated symlink is preserved;
- non-colliding custom skills remain in place and are reported;
- root `AGENTS.md` remains user-owned and is skipped.

If you intentionally maintained a substantially different custom skill under the upstream-owned `feature-planning` or `tmux` name, restore it from the backup and rename it before future syncs.

## Update A Customized Root `AGENTS.md`

Because sync does not overwrite root `AGENTS.md`, an existing project may still mention retired skills, retain completed work by default, or show a mandatory handoff workflow.

Run:

```text
Run adapt and update stale generic dot-agents workflow guidance for v0.5. Preserve project-specific instructions.
```

Or update it manually:

1. Remove direct references to `.agents/skills/feature-planning/SKILL.md`.
2. Route durable requirements, planning, refinement, execution, and handoffs through `agent-work`.
3. Remove generic references to the retired `tmux` skill and follow the project's or environment's current process-management guidance.
4. Keep small, self-contained planning and execution conversational.
5. Make work items conditional on continuity, coordination, handoff, auditability, durable decisions, or explicit request.
6. Keep handoffs optional rather than a mandatory lifecycle stage.
7. Describe completion as promotion, a committed final snapshot, and explicit removal—not sync cleanup.
8. Point detailed artifact and status rules to `.agents/work/AGENTS.md` instead of copying them.

`adapt` is instructed to repair only stale generic dot-agents sections while preserving project architecture, commands, safety rules, and intentional custom workflows.

## Artifact Ownership

v0.5 clarifies existing artifacts without renaming them:

- `index.md`: stable intent, lifecycle state, artifact map, open questions, and canonical next action;
- active plan: intended tasks, acceptance criteria, planned verification, and task checkboxes;
- `progress.md`: observed evidence, blockers, current slice, and concise resumption detail;
- `decisions/`: enduring choices and rationale;
- research: sourced facts, alternatives, recommendations, and uncertainty;
- `prd.md`: requirements alignment when the plan alone is insufficient;
- `handoff-*.md`: first-class but optional, separately named transition context when reuse or durability justifies it.

Do not create a handoff by default or embed a large execution prompt in the plan. Link a persisted handoff from `index.md`, keep it current, and remove it when stale.

## Completion And Removal

Completion now includes checking whether validated outcomes should be promoted to canonical docs, short always-relevant guidance, a reusable skill, a deterministic check, or reusable research.

After promotion and final verification:

1. Remove stale handoffs, set `Status: completed`, and set `## Next Action` to exactly `- None.`.
2. Commit all remaining scoped changes and the final work-item snapshot.
3. Run `close-work.sh --check`, then run it without `--check` to stage deletion.
4. Review and commit that deletion separately. The helper never commits.

Git history is the archive. If a squash workflow would discard the final snapshot commit, land that snapshot in retained history before a follow-up deletion or leave the item in the tree. Existing completed items are not removed during sync; close each one explicitly only after reviewing promotion and history safety.

## No Automatic User-Content Migration

v0.5 sync changes upstream workflow guidance and core-skill ownership. Sync does not rename, move, or delete work items, research, legacy plan/PRD documents, or canonical project data. Work-item removal happens only through the separately invoked guarded closeout helper.
