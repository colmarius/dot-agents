# dot-agents

A template for adding an `.agents` directory structure to any project. Provides a starting point for agent-assisted development workflows.

## Installation

Install with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash
```

### Options

| Flag | Description |
|------|-------------|
| `--dry-run` | Preview changes without making them |
| `--force` | Overwrite conflicts (creates backup first) |
| `--ref <ref>` | Install specific version (branch, tag, or commit) |
| `--yes` | Skip confirmation prompts |
| `--help` | Show usage information |

### Examples

```bash
# Preview what would be installed
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --dry-run

# Install a specific version
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --ref v1.0.0

# Force update (backs up existing files first)
curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash -s -- --force
```

## Update

To update an existing installation, run the install command again. By default:
- New files are installed
- Identical files are skipped
- Changed files create `.dot-agents.new` conflict files for manual review

Use `--force` to overwrite all files (backups are created automatically).

## Structure

```
.agents/
├── plans/           # Task management
│   ├── todo/        # Planned work
│   ├── in-progress/ # Active work
│   └── completed/   # Finished work
├── research/        # Saved research findings
├── skills/          # Agent capabilities
├── PROJECT.md       # Project-specific configuration
└── .dot-agents.json # Installation metadata
```

## Included Skills

| Skill | Purpose |
|-------|---------|
| **ralph** | Autonomous multi-iteration implementation using handoff loops |
| **research** | Deep research on technical topics, saves findings to `.agents/research/` |
| **tmux** | Background process management for servers and long-running tasks |

## Customization

After installation:

1. **Edit `.agents/PROJECT.md`** - Fill in your project's specific commands and conventions
2. **Update `AGENTS.md`** - Customize the project-level agent instructions
3. **Add skills** - Create project-specific skills in `.agents/skills/`

The installer auto-detects your tech stack (Node.js, Rust, Go, Python) and pre-fills suggestions in PROJECT.md.

## License

MIT
