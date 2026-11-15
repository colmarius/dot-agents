# Note tags

Status: in-progress

## Why

People want to group notes and list one group at a time.

## Summary

Notes accept a `tags` array on create, and `GET /notes?tag=<tag>` filters by tag. Both are implemented and tested in `test/app.test.js`. The API docs do not mention tags yet.

## Decisions

- Accepted: tags are free-form strings with no registry (owner, 2026-11-08).
- Open: a tag rename endpoint was suggested; the owner said it is a separate idea, not part of this item.

## Next Action

- Document tags and the `tag` filter in `docs/api.md`, then close this item.
