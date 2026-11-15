---
title: How dot-agents works
description: When to keep work in the conversation, when a work item earns its place, and how to start, continue, and finish work with an agent.
---

# How dot-agents works

## Workflow

```text
Request
├─ One thread can finish it ──▶ Work in the conversation ──▶ Verify and report
└─ People must review it, or ──▶ Work item (index.md) ──▶ Research, propose, plan, or build as needed
   it must outlive this thread        │                         │
                                      └── checkpoint: index.md now, log.md history
                                                                 │
                                            Promote outcomes → Commit snapshot → Remove
```

1. **Choose the path.** Keep work in the conversation when one thread can finish it. Create a work item when people need a durable record to review or decide direction, when the work must resume in another session, thread, or worker, or when you ask for one. Creating one late is fine: the first delegation, wait on a person, or context compaction is a good moment when the work needs a durable record.
2. **Start at `index.md`.** It is the shared record of current state: why the work exists, what is done and what remains, what was decided, and the next action. `log.md` beside it holds the dated history; together they are the recovery checkpoint.
3. **Add files only when someone will read them.** `research.md` for what is true, `proposal.md` for what reviewers must decide (with contracts, data types, and diagrams), and `plan.md` when the order is not obvious or someone else will execute it.
4. **Work in the current thread by default.** Delegate when parallel work, isolation, another environment, or an independent review helps; the coordinating thread keeps the work item current.
5. **Checkpoint at milestones.** After a commit, a finished step, a decision, a blocker, a delegation, and before stopping, rewrite the summary and next action in `index.md` and append one entry with evidence to `log.md`.
6. **Finish when you ask.** Promote what should last to code, docs, guidance, or `.agents/research/`, resolve open decisions, commit the completed snapshot, then remove the item in a separate commit. Git history is the archive; with squash merges, remove it in a later change.

The rules live in the [work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md) and the [agent-work skill](https://github.com/colmarius/dot-agents/blob/main/.agents/skills/agent-work/SKILL.md).

## Working With The Agent

### Start

Uncertainty alone does not require research, a proposal, a plan, or a work item. Give the agent the outcome, observable acceptance conditions, what it may change without asking, and who owns product choices:

```text
Deduplicate the retry logic in the sync workers. Acceptance: one shared
implementation and the existing tests pass. Do not change public interfaces
or add dependencies without asking. I own any behavior tradeoffs.
```

Let the agent answer what the repository answers, and ask you only when a decision would change the outcome or an action needs approval. Access is not permission: a configured remote does not authorize a push, and production access does not authorize a migration. When people must agree on direction first, ask for a work item with a proposal:

```text
Create a new work item for <goal> and write a proposal for review.
```

### Continue

```text
Continue the work item at .agents/work/<category>/<slug>.
```

The agent reads `index.md`, then the latest `log.md` entries, checks them against `git log` and the code, fixes anything stale, and loads only what the next action needs. Keep connected work in one thread while its context stays useful. Split only for a concrete benefit: an independent review, an isolated experiment, independent slices with disjoint write targets, or access only another environment has. Before splitting, name one integration owner for durable state, combined verification, and final acceptance.

A handoff prompt is generated in the conversation, not stored. It names the work item and files to read, the base revision and how the worker gets unpushed work, the slice and what is out of scope, the verification expected, what to return, and exact delivery authority:

```text
Write a handoff prompt for <slice> of .agents/work/<category>/<slug>. The
recipient may commit locally but not push or merge; I integrate the result.
```

Do not accept "tested" on its own. Each claim names its command or observation and whether it was observed now, inherited without rerunning, or unverified:

```text
npm test — rerun now: passed
checkout browser flow — inherited from prior handoff: not rerun
mobile layout — unverified
```

### Finish

Accept outcomes on evidence, not because code exists or a worker reported success. You, not the agent, accept residual risk and authorize shared-state actions. Before calling the work done, check that it solved the stated problem, who owns remaining decisions and manual work, and what rollout, cleanup, or follow-up remains.

```text
Complete and close the work item at .agents/work/<category>/<slug>.
```

The agent promotes what future work will reuse (behavior to code, tests, or docs; project rules to `AGENTS.md`; procedures to skills or scripts; sourced findings to `.agents/research/`), resolves open decisions or reports them as follow-ups, commits a `completed` snapshot, and removes the item in a second commit. A close request authorizes both commits. If your merges squash commits, merge the snapshot first and remove the item in a later change.

## Work Item Shape

```text
.agents/work/<category>/<slug>/
├── index.md       # required: current state (why, summary, decisions, next action)
├── log.md         # required: dated history, newest last
├── research.md    # optional: what is true
├── proposal.md    # optional: what reviewers must decide
└── plan.md        # optional: ordered tasks when the order is not obvious
```

Name other files by what they hold; one file may hold several roles when that is easier to review.

## Example Work Item

```markdown
# User authentication

Status: blocked

## Why

Users need secure access across sessions.

## Summary

Done: research and a proposal recommending session cookies over JWTs. Remaining: review, plan, implementation. No code is written. Branch `research/auth` at `3f2a9c1`; uncommitted work: none.

## Artifacts

- [log.md](log.md) — dated history
- [research.md](research.md) — current login flow and library options
- [proposal.md](proposal.md) — recommendation, API changes, session data type
- Team review page (copy of proposal.md at `3f2a9c1`)

## Decisions

- Accepted: email and password only for v1 (Dana, 2026-11-12, kickoff call).
- Proposed: server-side sessions in Postgres (Dana decides); see proposal.md.
- Open: session lifetime (Dana decides).

## Next Action

- Dana reviews proposal.md and decides session lifetime; then write plan.md.
```

Its `log.md`:

```markdown
# Log

- 2026-11-12 — Recorded the v1 scope decision from the kickoff call.
- 2026-11-14 — Wrote research.md and proposal.md from the current login code and three library options. Shared the review page with Dana.
```

`index.md` holds only current state and is rewritten at each checkpoint; `log.md` only grows. The category comes from the folder and the last change from git.

## Statuses And Decisions

- `researching` while research or a proposal is written; `in-progress` once every decision that sets direction is accepted (or for the accepted part of a partly accepted proposal); `blocked` while the next step waits on a person, including review and your close request; `completed` only in the final snapshot.
- Decisions are `Open:` (no recommendation yet), `Proposed:` (with a recommended default), or `Accepted:` (who, when, where). Only the named decider or their delegate accepts; agents record acceptances and never give them.
- A `Proposed:` decision is not approval. Agents build on one only when it is easy to reverse and does not change behavior people rely on; otherwise they do the independent part and leave the decision to its owner.
- Each fact has one home. When a plan exists, its checkboxes are the task state.

Rendered documents, Notion pages, PR descriptions, and slides are views for people. `index.md` stays canonical for status, decisions, and next action; each view is listed with the commit it reflects, and feedback left there is brought back into the authoritative copy before acting.

## Legacy Content

Work items from v0.5 and earlier may contain `Category:` and `Updated:` lines, a `planned` status (read as `in-progress`), `progress.md`, `prd.md`, `decisions/`, `plans/`, or `handoff-*.md`; they remain valid. Older installs used `.agents/plans/` and `.agents/prds/`; those documents are preserved as user content. See the [migration guides](https://github.com/colmarius/dot-agents/blob/main/docs/README.md#upgrading).

## Glossary

| Term | Definition |
| --- | --- |
| adapt | Skill that fills in `AGENTS.md` from the project |
| category | Open lowercase kebab-case path segment that groups work items by product, domain, or work type |
| checkpoint | The current `index.md` plus the latest entries in `log.md`; a new thread resumes from it |
| closeout | Committing the completed snapshot, then staging and separately committing its removal |
| delivery authority | Explicit permission for commits and shared-state actions such as pushing, merging, deploying, or migrating; implementing does not imply it |
| final snapshot | The committed `Status: completed` state kept in git history before removal |
| handoff prompt | Prompt that briefs another thread or worker on a bounded slice |
| integration owner | The person or coordinating thread that owns the work item, combined verification, and final acceptance |
| log | `log.md`: dated entries of what happened and the evidence, newest last; history only, never current state |
| promotion | Moving a validated outcome out of a work item into its lasting home |
| proposal | Optional `proposal.md` holding what reviewers must decide: recommendation, alternatives, contracts, diagrams |
| skills | Specialized agent instructions loaded on demand |
| sync | Script that updates dot-agents from upstream while preserving user content |
| work item | Folder under `.agents/work/<category>/<slug>/` holding the shared record for work that needs review or must outlive the conversation |
