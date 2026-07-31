# Agent Work Guide

Guidance for durable work-item context under `.agents/work/`.

## Scope

Each work item lives at:

```text
.agents/work/<category>/<work-slug>/
```

Use work items for multi-session work where intent, context, plans, progress, decisions, and execution evidence should stay together. Keep `.agents/research/` for reusable cross-work findings.

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
  - `completed`: implementation and verification are done.
- Update `Updated:` whenever `Status:` or `Next Action` changes.
- Keep status in `index.md`; do not move folders between status directories.

## Artifact Rules

- `index.md`: required landing page with stable intent, current summary, artifact map, and next action.
- `research.md`: work-local synthesis when investigation mainly supports this work item.
- `research/`: optional folder for multiple focused research notes; add `research/index.md` as its map.
- `prd.md`: optional short requirements brief for user-facing, ambiguous, or cross-team work.
- `plan.md`: primary implementation-ready task plan.
- `plans/`: optional folder for multiple focused implementation plans; add `plans/index.md` as its map.
- `progress.md`: optional living execution summary for work spanning sessions or workers.
- `decisions/`: optional one-file-per-decision records when a decision should outlive chat context.

Do not create empty support folders by default. Add `research/`, `plans/`, `decisions/`, or other subfolders only when they hold useful files.

## Research Placement

Use work-local `research.md` when findings mainly explain this work item's implementation choices. Promote or duplicate a concise reusable synthesis to `.agents/research/` only when the findings are likely to guide future unrelated work.

## Planning And Progress

Work-local plans live at `plan.md` or under `plans/` and use the canonical agent-work plan contract. Implement in the current thread by default. When delegation helps, the coordinating thread owns scope, durable state, integration, and final acceptance unless a handoff explicitly assigns narrower artifact updates.

Keep task completion in plan checkboxes and lifecycle state in `index.md`. Use `progress.md` only when durable execution evidence helps resumption: keep `Current Slice`, `Verification Evidence`, optional `Blockers`, and `Next` current, and replace superseded detail instead of accumulating a transcript.

When `plans/` exists, keep `plans/index.md` and top-level `index.md` pointed at the active phase. If requirements change during execution, update the active plan before marking affected tasks complete.

## Handoff Prompts

When another implementation thread is useful, ask for a paste-ready handoff prompt that names the work item path, the active plan task or phase, scope limits, expected artifact updates, verification and proof targets, stop conditions, and expected final response. Handoff is optional, not a required lifecycle stage.

## Decisions

Create a file under `decisions/` only when a decision would otherwise be repeated across research, requirements brief, plan, and chat. Link to the decision file from other artifacts instead of restating the full rationale.
