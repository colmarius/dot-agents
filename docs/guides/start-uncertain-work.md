---
title: Start uncertain work
description: Frame the outcome, reduce only the unknowns that block action, and decide whether durable context will earn its cost.
order: 1
---

Uncertainty alone does not require research, a requirements brief, a plan, or a work item. Begin with the outcome and add structure only when it helps the next action.

## Frame the outcome

Give the agent enough to act without inventing scope: the purpose, relevant context, observable acceptance conditions, authority boundaries, and the human owner for product choices and residual risk.

Let the agent resolve questions answered by the repository. Ask for a focused question only when a product decision would change the outcome or an action needs approval.

Access is capability, not authority. Credentials or production access do not authorize commits, pushes, merges, deploys, migrations, data changes, or other shared-state actions. Grant each action explicitly when needed.

## Choose how much state the work needs

Keep work conversational when it is bounded, can finish now, and does not need a repository record for another person or thread.

When resumption, coordination, handoff, auditability, or durable decisions make continuity valuable, invoke the [agent-work skill](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/SKILL.md). Let it find or create the work item and choose the smallest useful set of artifacts. Research, requirements, and plans are optional—not stages to perform by default.

## Use skills for the unknowns that matter

- Use [research](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/research/SKILL.md) when a technical question needs authoritative sources, comparison, or findings worth preserving. Keep the answer conversational when durability adds no value.
- Use [agent-browser](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-browser/SKILL.md) when a web workflow needs running-system evidence rather than source inspection alone.
- Let the agent choose a reversible default for details that do not change scope, safety, or acceptance.

## Begin with a slice that can prove something

Ask for the smallest safe action that can produce useful evidence. The return should distinguish what changed, what was observed, what remains unverified, and what decision or authority is still needed.

For the reasoning behind these choices, see [Brief the Agent Like a Capable Co-Worker](https://with-agents.dev/coding/posts/capable-coworker-coding-agents/) and [Your Repo Is the Memory](https://with-agents.dev/coding/posts/durable-context-coding-agents/). For installation and skill discovery, use the [Quickstart](https://github.com/colmarius/dot-agents/blob/main/QUICKSTART.md).
