# Notes pagination

Status: in-progress

## Why

`GET /notes` returns every note. The mobile client needs pages so large accounts load quickly.

## Summary

The store supports `limit` and `offset` (Task 1). The HTTP layer and docs do not expose pagination yet. Scope: offset pagination only; cursors are out of scope.

## Artifacts

- [plan.md](plan.md) — tasks and verification

## Decisions

- Accepted: offset pagination with `limit` and `offset` query parameters (owner, 2026-11-11).
- Proposed: default `limit` 50, maximum 100; reject larger values with `400`.

## Next Action

- Task 2 in [plan.md](plan.md): parse and validate `limit` and `offset` in `GET /notes`, on branch `main`.
