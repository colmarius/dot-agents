# Handoff Context

Use a handoff when another thread, worker, or environment will execute a bounded slice. Handoff is optional: current-thread implementation remains the default.

Keep context proportional. Atomic work can stay terse; cross-layer, security, migration, rollout, or release work needs explicit boundaries and evidence.

When the user asks only for a handoff prompt, produce the paste-ready prompt and do not execute the handed-off slice unless explicitly asked.

## Handoff Contract

Include the applicable parts:

1. **Authority and state**
   - Name one canonical execution source, normally the work item and active plan.
   - Name authoritative requirements or decisions, the current branch or revision, and useful prior thread or commit anchors.
   - Summarize decisions changed since older anchors instead of replaying stale history.
2. **Slice and boundaries**
   - State the smallest implementation slice, required skills, scope, non-goals, invariants or acceptance criteria, and stop or escalation conditions.
3. **Evidence and outputs**
   - Name expected implementation and artifact updates.
   - Match verification to the likely failure mode.
   - Distinguish evidence newly observed for this work from inherited claims that were not rerun.
4. **Delivery authority**
   - State whether the worker may implement only, commit, push, open a pull request, merge, deploy, migrate, or change other shared state.
   - Never infer permission for a later delivery step from an earlier one.

The coordinating thread retains scope, integration, durable state, and final acceptance. A delegated report alone is not acceptance.

## Persistence

Generate the handoff in conversation by default. A persisted handoff is a first-class optional work-item artifact: it belongs in the artifact map, but exists only when reuse or a durable transition justifies another file.

- Use a clear name such as `handoff-task-2.md`, `handoff-phase-1.md`, or `handoff-review.md`.
- Keep it separate from the plan and link it from `index.md`.
- Update or remove a persisted handoff when its slice is superseded so it cannot masquerade as current state; remove stale handoffs before completing the work item.
- Do not put secrets, personal data, machine-specific absolute paths, or ephemeral environment URLs in durable context.

## Paste-Ready Shape

```text
Continue the work item at <repository-relative path>.

Read first:
1. <index and active plan>
2. <only relevant research or decisions>

Canonical state:
<current branch/revision, completed work, and changed decisions>

Implement only:
<smallest slice and acceptance criteria>

Boundaries:
- <scope and non-goals>
- <stop or escalation conditions>

Evidence and updates:
- <artifact updates>
- <verification and whether prior evidence must be rerun>

Delivery authority:
<implement only / commit / push / open PR / merge / deploy / other shared state>

Return:
<changes, observed verification, work-item updates, and remaining next action>
```
