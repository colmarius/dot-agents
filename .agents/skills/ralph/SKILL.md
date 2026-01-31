---
name: ralph
description: Autonomous multi-iteration feature implementation using handoff loops. Use when asked to "run ralph", "execute autonomously", "implement this plan autonomously", or for hands-free feature development from structured plans.
---

# Ralph Autonomous Agent

Orchestrates autonomous code generation through repeated iterations using fresh agent instances until all tasks are complete.

## Execution Contract

### Inputs

When invoking ralph, provide:

- **Plan file path**: Absolute or workspace-relative path to the plan markdown file
- **Starting task** (optional): Task ID to resume from (e.g., "Task 3")
- **Max iterations** (optional): Default 20

### State Files

Ralph creates a companion progress file alongside the plan:

```text
.agents/plans/in-progress/
├── my-feature.md              # The plan
└── my-feature.progress.md     # Progress log (auto-created)
```

### Task Status Markers

In plan files, tasks use checkbox status with optional annotations:

| Marker | Meaning |
|--------|---------|
| `- [ ]` | Not started |
| `- [x]` | Completed |
| `- [ ] (blocked)` | Blocked, needs intervention |
| `- [ ] (manual-verify)` | Requires manual verification |

### Stop Conditions

The loop exits when ANY of these occur:

1. **All tasks complete**: Every task checkbox is `[x]`
2. **Blocked encountered**: A task is marked `(blocked)`
3. **Max iterations reached**: Default 20 iterations
4. **Only manual-verify remaining**: All incomplete tasks require manual verification
5. **Explicit stop**: User interrupts

### Handoff Payload

When handing off to fresh iteration, include:

```text
Continue ralph execution for: [plan file path]

Current task: [Task ID and title]
Last progress: [Most recent progress entry summary]
Next action: [Specific next step]

Load the ralph skill and continue execution.
```

## Phases

### Phase 1: Setup

Before running the loop, ensure the plan has proper structure.

**Required task format:**

```markdown
- [ ] **Task N: Short descriptive title**
  - Scope: `path/to/affected/files` or package name
  - Depends on: Task M (or "none")
  - Acceptance:
    - Specific criterion 1
    - Specific criterion 2
  - Notes: Optional implementation hints
```

**Task sizing rule:** If you can't describe the task in 2-3 sentences, it's too big. Split it.

**Dependency ordering:** Schema → Service → API → UI → Tests

### Phase 2: Execution Loop

Each iteration follows this workflow:

1. **Load context**: Read plan file, identify next incomplete task
2. **Check dependencies**: Ensure all `Depends on` tasks are complete
3. **Implement**: Complete the task following its scope and acceptance criteria
4. **Verify**: Run verification commands (see Verification section)
5. **Update progress**: Append entry to `.progress.md`
6. **Update plan**: Check off completed task `[x]`
7. **Commit**: One task = one commit with proper footers
8. **Handoff or complete**: Continue to next task or exit if done

**Git discipline:**

- One task = one commit
- Never push to main branch
- Include footers: `Amp-Thread-ID` and `Co-authored-by: Amp <amp@ampcode.com>`
- Commit format: `feat: [Task ID] - [Task Title]`

## Verification Strategy

Run verification commands appropriate for the project. Check `AGENTS.md` for project-specific commands.

| Situation | Action |
|-----------|--------|
| Every task | Run typecheck/build command |
| After code changes | Run linter |
| Logic changes | Run tests |
| Pre-commit | Run full CI check |

**Examples by language:**

```bash
# TypeScript/Node
npm run check && npm run lint && npm test

# Rust
cargo check && cargo clippy && cargo test

# Go
go build ./... && go test ./...

# Python
mypy . && ruff check . && pytest
```

## Stuck Detection & Safety

### Limits

- **Max iterations**: 20 per session
- **Max retries per task**: 2 attempts before marking blocked
- **Scope control**: Only modify files in declared `Scope`

### Blocking a Task

When a task cannot proceed:

1. Add `(blocked)` annotation to the task checkbox
2. Add blocker details to progress file
3. Stop the loop and surface to user

**Example blocked task:**

```markdown
- [ ] (blocked) **Task 5: Integrate payment API**
  - Scope: `cloud/functions/payments`
  - Depends on: Task 4
  - Acceptance: Payment webhook handler works
  - Notes: Blocked - need API credentials from finance team
```

### Manual Verification Tasks

Tasks marked `(manual-verify)` require human interaction:

- Don't retry these automatically
- Stop loop when only manual-verify tasks remain
- Surface verification instructions to user

## Guardrails

1. **Scope control**: Only touch files in declared `Scope`
2. **No scope creep**: Expanding scope requires explicit plan edit
3. **No prod commands**: Never run production deployments
4. **No secrets**: Never commit credentials or API keys
5. **Branch safety**: Never push to main

## Usage

### Starting Fresh

```text
Run ralph on .agents/plans/tech-debt/in-progress/my-feature.md
```

### Resuming

```text
Continue ralph from Task 5 on .agents/plans/tech-debt/in-progress/my-feature.md
```

### Checking Status

```text
Show ralph progress for .agents/plans/tech-debt/in-progress/my-feature.md
```

## Integration with Plans

Ralph works with plans in the standard directory structure:

- Plans live in `.agents/plans/in-progress/`
- Create plans manually following the task format above
- Use ralph to execute plans autonomously
