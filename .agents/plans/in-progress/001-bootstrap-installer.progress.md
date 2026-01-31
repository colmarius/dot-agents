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

