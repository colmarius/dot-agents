---
name: agent-work
description: "Manages durable work items, plans, execution, and handoffs. Use when repository context must survive or coordinate work. Triggers on: create work item, implement work item, requirements brief, refine plan, handoff prompt, stress-test plan."
---

# Agent Work

Manage durable work under `.agents/work/<category>/<work-slug>/`, from requirements and planning through execution, evidence, handoffs, and completion.

Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit user request justifies repository context. Keep small, self-contained planning and execution in the current conversation. A work item is a folder; entries inside its plan are the executable tasks.

## Workflow

1. **Choose conversational or durable work**
   - For a self-contained request, plan, implement, verify, and report in the current conversation without creating repository artifacts.
   - For durable work, check existing context before creating anything.
2. **Locate or create the work item**
   - Run `.agents/skills/agent-work/scripts/list-work.sh --all` or search `.agents/work/` before creating a new work item.
   - Read a work item's `index.md` first when continuing existing work.
   - When `research/` or `plans/` contains multiple durable files, read its `index.md` before leaf files.
   - Run `.agents/skills/agent-work/scripts/new-work.sh --category <category> --slug <work-slug> --title "<Work Item Title>"` from the repo root.
   - Create only `index.md` at first; do not add empty support folders.
3. **Build only the context the work needs**
   - Follow the [work-item contract](../../work/AGENTS.md) for artifact ownership, status, and lifecycle rules.
   - Use `research` for technical facts. Create a requirements brief only when behavior or alignment is unclear.
   - Follow [plan refinement and execution](references/plan-execution.md) to create, refine, stress-test, execute, or resume a plan.
4. **Keep durable state current**
   - Keep `Why` stable as the original intent. Update `Summary`, `Status:`, `Updated:`, `Artifacts`, `Next Action`, and material `Open Questions` as the work evolves.
   - When `plans/` exists, point `index.md` and handoff prompts to the active plan file.
5. **Execute or hand off**
   - Execute the active plan in the current thread by default and load project-specific implementation or verification skills as needed.
   - Delegate only when isolation, parallelism, durable follow-up, or a different execution environment genuinely helps. Follow **Coordinating Workers And Reviewers** below.
   - Follow [handoff context](references/handoff-context.md) when a fresh thread or worker is useful.
6. **Finish the work**
   - Reconcile plan checkboxes and observed evidence, promote reusable outcomes, and follow **Completing And Removing Work Items**.

## Coordinating Workers And Reviewers

- The coordinating thread owns scope, durable work-item state, integration, and final acceptance.
- Brief every fresh worker as if it has none of the current thread's context.
- Parallelize only clearly independent work with one writer per worktree and disjoint targets across concurrent environments.
- Never accept a delegated report alone: inspect the resulting changes and evidence, then run combined verification.
- Before assigning multiple workers, a resumable worker, or a worker/reviewer loop, read [references/coordinated-execution.md](references/coordinated-execution.md).

## Work-Item Contract

Follow [`.agents/work/AGENTS.md`](../../work/AGENTS.md) for canonical paths, statuses, artifact ownership, lifecycle invariants, and completion semantics. Keep this skill focused on actions and routing rather than copying that contract.

## Closing Completed Work

Close a work item only after implementation and verification are finished. First promote anything worth retaining, discard obsolete handoffs, and make the index final: it must say `Status: completed`, and `## Next Action` must contain only `- None.`. Commit that snapshot with the implementation before removing the folder.

Use `close-work.sh --check` as the closeout preflight. If it succeeds, rerun the command without `--check`; it stages the folder removal but does not create a commit. Record that staged removal in its own commit so the preceding snapshot remains reachable in history.

Closeout requires authority to commit the removal. The command rejects dirty repositories and leaves ignored or untracked material untouched. When planned history rewriting would erase the final snapshot, either preserve it on a retained ref or keep the completed folder in the tree.

## Scripts

Run commands from the repository root.

```bash
# Create a work item
.agents/skills/agent-work/scripts/new-work.sh \
  --category platform \
  --slug user-authentication \
  --title "User authentication"

# Inspect current work
.agents/skills/agent-work/scripts/list-work.sh
.agents/skills/agent-work/scripts/list-work.sh --all
.agents/skills/agent-work/scripts/list-work.sh --status blocked

# Validate a completed item before removal
.agents/skills/agent-work/scripts/close-work.sh \
  --category platform \
  --slug user-authentication \
  --check
```

## Legacy Plans

Existing legacy `.agents/plans/` and `.agents/prds/` documents are user content. Do not auto-migrate or delete them.

When the user asks to migrate one legacy plan:

1. Create `.agents/work/<category>/<slug>/index.md`.
2. Copy the old plan to `plan.md`, preserving task checkboxes.
3. Copy a matching progress file to `progress.md` if it exists.
4. Copy or summarize a linked PRD into `prd.md` if still relevant.
5. Update `index.md` with status, artifacts, next action, and open questions.
6. Leave legacy files in place unless the user explicitly asks to delete them.

Full upstream guide: [migration-v0.3](https://github.com/colmarius/dot-agents/blob/main/docs/migration-v0.3.md).

## Templates

- `assets/work-index-template.md`: starting point for `index.md`
- `assets/plan-template.md`: implementation-ready `plan.md` contract
- `assets/prd-template.md`: optional requirements brief (`prd.md`) structure
- `assets/work-decision-template.md`: optional decision record template
- `references/plan-execution.md`: requirements, planning, refinement, stress testing, and execution
- `references/handoff-context.md`: proportional fresh-thread and worker handoffs
- `references/coordinated-execution.md`: runner-neutral worker and reviewer coordination

## Verification

- Confirm new work items contain `index.md` and no empty support folders.
- Run `.agents/skills/agent-work/scripts/list-work.sh` and confirm the work item appears with the expected status.
- Confirm verification records observed results and explicitly identifies anything that remains unverified.
- For closeout, run `close-work.sh --check` before staging the deletion.
