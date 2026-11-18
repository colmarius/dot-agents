# Migrating to safe sync (unreleased)

Ordinary sync now preserves differing managed files and retired content. This changes the older default that automatically forced replacement during sync. No release version has been assigned to this change.

## Choose the installer deliberately

`sync.sh` fetches and executes `install.sh` from the upstream and ref in `.agents/.dot-agents.json`. An older pinned ref still runs its older installer. Passing `--ref` changes the archive selected by that installer, not the installer already downloaded. To adopt safe sync from a reviewed revision, run that revision's installer with the same revision as `--ref`. The next approved release should announce this changed default prominently and supply matching installer/archive pins.

This change does not update installed projects automatically. It adds no checksum database or three-way merge: every managed file differing from the incoming copy needs review, including untouched files from an older release.

## Review a partial update

1. Preview with the reviewed installer's `--diff`. Exit 1 means changes are pending; no project files, metadata, or backups are written. `--dry-run` is also read-only, including when combined with `--force` or `--interactive`.
2. Run ordinary sync. Missing files are installed, identical files stay unchanged, and differing files stay active. Incoming Markdown goes to `file.dot-agents.md`; other files go to `file.ext.dot-agents.new`. Existing conflict copies are never overwritten, even if incoming content has changed since they were created.
3. Review the separate preserved-conflict and pending-removal lists. Exit 1 means the update remains unresolved, not that no files changed. Metadata retains the last completed installation/sync, not the attempted ref. Do not report that ref as fully synchronized.
4. Move lasting customizations into project-owned guidance or non-colliding custom skills where appropriate. Compare each incoming copy, merge deliberately, and remove the review copy when finished. To regenerate an old review copy, first preserve any notes you need and remove it. A local file still differing from upstream remains a conflict on subsequent runs, even after a deliberate manual merge.
5. Remove retired managed content manually after review, or authorize the installer with `--interactive` or `--force`. Interactive keep/skip still exits 1; overwrite-all does not approve removals. `--yes` grants neither permission. `--force --write-conflicts` is invalid.

Explicit `--force` backs up replaced files and removed managed targets under `.agents/.dot-agents-backup/`. It does not delete conflict review copies or non-colliding user content. Inspect backups before restoring a specific file or directory; do not copy the entire backup tree over newer project work.

Retired skills, legacy guidance/templates, retired `agent-work` references, and stale managed Claude links remain until removal is authorized. Preserving a retired skill also preserves its existing discovery link, so its old instructions may remain active while you review. Root `AGENTS.md`, work items, research, legacy plan/PRD documents, custom skills, and user-owned Claude paths retain their ownership rules.

Automation that requires replacement must opt into `--force` after its owner approves that policy. Otherwise treat exit 1 as a review-needed partial update, not as success or an instruction to retry with force. No production rollout or project migration is authorized merely by documenting this procedure.
