# Agent Work Guide

Guidance for durable work-item context under `.agents/work/`.

## Scope

Each work item lives at:

```text
.agents/work/<category>/<work-slug>/
```

Use work items for multi-session work where context, plans, progress, decisions, and handoff prompts should stay together. Keep `.agents/research/` for reusable cross-work findings.

A work item is a *container of tasks*; task checklists live inside `plan.md` or focused plan files under `plans/`.

## Required Entrypoint

Every work item must have `index.md` with these metadata lines near the top:

```markdown
Status: researching | planned | in-progress | blocked | completed
Category: feature | bugfix | tech-debt | docs | tooling | research | other
Updated: YYYY-MM-DD
```

Read `index.md` first when entering a work item, then load only the artifacts needed for the current step.

## Status Rules

- Use `researching`, `planned`, `in-progress`, `blocked`, or `completed`:
  - `researching`: context exists, but no implementation-ready plan exists yet.
  - `planned`: `plan.md` or `plans/<name>.md` exists and is ready for a handoff prompt or implementation.
  - `in-progress`: implementation has started.
  - `blocked`: progress needs input, access, or plan changes before continuing.
  - `completed`: implementation and verification are done.
- Update `Updated:` whenever `Status:` or `Next Action` changes.
- Keep status in `index.md`; do not move folders between status directories.

## Artifact Rules

- `index.md`: required work-item landing page and current summary.
- `research.md`: work-local synthesis when investigation mainly supports this work item.
- `research/`: optional indexed folder for multiple focused research notes.
- `prd.md`: optional short requirements brief for user-facing, ambiguous, or cross-team work.
- `plan.md`: primary implementation-ready task plan.
- `plans/`: optional indexed folder for multiple focused implementation plans.
- `progress.md`: running implementation log, verification notes, blockers, and next actions.
- `decisions/`: optional one-file-per-decision records when a decision should outlive chat context.

Do not create empty support folders by default. Add `research/`, `plans/`, `decisions/`, or other subfolders only when they hold useful files.

## Research Placement

Use work-local `research.md` when findings mainly explain this work item's implementation choices. Promote or duplicate a concise reusable synthesis to `.agents/research/` only when the findings are likely to guide future unrelated work.

## Planning And Progress

Work-local plans live at `plan.md` or under `plans/` and use the canonical agent-work plan contract. A new implementation thread should update task checkboxes, append to `progress.md`, and refresh `index.md` when status, artifacts, or next action changes. When `plans/` exists, keep `index.md` pointed at the active plan file.

One active implementation thread should own a work item at a time. If `progress.md` conflicts, preserve both entries in chronological order and recompute the current `index.md` summary.

## Handoff Prompts

When preparing a new implementation thread, ask for a paste-ready handoff prompt that names the work item path, the active plan task or phase, scope limits, expected artifact updates, verification commands, stop conditions, and expected final response.

## Decisions

Create a file under `decisions/` only when a decision would otherwise be repeated across research, requirements brief, plan, and chat. Link to the decision file from other artifacts instead of restating the full rationale.
