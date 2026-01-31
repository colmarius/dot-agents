# Progress File Format

Progress files track work across iterations. They are append-only logs.

## File Location

Progress files live alongside their plan:

```text
.agents/plans/in-progress/
├── my-feature.md              # Plan file
└── my-feature.progress.md     # Progress log
```

## Entry Format

Each completed task gets one entry:

```markdown
## Task N: [Task Title]

**Thread**: [Amp thread URL]
**Status**: completed | blocked | partial
**Iteration**: N

### Changes

- `src/module.rs` - Added X
- `src/lib.rs` - Modified Y

### Commands Run

- `just check` ✓
- `just test` ✓

### Learnings

- [Any patterns discovered or gotchas encountered]

### Next

- [What the next iteration should do]

---
```

## Required Fields

| Field | Description |
| ----- | ----------- |
| Task ID | Task number and title from plan |
| Thread | Amp thread URL for traceability |
| Status | `completed`, `blocked`, or `partial` |
| Iteration | Which loop iteration this was |
| Changes | Files modified with brief description |
| Commands Run | Verification commands and pass/fail |
| Next | What the next iteration should focus on |

## Optional Fields

| Field | Description |
| ----- | ----------- |
| Learnings | Patterns discovered, gotchas, or tips for future |
| Blockers | For blocked status, describe the blocker |

## Example Progress File

```markdown
# Progress: My Feature

## Task 1: Add investor type enum

**Thread**: https://ampcode.com/threads/T-abc123
**Status**: completed
**Iteration**: 1

### Changes

- `src/protocol.rs` - Added new command enum variant
- `src/lib.rs` - Exported new command

### Commands Run

- `just check` ✓

### Next

- Task 2: Implement command handler

---

## Task 2: Implement command handler

**Thread**: https://ampcode.com/threads/T-def456
**Status**: completed
**Iteration**: 2

### Changes

- `src/protocol.rs` - Added handler function

### Commands Run

- `just check` ✓
- `just test` ✓

### Learnings

- Protocol requires proper byte alignment for display commands

### Next

- Task 3: Add CLI integration

---
```

## Blocked Entry Example

```markdown
## Task 5: Integrate payment API

**Thread**: https://ampcode.com/threads/T-xyz789
**Status**: blocked
**Iteration**: 5

### Blockers

- Need API credentials from finance team
- Contact: finance@company.com

### Next

- Wait for credentials, then resume from Task 5

---
```
