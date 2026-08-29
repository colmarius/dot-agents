# Documentation Consolidation Plan

Review the workflow-guide branch as one documentation system, prototype restrained improvements, and integrate only changes that make navigation or concepts materially clearer.

## Tasks

- [x] **Task 1: Review and prototype in a fresh high-mode orb**
  - Scope: complete feature diff from `4f61c7f`, site navigation and guide routes, `README.md`, `QUICKSTART.md`, and `docs/`
  - Depends on: none
  - Acceptance:
    - The worker applies the exact feature patch before reviewing.
    - Findings distinguish navigation, readability, conceptual clarity, reference ownership, and duplication.
    - Any prototype remains incremental and adds no docs framework, search, sidebar, client runtime, or broad content duplication.
    - The worker returns an incremental patch, desktop/mobile screenshots, checks run, and explicit recommended cuts.

- [x] **Task 2: Inspect and integrate the smallest validated improvements**
  - Scope: worker patch and evidence, affected site and Markdown files
  - Depends on: Task 1
  - Acceptance:
    - The coordinating thread inspects actual changed files and screenshots rather than accepting the report alone.
    - Each accepted change solves a demonstrated navigation, readability, or ownership problem.
    - Rejected changes and consolidation choices are explained before integration.

- [x] **Task 3: Run combined documentation verification**
  - Scope: final branch diff, built site routes, canonical Markdown links
  - Depends on: Task 2
  - Acceptance:
    - Repository tests, Astro build, diff checks, internal and external link checks pass.
    - Browser checks cover the homepage, docs hub, and all guides at representative mobile and desktop widths.
    - Navigation, keyboard interaction, accessibility, overflow, and representative visuals are inspected.

## Constraints / Decisions

- Keep the three guides as non-linear entry points and preserve current workflow semantics.
- Existing Quickstart, Concepts, Skills, and migration pages remain canonical reference material unless consolidation clearly improves ownership.
- Prefer better labels, cross-links, and local edits over new pages, components, or navigation systems.
- Do not push the feature branch or deploy without separate authorization.

## Verification

- `./scripts/test.sh`
- `npm run build`
- `git diff --check`
- Built-site and Markdown link validation
- Real-browser responsive, accessibility, keyboard, and visual checks
