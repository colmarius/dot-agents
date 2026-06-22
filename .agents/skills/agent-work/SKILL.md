---
name: agent-work
description: "Creates and curates .agents/work/ work items. Use for durable indexes, artifacts, progress, migration, and new-thread handoffs. Triggers on: work item, agent work, new work item, list active work, handoff prompt."
---

# Agent Work

Create and maintain work items under `.agents/work/<category>/<work-slug>/` so context, plans, progress, decisions, and handoff prompts stay together for one piece of multi-session work.

A "work item" is a folder; the entries inside `plan.md` are the executable tasks.

## Workflow

1. **Check existing context**
   - Run `.agents/skills/agent-work/scripts/list-work.sh --all` or search `.agents/work/` before creating a new work item.
   - Read a work item's `index.md` first when continuing existing work.
2. **Create the work item**
   - Run `.agents/skills/agent-work/scripts/new-work.sh --category <category> --slug <work-slug> --title "<Work Item Title>"` from the repo root.
   - Create only `index.md` at first; do not add empty support folders.
3. **Place artifacts deliberately**
   - Use `research.md` for findings specific to this work item.
   - Use `.agents/research/` for reusable cross-work findings.
   - Use `prd.md` as a short requirements brief only when alignment is needed.
   - Use `plan.md` for implementation-ready tasks; copy `.agents/skills/agent-work/assets/plan-template.md` as a starting point.
   - Use `progress.md` for implementation notes, verification results, blockers, and next action.
   - Add `decisions/` only when durable decision records are worth linking.
4. **Keep `index.md` current**
   - Update `Status:`, `Updated:`, `Artifacts`, `Next Action`, and material `Open Questions` as the work item evolves.
   - Keep status in `index.md`; do not move work folders between status directories.
5. **Prepare handoffs when needed**
   - Use `feature-planning` to refine a stale or ambiguous plan.
   - Ask for a paste-ready handoff prompt before starting a new implementation thread.
   - A good handoff prompt names the work item path, active plan slice, scope limits, expected artifact updates, verification, stop conditions, and expected final response.

## Paths And Statuses

- Canonical path: `.agents/work/<category>/<work-slug>/`
- Category values: `feature`, `bugfix`, `tech-debt`, `docs`, `tooling`, `research`, `other`
- Categories are intentionally closed; use `other` when none fit.
- Required file: `index.md`
- Status values: `researching`, `planned`, `in-progress`, `blocked`, `completed`
- Optional files: `research.md`, `prd.md`, `plan.md`, `progress.md`
- Optional folders: `research/`, `decisions/`

Status meanings:

- `researching`: context exists, but no implementation-ready plan exists yet.
- `planned`: `plan.md` exists and is ready for a handoff prompt or implementation.
- `in-progress`: implementation has started.
- `blocked`: progress needs input, access, or plan changes before continuing.
- `completed`: implementation and verification are done.

See `.agents/work/AGENTS.md` for conventions automatically applied inside work items.

## Scripts

Run commands from the repository root.

```bash
.agents/skills/agent-work/scripts/new-work.sh \
  --category feature \
  --slug user-authentication \
  --title "User authentication"
```

```bash
.agents/skills/agent-work/scripts/list-work.sh
.agents/skills/agent-work/scripts/list-work.sh --all
.agents/skills/agent-work/scripts/list-work.sh --status blocked
```

## Legacy Plan Migration

Existing legacy plan and PRD documents are user content. Do not auto-migrate or delete them. Retired Ralph guidance/templates in those folders may be backed up and removed by sync.

When the user asks to migrate one legacy plan:

1. Create `.agents/work/<category>/<slug>/index.md`.
2. Copy the old plan to `plan.md`, preserving task checkboxes.
3. Copy a matching progress file to `progress.md` if it exists.
4. Copy or summarize a linked PRD into `prd.md` if still relevant.
5. Update `index.md` with status, artifacts, next action, and open questions.
6. Leave legacy files in place unless the user explicitly asks to delete them.

## Templates

- `assets/work-index-template.md`: starting point for `index.md`
- `assets/plan-template.md`: implementation-ready `plan.md` contract
- `assets/prd-template.md`: optional requirements brief (`prd.md`) structure
- `assets/work-decision-template.md`: optional decision record template

## Verification

- Confirm new work items contain `index.md` and no empty support folders.
- Run `.agents/skills/agent-work/scripts/list-work.sh --all` and confirm the work item appears with the expected status.
