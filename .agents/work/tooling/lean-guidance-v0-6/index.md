# Lean guidance for v0.6

Status: completed

## Why

Simplify dot-agents guidance for current frontier models (Opus 5.5, GPT-6 Astra, Fable 5.2): keep what they cannot infer, and make work items a light shared record of what is being done, what was decided, what is done, and what remains, so people stay aligned and another thread can resume.

## Summary

Done: dot-agents v0.6 simplifies the guidance for current frontier models. Work items are a lean shared record (`index.md` for current state, `log.md` for history, `Decisions` with `Open:`/`Proposed:`/`Accepted:`), with four statuses and `Status:` as the only metadata; the contract holds what every reader needs and the `agent-work` skill holds the actions; `agent-browser` and the PRD, decision, and reference files are retired; the guides are one docs page; and `scripts/evals/` holds the regression eval. Five review passes and five eval rounds on Opus 5.5, GPT-6 Astra (medium), and Fable 5.2 shaped it. Outcomes live in `.agents/work/AGENTS.md`, the skills, `docs/`, `CHANGELOG.md`, and `scripts/evals/README.md`. Nothing remains in scope; the v0.6.0 release commit follows this item's removal on the same branch.

Branch `simplify-guidance-v0.6`, on `main` `5ca76b8`. Uncommitted work: none.

## Artifacts

- [log.md](log.md) — dated history
- [research.md](research.md) — how the guidance is used in practice
- [proposal.md](proposal.md) — the original proposal; superseded where Decisions below differ
- `scripts/evals/README.md` — eval harness and what the rounds learned

## Decisions

- Accepted: implement the simplification and iterate with reviews and evals before release (owner, 2026-11-15, kickoff request).
- Accepted: release as 0.6.0, a minor release, with the second simplification pass included (owner, 2026-11-15, chat).
- Accepted: drop `planned`; statuses are `researching`, `in-progress`, `blocked`, `completed` (owner, 2026-11-15, chat).
- Accepted: `log.md` beside `index.md` from the start (owner, 2026-11-15, chat).
- Accepted: finished scope waiting for the close request is `blocked` (owner, 2026-11-15, chat).
- Accepted: keep the two-commit closeout; with squash merges, remove in a later change (owner, 2026-11-15, chat).

## Next Action

- None.
