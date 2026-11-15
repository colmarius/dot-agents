# Research: how dot-agents guidance is used in practice

Date: 2026-11-15
Sources: the owner's Amp threads from 2026-08-15 to 2026-11-15, mostly in one private product repository and its `.agents/` tree; two collaborators' threads over the same period; and earlier dot-agents audits. Thread sources are in a private workspace and are not linked here. People and products are not named.

## What work items are actually used for

1. **Aligning with humans on direction.** Permission-model, file-delivery, and API-integration work produced research notes, proposals, use cases, data-structure sketches (TypeScript pseudo-types), API responsibility tables, decision lists, and visuals. Several never reached an implementation plan; the item stayed `researching` while humans reviewed it.
2. **Recovering and coordinating long work.** A 12-task isolation effort (many review orbs, a crash and recovery) and a 17-worker dead-code cleanup used the work item as the shared record of what was done and what remained.
3. **Parking deferred work.** Follow-up threads created index-only items holding a table of findings and open owner decisions.

## Artifact usage in the product repository (20 live items, 78 files)

| Artifact | Items using it | Notes |
| --- | --- | --- |
| `index.md` | 20 | 28–90 lines; long ones carry review resolutions and delivery history |
| `research.md` or `research/` | 16 | most common support file |
| `plan.md` or `plan/` | 10 | multi-file plans in 3 items |
| custom names (`design.md`, `boundaries.md`, `team-proposal.md`, `use-cases.md`, `data-structures.md`) | 3+ | invented because the catalog had no alignment document |
| `prd.md` | 1 | |
| `decisions/` | 0 | decisions were kept as lists in `index.md` |
| persisted `handoff-*.md` | 0 | every handoff stayed in the prompt |
| progress file | 0 live; used in the two largest efforts | `plan.progress.md` reached 855 lines |

## Friction observed

- **Index bloat and duplicated state.** `index.md` grew into a delivery log that overlapped the progress file; the same conclusions lived in notes, Amp artifacts, visuals, and chat replies.
- **Stale state.** Summaries, `researching` status, and next actions lagged behind reality for days; an inherited index said "review pending" after the review had found a blocker.
- **Progress fell behind.** The coordinator updated the progress file only at milestones; recovery after context compaction relied on the compaction summary, not the file.
- **No home for alignment content.** Proposals, contracts, data types, and diagrams had no named artifact, so each effort invented one.
- **Repository versus rendered documents.** Nothing said which is canonical when a work item and an Amp artifact or Notion page both hold the proposal; artifacts drifted.
- **Closeout.** "Git history is the archive" failed when the snapshot commit was not reachable from the merged branch; links into removed items had to be rewritten; a later continuation had to recover a deleted item with `git show <sha>^:path`.
- **Unused machinery.** Decision records, persisted handoffs, PRDs, and `plans/index.md` maps were rarely or never used; the plan template's per-task `Scope`/`Depends on`/`Acceptance` fields were followed but rarely read back.

## Collaborators' usage

Two collaborators, read through about seven threads each; long threads were sampled.

- **History buried current state wherever it was written into state files.** One `index.md` reached 967 lines, about 700 of them old handoffs under Next Action; a `plan.md` reached 3,211 lines and had become a session log; a later index overview turned into a PR-by-PR log. One cleanup cut an item from 6,978 to 861 lines. In an item whose progress lived in its own file (255 lines), `index.md` stayed at 34 lines.
- **People asked for a short view of done and remaining:** a clear task list of what is left, a high-level overview, and a closing record that only checks off what was resolved. One collaborator wrote a personal skill for Done/Remaining reports.
- **Trackers multiplied.** Amp artifacts became the live board, with Git snapshots stamped by artifact revision, plus Notion and GitHub issues, all synced at every milestone.
- **Closeout in practice.** A weekly personal skill removes items whose implementation PR merged with `git rm -r`, because those items never got a `completed` snapshot and their status still read `blocked` or `in-progress`. Plan files were removed from branches once work finished.
- **Decision records went unused.** One `decisions/001` file absorbed every later decision; progress files stayed "none" in several items.
- **Conversation first.** One collaborator worked mostly in conversation, approved each delivery step separately, often accepted suggested replies, aligned through prototypes, screenshots, and videos more than documents, kept research, contracts, and tasks in one plan file, and pushed back on over-testing and over-documenting.

## What worked and should stay

- One `index.md` entrypoint read first; `list-work.sh` surfaced existing items and prevented contradictions.
- Status plus a single canonical next action; `blocked` with an owner decision as the next action.
- Handoff prompts naming base revision, scope, verification, and exact delivery authority.
- Promote-then-remove closeout, with `close-work.sh` as a deterministic guard.
- Conversational work by default; research that stays a single reusable note.

## Implications for frontier models

Current models (Opus 5.5, GPT-6 Astra, Fable 5.2) plan, research, delegate, and verify well without step-by-step procedures, and harnesses such as Amp already supply delegation and verification rules. Guidance earns its place when it states facts a model cannot infer: where shared state lives, its minimal shape, when to create it, and which delivery actions need authority. Long procedural references mostly restate what the model would do anyway and compete for attention with project guidance.
