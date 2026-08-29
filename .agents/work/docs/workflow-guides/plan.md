# Workflow Guides Plan

Add a simple, local documentation path that helps users enter the dot-agents workflow at Start, Continue, or Finish without requiring them to learn the complete artifact system first.

## Goals

- Give users three direct, non-linear workflow entry points with practical prompts and examples.
- Keep the homepage concise and preserve dot-agents' restrained visual identity.
- Keep dot-agents procedures, repository reference docs, and With Agents explanations in clear ownership boundaries.

## Tasks

- [x] **Task 1: Build the Markdown-backed docs thin slice**
  - Scope: `docs/guides/`, `site/src/content.config.ts`, `site/src/layouts/`, `site/src/pages/docs/`, guide-specific site styles, `site/src/pages/index.astro`
  - Depends on: none
  - Acceptance:
    - `/docs/` presents Start, Continue, and Finish as direct, non-linear choices in its first viewport at desktop and mobile widths.
    - One guide renders from canonical Markdown through an Astro content collection and a shared minimal guide layout.
    - The homepage points Docs locally and adds no more than one quiet contextual guide link.
    - The implementation adds no Starlight, search, persistent sidebar, right-hand table of contents, theme switcher, or client framework.
  - Notes: Use the progressive prototype's calm hub and the multi-page prototype's content boundaries, not either prototype wholesale.

- [x] **Task 2: Complete the three concise workflow guides**
  - Scope: `docs/guides/`, `docs/README.md`, shared guide metadata and navigation
  - Depends on: Task 1
  - Acceptance:
    - The guides are `Start uncertain work`, `Continue durable work`, and `Finish and preserve outcomes`.
    - Core steps, authority boundaries, prompts, and expected evidence remain visible without opening disclosures.
    - Each guide uses at most two optional disclosures for a composite example and recovery/detail.
    - Content reflects v0.5 semantics: small work stays conversational, artifacts and handoffs are optional, current-thread execution is the default, evidence distinguishes inherited/rerun/newly observed/unverified, and closeout preserves the final snapshot before removal.
    - Each guide links to only the most relevant current `/coding/` With Agents explanations and canonical repository references.
  - Notes: Keep explanatory essays on with-agents.dev; dot-agents owns exact procedures and commands.

- [x] **Task 3: Refine the focused responsive experience**
  - Scope: docs layout and styles, guide navigation, prompt and disclosure presentation
  - Depends on: Task 2
  - Acceptance:
    - Users can reach the relevant stage from `/docs/` in one click.
    - Guide titles remain compact on mobile and substantive content begins within the first viewport.
    - Navigation and disclosures are semantic, keyboard-operable, visibly focused, and at least 44px at mobile widths.
    - No horizontal overflow, clipping, overlap, nested scrolling, or hidden-scrollbar interaction exists at 320px, 390px, tablet, or desktop widths.
  - Notes: Prefer typography, whitespace, and thin rules over card or navigation chrome.

- [x] **Task 4: Review, verify, and prepare the portal**
  - Scope: complete feature-branch diff and running documentation routes
  - Depends on: Task 3
  - Acceptance:
    - High-mode prototype/review findings and focused Oracle findings are validated and all material issues are addressed.
    - `./scripts/test.sh`, `npm run build`, `git diff --check`, internal link validation, and targeted external With Agents link checks pass.
    - Browser verification covers `/`, `/docs/`, and all three guides at representative desktop and mobile widths, with zero axe violations and no page/console errors.
    - A final portal exposes the reviewed branch only after the accepted implementation is complete.
  - Notes: Do not push the feature branch or deploy without separate authorization.

## Implementation Notes

- Use Astro's filesystem content loader so `docs/guides/*.md` remains useful in GitHub and to coding agents.
- Derive the hub and cross-guide navigation from guide metadata rather than duplicating route labels.
- Existing Quickstart, Concepts, Skills, and migration documents remain canonical repository references in this release.
- Treat Start, Continue, and Finish as entry points, not a mandatory lifecycle.

## Constraints / Decisions

- Simplicity is the primary design constraint.
- The landing page remains a concise onboarding funnel rather than a docs index.
- No reference-content duplication is introduced.
- Examples are anonymized composites; private thread details are not published.
- Access does not imply authority; guide examples name commit, push, PR, merge, deploy, migration, and shared-state boundaries where relevant.

## Acceptance Criteria

- The site provides a coherent local workflow-guide experience without introducing documentation-framework weight.
- The three guides are practical enough to act from and short enough to scan.
- Product behavior remains canonical in dot-agents, while With Agents supplies optional deeper rationale.

## Verification

- `./scripts/test.sh`
- `npm run build`
- `git diff --check`
- Targeted internal and external link checks
- Real-browser keyboard, responsive, accessibility, navigation, and visual checks at 320px, 390px, tablet, and desktop widths
