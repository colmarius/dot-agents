# dot-agents

A template for adding an `.agents` directory structure to any project. Provides a starting point for agent-assisted development workflows.

## Usage

Copy the `.agents` directory and `AGENTS.md` to your project, then adapt to your codebase's conventions.

## Structure

```
.agents/
├── plans/           # Task management
│   ├── todo/        # Planned work
│   ├── in-progress/ # Active work
│   └── completed/   # Finished work
├── research/        # Saved research findings
└── skills/          # Agent capabilities
```

## Included Skills

| Skill | Purpose |
|-------|---------|
| **ralph** | Autonomous multi-iteration implementation using handoff loops |
| **research** | Deep research on technical topics, saves findings to `.agents/research/` |
| **tmux** | Background process management for servers and long-running tasks |

## Customization

- Update `AGENTS.md` with your project's commands and conventions
- Add project-specific skills to `.agents/skills/`
- Modify plan templates to match your workflow

## License

MIT
