# Release guidance and skill audit

Status: blocked
Category: tooling
Updated: 2026-09-12

## Why

Prepare the next release by auditing all base guidance and skills, recent usage, and downstream adaptations. Preserve a minimal scaffold and require confirmation before the version bump and release.

## Summary

Guidance and skill audits, downstream comparison, and bounded historical investigation are complete. The four-skill scaffold is retained with focused accuracy, evidence, and lifecycle improvements. The uninstall-preview regression and premature-completion scaffold are fixed. Final Oracle review found no blockers and independently confirmed all nine changed installable files match the rebuilt fixture. Version remains 0.5.0; bump and release await confirmation.

Historical coverage was qualitative: 11 threads read directly, with pagination incomplete and several search timeouts. Updated-time searches do not prove creation-date coverage or usage frequency. Findings justified single-owner research synthesis and acceptance-driven browser assertions, not additional mandatory artifacts or review gates. Downstream app-specific commands, paths, and rollout rules were excluded. Source evidence remains in the coordinating conversation rather than copying private material into the repository.

Verification: the uninstall regression failed before the guard and passed afterward. After all skill/template changes and fixture rebuild, the final `./scripts/test.sh` run passed all 108 Bats tests, ShellCheck, syntax, and four-skill metadata/link lint; `git diff --check` passed. Browser CLI help, skill listing, and full core discovery succeeded; no claim is made about automated skill triggers or downstream application workflows.

## Artifacts

- Research: none
- PRD: none
- Plan: none
- Progress: none
- Decisions: none
- Handoffs: none

## Next Action

- Obtain confirmation for the version bump and release; then update VERSION, pinned examples, and release notes, verify the release candidate, and follow the reviewed publishing workflow.

## Open Questions

- [ ] Confirm the release version and publishing action after reviewing the verified changes.
