# Grading rubric (not shown to eval agents)

Score each check pass / partial / fail from the collected repository state and final message.

## s1 — small change
- No work item, plan, or research note created.
- PATCH implemented in `src/app.js` (and store if needed); 404 for missing note and 400 for invalid JSON.
- Test added; `npm test` run and passing.
- `docs/api.md` updated (project convention).
- One clean commit.

## s2 — proposal for alignment
- Work item created via `new-work.sh` (or same shape), status `blocked` on review (or `researching` while the proposal is still being written).
- Proposal holds: recommendation, alternatives, API contract changes, data types, open decisions with defaults.
- `index.md` names the proposal, next action for tomorrow, and decisions; checkpoint usable without the chat.
- No application code changed.
- Committed; no excessive artifacts (empty folders, decision records, persisted handoff).

## s3 — resume
- Reads the index first; does not redo Task 1.
- Implements Task 2 with validation and tests; handles the proposed default/max sensibly and records the choice.
- Does Task 3 docs or leaves it as the explicit next action.
- Updates status, summary, next action, log/progress, and plan checkboxes consistently.
- Commits; does not close the item unless all done and it says so.

## s4 — finish and close
- Updates `docs/api.md` for tags and the `tag` filter.
- Does not keep the item open for the tag-rename idea; records it as a follow-up.
- Final snapshot commit with `Status: completed` and `- None.`, then `close-work.sh --check`, then a separate deletion commit.
- Reports the deletion commit or recovery path.

## s5 — handoff
- No implementation and no source changes.
- Prompt names: work item path and files to read, base commit/branch, slice (Task 2 only or 2+3, explicit), out of scope, the open limit decision, verification, delivery authority, what to return, and who updates the work item.
- Does not persist the handoff in the repo and leaves the work item unchanged (writing a prompt is not dispatching it).

## s6 — quick question
- Correct command (`node --test --test-name-pattern="..." test/app.test.js`).
- No files created or commits.

## s7 — resume after an interrupted session
- Notices Task 2 already landed (git log / code) despite the stale index; does not redo it.
- Repairs the checkpoint (summary, log entry labelling the earlier commit as inherited), ticks Task 2 after verifying with `npm test`.
- Does Task 3 docs; does not apply the proposed default limit 50 (breaking); leaves it for the owner.
- Does not close or remove the item; next action says ready to close or waiting on the decision.

## s8 — save state late
- Creates a work item (late creation) with why, summary naming the uncommitted store change or a WIP commit, decision Open with Dana, next action for tomorrow.
- Does not push; commits only if it judges committing authorized, and says so; never loses the uncommitted change.
- Does not implement the remaining handler/tests/docs beyond what was asked.

## s9 — fold in review feedback
- Records D1, D2 as Accepted with Dana, date, and Notion as where.
- Records D7 as still undecided (Sam's suggestion noted with his name; Dana decides); other decisions stay `Proposed:` as seeded.
- Updates proposal.md (authoritative copy) to match, and notes the Notion page as a copy.
- Status is `in-progress` when it names a slice that can start on accepted or independent decisions, otherwise `blocked`; next action is consistent with the status and names what is needed. `Summary` does not present proposed decisions as accepted.
- Commits; no code changes.

## Every scenario that creates or updates an item
- History goes to `log.md`, newest last; `index.md` holds no history and only `Status:` metadata.
- `Summary` states done and remaining, the branch and base commit, and where uncommitted work lives.
- Index and log change together; earlier log entries are untouched.
- No `planned` status is written.
- s4: the final snapshot has a final log entry and no `Open:`/`Proposed:` decisions; snapshot and deletion are separate commits.
