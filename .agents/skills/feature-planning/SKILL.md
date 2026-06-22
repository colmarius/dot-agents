---
name: feature-planning
description: "Turns research and PRDs into implementation-ready plans and paste-ready handoff prompts. Use for planning, plan refinement, and new-thread prompts. Triggers on: plan, PRD, feature planning, handoff prompt, stress-test design."
---

# Feature Planning

Manage work-item planning from rough intent through PRD, implementation-ready plan, and paste-ready prompt for a fresh implementation thread.

## Workflow Overview

```text
Work Item → Research/PRD as needed → Plan → Refine → Handoff Prompt → Implement → Record Progress
```

1. **Work item**: Use `agent-work` to create or locate `.agents/work/<category>/<work-slug>/`.
2. **Research**: Save task-specific findings in the work item and reusable findings in `.agents/research/`.
3. **PRD**: Create `prd.md` only when requirements need durable alignment.
4. **Plan**: Create or update `plan.md` with scoped tasks, dependencies, and acceptance criteria.
5. **Refine**: Validate assumptions against current repo reality before implementation.
6. **Handoff prompt**: Produce a paste-ready prompt for the next implementation thread.
7. **Progress**: The implementation thread updates task checkboxes, `progress.md`, and `index.md`.

## Plan Locations

New plans live inside work items:

```text
.agents/work/<category>/<work-slug>/
├── index.md
├── research.md
├── prd.md
├── plan.md
└── progress.md
```

Legacy standalone plan and PRD documents are user content. Migrate one at a time into `.agents/work/` only when requested. Retired Ralph guidance/templates may be backed up and removed by sync.

## PRD Guidance

Create `prd.md` when work is user-facing, ambiguous, cross-team, or likely to span multiple sessions. Use the [agent-work PRD template](../agent-work/assets/prd-template.md).

Skip the PRD for small scoped fixes when the desired behavior and acceptance criteria are already clear.

## Plan Guidance

Use the [agent-work plan template](../agent-work/assets/plan-template.md). Keep plans implementation-ready:

- Each task has `Scope`, `Depends on`, and verifiable `Acceptance`.
- The next task or phase is obvious.
- Scope limits and verification commands are explicit when not obvious.
- Blockers, manual steps, and risky assumptions are called out.
- Tasks are small enough to review independently.

For larger work, prefer an early thin slice that proves the end-to-end path before broad hardening.

## Pre-Implementation Refinement

Use this before writing a handoff prompt when work is multi-phase, ambiguous, or stale.

1. Read the work item's `index.md` and active `plan.md`.
2. Read relevant `research.md`, `prd.md`, and decisions only as needed.
3. Validate key assumptions against current code, dependencies, and test setup.
4. Resolve material open questions with repo evidence where possible; ask the user only for decisions the repo cannot answer.
5. If a planned task is already satisfied, record evidence and update the plan instead of creating no-op work.
6. Update `plan.md`, `progress.md`, and `index.md` when refinement changes the next action or known constraints.

Skip the full pass for small, obvious changes where the plan and repo state are already aligned.

## New-Thread Handoff Prompt

Use this mode when asked to write a prompt for a new thread, implementation handoff, or continuation. Produce a paste-ready prompt; do not implement the work yourself unless the user explicitly asks.

The prompt should include:

1. Work item path.
2. Files to read first.
3. Goal and current state.
4. Exact task, phase, or slice to implement.
5. Scope limits and non-goals.
6. Artifact update contract for `plan.md`, `progress.md`, and `index.md`.
7. Verification commands or manual checks.
8. Stop conditions.
9. Expected final response format.

Use this template:

```text
You are continuing the work item at:

.agents/work/<category>/<slug>/

Read first:
1. .agents/work/<category>/<slug>/index.md
2. .agents/work/<category>/<slug>/plan.md
3. Relevant artifacts linked from index.md

Goal:
<one-paragraph goal>

Current state:
<what is already done, plus branch/commit/thread anchors if useful>

Implement only this slice:
- <Task N / phase / exact acceptance criteria>

Scope limits:
- Touch only <paths/modules> unless the plan proves the scope is wrong.
- Do not broaden the feature.
- If the plan is stale, update the plan and explain why before implementing.

Progress contract:
- Update completed task checkboxes in plan.md.
- Append or update progress.md with changes, verification, blockers, and next action.
- Update index.md Status, Updated, Artifacts, and Next Action when they change.

Verification:
- Run <commands>.
- If verification cannot run, record why and what remains unverified.

Stop conditions:
- Stop and report if blocked by missing decisions, credentials, unsafe migrations, unrelated failing tests, or scope expansion.

Expected final response:
- Summary of changes
- Files changed
- Verification results
- Work item updates made
- Remaining next action
```

## Stress-Test Mode

Use this only when the user explicitly asks to stress-test, grill, or walk decision branches.

1. Inspect the existing PRD, plan, repo docs, and relevant code first.
2. Ask one highest-leverage unresolved question at a time.
3. Provide a recommended default answer and brief rationale for each question.
4. Capture outcomes in `prd.md`, `plan.md`, or `index.md`.
5. Exit once remaining ambiguity no longer materially changes scope, sequencing, or architecture.

## Definition Of Done

Planning is done when the work item has a current `index.md`, required context artifacts, an implementation-ready `plan.md`, and either a clear next action or a paste-ready handoff prompt.
