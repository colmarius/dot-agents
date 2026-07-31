# v0.4 skill evolution plan

Update the portable dot-agents workflow with the durable contracts proven in downstream repositories and prepare the next minor version.

## Goals

- Make current-thread execution the default while preserving explicit handoffs and runner-neutral delegation.
- Improve work-item restartability, verification evidence, and skill authoring quality.
- Add `agent-browser` as a small core discovery skill without installing its external runtime.
- Release the changes as v0.4.0 with complete documentation and tests.

## Tasks

- [x] **Task 1: Evolve work-item and planning contracts**
  - Scope: `.agents/skills/agent-work`, `.agents/skills/feature-planning`, `.agents/work/AGENTS.md`, `.agents/skills/adapt/SKILL.md`
  - Depends on: none
  - Acceptance:
    - Current-thread implementation is the default and handoff remains an explicit optional mode.
    - Coordinated execution has one integration owner, bounded workers, environment checks, one result path, and combined verification.
    - New indexes separate stable `Why` from evolving `Summary`; categories accept lowercase kebab-case domains.
    - Existing `plans/` and `progress.md` names remain, with indexed-folder and living-progress semantics.

- [x] **Task 2: Add browser discovery and deterministic skill lint**
  - Scope: `.agents/skills/agent-browser`, `.agents/skills/AGENTS.md`, `scripts/skills-lint.sh`, `scripts/lint.sh`, `install.sh`, `test/integration`
  - Depends on: Task 1
  - Acceptance:
    - `agent-browser` is a core discovery stub that loads current instructions from an installed CLI and does not install dependencies automatically.
    - Core skill metadata and relative links are checked deterministically.
    - Installer, custom-skill ownership, and Claude Code discovery tests cover the sixth core skill.

- [x] **Task 3: Update release documentation and version**
  - Scope: `AGENTS.md`, `AGENTS.template.md`, `README.md`, `QUICKSTART.md`, `docs/`, `site/`, `VERSION`, `CHANGELOG.md`
  - Depends on: Tasks 1 and 2
  - Acceptance:
    - User-facing guidance describes the v0.4 workflow and browser skill accurately.
    - Migration notes explain changed defaults, open categories, forward-only `Why`, living progress, and core `agent-browser` ownership.
    - Version and pinned installation examples use 0.4.0.

- [x] **Task 4: Rebuild, verify, and commit**
  - Scope: `test/fixtures/sample-archive.tar.gz`, repository worktree
  - Depends on: Tasks 1–3
  - Acceptance:
    - The fixture is rebuilt from the final `.agents/` and template state.
    - `./scripts/test.sh` and `./scripts/release.sh --dry-run` pass.
    - The completed work item and release-ready changes are committed without creating or pushing a tag.

## Implementation Notes

- Upstream durable contracts rather than Norm-specific architecture, commands, or orchestration scripts.
- Keep the core small; `agent-browser` is the only new core skill.
- Record verification results, not command intentions.

## Constraints / Decisions

- Breaking workflow guidance is acceptable for the new minor version.
- Existing user work remains preserved by sync.
- Do not add automatic completed-work deletion or rename existing artifact paths.

## Deployment / Migration

- Release unit: dot-agents v0.4.0 source archive and tag.
- Migration: sync updates core guidance and adds `agent-browser`; existing work items require no file renames or backfill.
- Release action after this change: review the commit, then run `./scripts/release.sh --push` only when explicitly approved.

## Verification

- `./scripts/build-test-fixture.sh` rebuilt the archive at 28 KB and confirmed local reference checkouts were excluded.
- `./scripts/test.sh` passed syntax checks, ShellCheck, skill lint for all six core skills, and all 89 Bats tests.
- `./scripts/release.sh --dry-run` targeted v0.4.0, extracted the expected release notes, and did not create a tag.
- `git diff --check` passed.
