# PRD Template

Use this template when work needs requirements alignment before implementation. For small, scoped changes with clear acceptance criteria, create `plan.md` directly instead.

## Template

```markdown
# [Feature Name] PRD

## Problem Statement

What problem are we solving? Why now?

## Goals

- Goal 1
- Goal 2

## Non-Goals

- What we are explicitly not doing

## Users / Use Cases

- Primary user or system actor and scenario

## Requirements

### Must Have

- [ ] Requirement 1
- [ ] Requirement 2

### Nice to Have

- [ ] Optional requirement

## Constraints / Decisions

- Constraint or decision 1
- Constraint or decision 2

## Acceptance Criteria

- Criterion 1
- Criterion 2

## Verification / Rollout

- How this should be verified
- Rollout guardrails or follow-up checks

## Open Questions

- [ ] Question that materially affects scope, sequence, or architecture
```

## Handoff To Planning

Once the PRD is approved, create `plan.md` in the same work item using the [agent-work plan template](plan-template.md). Do not create new `.agents/plans/` files.
