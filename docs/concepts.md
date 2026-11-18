---
title: How dot-agents works
description: When a work item helps, the four things you ask your agent, and what a work item holds.
---

# How dot-agents works

## When to use a work item

Most work needs no files. When one conversation can finish it, just ask: the agent does the work, checks it, and reports.

Ask for a work item when:

- people need to review or decide the direction, such as research findings, a proposal, or an API change; or
- the work continues later, in another session, with another agent, or with another person.

Creating one late is fine. Stopping for the day, handing work to someone else, and waiting on a decision are good moments.

## Start

```text
Create a work item for <goal>.
```

The agent creates `.agents/work/<category>/<slug>/` with an `index.md` and a `log.md`. When people must agree on the direction first, ask for a proposal too:

```text
Create a work item for <goal> and write a proposal for review.
```

A proposal leads with a recommendation, then the alternatives, the API and data-type changes, a diagram, and each decision with a suggested default and who decides.

## Continue

```text
Continue the work item at .agents/work/<category>/<slug>.
```

The agent reads `index.md` and the latest `log.md` entries, checks them against git and the code, fixes anything out of date, then does the next step. At each milestone it rewrites `index.md` and adds a dated entry with evidence to `log.md`, so any later session can pick up from there.

## Hand off

```text
Write a handoff prompt for <slice> of .agents/work/<category>/<slug>.
```

The agent writes a prompt in the conversation for another agent or person: what to read, which commit to start from, what is in and out of scope, how to verify, and whether the recipient may commit or push. Nothing is saved to the repo.

## Finish

```text
Close the work item at .agents/work/<category>/<slug>.
```

The agent moves what should last into code, tests, docs, or `AGENTS.md`, settles or reports open decisions, commits a final snapshot, then removes the item in a second commit. Git history keeps the snapshot; if your merges squash commits, merge the snapshot first and remove the item in a later change.

Items close only when you ask. A finished item waits as `blocked` on your close request.

## What a work item holds

```text
.agents/work/<category>/<slug>/
├── index.md      # current state
├── log.md        # dated history
├── research.md   # optional: findings
├── proposal.md   # optional: for review
└── plan.md       # optional: task order
```

`index.md` is rewritten at each checkpoint; `log.md` only grows. An example `index.md`:

```markdown
# User authentication

Status: blocked

## Why

Users need secure access across sessions.

## Summary

Done: research and a proposal recommending session cookies.
Remaining: review, then implementation.
Branch research/auth at 3f2a9c1; uncommitted work: none.

## Artifacts

- [log.md](log.md) — dated history
- [proposal.md](proposal.md) — recommendation, API changes, session type

## Decisions

- Accepted: email and password only for v1 (Dana, 2026-11-12, kickoff call).
- Proposed: server-side sessions in Postgres (Dana decides).
- Open: session lifetime (Dana decides).

## Next Action

- Dana reviews proposal.md and decides the session lifetime.
```

## Statuses and decisions

| Status | Meaning |
| --- | --- |
| `researching` | Research or a proposal is being written. |
| `in-progress` | Work on an agreed direction is under way or ready to start. |
| `blocked` | Waiting on a person: a review, a decision, or your close request. |
| `completed` | Only in the final snapshot, just before the item is removed. |

| Decision | Meaning |
| --- | --- |
| `Open:` | No recommendation yet; names who decides. |
| `Proposed:` | A recommended default; names who decides. |
| `Accepted:` | The outcome, who accepted it, when, and where. |

Only the named decider accepts a decision; the agent records it. A `Proposed:` decision is not approval: the agent builds on one only when it is easy to undo and changes nothing people rely on, and otherwise does the parts that do not depend on it.

When people review a proposal elsewhere, such as Notion or a PR, list that copy in `index.md` with the commit it reflects, and bring their feedback back into the repo before acting on it.

## Work across repositories

One coordinator work item can link an API change and its consumer without creating a work item per worker. Give each writer disjoint targets, name each repository's base revision, and say how unpushed code and evidence reach the recipient. A hash or local path alone does not transfer them.

When rollout is in scope, use `Summary` to distinguish implementation, verification, merge, and deployment, with the environment and revision tested. For example (fictional):

> API and consumer implementations and targeted tests are complete; the API is merged and development deployment `4444444` is verified. The consumer PR at `5555555` remains open. Its live integration check returned HTTP 503, so end-to-end behavior is unverified. Consumer and production deployment remain unauthorized.

Keep dated evidence in `log.md`, optional rollout order in `plan.md`, and durable behavior in the owning repository's code and docs. A merged API and passing fixture tests do not prove the consumer works against the deployed API. Implementation-only and documentation-only requests acquire no deployment checklist.

The [cross-repository delivery example](https://github.com/colmarius/dot-agents/blob/main/docs/examples/cross-repository-delivery.md) follows fictional `service-api` and `booking-app` changes through ownership, patch transfer, context storage, and an incomplete rollout.

## Update without losing customizations

The unreleased safe-sync default installs missing files but preserves differing managed files and retired content for review. Conflicts use `file.dot-agents.md` or `file.ext.dot-agents.new`; existing review copies are kept. Unresolved updates exit 1 even though non-conflicting additions may already be installed, and do not advance installation metadata.

Preview with `--diff` or `--dry-run`; neither writes project files. Use explicit `--force` for backed-up replacement/removal, or `--interactive` for separate decisions. `--yes` is not overwrite authority. Older pinned installers retain their old behavior; read the [safe-sync migration notes](https://github.com/colmarius/dot-agents/blob/main/docs/migration-safe-sync.md) before adopting the new default.

## Go deeper

- [Work-item contract](https://github.com/colmarius/dot-agents/blob/main/.agents/work/AGENTS.md): the rules agents follow.
- [Skills reference](https://github.com/colmarius/dot-agents/blob/main/docs/skills.md): `adapt`, `agent-work`, and `research`.
- [Migrating to v0.6](https://github.com/colmarius/dot-agents/blob/main/docs/migration-v0.6.md): including older items with `planned`, `Category:`, or `Updated:`.
- [With Agents](https://with-agents.dev/coding/): a field guide to briefing coding agents, checking their work, and keeping context.
