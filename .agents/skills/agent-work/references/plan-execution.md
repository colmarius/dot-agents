# Plan Refinement And Execution

Use this reference to create requirements and plans, refine ambiguous or stale work, stress-test a plan when explicitly requested, or execute and resume planned work.

## Requirements Brief

Most work does not need a PRD. For durable work, create `prd.md` only when the missing context is requirements alignment: users, behavior, goals, non-goals, acceptance, rollout, or stakeholder decisions. Use [`../assets/prd-template.md`](../assets/prd-template.md). Keep a self-contained requirements discussion in the conversation.

Use research for technical discovery. If the goal and acceptance criteria fit naturally in the active plan, skip the requirements brief.

## Create An Execution-Ready Plan

For a durable work item, use [`../assets/plan-template.md`](../assets/plan-template.md) and follow its artifact checklist. A conversational plan follows the same task, acceptance, and verification principles without creating files or work-item metadata.

Keep plans implementation-ready:

- Each task has `Scope`, `Depends on`, and verifiable `Acceptance`.
- The next task or phase is obvious.
- Scope limits, blockers, manual steps, and risky assumptions are explicit.
- Tasks are small enough to review independently.
- Verification matches the likely failure mode and names running-system or manual proof when automated checks are insufficient.
- Deployment, migration, ordering, approval, and rollback steps are explicit when the change touches a release surface.

For larger work, prefer an early thin slice that proves the end-to-end path before broad hardening.

## Pre-Implementation Refinement

Use this before implementation or handoff when work is multi-phase, ambiguous, or stale.

1. For a work item, read `index.md`, then the active plan and only the research or decisions relevant to the next slice.
2. Validate material assumptions against the current codebase, dependencies, and test setup.
3. Resolve questions the repository can answer. Ask the user only for decisions the available evidence cannot supply.
4. If a task is already satisfied, record the evidence and update the plan instead of adding no-op work.
5. Update affected acceptance criteria, decisions, and blockers before implementation. For a work item, also update the canonical `index.md` next action.

Skip the full pass for small, obvious changes whose plan and repository state already align.

## Stress-Test Mode

Enter this mode only when the user explicitly asks to stress-test, grill, or walk decision branches.

1. Inspect the requirements, plan, relevant documentation, and code before asking questions.
2. Ask one highest-leverage unresolved question at a time.
3. Give a recommended default and brief rationale with each question.
4. Record outcomes in the requirements, plan, or a durable decision when they affect later work.
5. Stop when remaining ambiguity no longer changes scope, sequencing, or architecture.

This mode may refine a self-contained in-conversation plan without creating a work item.

## Execute Or Resume

1. Select the smallest incomplete slice that preserves acceptance criteria and dependency order.
2. Implement only that slice and run verification targeted at its likely failure mode. Broaden checks at meaningful phase or release boundaries.
3. Reconcile the plan with observed results; for durable work, update plan checkboxes and progress when present. Do not accept inherited or delegated verification claims without checking the evidence.
4. At phase boundaries, reassess whether new evidence requires smaller scope, reordered tasks, or updated rollout steps.
5. For a work item, keep lifecycle status and the canonical next action in `index.md`; use `progress.md` only for observed evidence and concise resumption detail. For conversational work, report the observed result and remaining action directly.

Plan execution does not itself authorize commits, pushes, deployments, migrations, or shared-state changes. Preserve the user's or handoff's delivery authority.

## Definition Of Ready

Planning is ready for execution when required context exists, the active plan has scoped tasks and verifiable acceptance criteria, material blockers and manual steps are explicit, and planned verification is proportional to risk. For a work item, `index.md` also points to the next slice.
