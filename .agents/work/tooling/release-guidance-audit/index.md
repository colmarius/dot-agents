# Release guidance and skill audit

Status: blocked
Category: tooling
Updated: 2026-09-12

## Why

Prepare the next release by auditing all base guidance and skills, recent usage, and downstream adaptations. Preserve a minimal scaffold and require confirmation before the version bump and release.

## Summary

Guidance and skill audits, downstream comparison, bounded historical investigation, and the site/repository documentation pass are complete. The four-skill scaffold is retained with focused accuracy, evidence, and lifecycle improvements. Final whole-repository high-orb findings were integrated: failed-download handling, custom-link preview accuracy, release continuation and CLI preflight, and release-script lint coverage. Oracle reviewed the integrated changes and found no blockers. Version remains 0.5.0; bump and release await confirmation.

Historical coverage was qualitative: 11 threads read directly, with pagination incomplete and several search timeouts. Updated-time searches do not prove creation-date coverage or usage frequency. Findings justified single-owner research synthesis and acceptance-driven browser assertions, not additional mandatory artifacts or review gates. Downstream app-specific commands, paths, and rollout rules were excluded. Source evidence remains in the coordinating conversation rather than copying private material into the repository.

Verification: regressions reproduced uninstall-preview deletion, failed-download success, false custom-link removal, and release-helper failures before their fixes. The integrated `./scripts/test.sh` run passed all 112 Bats tests, ShellCheck, syntax, and four-skill metadata/link lint; `git diff --check` passed. The fixture was rebuilt and its updated sync script inspected. `npm run build` passed; 82 local links and anchors across six generated HTML files resolved. Desktop and 390px Chromium screenshots were inspected; DOM checks confirmed matched URL/payload pins, the no-plan example, Continue prompt, Skills link, and optional-plan guide wording. Narrow document width matched the viewport and no browser errors were reported. These are local checks, not production deployment, macOS, full accessibility, cross-browser, automatic skill-trigger, or downstream application verification.

## Artifacts

- Research: none
- PRD: none
- Plan: none
- Progress: none
- Decisions: none
- Handoffs: none

## Next Action

- Obtain confirmation for the new version and publication, then update VERSION, current pins and release notes, verify the release candidate, and follow the reviewed publishing workflow. Preparation is ready; the release candidate has not yet been versioned or published.

## Open Questions

- [ ] Confirm the release version and publishing action after reviewing the verified changes.
