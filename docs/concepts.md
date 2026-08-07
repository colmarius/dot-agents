# Concepts

## Workflow

```text
Request or change
├─ Self-contained ───────────▶ Plan and execute in this conversation ─▶ Verify and report
└─ Continuity has value ─────▶ Work Item → Context as needed → Plan → Execute → Verify
                                                                    ├─ Hand off when useful
                                                                    └─ Promote → Commit snapshot → Remove
```

1. **Choose the path:** Keep small, self-contained planning and execution in the current conversation. Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit request makes repository context valuable.
2. **Work Item:** For durable work, create `.agents/work/<category>/<slug>/index.md` as the context entrypoint and canonical current state.
3. **Context:** Add optional context only when it helps: research for technical facts or `prd.md` when behavior needs alignment.
4. **Plan:** Break work into scoped tasks with dependencies, acceptance criteria, and planned verification.
5. **Execute:** Implement in the current thread by default. Delegate only when isolation, parallelism, durable follow-up, or another environment helps.
6. **Record Evidence:** Keep task completion in the plan, lifecycle state and canonical next action in `index.md`, and observed evidence in `progress.md` only when durability helps.
7. **Handoff When Useful:** Generate a proportional prompt only when another thread will execute a bounded slice. Permission to implement does not imply permission to commit, push, merge, deploy, or change shared state.
8. **Promote And Remove:** Move reusable outcomes to canonical homes, commit the final completed snapshot, then stage and separately commit removal. Git history is the archive.

The detailed artifact, status, handoff, and completion contract lives in [`.agents/work/AGENTS.md`](../.agents/work/AGENTS.md).

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
├── decisions/     # optional durable decisions
└── handoff-*.md   # optional reusable transition prompts
```

Create optional files only when they hold useful context. The required `index.md` should stay short and point to the current next action. A persisted `handoff-*.md` is a first-class optional artifact: link it in the artifact map, but do not create one by default or use it as a second plan.
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

- Implement Task 1 from plan.md.
```

Current and future threads start by reading `index.md`, then load only the plan, research, or progress they need.

`Why` preserves original intent while `Summary` changes with scope and status. Categories are open lowercase kebab-case values, so projects can use stable owners such as `platform`, `security`, or an application name instead of forcing work into `other`.

## Handoff Prompts

A handoff prompt is an optional paste-ready prompt for a new agent thread. Generate it in conversation by default and persist a separate, clearly named `handoff-*.md` only when reuse or durable transition context justifies it. Persisted handoffs are first-class in the artifact map, but are not a required lifecycle stage. Never embed a large execution prompt in the plan.

It should name:

- Canonical authority and current state.
- Goal, smallest implementation slice, scope limits, and non-goals.
- Expected outputs and newly observed versus inherited evidence.
- Verification, stop conditions, and escalation path.
- Exact delivery authority: implement, commit, push, open a pull request, merge, deploy, or other shared-state actions.

dot-agents does not assume a specific execution runtime. The work item is the continuity layer, and the coordinating thread remains responsible for integration and combined verification.

## Completion And Removal

Completed work items do not remain in the current tree by default:

1. Finish planned work and final verification.
2. Promote reusable outcomes to canonical code, docs, guidance, checks, skills, or `.agents/research/`.
3. Remove stale handoffs, set `Status: completed`, and set `## Next Action` to exactly `- None.`.
4. Commit the final snapshot.
5. Run `close-work.sh --check`, stage removal with `close-work.sh`, then commit that deletion separately.

The helper refuses dirty repositories and ignored or untracked work-item content; it never commits. Sync also never removes work items automatically. If a squash workflow would discard the final snapshot commit, land the snapshot before a follow-up deletion or keep the work item in the tree.

## Legacy Content

Older dot-agents installs used `.agents/plans/` and `.agents/prds/`. v0.3.0 preserves legacy plan and PRD documents as user content but no longer creates those paths on fresh install. See [migration guide](./migration-v0.3.md) for how to move active work into `.agents/work/`.

## Glossary

| Term | Definition |
| --- | --- |
| adapt | Skill that analyzes your project and fills in `AGENTS.md` |
| work item | Durable folder under `.agents/work/<category>/<slug>/` when continuity, coordination, auditability, decisions, or handoff justify repository context |
| task | Checkbox entry inside `plan.md` or a focused plan under `plans/` |
| PRD | Optional short requirements brief defining what should be true |
| plan | Implementation-ready task list with scope, dependencies, and acceptance criteria |
| handoff prompt | Paste-ready prompt for a fresh implementation thread |
| final snapshot | Committed `Status: completed` work-item state retained in git history immediately before removal |
| progress summary | Optional living `progress.md` for the current slice, observed verification evidence, blockers, and concise resumption detail |
| skills | Specialized agent instructions loaded via natural language |
| sync | Script that updates dot-agents from upstream while preserving user work |
