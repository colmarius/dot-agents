# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/colmarius/dot-agents/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/colmarius/dot-agents/releases/tag/v0.1.0
