# Progress: Bootstrap Installer for dot-agents

## Task 1: Create install.sh core script with safe merge

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Created core installer script with safe merge logic

### Commands Run

- `./install.sh` ✓ (tested against local repo, all files skipped as identical)

### Learnings

- Used global TMP_DIR variable for proper trap cleanup
- macOS needs md5 -q instead of md5sum

### Next

- Task 2: Add CLI flags to install.sh

---

## Task 2: Add CLI flags to install.sh

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Added parse_args function with --dry-run, --force, --ref, --yes, --help flags

### Commands Run

- `./install.sh --help` ✓
- `./install.sh --dry-run --ref v0.1.0` ✓ (correctly shows ref and dry-run mode)

### Next

- Task 3: Add backup mechanism

---

## Task 3: Add backup mechanism

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Added create_backup_dir and backup_file functions
- Backs up files before --force overwrite to `.dot-agents-backup/YYYY-MM-DDTHHMMSSZ/`
- Summary shows backup count and location

### Commands Run

- Tested backup in /tmp/test-backup with existing AGENTS.md ✓
- Verified backup file preserved original content ✓

### Next

- Task 4: Add metadata tracking

---

## Task 4: Add metadata tracking

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Added write_metadata function
- Creates `.agents/.dot-agents.json` with upstream, ref, installedAt

### Commands Run

- `./install.sh` ✓
- `cat .agents/.dot-agents.json` ✓ (verified correct JSON format)

### Next

- Task 5: Create PROJECT.md template

---

## Task 5: Create PROJECT.md template

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `.agents/PROJECT.md.template` - Created template with placeholders for project name, tech stack, commands, conventions
- `install.sh` - Copies template as PROJECT.md if PROJECT.md doesn't exist

### Commands Run

- Verified template structure ✓

### Next

- Task 6: Add stack detection

---

## Task 6: Add stack detection

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Added detect_stack function
- Detects package.json, Cargo.toml, go.mod, pyproject.toml, requirements.txt
- Appends detected stack info to PROJECT.md when created

### Commands Run

- Tested detect_stack in /tmp/test-node with package.json ✓

### Next

- Task 7: Update README.md with installation instructions

---

## Task 7: Update README.md with installation instructions

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `README.md` - Rewrote with installation instructions, CLI flags, examples, update workflow, structure docs

### Next

- Task 8: Add uninstall command

---

## Task 8: Add uninstall command

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Added --uninstall flag and do_uninstall function
- Prompts for confirmation unless --yes
- Preserves PROJECT.md on uninstall

### Commands Run

- Tested uninstall in /tmp/test-node ✓
- Verified PROJECT.md preserved after uninstall ✓

### Next

- Task 9: Add --interactive mode (optional)

---

## Task 9: Add --interactive mode

**Thread**: https://ampcode.com/threads/T-019c1408-6293-750c-a6c2-caef909b0cd5
**Status**: completed
**Iteration**: 1

### Changes

- `install.sh` - Added --interactive flag and prompt_conflict function
- Shows diff preview when diff command available
- Options: keep/overwrite/new file/skip all/overwrite all

### Commands Run

- `./install.sh --help` ✓ (shows --interactive flag)

### Next

- Task 10: Create "adapt" skill (manual-verify)

---

