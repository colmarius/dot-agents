---
title: Continue durable work
description: Resume from canonical state, keep connected work together, and split only when another boundary creates a concrete benefit.
order: 2
---

One connected job can include research, planning, implementation, verification, and feedback in the same thread. Durable state supports continuity; it does not require more agents or more artifacts.

## Re-enter through canonical state

Start with the work item's `index.md`. Confirm its intent, status, summary, artifact links, open questions, and next action. Then read only the active plan, decision, research, or progress material needed for that action.

```text
Continue .agents/work/<category>/<slug>/.

Read index.md first, then only the artifacts needed for its next action. Compare
the recorded state with the current repository before changing files. Return any
stale assumption or blocker that changes scope, sequence, or safety.
```

Use `list-work.sh --all` when the path is unknown. Follow the [work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md) for artifact ownership rather than reconstructing state from chat history.

## Keep connected work together by default

Continue in the current thread while the same context and judgment remain useful. When feedback changes accepted behavior, update the existing artifact that owns it—`index.md`, `prd.md`, or the active plan—before continuing affected implementation.

Split only when the boundary creates a concrete benefit:

- **Fresh judgment:** an independent review should not inherit the implementer's framing.
- **Isolation:** a risky experiment or conflicting change needs a separate worktree or sandbox.
- **Independent work:** slices have disjoint inputs and write targets and can proceed without serial decisions.
- **Different access or environment:** another worker has the required repository, machine, service, or tool.

Name one integration owner before splitting. That owner keeps scope and durable state coherent, inspects results, resolves conflicts, runs combined verification, and accepts the integrated outcome. Another environment does not automatically share the branch, uncommitted files, credentials, or local services.

## Label evidence by what happened

Do not flatten all evidence into “tested.” Distinguish:

| Evidence | Record |
| --- | --- |
| **Inherited** | A prior report or artifact and its provenance; do not imply it was rerun. |
| **Rerun** | The command or exercise performed again, revision or environment, and observed result. |
| **Newly observed** | Evidence first produced in this slice, with enough detail to inspect it. |
| **Unverified** | A material claim not checked, why it remains open, and who or what can resolve it. |

Plan checkboxes record intended task completion. `progress.md`, when durability helps, records concise observed evidence and resumption detail. Neither a checkbox nor a worker summary proves behavior by itself.

## Hand off accepted state, not transcripts

Use a handoff only when another thread, worker, or environment will execute a bounded slice. Generate it in conversation by default; persist `handoff-*.md` only when the transition must survive or be reused.

```text
Continue the work item at <path>.

Read first: <index, active plan, and only relevant decisions or findings>
Accepted state: <current revision, completed work, changed decisions>
Implement only: <bounded slice and acceptance criteria>
Boundaries: <scope, non-goals, invariants, stop conditions>
Evidence: <what is inherited, what to rerun, what must be newly observed>
Delivery authority: <inspect/edit/check plus each allowed shared action>
Return: <changes, evidence by category, artifact updates, remaining action>
Integration owner: <human or coordinating thread>
```

Authority does not travel with access or an implementation assignment. State separately whether the recipient may commit, push, open a pull request, merge, deploy, run migrations, change data, or perform another shared-state action.

<details>
<summary>Composite example: parallel documentation and implementation</summary>

One worker tests a content-loading boundary while another drafts guide copy in a separate orb. Neither may push. The coordinating thread owns the work item, downloads and inspects both patches, chooses the combined design, reruns the integrated build and browser checks, and reports which evidence was newly observed rather than inherited.

</details>

## Integrate before accepting

The integration owner should:

1. Inspect actual changes and durable artifacts, not only the return message.
2. Compare the result with current acceptance criteria and authority boundaries.
3. Run combined verification and label the resulting evidence.
4. Apply accepted feedback to the existing artifact that owns it—`index.md`, `prd.md`, or the active plan—before more work.
5. Update checkboxes, `index.md`, and `progress.md` only where each artifact owns that state.

The expected return is a reviewable change set, observed and unverified evidence kept distinct, one canonical next action, and any decision that remains with the human owner.

For exact procedures, use [handoff context](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/references/handoff-context.md) and [coordinated execution](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/references/coordinated-execution.md). For the reasoning behind thread boundaries, see [Right-Sized Threads, Durable State](https://with-agents.dev/coding/posts/right-sized-threads-durable-state/).
