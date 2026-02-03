# install.sh Postfix Increment Failure Investigation

**Issue:** [GitHub Issue #1](https://github.com/colmarius/dot-agents/issues/1)
**Reporter:** @erichoswald
**Reporter's Bash:** GNU bash 5.3.9(1)-release (aarch64-apple-darwin24.6.0)

## Problem Summary

The install script fails after processing the first file when using `set -e` with postfix increment operators like `((installed_count++))`.

## Root Cause

When using `((expression))` arithmetic commands in bash:
- The **return status** is 0 if the expression value is non-zero
- The **return status** is 1 if the expression value is zero

With postfix increment `((var++))`:
- The expression evaluates to the **old value** before incrementing
- When `var=0`, `((var++))` evaluates to `0`, returning exit status 1
- With `set -e` (errexit), this causes the script to exit

```bash
var=0
((var++))   # Returns exit status 1 because expression value is 0 (the old value)
# Script exits here with set -e
```

## Current Mitigation in install.sh

The script already uses `|| true` on all increment operations:

```bash
((installed_count++)) || true
((skipped_count++)) || true
# etc.
```

This should prevent the exit, but the reporter claims it still fails on bash 5.3.9.

## Possible Explanations

1. **Subshell evaluation**: Some bash versions may evaluate the arithmetic before the `|| true` in certain contexts
2. **Bash 5.3 behavior change**: There may be a subtle change in bash 5.3.x behavior
3. **User environment**: Could be shell options or environment differences

## Recommended Solutions

### Option 1: Use `+= 1` assignment (safest)
```bash
# Instead of:
((installed_count++)) || true

# Use:
installed_count=$((installed_count + 1))
# or
((installed_count += 1)) || true
```

The assignment form `var=$((var + 1))` always returns status 0 because the assignment succeeds regardless of the expression value.

### Option 2: Use prefix increment `++var`
```bash
((++installed_count)) || true
```

Prefix increment returns the **new value** after incrementing, so `((++var))` when `var=0` returns 1 (truthy), not 0.

### Option 3: Explicit true fallback with grouping
```bash
{ ((installed_count++)); } || true
```

## Recommendation

**Use Option 1 (`+= 1`)** as it's:
- Most portable across bash versions
- Clearest intent
- No special handling needed
- Matches what reporter found works

Replace all occurrences:
```bash
# From:
((installed_count++)) || true
((skipped_count++)) || true
((conflict_count++)) || true
((backup_count++)) || true
((removed++)) || true

# To:
installed_count=$((installed_count + 1))
skipped_count=$((skipped_count + 1))
conflict_count=$((conflict_count + 1))
backup_count=$((backup_count + 1))
removed=$((removed + 1))
```

## References

- [Stack Exchange: bash set -o errexit and increment variable](https://unix.stackexchange.com/questions/276484/bash-set-o-errexit-problem-or-the-way-of-incrementing-variable)
- [Stack Overflow: Bash errexit with arithmetic expansion](https://stackoverflow.com/questions/44819831/bash-errexit-with-arithmetic-expansion)
- [Alex Chan TIL: errexit and arithmetic expressions](https://alexwlchan.net/til/2024/errexit-and-arithmetic-expressions/)

## Files to Modify

- [`install.sh`](/Users/marius/Projects/dot-agents/install.sh): Lines 152, 163, 205, 346, 352, 364, 375, 382, 401
