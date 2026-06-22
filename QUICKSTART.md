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

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

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

## 3. Create a Work Item

Ask your agent:

```text
Create a new work item for user authentication.
```

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

## Legacy Plans and PRDs

Older dot-agents installs used `.agents/plans/` and `.agents/prds/`. Legacy plan and PRD documents are preserved on sync, while retired Ralph guidance/templates are backed up and removed. Migrate one plan at a time into `.agents/work/<category>/<slug>/` when you need to resume it.

**Next:** [Concepts](./docs/concepts.md) · [Skills Reference](./docs/skills.md) · [dot-agents.dev](https://dot-agents.dev)
