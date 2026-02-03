# Plan: Skills Documentation

| Field | Value |
|-------|-------|
| PRD | N/A |
| Research | `../../research/documentation-skills.md` |
| Status | todo |
| Created | 2026-02-03 |

## Overview

Create user-facing skills documentation that explains what each skill does, when to use it, and how to add custom skills. Skills have SKILL.md for agents but users lack overview documentation.

## Tasks

- [x] **Task 1: Create docs/skills.md overview page**
  - Scope: `docs/skills.md`
  - Depends on: none
  - Acceptance:
    - File exists at docs/skills.md
    - Has intro explaining what skills are
    - Has table listing all skills: adapt, ralph, research, tmux
    - Table columns: Skill name, Trigger phrase, Purpose
    - Each skill name links to its section in the document
  - Notes: See research file for table content

- [x] **Task 2: Add individual skill sections to docs/skills.md**
  - Scope: `docs/skills.md`
  - Depends on: Task 1
  - Acceptance:
    - Section for adapt: description, invoke command, link to SKILL.md
    - Section for ralph: description, invoke command, options, link to SKILL.md
    - Section for research: description, invoke command, link to SKILL.md
    - Section for tmux: description, note about auto-loading, link to SKILL.md
    - Each section links to actual SKILL.md as source of truth
  - Notes: Keep descriptions brief, link to SKILL.md for details

- [ ] **Task 3: Add custom skills section to docs/skills.md**
  - Scope: `docs/skills.md`
  - Depends on: Task 2
  - Acceptance:
    - "Adding Custom Skills" section exists
    - Shows directory structure for new skill
    - Shows SKILL.md frontmatter format (name, description)
    - Explains invocation via natural language matching
    - Notes that custom skills are preserved during sync
  - Notes: Important for extensibility story

- [ ] **Task 4: Update AGENTS.md to link to skills documentation**
  - Scope: `AGENTS.md`
  - Depends on: Task 1
  - Acceptance:
    - "Using Skills" section links to docs/skills.md
    - Link text: "See docs/skills.md for full skill documentation"
  - Notes: Add after existing skills table

## Verification

After all tasks complete:

```bash
# Verify skills.md exists and has content
test -f docs/skills.md
grep -q "adapt" docs/skills.md
grep -q "ralph" docs/skills.md
grep -q "Adding Custom Skills" docs/skills.md

# Verify AGENTS.md links to skills docs
grep -q "docs/skills.md" AGENTS.md
```

All checks must pass before marking plan complete.
