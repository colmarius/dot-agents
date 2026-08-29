---
title: Finish and preserve outcomes
description: Reconcile claims with evidence, promote what will be reused, and close durable work without losing its final state.
order: 3
---

Conversational work can finish with verified changes and a clear report. Do not create a work item just to document work that is already done. Unfamiliar terms—promotion, final snapshot, canonical state—are defined in the [glossary](https://github.com/colmarius/dot-agents/blob/main/docs/concepts.md#glossary).

## Accept outcomes based on evidence

Ask the agent to reconcile each material claim with the evidence actually produced:

```text
Reconcile each claim about this work with observed evidence. Mark each claim
as rerun, newly observed, inherited, or unverified, and recommend whether to
fix, verify further, defer with an owner, or accept the residual risk.
```

Do not mark work complete because code exists or a worker reported success.

Scale further verification to consequence, reversibility, and detectability. Use the skill appropriate to the system; invoke [agent-browser](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-browser/SKILL.md) when a web workflow needs running-system proof.

The human owner—not the agent—accepts material residual risk and authorizes consequential shared-state actions.

## Promote only what future work will reuse

Ask [agent-work](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/SKILL.md) to promote validated outcomes before closing durable work. Put behavior in code, tests, or product documentation; stable project rules in `AGENTS.md`; reusable procedures in skills or scripts; and reusable sourced findings in research.

Promote the result, not a transcript, and only when future work will realistically consult it.

## Check the whole outcome

Before declaring the work finished, ask:

- Did the result solve the stated problem?
- What observed evidence proves the important behavior?
- Who owns remaining decisions, risk, and manual work?
- What rollout, migration, cleanup, monitoring, documentation, or follow-up remains?

Unowned hidden work means the job is not cleanly finished. Assign it, explicitly defer it, or keep durable work active or blocked.

## Close durable work with agent-work

Once implementation and verification are complete, ask agent-work to complete and close the work item:

```text
Complete and close the work item at .agents/work/<category>/<slug>. You
may create the commits required for closeout.
```

The skill owns the exact status, final snapshot, preflight, and removal procedure.

Closeout requires explicit authority to commit both the final snapshot and the later removal. If that authority is missing, leave the completed context in place and report the pending action to the owner.

For exact semantics, rely on agent-work and the [work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md#completion-and-removal). For the reasoning behind acceptance, see [Make the Agent Prove It](https://with-agents.dev/coding/posts/make-the-agent-prove-it/).
