# Concepts

## Workflow

```text
Work Item → Context as needed → Plan → Handoff Prompt → Implement → Record Progress
```

1. **Work Item:** Create `.agents/work/<category>/<slug>/index.md` as the durable context entrypoint.
2. **Context:** Add optional context only when it helps: `research.md` for technical facts, or `prd.md` as a short requirements brief when behavior needs alignment.
3. **Plan:** Break work into implementation-ready tasks in `plan.md` with scope, dependencies, and acceptance criteria.
4. **Handoff Prompt:** Ask an agent to write a paste-ready prompt for a fresh implementation thread.
5. **Implement:** Paste the prompt into the new thread and let that agent do the scoped work.
6. **Record Progress:** Update `progress.md`, task checkboxes, and `index.md` so future threads can resume.

Context is optional. Use `research.md` when the question is "what is true?" Use `prd.md` as a requirements brief when the question is "what should be true?" Skip both when the plan can state the goal and acceptance criteria clearly.

## Work Item Shape

```text
.agents/work/<category>/<slug>/
├── index.md       # required landing page
├── research.md    # optional, work-specific findings
├── prd.md         # optional requirements brief
├── plan.md        # optional implementation-ready tasks
├── progress.md    # optional implementation log
└── decisions/     # optional durable decisions
```

Create optional files only when they hold useful context. The required `index.md` should stay short and point to the current next action.

## Handoff Prompts

A handoff prompt is a paste-ready prompt for a new agent thread. It should name:

- Work item path and files to read first.
- Goal, current state, and exact implementation slice.
- Scope limits and non-goals.
- Required updates to `plan.md`, `progress.md`, and `index.md`.
- Verification commands and stop conditions.
- Expected final response shape.

dot-agents does not assume a specific execution runtime. The work item is the continuity layer.

## Legacy Content

Older dot-agents installs used `.agents/plans/` and `.agents/prds/`. v0.3.0 preserves legacy plan and PRD documents as user content but no longer creates those paths on fresh install. See [migration guide](./migration-v0.3.md) for how to move active work into `.agents/work/`.

## Glossary

| Term | Definition |
| --- | --- |
| adapt | Skill that analyzes your project and fills in `AGENTS.md` |
| work item | Durable folder under `.agents/work/<category>/<slug>/` for one multi-session effort |
| task | Checkbox entry inside `plan.md` |
| PRD | Optional short requirements brief defining what should be true |
| plan | Implementation-ready task list with scope, dependencies, and acceptance criteria |
| handoff prompt | Paste-ready prompt for a fresh implementation thread |
| progress log | `progress.md`, the implementation log for changes, verification, blockers, and next action |
| skills | Specialized agent instructions loaded via natural language |
| sync | Script that updates dot-agents from upstream while preserving user work |
