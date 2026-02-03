# Research: Documentation Structure Improvements

**Date:** 2026-02-03
**Status:** Complete
**Tags:** documentation, developer-experience, information-architecture

## Summary

Analysis of current documentation structure and git history to identify opportunities for better organization, discoverability, and user experience.

## Current State

### Documentation Locations

| File | Purpose | Audience |
|------|---------|----------|
| README.md | Install + quick links | New users |
| QUICKSTART.md | Step-by-step workflow | New users |
| AGENTS.md | Template for user projects | End users |
| CHANGELOG.md | Release history | All users |
| docs/index.html | Landing page (dot-agents.dev) | Visitors |
| .agents/skills/*/SKILL.md | Skill instructions | Agents |
| .agents/prds/TEMPLATE.md | PRD template | End users |
| .agents/plans/TEMPLATE.md | Plan template | End users |

### Git History Insights

Documentation evolution shows iterative refinement:

1. **Initial:** Consolidated PROJECT.md.template into AGENTS.md (commit `501b5ab`)
2. **Simplification:** Moved details from README to docs site (commit `bea4900`)
3. **User journey:** Added QUICKSTART.md (commit `be641fa`)
4. **Discoverability:** Added skill invocation docs to AGENTS.md (commit `29e98dc`)

Pattern: Moving from comprehensive single files → distributed, purpose-specific docs.

## Identified Gaps

### 1. No Intermediate Documentation

Gap between landing page (marketing) and QUICKSTART (hands-on).

**Missing:**

- Concept explanations (what is Ralph? what are skills?)
- Workflow diagrams
- Decision trees (when to research vs. when to start coding)

### 2. docs/ Directory Underutilized

Currently only has:

- `index.html` - Landing page
- `style.css` - Styling
- `.nojekyll` - GitHub Pages config

No actual documentation content beyond the landing page.

### 3. Skills Lack User-Facing Documentation

Skills have SKILL.md for agent consumption, but users don't know:

- What each skill does
- When to use which skill
- How to customize skills

### 4. No Troubleshooting Guide

Common issues (e.g., bash compatibility) documented in CHANGELOG but not easily discoverable.

### 5. README vs. AGENTS.md Confusion

- README.md = project documentation for dot-agents repo itself
- AGENTS.md = template users customize for their projects

This distinction isn't obvious. Users might not know which file to reference.

## Recommendations

### Option A: Minimal (Low Effort)

Keep current structure, add:

1. **README section:** "How This Repo Works" explaining file purposes
2. **QUICKSTART addendum:** Link to skill documentation
3. **Troubleshooting section** in QUICKSTART.md

**Effort:** ~1 hour

### Option B: Docsify/MkDocs Site (Medium Effort)

Replace static landing page with documentation site:

```text
docs/
├── index.md          # Home (current landing page content)
├── getting-started/
│   ├── install.md
│   └── quickstart.md
├── concepts/
│   ├── workflow.md   # Research → PRD → Plan → Ralph
│   ├── skills.md     # Skill system explained
│   └── plans.md      # Plan format and lifecycle
├── skills/
│   ├── adapt.md
│   ├── ralph.md
│   ├── research.md
│   └── tmux.md
└── troubleshooting.md
```

**Benefits:**

- Search functionality
- Better navigation
- Versioned docs (can track changes)

**Effort:** ~4-6 hours

### Option C: GitHub Wiki (Low Effort)

Use GitHub's built-in wiki for extended documentation, keep README minimal.

**Benefits:**

- Easy to edit
- Separate from main repo
- Community contributions

**Drawbacks:**

- Not version-controlled with repo
- Different editing experience

**Effort:** ~2 hours

## Specific Improvements

### 1. Clarify AGENTS.md Purpose

Add header comment:

```markdown
<!--
This is a TEMPLATE for your project's AGENTS.md.
After installing dot-agents, customize this file with your:
- Project overview
- Tech stack
- Commands
- Conventions

Run `adapt` to auto-fill based on your codebase.
-->
```

### 2. Add Workflow Diagram to QUICKSTART.md

```text
┌──────────┐    ┌─────┐    ┌──────┐    ┌─────────┐
│ Research │ → │ PRD │ → │ Plan │ → │ Execute │
└──────────┘    └─────┘    └──────┘    └─────────┘
     ↓              ↓          ↓           ↓
.agents/research/ .agents/prds/ .agents/plans/ Ralph loops
```

### 3. Create Skills Overview Page

```markdown
# Skills

Skills are specialized agent instructions for specific workflows.

| Skill | Trigger | Purpose |
|-------|---------|---------|
| adapt | "Run adapt" | Analyze project, fill AGENTS.md |
| research | "Research X" | Deep investigation, saves findings |
| ralph | "Run ralph on plan" | Autonomous task execution |
| tmux | (auto-loaded) | Background process management |
```

### 4. Add FAQ/Troubleshooting

Common issues:

- Bash compatibility errors
- Sync conflicts
- Skill not loading
- Ralph not finding tasks

### 5. Document Sync Behavior with Examples

```bash
# Preview what would change
.agents/scripts/sync.sh --dry-run

# Force update (creates backups)
.agents/scripts/sync.sh --force

# Check version
.agents/scripts/sync.sh --version
```

## Priority Matrix

| Improvement | Impact | Effort | Priority |
|-------------|--------|--------|----------|
| AGENTS.md template comment | Medium | Low | High |
| Workflow diagram in QUICKSTART | High | Low | High |
| Skills overview | High | Medium | High |
| Troubleshooting guide | Medium | Low | Medium |
| Full docs site (Option B) | High | High | Low |
| GitHub Wiki | Medium | Low | Low |

## Recommended Next Steps

1. **Quick wins (this session):**
   - Add template comment to AGENTS.md
   - Add workflow diagram to QUICKSTART.md
   - Add troubleshooting section to QUICKSTART.md

2. **Short-term (next iteration):**
   - Create skills overview in docs/
   - Add "How This Repo Works" to README

3. **Long-term (future):**
   - Evaluate Docsify/MkDocs for proper documentation site
   - Consider versioned docs if multiple releases

## Oracle Review Findings

### Additional Gaps Identified

#### 1. Onboarding Correctness & Prerequisites

Missing from current docs:

- Supported shells/OS, required tools (git, curl)
- Bash version quirks (5.3+ compatibility)
- What install script actually does (high-level overview)
- Security note for `curl | bash` (inspect script / pin version)

#### 2. Expected Outputs & Examples

QUICKSTART shows imperative prompts but lacks:

- Example prompts with resulting file paths
- Minimal "golden path" example: one feature through research → PRD → plan → Ralph
- Sample filenames for each artifact

#### 3. Customization & Extension Guide

Missing:

- How to add custom skills (directory structure, naming, invocation)
- How to modify templates without sync overwriting them
- Naming conventions for PRDs/plans
- What to gitignore in `.agents/`

#### 4. Audience Segmentation

Three distinct audiences not clearly addressed:

1. **New adopters:** Install + first run
2. **Existing users:** Sync/update, troubleshooting
3. **Contributors:** Release/versioning, testing

#### 5. AGENTS.md Naming Confusion

The name `AGENTS.md` is used for both:

- The template in dot-agents repo
- The user's customized project file

**Options:**

- Rename template to `AGENTS.template.md` (install copies to `AGENTS.md`)
- Add prominent "THIS REPO'S AGENTS.md vs YOUR PROJECT'S" explanation
- Add visible banner at top (not just HTML comment)

### Revised Recommendations

**Recommended approach:** Fill the "middle layer" without heavy tooling.

1. **Add docs hub:** `docs/README.md` linked from README and QUICKSTART
2. **Concepts & Glossary:** Define adapt, research, PRD, plan, Ralph, skills, sync
3. **Make QUICKSTART executable:**
   - Prerequisites (bash version, git, curl, OS)
   - Expected outputs after install
   - First-run verification checklist
4. **Document confusing boundaries:**
   - Repo-level docs vs user-project template
   - Upstream dot-agents vs customized workspace (sync behavior)
5. **Skills overview:** `docs/skills.md` listing each skill with links to SKILL.md
6. **Troubleshooting:** Top 5 real failures in one place
7. **Maintenance guardrail:** "Docs update checklist" for contributors

### When to Adopt a Docs Site

Move to Docsify/MkDocs only when:

- More than 8-12 pages and cross-linking becomes painful
- Users frequently ask same concept questions despite Markdown docs
- Versioned docs per release tag becomes necessary

### Risks & Guardrails

| Risk | Guardrail |
|------|-----------|
| Docs drift from SKILL.md | Make `docs/skills.md` an index + "when to use," link to SKILL.md as source of truth |
| Over-investing in site generator | Only adopt after ~10+ pages and navigation complaints |
| Website vs repo docs confusion | Add "Docs currently live on GitHub" link on landing page |

## Updated Priority Matrix

| Improvement | Impact | Effort | Priority |
|-------------|--------|--------|----------|
| Prerequisites in QUICKSTART | High | Low | **High** |
| Expected outputs + golden path example | High | Medium | **High** |
| docs/README.md hub page | Medium | Low | **High** |
| Concepts/glossary page | High | Medium | **High** |
| AGENTS.md clarification (banner) | Medium | Low | **High** |
| Skills overview (docs/skills.md) | High | Medium | Medium |
| Troubleshooting guide | Medium | Low | Medium |
| Customization guide | Medium | Medium | Medium |
| Contributor docs section | Low | Low | Low |
| Full docs site (Docsify/MkDocs) | High | High | Low (defer) |

## Actionable Next Steps

### Phase 1: Quick Wins (~1-2h)

1. Add prerequisites section to QUICKSTART.md
2. Add expected outputs after install to QUICKSTART.md
3. Add visible banner to top of AGENTS.md clarifying template purpose
4. Create `docs/README.md` as hub linking to all docs

### Phase 2: Middle Layer (~2-3h)

1. Create `docs/concepts.md` with glossary
2. Create `docs/skills.md` overview
3. Add golden path example to QUICKSTART
4. Create `docs/troubleshooting.md`

### Phase 3: Polish (defer)

1. Customization/extension guide
2. Contributor documentation
3. Evaluate docs site generator (only if needed)

## Open Questions

- [ ] Should docs/ use a static site generator (Docsify, MkDocs)? → **Defer until 10+ pages**
- [ ] Is the current single-page landing page sufficient? → **Yes, add "docs on GitHub" link**
- [ ] Should skills have user-facing docs separate from SKILL.md? → **Yes, as lightweight index**
- [ ] How to handle documentation for custom skills users add? → **Add to customization guide**
- [ ] Rename AGENTS.md to AGENTS.template.md? → **Evaluate disruption vs clarity**

## Sources

- Git history analysis: `git log --oneline --all -- README.md AGENTS.md QUICKSTART.md docs/`
- Current docs review: README.md, QUICKSTART.md, docs/index.html
- Previous research: `.agents/research/improvement-opportunities.md`
- Oracle review: Architecture and documentation analysis
