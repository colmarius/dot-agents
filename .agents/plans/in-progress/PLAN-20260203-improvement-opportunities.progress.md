# Progress: dot-agents Improvement Opportunities

## Task 1: Fix BASH_SOURCE install script execution guard

**Thread**: https://ampcode.com/threads/T-019c2539-d0c9-740b-8052-cbfa7d112387
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Fixed execution guard to handle piped execution (empty BASH_SOURCE)

### Commands Run

- `./install.sh --dry-run` ✓
- `cat install.sh | bash -s -- --dry-run` ✓
- `source ./install.sh` (no output) ✓
- `./scripts/lint.sh` ✓

### Next

- Task 2: Fix installer skip logic for plans/TEMPLATE.md

---

## Task 2: Fix installer skip logic for plans/TEMPLATE.md

**Thread**: https://ampcode.com/threads/T-019c2539-d0c9-740b-8052-cbfa7d112387
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Changed skip logic to only skip `plans/todo/*.md`, `plans/in-progress/*.md`, `plans/completed/*.md`

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 3: Add plan TEMPLATE.md

---

## Task 3: Add plan TEMPLATE.md

**Thread**: https://ampcode.com/threads/T-019c2539-d0c9-740b-8052-cbfa7d112387
**Status**: completed
**Iteration**: 1

### Changes

- `.agents/plans/TEMPLATE.md` - Created plan template with metadata table and Ralph-ready task format

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 4: Add .agents/.gitignore

---

## Task 4: Add .agents/.gitignore

**Thread**: https://ampcode.com/threads/T-019c2539-d0c9-740b-8052-cbfa7d112387
**Status**: completed
**Iteration**: 1

### Changes

- `.agents/.gitignore` - Created with `reference/` exclusion and explanatory comment

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 5: Add skill invocation documentation to AGENTS.md

---

## Task 5: Add skill invocation documentation to AGENTS.md

**Thread**: https://ampcode.com/threads/T-019c2539-d0c9-740b-8052-cbfa7d112387
**Status**: completed
**Iteration**: 1

### Changes

- `AGENTS.md` - Added "## Using Skills" section with command/effect table

### Commands Run

- `./scripts/lint.sh` ✓

### Next

- Task 6: Add --version flag to install.sh

---

## Task 6: Add --version flag to install.sh

**Thread**: https://ampcode.com/threads/T-019c253d-2c8f-74be-8e09-ad5690094dec
**Status**: completed
**Iteration**: 2

### Changes

- `install.sh` - Added `--version` flag with `do_version()` function that outputs upstream URL, default ref, and installation metadata if present

### Commands Run

- `./scripts/lint.sh` ✓
- `./install.sh --version` ✓ (shows installation info)
- `/tmp: ./install.sh --version` ✓ (shows "not installed" message)

### Next

- Task 7: Create QUICKSTART.md

---

