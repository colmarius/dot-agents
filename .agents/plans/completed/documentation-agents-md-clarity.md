# Plan: AGENTS.md Template Clarity

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/documentation-agents-md-clarity.md` |
| Status | completed |
| Created | 2026-02-03 |

## Overview

Add a prominent banner to AGENTS.md clarifying it's a template to customize, and document sync behavior so users understand their customizations are preserved.

## Tasks

- [x] **Task 1: Add prominent template banner to AGENTS.md**
  - Scope: `AGENTS.md`
  - Depends on: none
  - Acceptance:
    - Banner appears at very top of file, before "# Project Instructions"
    - Uses blockquote format with emoji: `> **📝 TEMPLATE:**`
    - Explains this is the dot-agents template to customize
    - Instructs user to fill in sections and delete banner when done
  - Notes: Keep banner concise, 2-3 lines max

- [x] **Task 2: Update README.md to clarify AGENTS.md customization**
  - Scope: `README.md`
  - Depends on: none
  - Acceptance:
    - README mentions "customize AGENTS.md for your project"
    - Mentions `adapt` skill auto-fills the template
    - Clear that AGENTS.md is user's project file after install
  - Notes: Add to install or post-install section

- [x] **Task 3: Update QUICKSTART.md to clarify adapt fills template**
  - Scope: `QUICKSTART.md`
  - Depends on: none
  - Acceptance:
    - Step 2 (Adapt AGENTS.md) mentions it fills in the template
    - Clear that user can also manually customize
  - Notes: Existing text may already cover this, enhance if needed

- [x] **Task 4: Document sync behavior for AGENTS.md**
  - Scope: `README.md` or `docs/concepts.md`
  - Depends on: none
  - Acceptance:
    - Documents what sync updates vs preserves
    - Explicitly states AGENTS.md is NOT overwritten by sync
    - Lists preserved items: AGENTS.md, PRDs, plans, research
    - Lists updated items: skills, scripts
  - Notes: Could be table format for clarity

## Verification

After all tasks complete:

```bash
# Verify banner exists
head -5 AGENTS.md | grep -q "TEMPLATE"

# Verify README mentions customization
grep -q "customize" README.md || grep -q "AGENTS.md" README.md
```

All checks must pass before marking plan complete.
