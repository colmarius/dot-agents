# Cross-repository delivery: API and booking app

This is a fictional worked example, not a release record. Every repository, branch, revision, command, date, person, and outcome below is illustrative. No deployment commands are supplied where the fictional repositories have not established them.

Most work still needs no files. This change needs one coordinator work item because two repositories share an acceptance check and the work continues across environments. It does not need a work item per worker or new lifecycle statuses. Use the existing [handoff contract](../../.agents/skills/agent-work/SKILL.md#hand-off-or-delegate).

## Agree on an additive contract

`service-api` will add optional `availableSeats` to `GET /departures/:id`. Existing response fields remain unchanged. `booking-app` will show the seat count when present and retain its current availability text when absent.

Acceptance distinguishes the cases that can be confused:

- With `availableSeats: 3`, the app shows “3 seats available”.
- With `availableSeats: 0`, the app shows “Sold out”; zero is not treated as a missing value.
- Without the field, the old availability text remains, and older API clients still work.
- After the API development deployment, the booking app reads those responses from the live development API. Fixture and unit tests do not satisfy this check.

The product owner accepts this contract and authorizes feature branches, commits, PRs, and the API's development rollout after review. Merging the API PR triggers that development deployment automatically, so its merge is also inside that authorization. The consumer PR may be opened but not merged yet. Production merges, tags, deployments, migrations, and publishing a shared package remain unauthorized.

## Give each writer a boundary

The coordinator owns `service-api/.agents/work/booking/seat-count/index.md`, `log.md`, and the optional `plan.md`, plus integration and final acceptance. The index links the API PR on `feature/seat-count` and consumer PR on `feature/seat-count-ui` in their respective repositories; it does not duplicate their diffs.

| Owner | Write targets | Starting base |
| --- | --- | --- |
| API worker | `service-api`: `packages/availability/`, `apps/api/`, API tests and contract docs | `origin/main` at `1111111111111111111111111111111111111111` |
| Consumer worker | `booking-app`: departure UI, response fixture, consumer tests | `origin/main` at `2222222222222222222222222222222222222222` |
| Coordinator | Canonical work item and integrated checks | The API base above; receives both workers' results |

Each worker starts from the named base for its repository; neither assumes another checkout's local `main` equals `origin/main`. Shared config and lock-file changes return to the coordinator for ownership assignment rather than being edited concurrently. Workers report results through the agreed conversation; only the coordinator updates canonical status.

## Transfer the code, not just its hash

The coordinator attaches a revision-dated read-only view of the index and accepted contract to the conversation before dispatch, naming the repository index as authoritative. This makes the context available even though the consumer checkout does not contain it. An illustrative consumer handoff:

> Read the coordinator index and accepted API contract first. Implement the departure UI in `booking-app` from `origin/main` at `2222222222222222222222222222222222222222`, on `feature/seat-count-ui`. The API worker's contract change is committed locally on `feature/seat-count` at `3333333333333333333333333333333333333333`, but is not pushed. Its hash alone cannot be fetched. The coordinator will transfer `seat-count-api.patch` and its SHA-256 digest through our access-controlled file-transfer channel; confirm receipt and the digest before using it in a separate `service-api` checkout at `1111111111111111111111111111111111111111`. If it is unavailable, report the missing transfer; do not claim to have inspected that API implementation. You can begin the UI against the accepted three-case fixture now. Own only the consumer targets above. Commit, push, and open the consumer PR; do not merge or deploy. Run the fixture checks and report their commands, revisions, and results, labeling API worker results as inherited. The live integration check waits for the API development deployment. Return your changes, evidence, and blockers here; do not edit the coordinator's work item.

For that single committed API change, an illustrative export from the API checkout is:

```bash
git format-patch --stdout 1111111111111111111111111111111111111111..3333333333333333333333333333333333333333 > seat-count-api.patch
sha256sum seat-count-api.patch
```

The coordinator transfers the file and digest, not this local filename. The recipient verifies the digest and base before `git am seat-count-api.patch`. Store the patch in ignored local storage and move it through the agreed channel; the commands above do not perform that transfer. A pushed branch is another valid code-delivery method when pushing is authorized. For uncommitted work, the handoff must also transfer the uncommitted patch and any required untracked files, or explicitly exclude them.

## Keep each kind of context in one home

| Content | Home |
| --- | --- |
| Intent, current state, decisions, next action | Coordinator work-item `index.md` |
| Dated verification and milestone history | `log.md`, linking larger evidence |
| Task order and rollout procedure | Optional `plan.md` |
| Implemented API or product behavior | Owning repository's code and canonical docs |
| Worker-specific instructions and temporary execution details | Handoff in the conversation |
| Raw logs, screenshots, temporary patches, local resource identifiers | Ignored local storage or an access-controlled evidence store |
| Notion, PR, or rendered review copy | Linked view naming the authoritative source and revision/date it reflects |

For example, an external review copy says “View of the coordinator index as of 2026-11-18; the repository index is authoritative.” The coordinator links it under `Artifacts`, reconciles review comments into the index or owning proposal, and updates the view after a decision. An Amp-specific local directory such as `.amp/in/` is not required by dot-agents and does not itself make files accessible to another environment.

Evidence links must be accessible to the reviewer. Record the evidence-store record identifier and how an authorized person retrieves or regenerates it; keep access tokens and expiring download links out of committed docs. Durable API docs describe the three response cases and how to seed them in a disposable environment, not a worker's temporary fixture URL.

## Order the optional rollout

This work's `plan.md` needs a rollout section because live integration depends on deployment. Its rollout details are:

1. **API development release unit:** rebuild `service-api/apps/api`, which bundles `packages/availability`. Updating only the library source does not update the running API. Regenerate the API schema using the repository's established command and include it in the reviewed API change. This additive field needs no database migration or new configuration; confirm that assumption during review.
2. **API deployment:** the authorized API merge triggers the development pipeline. Record its immutable build revision, wait for its result, and query the seeded departure cases. A successful build alone is not evidence that the environment serves the new contract.
3. **Consumer integration:** use the consumer PR revision in a local preview against the development API only after step 2. Check all three seat-count cases and the existing booking action. The development API URL and test-data access come from the environment owner through the agreed access channel; production data is not copied into fixtures.
4. **Consumer release unit:** `booking-app` needs its own build and deployment after integration passes and merge/deployment authority is granted. Do not infer that the API pipeline deploys the consumer. The consumer's automatic/manual deployment policy and exact command remain an explicit gap for its maintainer to resolve before rollout.
5. **Production:** repeat API-before-consumer ordering only after the owner approves the exact revisions, environment, and deployment mechanism. Documenting that order grants no execution authority.
6. **Recovery:** restore the previous consumer build first if it has shipped, then the previous API build through the environment's approved rollback procedure. The consumer's missing-field fallback supports the older API. No irreversible data step is planned; if a later design adds a backfill or destructive migration, replace this simple rollback with a reviewed recovery plan before executing it.

## Record a checkpoint that does not overclaim

Suppose the API worker reports passing unit tests, the coordinator inspects the changes, and the API is merged and deployed to development at illustrative revision `4444444`. The consumer fixture tests pass at illustrative revision `5555555`, but the live integration request returns HTTP 503. The coordinator records the failure instead of treating the two worker reports as integrated success.

An illustrative `Summary` in the canonical index:

> API and consumer implementations and targeted tests are complete. The API change is merged and development deployment `4444444` passed the API contract checks. Consumer PR `feature/seat-count-ui` at `5555555` remains open; its fixture checks pass, but the coordinator's live development integration check returned HTTP 503, so end-to-end behavior remains unverified. No consumer deployment is claimed. Production and consumer merge/deployment are outside current authorization. Coordinator branch `delivery/seat-count` is based on `4444444`; uncommitted work: none. Detailed checks and accessible evidence are linked in `log.md`.

With no independent task left, the item is `blocked`; `Next Action` names the development environment owner restoring access, then the coordinator rerunning live integration. An unavailable environment would remain open in the same way. Once the scoped checks pass, the coordinator asks for any still-required delivery authorization; production does not become a requirement if it was never part of the requested outcome.

An illustrative dated log entry holds the evidence rather than repeating the whole summary:

> 2026-11-18 — Inspected both repository changes. Inherited: workers' unit/fixture reports at `3333333`/`5555555`. Observed: development API revision `4444444` returned 3, 0, and missing-field cases as expected; consumer live integration returned HTTP 503. The access-controlled evidence record contains request/response captures and the exact check command. Integration remains open; environment owner to restore access. No production action taken.

A one-session documentation correction can omit the work item and rollout entirely. The extra detail here follows from this change's cross-repository dependency and authorized development rollout, not from a mandatory delivery checklist.
