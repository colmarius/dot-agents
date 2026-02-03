# Plan: Documentation Information Architecture

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/documentation-information-architecture.md` |
| Status | in-progress |
| Created | 2026-02-03 |

## Overview

Create a documentation hub and concepts page in docs/ to provide better navigation and explain core terminology without adopting heavy tooling.

## Tasks

- [x] **Task 1: Create docs/README.md as hub page**
  - Scope: `docs/README.md`
  - Depends on: none
  - Acceptance:
    - File exists at docs/README.md
    - Has "Getting Started" section linking to README.md#install and QUICKSTART.md
    - Has "Concepts" section linking to concepts.md
    - Has "Reference" section linking to skills.md, AGENTS.md, troubleshooting.md
    - Has "For Contributors" section linking to CHANGELOG.md
    - Uses relative paths that work from docs/ directory
  - Notes: Keep lightweight, this is an index page

- [ ] **Task 2: Create docs/concepts.md with workflow and glossary**
  - Scope: `docs/concepts.md`
  - Depends on: Task 1
  - Acceptance:
    - File exists at docs/concepts.md
    - Has "Workflow" section explaining Research → PRD → Plan → Execute
    - Has "Glossary" table defining: adapt, Ralph, PRD, Plan, Skills, sync
    - Each glossary term has clear, concise definition
  - Notes: See research file for exact definitions

- [ ] **Task 3: Update README.md to link to docs hub**
  - Scope: `README.md`
  - Depends on: Task 1
  - Acceptance:
    - README.md has "Documentation" section
    - Links to QUICKSTART.md with description
    - Links to docs/README.md as "Full Docs"
  - Notes: Add near top of README, after install section

- [ ] **Task 4: Update QUICKSTART.md to link to docs hub**
  - Scope: `QUICKSTART.md`
  - Depends on: Task 1
  - Acceptance:
    - QUICKSTART.md footer links to docs/README.md
    - Replaces or supplements existing dot-agents.dev link
  - Notes: Keep both links if dot-agents.dev provides different value

- [ ] **Task 5: Add docs link to landing page**
  - Scope: `docs/index.html`
  - Depends on: Task 1
  - Acceptance:
    - index.html has link to GitHub docs (docs/README.md or repo docs)
    - Link text is clear: "Full documentation on GitHub" or similar
  - Notes: Add to appropriate location in existing page structure

## Verification

After all tasks complete:

```bash
# Verify new files exist
test -f docs/README.md
test -f docs/concepts.md

# Verify links in README
grep -q "docs/README.md" README.md

# Verify links in QUICKSTART
grep -q "docs" QUICKSTART.md
```

All checks must pass before marking plan complete.
