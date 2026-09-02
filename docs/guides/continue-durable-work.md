---
title: Continue durable work
description: Resume from canonical state, keep connected work together, and split only when another boundary creates a concrete benefit.
order: 2
---

One connected job can include research, planning, implementation, verification, and feedback in the same thread. Durable state supports continuity; it does not require more agents or more artifacts. Unfamiliar terms—work item, canonical state, integration owner, delivery authority—are defined in the [glossary](https://github.com/colmarius/dot-agents/blob/main/docs/concepts.md#glossary).

## Resume with agent-work

Invoke [agent-work](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/SKILL.md) to locate and continue the work item:

```text
Continue the work item at .agents/work/<category>/<slug>. Implement its
next action and record verification evidence.
```

The agent reads `index.md` first, then only the linked plan, research, or progress its next action needs. It should check recorded assumptions against the current repository rather than reconstructing state from chat history.

## Keep connected work together by default

Continue in the current thread while the same context and judgment remain useful. When feedback changes accepted behavior or the next action, update the active plan and `index.md` before continuing.

Split only when the boundary creates a concrete benefit:

- **Fresh judgment:** an independent review should not inherit the implementer's framing.
- **Isolation:** a risky experiment or conflicting change needs a separate worktree or sandbox.
- **Independent work:** slices have disjoint inputs and write targets and can proceed without serial decisions.
- **Different access or environment:** another worker has the required repository, machine, service, or tool.

Before splitting, name one integration owner for scope, durable state, combined verification, and final acceptance. Another environment does not automatically share the branch, uncommitted files, credentials, or local services.

## Keep evidence explicit

Do not report only “tested.” Name the command or observation, its result, and whether it was observed now, inherited from an earlier report without rerunning, or remains unverified. A checkbox or worker summary is not proof by itself.

```text
npm test — rerun now: passed
checkout browser flow — inherited from prior handoff: not rerun
mobile layout — unverified
```

Use the verification skill appropriate to the work. For web flows, invoke [agent-browser](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-browser/SKILL.md) when running-system proof matters.

## Hand off and integrate deliberately

When another worker or environment genuinely helps, ask agent-work for a handoff that contains only the context the recipient needs for its bounded slice. Supply:

- The accepted state and the bounded slice.
- Acceptance conditions and non-goals.
- Stop conditions and delivery authority.
- The integration owner.

```text
Write a handoff prompt for <slice> of .agents/work/<category>/<slug>. The
recipient may commit locally but not push or merge; I integrate the result.
```

State separately what the recipient may do to shared state—commit, push, merge, deploy, migrate, or change data. Access alone authorizes none of it.

The integration owner inspects the actual changes, resolves conflicts, runs combined verification, and then updates the plan checkboxes, recorded evidence, and `index.md` status and next action before final acceptance.

For exact procedures, rely on agent-work and the [work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md). For the reasoning behind thread boundaries, see [Right-Sized Threads, Durable State](https://with-agents.dev/coding/posts/right-sized-threads-durable-state/).
