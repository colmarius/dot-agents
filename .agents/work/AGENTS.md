# Agent Work Guide

Guidance for durable work-item context under `.agents/work/`.

## Scope

Each work item lives at:

```text
.agents/work/<category>/<work-slug>/
```

Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit user request justifies repository context. Keep small, self-contained planning and execution in the current conversation.

Keep `.agents/research/` for reusable cross-work findings. Do not use a work item as a shadow location for canonical product data, documentation, or generated application artifacts. Completed work items are preserved in git history and removed from the current tree after reusable outcomes are promoted.

A work item is a *container of tasks*; task checklists live inside `plan.md` or focused plan files under `plans/`.

## Required Entrypoint

Every work item must have `index.md` with these metadata lines near the top:

```markdown
Status: researching | planned | in-progress | blocked | completed
Category: <lowercase-kebab-case project, product, domain, or work type>
Updated: YYYY-MM-DD
```

Categories are an open namespace. Reuse a stable project or domain owner when possible; common work-type defaults include `feature`, `bugfix`, `tech-debt`, `docs`, `tooling`, and `research`.

New indexes contain `## Why` for stable original intent and `## Summary` for evolving current state and scope. Do not rewrite `Why` as execution progresses or mechanically backfill old work items.

Read `index.md` first when entering a work item, then load only the artifacts needed for the current step.

## Status Rules

- Use `researching`, `planned`, `in-progress`, `blocked`, or `completed`:
  - `researching`: context exists, but no implementation-ready plan exists yet.
  - `planned`: `plan.md` or an indexed phase under `plans/` exists and is ready for implementation or handoff.
  - `in-progress`: implementation has started in the current thread or a delegated worker.
  - `blocked`: progress needs input, access, or plan changes before continuing.
  - `completed`: implementation and verification are done; this is a committed final snapshot immediately before removal, not a retained state.
- Update `Updated:` whenever `Status:` or `Next Action` changes.
- Keep status in `index.md`; do not move folders between status directories.
- `index.md` alone owns lifecycle status and the canonical next action. Keep work `blocked` when it awaits approval or a separately scoped follow-up. A `completed` item must use exactly `- None.` under `## Next Action` so closeout can validate it.

## Artifact Ownership

- `index.md`: required landing page. It owns stable intent in `Why`, lifecycle status, current summary, artifact links, material open questions, and the canonical next action.
- `research.md`: optional work-local synthesis of sourced facts, alternatives, constraints, recommendations, and uncertainty.
- `research/`: optional folder for multiple focused research notes; add `research/index.md` as its map.
- `prd.md`: optional requirements and behavioral alignment when the active plan alone is insufficient.
- `plan.md`: primary implementation-ready plan. It owns intended tasks, scope, dependencies, constraints, acceptance criteria, planned verification, and task checkboxes.
- `plans/`: optional folder for multiple focused implementation plans; add `plans/index.md` as its map.
- `progress.md`: optional living execution summary. It owns the current slice, observed verification evidence, blockers, and concise resumption detail; it does not own lifecycle status or a second canonical next action.
- `decisions/`: optional one-file-per-decision records for choices and rationale that must survive plan rewrites or would otherwise be repeated.
- `handoff-*.md`: optional, clearly named, reusable handoff prompts when a transition must survive or be reused. Keep them separate from plans and link them from `index.md`; do not add one by default.

Do not create empty support folders by default. Add `research/`, `plans/`, `decisions/`, or other subfolders only when they hold useful files.

## Research Placement

Use work-local `research.md` when findings mainly explain this work item's implementation choices. Promote or duplicate a concise reusable synthesis to `.agents/research/` only when the findings are likely to guide future unrelated work.

## Planning And Progress

Work-local plans live at `plan.md` or under `plans/` and use the canonical agent-work plan contract. Implement in the current thread by default. When delegation helps, the coordinating thread owns scope, durable state, integration, and final acceptance unless a handoff explicitly assigns narrower artifact updates.

Keep task completion in plan checkboxes and lifecycle state in `index.md`. Use `progress.md` only when durable execution evidence helps resumption, and replace superseded detail instead of accumulating a transcript. The plan's `Verification` says what should be checked; progress records what was actually observed and what remains unverified.

When `plans/` exists, keep `plans/index.md` and top-level `index.md` pointed at the active phase. If requirements change during execution, update the active plan before marking affected tasks complete.

## Handoff Prompts

Handoff is optional, not a required lifecycle stage. Generate a paste-ready prompt in conversation by default. Persist it as a separate `handoff-*.md` only when reuse or durable transition context justifies another artifact; never embed a large execution prompt in the plan.

A handoff names the canonical state, smallest implementation slice, boundaries and non-goals, expected outputs, newly observed versus inherited evidence, stop conditions, and exact delivery authority. Permission to implement does not imply permission to commit, push, open or merge a pull request, deploy, migrate, or change shared state.

## Decisions

Create a file under `decisions/` only when a decision would otherwise be repeated across research, requirements brief, plan, and chat. Link to the decision file from other artifacts instead of restating the full rationale.

## Completion And Removal

After implementation and verification are complete:

1. Reconcile plan checkboxes with observed evidence.
2. Promote validated outcomes to canonical code or docs, short always-relevant guidance, a reusable skill, a deterministic check, or `.agents/research/` when they should outlive this work item.
3. Remove stale persisted handoffs, set `Status: completed`, update `Updated:`, and set `## Next Action` to exactly `- None.`.
4. Commit all remaining scoped changes and the final work-item snapshot.
5. Run `.agents/skills/agent-work/scripts/close-work.sh --category <category> --slug <work-slug> --check`, then rerun without `--check` to stage the work-item deletion. Commit that deletion separately.

The helper requires repository-root execution, a clean worktree, a committed final snapshot, and no ignored or untracked files under the work item. It stages only the deletion and never commits. Run it only with authority to commit closeout; otherwise leave the completed snapshot in place.

Git history is the archive. If a squash workflow would discard the completed snapshot commit, land that snapshot in retained history before a follow-up deletion, or keep the work item in the tree.
