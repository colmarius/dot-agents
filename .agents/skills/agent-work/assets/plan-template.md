# Plan Template

Use this template when creating `.agents/work/<category>/<work-slug>/plan.md`. Plans following this format are implementation-ready and easy to hand off to a fresh agent thread.

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

- Command or manual check 1
- Command or manual check 2
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

Split a task if it cannot be described in 2-3 sentences or cannot be reviewed independently.

## Task Status Markers

| Marker | Meaning |
| --- | --- |
| `- [ ]` | Not started |
| `- [x]` | Completed |
| `- [ ] (blocked)` | Blocked, needs intervention |
| `- [ ] (manual-verify)` | Requires manual verification |

## Handoff-Ready Checklist

Before asking for an implementation handoff prompt, confirm:

- [ ] The plan lives at `.agents/work/<category>/<work-slug>/plan.md`.
- [ ] `index.md` links the active plan and has the correct `Status:`.
- [ ] Every task has `Scope`, `Depends on`, and verifiable `Acceptance`.
- [ ] The next task or phase is clear.
- [ ] External blockers and human-only steps are explicit.
- [ ] The intended verification commands are named when not obvious.
