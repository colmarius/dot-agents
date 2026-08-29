---
title: Continue durable work
description: Resume from canonical state, keep connected work together, and split only when another boundary creates a concrete benefit.
order: 2
---

One connected job can include research, planning, implementation, verification, and feedback in the same thread. Durable state supports continuity; it does not require more agents or more artifacts.

## Resume with agent-work

Invoke [agent-work](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/SKILL.md) to locate and continue the work item. Let the skill load canonical state and only the active material needed for the next action. The agent should compare recorded assumptions with the current repository rather than reconstructing state from chat history.

## Keep connected work together by default

Continue in the current thread while the same context and judgment remain useful. Ask agent-work to reconcile feedback with durable state when accepted behavior or the next action changes.

Split only when the boundary creates a concrete benefit:

- **Fresh judgment:** an independent review should not inherit the implementer's framing.
- **Isolation:** a risky experiment or conflicting change needs a separate worktree or sandbox.
- **Independent work:** slices have disjoint inputs and write targets and can proceed without serial decisions.
- **Different access or environment:** another worker has the required repository, machine, service, or tool.

Before splitting, name one integration owner for scope, durable state, combined verification, and final acceptance. Another environment does not automatically share the branch, uncommitted files, credentials, or local services.

## Keep evidence explicit

Do not flatten all evidence into “tested.” Ask agents and reviewers to distinguish evidence that was inherited from an earlier report, rerun now, newly observed, or left unverified. A checkbox or worker summary is not proof by itself.

Use the verification skill appropriate to the work. For web flows, invoke [agent-browser](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-browser/SKILL.md) when running-system proof matters.

## Hand off and integrate deliberately

When another worker or environment genuinely helps, ask agent-work for a proportional handoff. Supply the accepted state, bounded slice, acceptance conditions, non-goals, stop conditions, delivery authority, and integration owner; let the skill determine the handoff details.

Authority does not travel with access or an implementation assignment. State separately whether the recipient may commit, push, merge, deploy, migrate, change data, or perform another shared-state action.

The integration owner should inspect actual changes, resolve conflicts, run combined verification, and ask agent-work to reconcile the accepted result with canonical state before final acceptance.

For exact procedures, rely on agent-work and the [work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md). For the reasoning behind thread boundaries, see [Right-Sized Threads, Durable State](https://with-agents.dev/coding/posts/right-sized-threads-durable-state/).
