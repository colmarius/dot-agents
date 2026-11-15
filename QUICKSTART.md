# Quickstart

Get productive with dot-agents in 5 minutes.

## Prerequisites

- **bash** 4.0+ (5.0+ recommended)
- **git** for version control
- **curl** for installation
- **OS:** macOS, Linux, or WSL

> **Security:** Review the install script before running:
>
> ```bash
> curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | less
> ```

## 1. Install

Run the installer from the root of the repository you want to equip with dot-agents:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

Fresh installs create `AGENTS.md` and `.agents/`. Re-running the installer later updates dot-agents while preserving work items, research, and your customized `AGENTS.md`.

### What Gets Installed

```text
your-project/
├── AGENTS.md
└── .agents/
    ├── work/
    │   └── AGENTS.md
    ├── research/
    ├── references/
    ├── scripts/
    │   └── sync.sh
    └── skills/
        ├── adapt/
        ├── agent-work/
        └── research/
```

If the project already has a `.claude/` directory, dot-agents also links skills into `.claude/skills/` so Claude Code can discover them as project skills.

### Verify Installation

```bash
ls -la .agents/
cat AGENTS.md | head -20
```

## 2. Adapt `AGENTS.md`

Ask your agent:

```text
Run adapt
```

This analyzes your project and fills in the `AGENTS.md` template with tech stack, commands, and conventions. You can also customize it manually.

If your agent does not auto-discover skills, tell it:

```text
Read .agents/skills/adapt/SKILL.md and follow it.
```

## 3. Choose Conversational Or Durable Work

For a small, self-contained change, stay in the current conversation:

```text
Implement this change, planning only as needed, then verify and report the result.
```

Create a work item when people need a durable record to review or decide direction, when the work must resume in another session, thread, or worker, or when you want one. Creating it late is fine, for example before handing off or stopping for the day.

Ask your agent:

```text
Create a new work item for user authentication.
```

If your agent does not auto-discover skills, tell it to read `.agents/skills/agent-work/SKILL.md` first.

Or run the helper directly:

```bash
.agents/skills/agent-work/scripts/new-work.sh \
  --category feature \
  --slug user-authentication \
  --title "User authentication"
```

A minimal work item is two files:

```text
.agents/work/feature/user-authentication/
├── index.md      # why, done and remaining, decisions, next action
└── log.md        # dated history, newest last
```

`index.md` is the shared record of current state; with the latest `log.md` entries it is the recovery checkpoint. Future threads start there, check it against the log and `git log`, then load only the files they need.

## 4. Research, Propose, Or Plan Only If Needed

If the unknowns are technical, ask for work-local research:

```text
Research authentication patterns for this work item.
```

If people must agree on the direction first, ask for a proposal they can review:

```text
Write a proposal for this work item: the recommendation, alternatives,
API and data-type changes, a diagram, and the decisions we need to make.
```

If the order of work is not obvious, or someone else will execute it, ask for a plan:

```text
Write plan.md for this work item.
```

When the next action is small and clear, skip all three and work from `index.md`.

## 5. Implement Or Hand Off

When the next action is clear, continue in the same thread by default:

```text
Continue .agents/work/feature/user-authentication from index.md. Do its
next action and log the verification evidence.
```

When another thread, worker, or environment would help, ask instead:

```text
Write a handoff prompt for the next step of .agents/work/feature/user-authentication.
The recipient may commit locally but not push; I integrate the result.
```

The agent writes the prompt in the conversation. The thread that owns the work item reviews what comes back, runs combined verification, and updates `index.md` (summary, next action, decisions) and appends a dated entry with evidence to `log.md`.

## 6. Continue Later

List current work:

```bash
.agents/skills/agent-work/scripts/list-work.sh
```

Then continue from the exact next action, or ask for a handoff prompt if another thread will take over.

## 7. Close Completed Work

After implementation and final verification:

1. Promote reusable outcomes to canonical code, docs, guidance, checks, skills, or `.agents/research/`.
2. Resolve open decisions, or report them as follow-ups.
3. Finalize `index.md` with `Status: completed`, exactly `- None.` under `## Next Action`, and a final entry in `log.md`, then commit that snapshot.
4. Validate and stage removal from the repository root:

```bash
.agents/skills/agent-work/scripts/close-work.sh \
  --category feature \
  --slug user-authentication \
  --check

.agents/skills/agent-work/scripts/close-work.sh \
  --category feature \
  --slug user-authentication
```

The helper requires a clean repository and never commits. Commit the staged deletion separately, naming the snapshot commit. Git history is the archive; if merges squash commits, merge the snapshot first and remove the item in a later change.

## Outcome

At the end of the quickstart, a self-contained change is implemented and verified in conversation, or longer work has a work item that people can review and any thread can resume. Once completed, its reusable outcomes remain canonical and its final snapshot remains in git history rather than the current tree.

## Upgrading?

See the [v0.6 migration guide](./docs/migration-v0.6.md) for the leaner work-item contract. Projects on v0.4 or older should also read the [v0.5 guide](./docs/migration-v0.5.md); earlier guides are in the [v0.4.0](https://github.com/colmarius/dot-agents/tree/v0.4.0/docs) release docs.

**Next:** [How dot-agents works](./docs/concepts.md) · [Skills Reference](./docs/skills.md) · [dot-agents.dev](https://dot-agents.dev)
