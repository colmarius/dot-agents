# Proposal: lean guidance for v0.6.0

> Superseded in places: this is the original proposal. The shipped design differs, notably the log lives in `log.md` from the start and is never compressed into `index.md`. `index.md` Decisions and `log.md` record what changed.

Updated: 2026-11-15

## Problem

dot-agents v0.5.1 ships about 1,100 lines of installed guidance: a 98-line work-item contract, a 110-line `agent-work` skill with three references (161 lines) and four templates (240 lines), a 134-line research skill, and a 129-line `AGENTS.md` template. Most of it describes procedures frontier models already follow. Meanwhile the parts people rely on most, aligning humans on direction and recovering long work across threads, have no explicit home. See [research.md](research.md) for the evidence.

## Goal

A work item becomes **the shared record between humans and agents**: what we are doing and why, what we decided, what is done, and what remains. Everything else is optional and named by its content.

## Proposed shape

```text
.agents/work/<category>/<slug>/
├── index.md        # required: why, current state, decisions, next action, log
└── <name>.md       # optional, named by content: research.md, proposal.md, plan.md, ...
```

`index.md` sections, in order:

| Section | Holds | Rule |
| --- | --- | --- |
| metadata | `Status`, `Category`, `Updated` | unchanged from v0.5 |
| `## Why` | intent and the outcome wanted | stable |
| `## Summary` | what is true now and the scope boundary | rewrite, never append |
| `## Artifacts` | links to support files and external views | optional |
| `## Decisions` | accepted and open decisions, one line each | new; replaces `decisions/` and `Open Questions` |
| `## Next Action` | the next step, then remaining work in order | the only canonical "what next" |
| `## Log` | dated entries: what changed, evidence, links | new; append-only; replaces `progress.md` |

Statuses stay `researching | planned | in-progress | blocked | completed`, so every existing work item and script keeps working.

Support files have suggested names, not a fixed catalog:

- `research.md` — what is true: sourced findings, constraints, options.
- `proposal.md` (or `design.md`) — what we propose, for human review: recommendation, alternatives, contracts (APIs, data types, schemas), diagrams, open decisions.
- `plan.md` — how we execute, when sequencing is not obvious: ordered tasks with acceptance, verification, rollout.

Rendered views (Amp artifacts, Notion pages, PR descriptions, slides, videos) are for people; the repository work item stays canonical and links to them.

## When to create a work item

Create one when people need to review or align on direction, when the work will outlive this thread (another session, thread, or person), or when the user asks. Skip it when one thread will finish the work, for quick research answers, and for reviews. In a long single-thread session the conversation already holds the plan; save a plan only when someone else must read it or sequencing is complex.

## File-level changes

| File | v0.5.1 | v0.6.0 target |
| --- | --- | --- |
| `.agents/work/AGENTS.md` | 98 lines, 9 artifact types | ~60 lines: shape, statuses, log, views, closeout |
| `agent-work/SKILL.md` | 110 lines + 3 references | ~80 lines; handoff, coordination, and stress-test essentials inline |
| `agent-work/references/*.md` | 3 files, 161 lines | removed |
| `assets/prd-template.md`, `assets/work-decision-template.md` | 2 files | removed |
| `assets/plan-template.md` | 90 lines | ~25 lines |
| `assets/work-index-template.md` | 6 sections | adds `Decisions` and `Log`; drops `Open Questions` |
| `research/SKILL.md` | 134 lines | ~60 lines |
| `adapt/SKILL.md` | 113 lines | ~60 lines; migration repair moves to the v0.6 migration guide |
| `AGENTS.template.md` | 129 lines | ~75 lines; no work-item file tree |
| `agent-browser`, scripts | | unchanged except sync retiring removed files |

## Compatibility

- Existing work items stay valid: metadata, statuses, `Why`, `Summary`, `Artifacts`, `Next Action`, and closeout validation are unchanged. Old `progress.md`, `prd.md`, `decisions/`, and `plans/` files remain user content.
- Sync removes the retired upstream templates and references from installed skills.
- Minor version bump (0.6.0): the contract is simplified, not broken.

## Trade-offs

- **Less prescription for weaker models.** Smaller or older models may plan less rigorously without the task-field contract. dot-agents targets current frontier models; projects can keep their own templates.
- **Log in `index.md` grows.** One file to read on resume beats two files that drift, but a long log costs context; the rule is to compress older entries once the log gets long.
- **No decision records.** Rationale for big decisions lives in `proposal.md` or the log; the index keeps one line per decision.
- **Fewer named artifacts.** Flexible naming fits real usage but makes items less uniform across projects.

## Open questions for reviewers

1. Is putting the log in `index.md` better than a separate `progress.md` for recovery across threads?
2. Should statuses shrink (for example `active | blocked | completed`), or is compatibility worth five?
3. Is the two-commit closeout still worth it, or should removal happen in the change that finishes the work?
4. What guidance is still missing for frontier models, and what else can go?
