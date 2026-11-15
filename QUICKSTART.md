# Quickstart

Install dot-agents, adapt it to your project, and use your first work item.

## Prerequisites

- **bash** 4.0+ (5.0+ recommended), **git**, and **curl**
- **OS:** macOS, Linux, or WSL

## 1. Install

From the root of your repository:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

To read the script first, pipe it to `less` instead of `bash`. Running the installer again later updates dot-agents and keeps your work items, research, and `AGENTS.md`.

It installs:

```text
your-project/
├── AGENTS.md          # project instructions for your agent
└── .agents/
    ├── work/          # work items, plus their rules in AGENTS.md
    ├── research/      # findings worth reusing
    ├── references/    # local checkouts (gitignored)
    ├── scripts/       # sync.sh
    └── skills/        # adapt, agent-work, research
```

If the project has a `.claude/` directory, the skills are also linked into `.claude/skills/` for Claude Code.

## 2. Adapt `AGENTS.md`

Ask your agent:

```text
Run adapt
```

It fills `AGENTS.md` with your project's commands and conventions. If your agent does not discover skills on its own, tell it to read `.agents/skills/adapt/SKILL.md` first.

## 3. Use A Work Item When You Need One

Most work needs no files: when one conversation can finish it, just ask. Create a work item when people must review the direction, or when the work continues in another session or with someone else:

```text
Create a work item for user authentication.
```

The agent creates `index.md` (why, what is done and left, decisions, next step) and `log.md` (dated history) under `.agents/work/<category>/<slug>/`. If people must agree first, add "and write a proposal for review".

In a later session:

```text
Continue the work item at .agents/work/feature/user-authentication.
```

To brief another agent or person:

```text
Write a handoff prompt for the next step of .agents/work/feature/user-authentication.
```

When the work is done:

```text
Close the work item at .agents/work/feature/user-authentication.
```

The agent moves what should last into code and docs, commits a final snapshot, and removes the item in a second commit. Git history keeps the snapshot.

To see current work items:

```bash
.agents/skills/agent-work/scripts/list-work.sh
```

## Next

- [How dot-agents works](./docs/concepts.md): statuses, decisions, and an example work item
- [Skills reference](./docs/skills.md)
- Upgrading: the [v0.6 migration guide](./docs/migration-v0.6.md); projects on v0.4 or older also read the [v0.5 guide](./docs/migration-v0.5.md), and earlier guides are in the [v0.4.0 docs](https://github.com/colmarius/dot-agents/tree/v0.4.0/docs)
