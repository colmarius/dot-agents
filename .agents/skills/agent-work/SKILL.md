---
name: agent-work
description: "Creates and curates .agents/work/ work items and coordinates execution. Use for durable intent, plans, progress, delegation, and handoffs. Triggers on: work item, agent work, implement work item, list active work, execution handoff."
---

# Agent Work

Create and maintain work items under `.agents/work/<category>/<work-slug>/` so intent, context, plans, progress, decisions, and execution evidence stay together for one piece of multi-session work.

A "work item" is a folder; entries inside `plan.md` or focused files under `plans/` are the executable tasks.

## Workflow

1. **Check existing context**
   - Run `.agents/skills/agent-work/scripts/list-work.sh --all` or search `.agents/work/` before creating a new work item.
   - Read a work item's `index.md` first when continuing existing work.
   - When `research/` or `plans/` contains multiple durable files, read its `index.md` before leaf files.
2. **Create the work item**
   - Run `.agents/skills/agent-work/scripts/new-work.sh --category <category> --slug <work-slug> --title "<Work Item Title>"` from the repo root.
   - Use any lowercase kebab-case category that gives the work a stable project or domain owner. Common defaults include `feature`, `bugfix`, `tech-debt`, `docs`, `tooling`, and `research`.
   - Create only `index.md` at first; do not add empty support folders.
3. **Place artifacts deliberately**
   - Use `research.md` for findings specific to this work item.
   - Use `research/` with `research/index.md` for multiple focused research notes specific to this work item.
   - Use `.agents/research/` for reusable cross-work findings.
   - Use `prd.md` as a short requirements brief only when alignment is needed.
   - Use `plan.md` for the primary implementation-ready task plan; copy `.agents/skills/agent-work/assets/plan-template.md` as a starting point.
   - Use `plans/` with `plans/index.md` when multiple phases need focused plans; link the active phase from the work-item index.
   - Use `progress.md` as an optional living summary for work spanning sessions or workers. Keep current slice, verification evidence, blockers, and next action; replace superseded detail instead of appending a transcript.
   - Add `decisions/` only when a choice constrains later work or should survive plan rewrites.
4. **Keep `index.md` current**
   - Keep `Why` stable as the original intent. Update `Summary`, `Status:`, `Updated:`, `Artifacts`, `Next Action`, and material `Open Questions` as the work evolves.
   - When `plans/` exists, point `index.md` and handoff prompts to the active plan file.
   - Keep status in `index.md`; do not move work folders between status directories.
5. **Execute or hand off**
   - Use `feature-planning` to refine a stale or ambiguous plan.
   - Execute the active plan in the current thread by default and load project-specific implementation or verification skills as needed.
   - Delegate only when isolation, parallelism, durable follow-up, or a different execution environment genuinely helps. Follow **Coordinating Workers And Reviewers** below.
   - Ask for a paste-ready handoff prompt when a fresh implementation thread is useful.
   - A good handoff prompt names the work item path, active plan slice, scope limits, expected artifact updates, verification, stop conditions, and expected final response.
6. **Finish the work**
   - Reconcile plan checkboxes and verification evidence, set `Status: completed`, update `Updated:`, and set `Next Action` to `None` when implementation and verification are done.

## Coordinating Workers And Reviewers

- The coordinating thread owns scope, durable work-item state, integration, and final acceptance.
- Brief every fresh worker as if it has none of the current thread's context.
- Parallelize only clearly independent work with one writer per worktree and disjoint targets across concurrent environments.
- Never accept a delegated report alone: inspect the resulting changes and evidence, then run combined verification.
- Before assigning multiple workers, a resumable worker, or a worker/reviewer loop, read [references/coordinated-execution.md](references/coordinated-execution.md).

## Paths And Statuses

- Canonical path: `.agents/work/<category>/<work-slug>/`
- Category values: any lowercase kebab-case project, product, domain, or work-type owner; common defaults are `feature`, `bugfix`, `tech-debt`, `docs`, `tooling`, and `research`.
- Required file: `index.md`
- Status values: `researching`, `planned`, `in-progress`, `blocked`, `completed`
- Optional files: `research.md`, `prd.md`, `plan.md`, `progress.md`
- Optional folders: `research/`, `plans/`, `decisions/`

Status meanings:

- `researching`: context exists, but no implementation-ready plan exists yet.
- `planned`: `plan.md` or an indexed phase under `plans/` exists and is ready for implementation or handoff.
- `in-progress`: implementation has started in the current thread or a delegated worker.
- `blocked`: progress needs input, access, or plan changes before continuing.
- `completed`: implementation and verification are done.

See `.agents/work/AGENTS.md` for conventions automatically applied inside work items.

## Scripts

Run commands from the repository root.

```bash
.agents/skills/agent-work/scripts/new-work.sh \
  --category platform \
  --slug user-authentication \
  --title "User authentication"
```

```bash
.agents/skills/agent-work/scripts/list-work.sh
.agents/skills/agent-work/scripts/list-work.sh --all
.agents/skills/agent-work/scripts/list-work.sh --status blocked
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
- `references/coordinated-execution.md`: runner-neutral worker and reviewer coordination

## Verification

- Confirm new work items contain `index.md` and no empty support folders.
- Run `.agents/skills/agent-work/scripts/list-work.sh --all` and confirm the work item appears with the expected status.
- Confirm verification records observed results and explicitly identifies anything that remains unverified.
