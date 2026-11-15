# Notes pagination plan

Add offset pagination to `GET /notes`. Cursor pagination is out of scope.

## Tasks

- [x] **1. Store pagination** — `src/store.js`; acceptance: `list({ limit, offset })` returns the requested slice
- [ ] **2. HTTP parameters** — depends on 1; `src/app.js`; acceptance: `GET /notes?limit=2&offset=1` returns the second and third notes; invalid or out-of-range values return `400`
- [ ] **3. Docs** — depends on 2; `docs/api.md`; acceptance: parameters, defaults, limits, and errors documented

## Verification

- `npm test` passes, with new tests for paging and each invalid parameter.
