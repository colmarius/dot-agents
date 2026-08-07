# Coordinated Execution

Use this reference before assigning multiple workers, a resumable worker, or a worker/reviewer loop. A single bounded worker for isolated work needs only the inline `agent-work` rules.

## Define The Contract

Brief each worker using the [handoff context contract](handoff-context.md). For coordinated execution, also name its role, expected outcome, effort or budget boundary, return format, and integration owner.

Choose worker capability by uncertainty, not urgency. Bounded, known-done tasks need less discovery than outcomes whose implementation path is unclear.

## Match The Worker To The Work

- Use a one-shot worker for isolated, well-specified work when its resulting artifacts and final report are sufficient.
- Use a resumable worker when the work needs follow-up, message or file exchange, a separate history, another project, or another execution environment.
- Parallelize only clearly independent work. Keep one writer per worktree and use separate environments for disjoint write targets.
- Never assume another environment can see the current branch, uncommitted files, credentials, or local services. Provide required inputs explicitly.

## Choose One Result Path

- Let a worker return asynchronously when useful work can continue in the coordinating thread.
- Wait only when its result blocks the next step.
- Do not request an asynchronous reply and also poll or wait for the same result.

## Review And Integrate

- The coordinating thread owns scope, durable work-item state, integration, and final acceptance.
- Ground review in intent, acceptance criteria, actual changes, and verification evidence rather than a worker's summary.
- Never accept a delegated report by itself: inspect the resulting artifacts and changes directly.
- Run combined verification after integration and reconcile findings into the work item.

## Scheduled Or Event-Driven Work

Treat unattended execution as a service boundary. Authenticate triggers, separate trusted metadata from untrusted content, grant least privilege, make duplicate delivery safe, bound recurrence and spend, name an owner and escalation path, and define expiry and cleanup.
