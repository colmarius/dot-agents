# Improvement Suggestions

Feedback gathered after installing dot-agents on an existing project.

## Suggested Improvements

### 1. Backup Location

**Current:** Creates `.dot-agents-backup/` in the project root.

**Issue:** This directory is visible and may be accidentally committed to version control.

**Suggestions:**

- Add `.dot-agents-backup/` to the generated `.agents/.gitignore`.
- Or nest backups inside `.agents/.backups/` to keep the root directory clean.

### 2. Post-Install Guidance

**Current:** Installation ends with a summary table only.

**Suggestion:** Print actionable next steps after install:

```bash
✓ Installation complete!

Next steps:
  1. Run 'adapt' to customize AGENTS.md for your project
  2. Read the quickstart: https://github.com/colmarius/dot-agents/blob/main/QUICKSTART.md
```

### 3. Version Tracking

**Current:** Shows `(ref: main)` during install.

**Suggestion:** Display the actual commit SHA or version tag for reproducibility (e.g., `Installing dot-agents v1.2.0 (abc123f)...`).

### 4. Interactive Mode for Conflicts

**Current:** Force overwrites managed files with automatic backup.

**Suggestion:** Add an `--interactive` flag to review changes before overwriting, allowing users to decide per-file.

### 5. Diff Preview for Skill Updates

**Current:** Backs up and overwrites without showing what changed.

**Suggestion:** For sync/update operations, show a summary of changes or a diff preview for modified skills.

### 6. Sync Command Documentation

**Current:** `scripts/sync.sh` is installed but not mentioned in post-install output.

**Suggestion:** Document how to update/sync in the output: `To update skills: .agents/scripts/sync.sh`.

### 7. Landing Page Improvements

- Add a copy button to the curl command for easier installation.
- Show the version number on the landing page.
- Add testimonials or example repos using dot-agents.

### 8. Preserve Custom Skills Table

**Current:** The `skills/AGENTS.md` file is force-overwritten with only core skills listed.

**Issue:** Projects with custom skills (e.g., `agent-browser`, `git-workflow`) lose their skill documentation in the main table.

**Suggestions:**

- Mark the "Available Skills" table as user-managed content (skip on sync).
- Or auto-generate the table by scanning existing skill directories.

### 9. Detect Existing Skills Before Overwrite

**Current:** No awareness of project-specific customizations.

**Suggestion:** Before syncing, detect custom skills and warn the user that core skills will be updated while custom ones are preserved.

### 10. Add .dot-agents-backup to .gitignore

**Current:** Backup folder created at project root is not ignored.

**Suggestion:** Automatically add `../.dot-agents-backup/` to the generated `.agents/.gitignore` or create a root entry.

## Priority Ranking

| Priority   | Improvement                  | Effort |
| ---------- | ---------------------------- | ------ |
| **High**   | Post-install guidance        | Low    |
| **High**   | Preserve custom skills table | Medium |
| **High**   | Add backup to gitignore      | Low    |
| **Medium** | Version tracking             | Medium |
| **Medium** | Sync command docs            | Low    |
| **Medium** | Detect existing skills       | Medium |
| **Low**    | Interactive mode             | High   |
| **Low**    | Diff preview                 | High   |
