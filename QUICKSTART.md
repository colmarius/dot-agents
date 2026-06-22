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
        ├── feature-planning/
        ├── research/
        └── tmux/
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

## 3. Create a Work Item

Use work items for multi-session or context-heavy work. For a tiny one-shot edit, you may not need one.

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
├── index.md      # status, summary, next action
└── plan.md       # added when you ask for a plan
```

Future threads start by reading `index.md`, then load only the plan, research, or progress they need.

## 4. Add Context Only If Needed, Then Plan

If the unknowns are technical, ask for work-local research:

```text
Research authentication patterns for this work item.
```

If the desired behavior is ambiguous, ask for a short requirements brief:

```text
Create a short requirements brief for this work item.
```

If the goal is already clear, skip extra context and ask for a plan:

```text
Create an implementation-ready plan in .agents/work/feature/user-authentication/plan.md.
```

Plans use tasks with scope, dependencies, and acceptance criteria.

## 5. Generate a Handoff Prompt

When the plan is ready, ask:

```text
Review .agents/work/feature/user-authentication and write a paste-ready handoff prompt for the next implementation thread.
```

Paste the generated prompt into a fresh agent thread. The new thread should read `index.md`, implement the requested slice, update the active plan file, append to `progress.md`, refresh `index.md`, and report verification results.

## 6. Continue Later

List active work:

```bash
.agents/skills/agent-work/scripts/list-work.sh
```

Then ask for a continuation prompt from the next action in the work item.

## Outcome

At the end of the quickstart, you have a work item with a current next action and a paste-ready prompt for a fresh implementation thread.

## Upgrading from v0.2?

See the [v0.3 migration guide](./docs/migration-v0.3.md) for legacy `.agents/plans/` and `.agents/prds/` projects.

**Next:** [Concepts](./docs/concepts.md) · [Skills Reference](./docs/skills.md) · [dot-agents.dev](https://dot-agents.dev)
