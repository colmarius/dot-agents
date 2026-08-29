---
title: Start uncertain work
description: Frame the outcome, reduce only the unknowns that block action, and decide whether durable context will earn its cost.
order: 1
---

Uncertainty alone does not require research, a requirements brief, a plan, or a work item. Begin with the outcome and add structure only when it helps the next action.

## Brief the job

Give the agent the smallest brief that prevents invented scope:

Access is capability, not authority. Credentials or production access do not authorize commits, pushes, pull requests, merges, deploys, migrations, data changes, or other shared-state actions. Grant each action explicitly when it is needed.

```text
Start this work without assuming a full lifecycle.

Purpose: <outcome and why it matters>
Context: <relevant paths, current state, constraints, decisions>
Acceptance: <observable done conditions>
Authority: <inspect, edit, local checks, and any approved delivery actions>
Owner: <human role responsible for choices and residual risk>
Return: <changes, observed evidence, unknowns, and next action>

Resolve repository-answerable uncertainty yourself. Ask one focused question
only when a product decision or unapproved shared-state action is required.
```

## Choose how much state the work needs

Keep work conversational when it is bounded, can finish now, and does not need a repository record for another person or thread.

Create a work item when resumption, coordination, handoff, auditability, durable decisions, or an explicit request makes continuity valuable. Check for an existing item first. New durable work begins with only:

```text
.agents/work/<category>/<slug>/index.md
```

Use the [agent-work skill](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/SKILL.md) for the current creation procedure. Add research when a durable answer to “what is true?” is useful. Add `prd.md` when desired behavior needs durable alignment. Add a plan when non-trivial execution needs ordered tasks. None is a ritual prerequisite.

## Reduce only the uncertainty that blocks action

| Unknown | Smallest useful treatment |
| --- | --- |
| What the repository or system does | Inspect the source of truth. Save findings only when they must survive or be reused. |
| What users or stakeholders need | Ask the owner. Persist requirements only when later work needs that alignment. |
| How to sequence non-trivial work | Make an execution-ready plan, conversationally or in the work item. |
| A detail that does not change scope, safety, or acceptance | Choose a reversible default, state it, and proceed. |

## Begin with a slice that can prove something

Choose the smallest safe action that produces evidence without crossing an authority boundary. The first return should make these points clear:

- the accepted brief and explicit assumptions;
- whether work is conversational or where its `index.md` lives;
- facts observed from source material and material points still unverified;
- the next action and the evidence it should produce;
- any decision or shared-state action that remains with the human owner.

For the reasoning behind these choices, see [Brief the Agent Like a Capable Co-Worker](https://with-agents.dev/coding/posts/capable-coworker-coding-agents/) and [Your Repo Is the Memory](https://with-agents.dev/coding/posts/durable-context-coding-agents/). For installation and exact helper commands, use the [Quickstart](https://github.com/colmarius/dot-agents/blob/main/QUICKSTART.md).
