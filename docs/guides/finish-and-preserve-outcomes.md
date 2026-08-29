---
title: Finish and preserve outcomes
description: Reconcile claims with evidence, promote what will be reused, and close durable work without losing its final state.
order: 3
---

Conversational work can finish with verified changes and a clear report. Do not create a work item just to document work that is already done.

## Reconcile claims with observed evidence

Review current acceptance criteria against the implementation and evidence actually produced. For each material claim, identify:

- **Claim:** what should now be true;
- **Evidence:** inherited, rerun, newly observed, or unverified, with the check, revision or environment, result, and relevant artifact;
- **Gap:** stale, partial, or missing proof;
- **Decision:** fix, verify further, defer with an owner, or accept the residual risk.

Do not mark work complete because code exists or a worker reported success. Inspect the change, rerun checks where current proof matters, and say when evidence remains inherited or unverified.

## Scale verification to the risk

| Factor | Ask |
| --- | --- |
| **Consequence** | What is harmed if the claim is wrong? |
| **Reversibility** | How quickly and safely can the change or action be undone? |
| **Detectability** | Will failure be obvious before users, systems, or data are affected? |

A low-consequence, reversible, obvious failure may need one focused check. A high-consequence, hard-to-reverse, or silent failure needs stronger independent evidence: broader tests, running-system proof, review, dry runs, rollback validation, or staged observation as appropriate.

The human owner—not the agent—accepts material residual risk and authorizes consequential shared-state actions. Access does not authorize commits, pushes, pull requests, merges, deploys, migrations, data changes, or other shared-state operations.

## Promote only what future work will reuse

Move each validated outcome to the smallest canonical home that future work will actually consult:

| Outcome | Canonical home |
| --- | --- |
| Product behavior or user instructions | Code, configuration, tests, or product documentation. |
| An always-relevant project rule | The closest applicable `AGENTS.md`. |
| A triggered reusable procedure | A skill and, when deterministic, its script. |
| A machine-checkable invariant | A test, lint rule, schema, or other deterministic check. |
| A sourced fact useful across unrelated work | `.agents/research/`. |

Promote the result, not a transcript. Link to an existing explanation instead of copying it. Leave work-local rationale in history unless it will guide future unrelated work.

## Use a four-question anti-slop check

- **Purpose:** Did the result solve the stated problem rather than merely produce output?
- **Evidence:** What observed result proves the important behavior?
- **Ownership:** Who accepts remaining decisions, manual steps, and risk?
- **Hidden work:** What rollout, migration, cleanup, monitoring, documentation, or follow-up is easy to overlook?

Unowned hidden work means the job is not cleanly finished. Assign it, explicitly defer it, or keep the work item active or blocked.

## Close a v0.5 work item exactly

Perform durable closeout only after implementation and verification are complete, and only with authority to commit both the final snapshot and the later removal.

1. Reconcile plan checkboxes and evidence, promote reusable outcomes, and remove stale persisted handoffs.
2. Set `Status: completed`, update `Updated:`, and make `## Next Action` contain exactly:

   ```markdown
   - None.
   ```

3. Commit all remaining scoped changes with the final work-item snapshot.
4. From a clean repository root, run the preflight:

   ```bash
   .agents/skills/agent-work/scripts/close-work.sh \
     --category <category> \
     --slug <slug> \
     --check
   ```

5. If it succeeds, rerun the command without `--check`. It stages only the work-item deletion; it does not commit.
6. Review the staged deletion and commit it separately so the completed snapshot remains reachable in history.

The helper rejects a dirty repository and ignored or untracked work-item content. If authority is missing, leave the completed snapshot in place and return the exact pending action to the owner. If later history rewriting would erase the snapshot, preserve it in retained history or keep the completed work item in the tree.

The canonical closeout semantics live in the [work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md#completion-and-removal) and the [v0.5 migration guide](https://github.com/colmarius/dot-agents/blob/main/docs/migration-v0.5.md#completion-and-removal). For the reasoning behind acceptance, see [Make the Agent Prove It](https://with-agents.dev/coding/posts/make-the-agent-prove-it/).
