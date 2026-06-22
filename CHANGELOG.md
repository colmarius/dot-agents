# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-06-22

### Changed

- **BREAKING:** Replaced the Ralph-centered `.agents/plans/` / `.agents/prds/` workflow with durable work items under `.agents/work/<category>/<slug>/`.
- **BREAKING:** Fresh installs now ship `adapt`, `agent-work`, `feature-planning`, `research`, and `tmux` as core skills.
- Research guidance now distinguishes work-local `research.md` from reusable `.agents/research/` notes.
- Documentation, quickstart, and landing page now describe prompt-based implementation handoffs instead of autonomous runner execution.
- `--diff` now exits non-zero for any pending sync change, including missing files, retired skills, retired guidance, and `.gitignore` updates.

### Removed

- **BREAKING:** Removed the `ralph` skill from core installs. Sync backs up and removes retired upstream `ralph` skill directories.
- Fresh installs no longer create legacy `.agents/plans/` or `.agents/prds/` directories.
- Sync backs up and removes retired legacy guidance/templates such as `.agents/prds/AGENTS.md` and old plan/PRD templates.
- Dropped support for the deprecated singular `.agents/reference/` path. External reference checkouts now live under `.agents/references/`; rename any existing `.agents/reference/` checkout, which is no longer gitignored.

### Added

- Work-item guidance at `.agents/work/AGENTS.md`.
- `agent-work` skill with templates and scripts for creating and listing work items.
- `feature-planning` skill for PRDs, implementation-ready plans, plan refinement, and paste-ready new-thread prompts.
- Legacy migration guide for moving old plans into `.agents/work/`.

## [0.2.0] - 2026-06-22

### Added

- Claude Code project skill discovery: when `.claude/` exists, install/sync links dot-agents skills into `.claude/skills/` so they can appear in Claude Code's `/` menu.

### Fixed

- Uninstall now removes dot-agents-managed Claude Code skill symlinks while preserving user-owned Claude Code skills.

## [0.1.1] - 2026-02-04

### Added

- Post-install guidance showing next steps (run 'adapt', see QUICKSTART.md)
- Version string in install message (e.g., "Installing dot-agents v1.2.3...")
- Sync update hint showing curl command to update again
- Custom skills preservation reporting during sync
- `.agents/.gitignore` with backup directory entry

### Changed

- Backup directory now auto-added to `.agents/.gitignore`

## [0.1.0] - 2025-02-03

### Changed

- **BREAKING:** Sync now overwrites conflicts by default (with backup)
  - Use `--diff` to preview changes before syncing
  - Use `--write-conflicts` to create `.dot-agents.new` files instead

### Added

- `--diff` flag to show unified diffs for conflicts without modifying files
- `--write-conflicts` flag to create `.dot-agents.new` files for manual review
- Initial project structure
- Install script with dry-run, force, interactive modes
- Sync script for updating from upstream
- Skills: adapt, ralph, research, tmux
- PRD template and workflow
- Plans directory structure (todo, in-progress, completed)
- Research directory for storing investigation results
- QUICKSTART.md with step-by-step guide from install to autonomous execution
- `--version` flag to install.sh and sync.sh
- Plan TEMPLATE.md for creating Ralph-ready plans
- Skill invocation documentation in AGENTS.md
- Sync behavior documentation in README
- This CHANGELOG

### Fixed

- BASH_SOURCE execution guard for piped installation
- Installer skip logic now correctly includes plans/TEMPLATE.md
- Postfix increment operators causing script exit on bash 5.3+ with `set -e` ([#1](https://github.com/colmarius/dot-agents/issues/1))

[Unreleased]: https://github.com/colmarius/dot-agents/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/colmarius/dot-agents/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/colmarius/dot-agents/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/colmarius/dot-agents/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/colmarius/dot-agents/releases/tag/v0.1.0
