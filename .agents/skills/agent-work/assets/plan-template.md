# Plan Template

Use this template when creating `.agents/work/<category>/<work-slug>/plan.md` or a focused plan under `.agents/work/<category>/<work-slug>/plans/<name>.md`. Plans following this format can be executed in the current thread or delegated as bounded work.

Use one `plan.md` for straightforward work. When `plans/` contains multiple phase plans, add `plans/index.md`, keep task numbers unambiguous across files, and link the active phase from the work-item index.

## Template

```markdown
# [Plan Title]

[Brief description of what this plan accomplishes.]

## Goals

- Goal 1
- Goal 2

## Tasks

- [ ] **Task 1: Short descriptive title**
  - Scope: `path/to/affected/files` or module name
  - Depends on: none
  - Acceptance:
    - Specific, verifiable criterion 1
    - Specific, verifiable criterion 2
  - Notes: Optional implementation hints

- [ ] **Task 2: Another task title**
  - Scope: `path/to/affected/files`
  - Depends on: Task 1
  - Acceptance:
    - Specific, verifiable criterion
  - Notes: None

## Implementation Notes

[Key principles, pitfalls to avoid, testing strategy, and scope limits.]

## Constraints / Decisions

- Constraint or decision 1
- Constraint or decision 2

## Acceptance Criteria

- Overall criterion 1
- Overall criterion 2

## Verification

- Focused command and observed success condition
- Running-system or manual evidence when the risk requires it

## Deployment / Migration

[Include this section only when releasing the change requires deployment, migration, generated artifacts, configuration, ordering, approval gates, or rollback steps. Name exact actions and owners; documenting a step does not authorize executing it.]
```

## Task Format Rules

Each task must include:

| Field | Required | Description |
| --- | --- | --- |
| **Title** | Yes | `**Task N: Short descriptive title**` |
| **Scope** | Yes | File path, module, package, or subsystem affected |
| **Depends on** | Yes | Task ID or `none` |
| **Acceptance** | Yes | Specific, verifiable criteria |
| **Notes** | No | Implementation hints, commands, or risks |

Split a task if it cannot be described in 2-3 sentences or cannot be reviewed independently. For multi-layer work, prefer an early thin end-to-end slice before follow-up hardening.

## Task Status Markers

| Marker | Meaning |
| --- | --- |
| `- [ ]` | Not started |
| `- [x]` | Completed |
| `- [ ] (blocked)` | Blocked, needs intervention |
| `- [ ] (manual-verify)` | Requires manual verification |

## Execution-Ready Checklist

Before implementing or delegating, confirm:

- [ ] The plan lives at `.agents/work/<category>/<work-slug>/plan.md` or `.agents/work/<category>/<work-slug>/plans/<name>.md`.
- [ ] `index.md` links the active plan file and has the correct `Status:`.
- [ ] Every task has `Scope`, `Depends on`, and verifiable `Acceptance`.
- [ ] The next task or phase is clear.
- [ ] External blockers and human-only steps are explicit.
- [ ] The intended verification commands are named when not obvious.
- [ ] Verification is proportional to blast radius and identifies evidence that can prove the behavior, not only commands to run.
- [ ] Release, migration, or rollback steps are explicit when the change touches a release surface.
