# Release guidance and skill audit

Status: completed
Category: tooling
Updated: 2026-09-12

## Why

Prepare the next release by auditing all base guidance and skills, recent usage, and downstream adaptations. Preserve a minimal scaffold and require confirmation before the version bump and release.

## Summary

Guidance and skill audits, downstream comparison, bounded historical investigation, and the site/repository documentation pass are complete. The four-skill scaffold is retained with focused accuracy, evidence, and lifecycle improvements. Final whole-repository high-orb findings were integrated: failed-download handling, custom-link preview accuracy, release continuation and CLI preflight, and release-script lint coverage. Oracle reviewed the integrated changes and found no blockers. The approved v0.5.1 release is published and deployed; outcomes are promoted to canonical guidance, docs, code, tests, and release notes.

Historical coverage was qualitative: 11 threads read directly, with pagination incomplete and several search timeouts. Updated-time searches do not prove creation-date coverage or usage frequency. Findings justified single-owner research synthesis and acceptance-driven browser assertions, not additional mandatory artifacts or review gates. Downstream app-specific commands, paths, and rollout rules were excluded. Source evidence remains in the coordinating conversation rather than copying private material into the repository.

Verification: regressions reproduced uninstall-preview deletion, failed-download success, false custom-link removal, and release-helper failures before their fixes. The integrated `./scripts/test.sh` run passed all 112 Bats tests, ShellCheck, syntax, and four-skill metadata/link lint; `git diff --check` passed. The fixture was rebuilt and its updated sync script inspected. `npm run build` passed; 82 local links and anchors across six generated HTML files resolved. Desktop and 390px Chromium screenshots were inspected; DOM checks confirmed matched URL/payload pins, the no-plan example, Continue prompt, Skills link, and optional-plan guide wording. Narrow document width matched the viewport and no browser errors were reported. These are local checks, not production deployment, macOS, full accessibility, cross-browser, automatic skill-trigger, or downstream application verification.

Post-release verification:

- [Release v0.5.1](https://github.com/colmarius/dot-agents/releases/tag/v0.5.1) is published, not draft or prerelease; the peeled tag matches [the release commit](https://github.com/colmarius/dot-agents/commit/4cec9cddf223f8a7501b830d1382a55410b4e007).
- [Release CI](https://github.com/colmarius/dot-agents/actions/runs/34697127823) passed all 112 tests on Ubuntu and macOS plus ShellCheck. [Pages deployment](https://github.com/colmarius/dot-agents/actions/runs/34697127810) succeeded for that commit.
- Independent high-orb real-network install verification passed for fresh and customized disposable repositories: four core skills, correct metadata, custom content/links retained, no-op sync preview unchanged, work-item creation, and uninstall-preview rejection without mutation. Downloaded installer SHA256 matched release source; no mocks were used.
- Independent high-orb Chromium verification of https://dot-agents.dev/ and its docs hub/three guides passed: HTTP 200, no broken internal links/anchors, matching v0.5.1 URL and payload pins, intended prompts, no-plan example, no runtime errors or horizontal overflow. Desktop and narrow screenshots were inspected, including the downloaded release-pin capture in the coordinating thread. Copy-button feedback passed; clipboard bytes could not be read due to browser permissions. No real-device, Safari, or full accessibility audit is claimed.

## Artifacts

- Research: none
- PRD: none
- Plan: none
- Progress: none
- Decisions: none
- Handoffs: none

## Next Action

- None.

## Open Questions

- None.
