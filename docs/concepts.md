# Concepts

## Workflow

```text
Work Item → Context as needed → Plan → Execute → Record Evidence
                                      └─ Hand off when useful
```

1. **Work Item:** Create `.agents/work/<category>/<slug>/index.md` as the durable context entrypoint.
2. **Context:** Add optional context only when it helps: `research.md` or `research/` for technical facts, or `prd.md` as a short requirements brief when behavior needs alignment.
3. **Plan:** Break work into implementation-ready tasks in the active plan file (`plan.md` by default, or `plans/<name>.md` for focused plans) with scope, dependencies, and acceptance criteria.
4. **Execute:** Implement in the current thread by default. Delegate only when isolation, parallelism, durable follow-up, or another environment helps.
5. **Record Evidence:** Update plan task checkboxes and `index.md`; keep living `progress.md` when work spans sessions or workers.
6. **Handoff When Useful:** Generate a paste-ready prompt only when another thread will execute a bounded slice.

Use work items for multi-session or context-heavy work. For a tiny one-shot edit, you may not need one.

Context is optional. Use `research.md` when the question is "what is true?" Use `research/` when multiple focused research notes are useful. Use `prd.md` as a requirements brief when the question is "what should be true?" Skip both when the plan can state the goal and acceptance criteria clearly.

## Work Item Shape

```text
.agents/work/<category>/<slug>/
├── index.md       # required landing page
├── research.md    # optional, work-specific findings
├── research/      # optional focused notes with research/index.md
├── prd.md         # optional requirements brief
├── plan.md        # optional primary implementation-ready tasks
├── plans/         # optional focused plans with plans/index.md
├── progress.md    # optional living execution summary
└── decisions/     # optional durable decisions
```

Create optional files only when they hold useful context. The required `index.md` should stay short and point to the current next action.
Create optional folders like `research/`, `plans/`, and `decisions/` only when they contain useful files.

## Example Work Item

```text
.agents/work/feature/user-authentication/
├── index.md      # status, summary, next action
└── plan.md       # implementation tasks, when useful
```

```markdown
# User authentication

Status: planned
Category: feature
Updated: 2026-06-22

## Why

Users need secure access across sessions.

## Summary

Add auth flows and session persistence.

## Next Action

Implement Task 1 from plan.md.
```

Current and future threads start by reading `index.md`, then load only the plan, research, or progress they need.

`Why` preserves original intent while `Summary` changes with scope and status. Categories are open lowercase kebab-case values, so projects can use stable owners such as `platform`, `security`, or an application name instead of forcing work into `other`.

## Handoff Prompts

A handoff prompt is an optional paste-ready prompt for a new agent thread. It should name:

- Work item path and files to read first.
- Goal, current state, and exact implementation slice.
- Scope limits and non-goals.
- Required updates to the active plan file, `progress.md`, and `index.md`.
- Verification commands and stop conditions.
- Expected final response shape.

dot-agents does not assume a specific execution runtime. The work item is the continuity layer, and the coordinating thread remains responsible for integration and combined verification.

## Legacy Content

Older dot-agents installs used `.agents/plans/` and `.agents/prds/`. v0.3.0 preserves legacy plan and PRD documents as user content but no longer creates those paths on fresh install. See [migration guide](./migration-v0.3.md) for how to move active work into `.agents/work/`.

## Glossary

| Term | Definition |
| --- | --- |
| adapt | Skill that analyzes your project and fills in `AGENTS.md` |
| work item | Durable folder under `.agents/work/<category>/<slug>/` for one multi-session effort |
| task | Checkbox entry inside `plan.md` or a focused plan under `plans/` |
| PRD | Optional short requirements brief defining what should be true |
| plan | Implementation-ready task list with scope, dependencies, and acceptance criteria |
| handoff prompt | Paste-ready prompt for a fresh implementation thread |
| progress summary | Optional living `progress.md` for the current slice, verification evidence, blockers, and next action |
| skills | Specialized agent instructions loaded via natural language |
| sync | Script that updates dot-agents from upstream while preserving user work |
