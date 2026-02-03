# Plan: Website Improvements

**Goal:** Enhance dot-agents.dev with targeted, high-leverage additions while maintaining the minimalist, no-build approach.

**Effort:** S–M (1-3 hours)

---

## Tasks

- [x] **Task 1: Add OG meta tags for link previews**
  - Scope: `site/index.html`
  - Depends on: none
  - Acceptance:
    - OpenGraph tags added (og:title, og:description, og:image, og:url)
    - Twitter card tags added (twitter:card, twitter:title, twitter:description)
    - Canonical URL meta tag added
  - Notes: Use existing tagline/description. For og:image, can use a simple placeholder or skip initially.

- [x] **Task 2: Add trust/security section near install command**
  - Scope: `site/index.html`
  - Depends on: none
  - Acceptance:
    - Text below install block: "Review the script first:" with `curl ... | less` command
    - Styled consistently with existing design (muted text, small font)
  - Notes: Critical for curl|bash credibility. Keep it one line.

- [x] **Task 3: Add "Pin a version" example**
  - Scope: `site/index.html`
  - Depends on: Task 2
  - Acceptance:
    - Shows pinned version command: `curl ... | bash -s -- --ref v1.0.0`
    - Either as second code block or collapsible `<details>` element
    - Styled consistently
  - Notes: Already documented in README, just surface it.

- [x] **Task 4: Add "What gets installed" directory tree section**
  - Scope: `site/index.html`, `site/style.css`
  - Depends on: none
  - Acceptance:
    - New section after install showing directory tree (from QUICKSTART.md)
    - Code block styled like install command
    - Brief heading like "What you get"
  - Notes: Reduces uncertainty, shows concrete output.

- [ ] **Task 5: Add Quickstart 5-step recipe section**
  - Scope: `site/index.html`, `site/style.css`
  - Depends on: Task 4
  - Acceptance:
    - Section with 5 condensed steps: Install → Adapt → Research → PRD → Execute
    - Each step shows the command/prompt (e.g., "Run adapt", "Research [topic]")
    - Styled as compact list or cards
  - Notes: Mirrors workflow section but with actionable commands.

- [ ] **Task 6: Clarify Ralph/Amp terminology in feature cards**
  - Scope: `site/index.html`
  - Depends on: none
  - Acceptance:
    - "Ralph Loops" card renamed to "Autonomous Execution" with "(Ralph)" in parentheses
    - "Structured Plans" card removes or explains "Ralph-ready"
    - Add link to docs/concepts.md glossary section from Ralph mention
  - Notes: Visitors may not know Amp ecosystem terminology.

- [ ] **Task 7: Update CTA section with Quickstart button**
  - Scope: `site/index.html`
  - Depends on: none
  - Acceptance:
    - Three buttons: Quickstart (primary) | Full Docs | GitHub
    - Quickstart links to QUICKSTART.md on GitHub
    - Button order reflects user journey priority
  - Notes: Direct path to getting started.

- [ ] **Task 8: Add minimal top navigation anchors**
  - Scope: `site/index.html`, `site/style.css`
  - Depends on: Tasks 4, 5
  - Acceptance:
    - Small nav: Install · What you get · Workflow · Docs
    - Smooth scroll to anchors
    - Responsive (collapses or scrolls on mobile)
  - Notes: Optional enhancement, can skip if it feels heavy.

---

## Out of Scope

- Multi-page site or static site generator
- Full documentation mirroring (keep in-repo docs canonical)
- Custom og:image creation (can add later)
- Analytics or tracking

## Success Criteria

- Site remains single HTML file with no build step
- All additions use content already in README/QUICKSTART (no drift risk)
- Page still loads instantly, scores well on Lighthouse
- New visitors understand what they get and how to start in <30 seconds
