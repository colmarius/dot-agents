# Work Items

A work item is the shared record between people and agents, and the recovery checkpoint for work that outlives one conversation: why the work exists, what is done, what was decided, and what remains. It is not a required plan. This file is what every reader needs; the `agent-work` skill covers creating, handing off, and closing items.

## When To Create One

Create a work item when:

- people need a durable record to review or decide direction, such as research findings, a proposal, contracts, or a rollout;
- the work must resume without this conversation, in another session, thread, worker, or person; or
- the user asks for one.

Skip it for work that ends in this thread as one reviewable change, for questions, and for reviews. A long session that already holds the context does not need a saved plan to follow.

Creating one late is fine. The first delegation, the first wait on a person, a context compaction, or "continue tomorrow" is a good moment to write down what the conversation holds, when the work needs a durable record. Before creating one, run `.agents/skills/agent-work/scripts/list-work.sh` and extend a matching item instead.

## Shape

```text
.agents/work/<category>/<slug>/
├── index.md       # current state: read first, rewritten at each checkpoint
├── log.md         # history: dated entries, appended at each checkpoint
└── <name>.md      # optional support files, named by content
```

`<category>` is open lowercase kebab-case: a product, domain, or work type such as `platform`, `security`, `feature`, or `tech-debt`. `index.md` uses this shape:

```markdown
# Title

Status: researching | in-progress | blocked | completed

## Why            stable intent and the outcome wanted
## Summary        what is done, what remains, and the scope boundary; rewrite, never append
## Artifacts      support files and external views, with what each holds (optional)
## Decisions      open, proposed, and accepted decisions that shape the work (optional)
## Next Action    the immediate step and who takes it
```

`index.md` holds only current state, so it stays short enough to read in full. History goes to `log.md`, newest entry last; read its latest entries when resuming, not the whole file. The category comes from the path and the last change from git, so the index does not repeat them.

Statuses:

- `researching`: researching or writing a proposal; direction is not settled. Once the proposal is ready for review, the item is `blocked` on that review.
- `in-progress`: work on an accepted direction is under way or ready to start. Move here only when every decision that sets direction is `Accepted:`, or for the accepted or independent part of a partly accepted proposal.
- `blocked`: the next step waits for a named person, review, decision, access, or dependency, including review of a finished proposal and the close request for finished work; `Next Action` says what unblocks it. When some step can start without the wait, the item is `in-progress` instead, with the wait noted under `Decisions`.
- `completed`: the scoped outcome is resolved, whether delivered, decided, rejected, or cancelled, and the final snapshot is about to be removed.

Older items may say `planned`; read it as `in-progress` with nothing started.

Each fact has one home, and other files link to it. Status and next action live only in `index.md`; support files do not repeat them. When a plan exists, `Next Action` links its next unchecked task, because plan checkboxes are the task state. A decision's one-line status lives under `Decisions`; its rationale lives in the proposal or research it links to.

## Keeping The Checkpoint Current

The thread doing the work keeps `index.md` and `log.md` current. When work is delegated, the delegating thread does; workers report back instead of editing them, unless their brief says otherwise.

Update them when you commit, finish or abandon a step, get a decision or verification result, hit a blocker, delegate, and before you stop; not after every command. Put the update in the same commit as the change that made the index stale; when earlier commits left it stale, commit the repair on its own. If you may edit but not commit, update the files and leave them uncommitted; if you may not edit, put the update in your report instead. Uncommitted work you find stays where it is unless committing it is authorized; record where it lives. At each update:

- rewrite `Summary` and `Next Action` so a new thread can find and start the next action from them. `Summary` says what is done, what remains (a short checklist when there is no plan), what is still unverified, the branch, the base commit (`HEAD` before you commit this update), and where any uncommitted work lives (`none` when this update commits everything);
- append one entry of a few lines to `log.md` with what git does not already show: `- YYYY-MM-DD — what changed; evidence (command and result, PR, thread link); what is unverified`. Link to long output and reports instead of pasting them. Label evidence you did not observe yourself as inherited, and name landed work you found, rather than did, by its commit. Never rewrite earlier entries except to correct them, and never copy history into `index.md`;
- tick plan tasks when their verification passes; when a pending decision blocks part of a task, split it into done and open sub-tasks instead of editing its acceptance;
- update `Decisions` as described below.

Recovery reaches only the last checkpoint. When resuming, compare `Summary` and `Next Action` with the latest entries in `log.md`, `git log`, the code, and any external copies the item names: check whether listed work already landed and whether people left feedback elsewhere, and fix whatever is stale before acting.

## Decisions

Record one decision per line: `Open:` (no recommendation yet) or `Proposed:` (with a recommended default), each with who decides, or `Accepted:` with the outcome (which may be "no" or "out of scope"), who accepted it, when, and where. Name a person or role as decider; when a group decides, record who accepted for it. When nobody is named, write `decider unknown` and ask; if nobody can be asked, keep it and name the gap in your report.

Only the named decider, or a person they delegated it to, accepts a decision. An agent records an acceptance and never gives one; silence is not acceptance, and a suggestion from anyone else is noted with its author and leaves the decision open.

A `Proposed:` decision is not approval, and neither is behavior that already landed on it. Build on one only when it is easy to reverse and does not change behavior that people or clients rely on: a proposed bound or validation on a new, unreleased parameter qualifies, because adding it later would break clients; a default that changes existing responses does not. Judge each choice on its own, splitting a line that bundles several. Otherwise do every part of the work that does not depend on it, including the independent part of a task that also touches the decision (for example, accept an explicit parameter but leave its default unchanged); keep behavior that already landed, leave the decision for its owner, and stop there.

## Support Files

Add a file only when someone will read it and the index cannot hold it. Name files by what they hold:

- `research.md`: what is true: sourced findings, constraints, options, uncertainty.
- `proposal.md` or `design.md`: what reviewers must decide: the recommendation, alternatives, contracts (APIs, data types, schemas), diagrams in a format the reviewers' tools render, and an indicative delivery order.
- `plan.md`: how to execute, written after the direction is accepted and only when order is not obvious or someone else will execute it.

One file may hold several of these when that is easier to review. Use a folder only for several files of one kind, with an `index.md` that maps them. Once implemented, code and docs are canonical for contracts and behavior; a work item is not a home for product documentation.

## Sharing And Closing

People often review a proposal or summary elsewhere: a rendered document, a Notion page, a PR description, slides. `index.md` stays canonical for status, decisions, and next action. List each view under `Artifacts` with the commit or date it reflects, name each document's one authoritative copy, and bring feedback and edits made elsewhere into it before acting. Prefer links to copies; every copy must be kept in sync.

Do not commit secrets, personal data, or temporary URLs.

Close an item only when the user asks. When the scope is done and the request did not ask to close, set `Status: blocked` with `Next Action` naming the owner's close request, and report that it is ready. Closing follows the `agent-work` skill: promote what should last, resolve open decisions, commit a `completed` snapshot, then remove the item in a separate commit.
