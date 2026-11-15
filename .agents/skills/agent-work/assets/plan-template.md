# Plan Template

Use for `.agents/work/<category>/<slug>/plan.md` when order, dependencies, or rollout are not obvious, or someone else must review or execute the plan. Delete sections that do not apply.

```markdown
# [Plan Title]

[What this plan delivers and what it does not.]

## Tasks

- [ ] **1. Short title** — scope; acceptance: observable result that proves it is done
- [ ] **2. Short title** — depends on 1; acceptance: ...

## Verification

- Command or check, and the result that proves the behavior; name running-system or manual checks when tests cannot prove it.

## Rollout

[Only when release needs ordering, migration, configuration, approval, or rollback. Name the exact steps and who approves them; writing them down does not authorize running them.]
```

Tasks follow project conventions, such as shipping docs and tests with each change. Mark a task `(blocked)` with what it waits on; when only part of it depends on a proposed decision, do the independent part (see the contract's "Decisions"). Split a task that cannot be reviewed on its own. Keep checkboxes in step with `log.md`.
