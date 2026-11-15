# User accounts and per-user notes

Status: blocked

## Why

Today any caller can read and delete every note. The team wants user accounts so each person sees and changes only their own notes. Before anyone writes code, the team needs to review the options and agree on a direction.

## Summary

Research and a proposal are drafted for team review; no code has changed. The recommendation is self-service username/password accounts, with Argon2id hashing from built-in `node:crypto` and opaque server-stored bearer tokens (`Authorization: Bearer`). Every note lookup is scoped by owner, so other users' notes return `404`. There are no new dependencies. The proposal lists nine decisions (D1–D9), each with a recommended default; none has been accepted yet.

Scope: accounts, login/logout, and per-user note isolation. Out of scope: persistence (everything stays in memory), password reset, email verification, MFA, sharing, and roles.

Repository state: branch `main`, based on the commit before the one that adds this item. All work-item files are committed; nothing is pushed.

## Artifacts

- [proposal.md](proposal.md): authoritative copy of the proposal to share. It has the recommendation, alternatives, API contract, data types, a sequence diagram, decisions D1–D9, and a delivery outline. Copies shared elsewhere (PR, doc, chat) are copies; reconcile comments back into this file.
- [research.md](research.md): sourced findings (OWASP, Node 24 `crypto` docs, RFC 6750, RFC 8725), observations about the current code, an options table, and open questions.

## Decisions

- Proposed: Option A, passwords + opaque server-side bearer tokens, over JWT, cookies, an IdP, API keys, or Basic auth. Rationale in [proposal.md](proposal.md#alternatives). Team decides.
- Proposed: D1–D9 in [proposal.md](proposal.md#decisions-needed): IdP vs in-house, transport, rollout of the breaking change, sign-up enumeration, `ownerId` exposure, password minimum, session lifetime, persistence, minimum Node version. Deciders are named per row.

## Next Action

- Share [proposal.md](proposal.md) with the team and collect answers to D1–D9. Reconcile any comments made elsewhere into it, then record each answer under Decisions as `Accepted:` with who approved. If D1 picks an existing IdP, or D2 picks a browser cookie, revise the proposal before planning. Otherwise set status to `in-progress` and start delivery slice 1 (owner-scoped store) from the proposal's delivery outline.
