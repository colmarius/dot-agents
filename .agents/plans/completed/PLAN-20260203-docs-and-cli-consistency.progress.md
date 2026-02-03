# Progress: Documentation and CLI Consistency

## Task 1: Link QUICKSTART.md from README.md

**Thread**: https://ampcode.com/threads/T-019c2543-155f-73ca-9875-810c5cad91d6
**Status**: completed
**Iteration**: 1

### Changes

- `README.md` - Added prominent link to QUICKSTART.md in "Next Steps" section

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 2: Add --version flag to sync.sh

---

## Task 2: Add --version flag to sync.sh

**Thread**: https://ampcode.com/threads/T-019c2543-155f-73ca-9875-810c5cad91d6
**Status**: completed
**Iteration**: 1

### Changes

- `.agents/scripts/sync.sh` - Added UPSTREAM_URL and DEFAULT_REF constants
- `.agents/scripts/sync.sh` - Added do_version() function mirroring install.sh
- `.agents/scripts/sync.sh` - Added --version flag handling in _main()

### Commands Run

- `./scripts/lint.sh` ✓
- `.agents/scripts/sync.sh --version` ✓ (shows installation info)
- `/tmp: sync.sh --version` ✓ (shows "not installed" message)

### Next

- Task 3: Add --help flag to sync.sh

---

## Task 3: Add --help flag to sync.sh

**Thread**: https://ampcode.com/threads/T-019c2543-155f-73ca-9875-810c5cad91d6
**Status**: completed
**Iteration**: 1

### Changes

- Already existed - sync.sh had --help from before
- Added --version to usage() documentation

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 4: Document sync behavior in README

---

## Task 4: Document sync behavior in README

**Thread**: https://ampcode.com/threads/T-019c2543-155f-73ca-9875-810c5cad91d6
**Status**: completed
**Iteration**: 1

### Changes

- `README.md` - Added "Sync Behavior" section with table explaining what gets updated vs skipped

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 5: Add CHANGELOG.md

---

## Task 5: Add CHANGELOG.md

**Thread**: https://ampcode.com/threads/T-019c2543-155f-73ca-9875-810c5cad91d6
**Status**: completed
**Iteration**: 1

### Changes

- `CHANGELOG.md` - Created with Keep a Changelog format, documenting v1.0.0 and unreleased changes

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 6: Document versioning scheme in README

---

## Task 6: Document versioning scheme in README

**Thread**: https://ampcode.com/threads/T-019c2543-155f-73ca-9875-810c5cad91d6
**Status**: completed
**Iteration**: 1

### Changes

- `README.md` - Added "Versioning" section explaining SemVer, --ref usage, and link to CHANGELOG

### Commands Run

- `./scripts/test.sh` ✓

### Next

- All tasks complete

---
