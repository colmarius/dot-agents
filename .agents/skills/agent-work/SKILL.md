---
name: agent-work
description: "Creates, continues, hands off, and closes durable work items. Use when work needs review or must outlive the conversation. Triggers on: create work item, continue work item, close work item, handoff prompt, stress-test plan."
---

# Agent Work

Follow the contract in [`.agents/work/AGENTS.md`](../../work/AGENTS.md); this skill covers the actions. Run scripts from the repository root.

## Create

1. Confirm a work item is warranted and no matching one exists (see the contract's "When To Create One").
2. Create it:

   ```bash
   .agents/skills/agent-work/scripts/new-work.sh --category <category> --slug <slug> --title "<Title>" [--status <status>]
   ```

3. Fill `Why`, `Summary`, and `Next Action`, then add only the support files the work needs.

For research, load the `research` skill. For a proposal, follow the contract's `proposal.md` description and lead with the recommendation; list each decision needed on its own line with a recommended default and who decides. Defaults stay proposals until their decider accepts them; never write that work proceeds if nobody objects.

## Continue

1. Read `index.md` first, then the latest entries in `log.md`. Load support files only as the next step needs them.
2. Check that state against the code and history as the contract's resume rule says, and fix stale state before acting on it.
3. Do the next action and, unless the request names a single step, the remaining steps in order. Verify each and update the checkpoint; for work that touches unaccepted decisions, follow the contract's "Decisions".
4. When the scope is done, mark it ready to close as the contract says; close it only when the user asks.

## Plan

Write `plan.md` only when order, dependencies, or rollout are not obvious, or someone else must review or execute it. Use [`assets/plan-template.md`](assets/plan-template.md). Prefer a thin end-to-end slice first. Tasks follow project conventions; when the plan conflicts with them, the conventions win and you fix the plan. A plan does not authorize commits, pushes, deploys, migrations, or other shared-state changes.

When the user asks to stress-test or grill a plan, read the relevant code and documents first, then ask one high-leverage question at a time with a recommended default. Record answers under `Decisions`. Stop when the remaining questions would not change scope, order, or architecture.

## Hand Off Or Delegate

Implement in the current thread by default. Delegate when parallel work, isolation, another environment, or an independent review helps.

A handoff prompt states:

- what to read first: the work item path and the relevant support files;
- the base: branch and commit, and how the worker gets the code: the same checkout, a pushed branch, or a transferred patch, since another environment cannot see uncommitted or unpushed work;
- the slice to do, what is out of scope, which decisions are only proposed, and when to stop and ask;
- the verification expected and how to report evidence, separating what was run from what was inherited;
- delivery authority: implement only, commit, push, open a PR, merge, deploy, or other shared-state changes; one does not imply the next;
- what to return, and whether the worker may edit the work item.

When coordinating several workers:

- the coordinator owns the work item, integration, and final acceptance;
- start workers from the same base and give them disjoint write targets, including shared config and lock files;
- choose one result path per worker: either it reports back, or you wait on it;
- inspect each worker's changes and evidence before integrating, run combined verification, then log the result.

Generate handoff prompts in the conversation. Do not persist them in the work item; writing a prompt does not change the item, and the thread that dispatches the worker records the delegation. When no thread stays to coordinate, the brief hands the item to the worker.

## Close

Close an item only when the user asks to finish or close it; that request authorizes both closeout commits.

1. Move what should outlive the item to its lasting home: code, docs, tests, checks, `AGENTS.md`, a skill, or `.agents/research/`. Accepted decisions that still constrain behavior belong in docs or code. Retained material must stand alone and not link into the item.
2. Resolve each `Open:` or `Proposed:` decision: record its outcome, such as `Accepted: out of scope` when the decider already said so, citing where, or remove it and name it as a follow-up in your final report. Create a new item for a follow-up only when asked.
3. Set `Status: completed`, set `Next Action` to exactly `- None.`, and append a final `log.md` entry with the outcome, where it went, and any follow-ups.
4. Commit that snapshot with the remaining changes.
5. Run `scripts/close-work.sh --category <category> --slug <slug> --check`, rerun it without `--check` to stage the deletion, and commit the deletion separately, naming the snapshot commit in its message.

`close-work.sh` refuses a dirty repository, an uncommitted or non-`completed` snapshot, leftover `Open:` or `Proposed:` decisions, and ignored files in the item; it never commits.

Git history is the archive only while the snapshot commit stays reachable from the default branch. If commits may be squashed, merge the snapshot first and remove the item in a later change. When you commit directly to the default branch, nothing is squashed; when you don't know the merge strategy, assume squashing. Without a close request, leave the item in place and report what is pending.

When cleaning up items whose work already merged without a completed snapshot, first check that the item's files on the default branch hold everything worth keeping and promote any remaining outcomes; then remove each with `git rm -r` in its own change, naming the merge that finished it. `list-work.sh` flags items with no recent change as candidates.

## Scripts

```bash
.agents/skills/agent-work/scripts/new-work.sh --category platform --slug user-auth --title "User authentication"
.agents/skills/agent-work/scripts/list-work.sh [--status blocked] [--stale-days 30]
.agents/skills/agent-work/scripts/close-work.sh --category platform --slug user-auth [--check]
```

`list-work.sh` shows each item's status, category, and last commit, and flags `completed` items still present, uncommitted changes, and items with no commit for `--stale-days` days.

## Legacy Content

Older items may contain `Category:` and `Updated:` lines, a `planned` status, `progress.md`, `plan.progress.md`, `prd.md`, `decisions/`, `plans/`, or `handoff-*.md`. They remain valid user content; read them when the index links them, keep using an existing progress file or start `log.md`, and do not migrate them unless asked. Legacy `.agents/plans/` and `.agents/prds/` files are user content too; migrate one only when asked, into `.agents/work/<category>/<slug>/`.
