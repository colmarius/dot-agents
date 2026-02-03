# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- QUICKSTART.md with step-by-step guide from install to autonomous execution
- `--version` flag to install.sh and sync.sh
- Plan TEMPLATE.md for creating Ralph-ready plans
- Skill invocation documentation in AGENTS.md
- Sync behavior documentation in README
- This CHANGELOG

### Fixed

- BASH_SOURCE execution guard for piped installation
- Installer skip logic now correctly includes plans/TEMPLATE.md

## [1.0.0] - 2026-01-31

### Added

- Initial release
- Install script with dry-run, force, interactive modes
- Sync script for updating from upstream
- Skills: adapt, ralph, research, tmux
- PRD template and workflow
- Plans directory structure (todo, in-progress, completed)
- Research directory for storing investigation results

[Unreleased]: https://github.com/colmarius/dot-agents/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/colmarius/dot-agents/releases/tag/v1.0.0
