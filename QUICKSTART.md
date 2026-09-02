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
        ├── agent-browser/
        ├── agent-work/
        └── research/
```

If the project already has a `.claude/` directory, dot-agents also links skills into `.claude/skills/` so Claude Code can discover them as project skills.

`agent-browser` is a discovery skill, not a bundled browser dependency. It uses the external `agent-browser` CLI when available and asks that installed version for current workflow instructions. dot-agents does not install the CLI or Chromium automatically.

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

Create a work item when its status, decisions, or next action must survive this conversation — for later resumption, coordination, handoff, or auditability — or when you explicitly want repository context.

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

The work item starts at:

```text
.agents/work/feature/user-authentication/index.md
```

A minimal work item looks like:

```text
.agents/work/feature/user-authentication/
└── index.md      # status, summary, next action
```

Future threads start by reading `index.md`, then load only the plan, research, or progress they need.

## 4. Add Context Or A Plan Only If Needed

If the unknowns are technical, ask for work-local research:

```text
Research authentication patterns for this work item.
```

If the desired behavior is ambiguous, ask for a short requirements brief:

```text
Create a short requirements brief for this work item.
```

If execution needs sequencing, skip extra context and ask for a plan:

```text
Create an implementation-ready plan in .agents/work/feature/user-authentication/plan.md.
```

Plans use tasks with scope, dependencies, and acceptance criteria. If the next action is already small and clear, skip a saved plan and implement directly from `index.md`.

## 5. Implement or Hand Off

When the next action is clear, continue in the same thread by default:

```text
Continue .agents/work/feature/user-authentication from index.md. Implement its
next action and record verification evidence.
```

For UI work, ask for running-system proof when the external CLI is available:

```text
Use agent-browser to verify the authentication flow and save reviewable evidence.
```

When another thread, worker, or environment would help, ask instead:

```text
Review .agents/work/feature/user-authentication and write a paste-ready handoff prompt for the next implementation thread.
```

Generate the prompt in conversation by default. When the transition itself must survive or be reused, save a separately named `handoff-*.md` and link it from `index.md`; it is an optional artifact, not a required stage or a second plan.

During current-thread execution, keep plan checkboxes and `index.md` current. For delegated work, the coordinating thread reviews the returned changes and evidence, then updates durable state unless the handoff explicitly assigns those files to the worker. Create or update `progress.md` only when observed evidence helps work resume across sessions or workers.

## 6. Continue Later

List current work:

```bash
.agents/skills/agent-work/scripts/list-work.sh
```

Then continue from the exact next action, or ask for a handoff prompt if another thread will take over.

## 7. Close Completed Work

After implementation and final verification:

1. Promote reusable outcomes to canonical code, docs, guidance, checks, skills, or `.agents/research/`.
2. Finalize `index.md` with `Status: completed` and exactly `- None.` under `## Next Action`, then commit that snapshot.
3. Validate and stage removal from the repository root:

```bash
.agents/skills/agent-work/scripts/close-work.sh \
  --category feature \
  --slug user-authentication \
  --check

.agents/skills/agent-work/scripts/close-work.sh \
  --category feature \
  --slug user-authentication
```

The helper requires a clean repository and never commits. Review and commit the staged deletion separately. Git history is the archive; if a squash workflow would discard the final snapshot commit, land that snapshot first or keep the work item in the tree.

## Outcome

At the end of the quickstart, a self-contained change is implemented and verified in conversation, or durable work has a resumable active work item. Once completed, its reusable outcomes remain canonical and its final snapshot remains in git history rather than the current tree.

## Upgrading?

See the [v0.5 migration guide](./docs/migration-v0.5.md) for workflow and core-skill changes. Projects older than v0.4 should also read the [v0.4](./docs/migration-v0.4.md) and [v0.3](./docs/migration-v0.3.md) guides as applicable.

**Next:** [Workflow Guides](./docs/README.md#workflow-guides) · [Concepts](./docs/concepts.md) · [Skills Reference](./docs/skills.md) · [dot-agents.dev](https://dot-agents.dev)
