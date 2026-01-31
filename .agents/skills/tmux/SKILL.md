---
name: tmux
description: Instructions for using tmux to spawn multiple processes, inspect them, and capture their output. Use when running servers, long-running tasks, or background processes.
---

# tmux

Manage background processes using tmux windows without blocking the terminal.

## 1. Verify Environment & Check Status

Confirm tmux is running and list existing windows:

```bash
tmux list-windows
```

## 2. Spawn a Background Process

Create a new tmux window and run a command:

```bash
tmux new-window -n "my-server" -d
tmux send-keys -t "my-server" "npm run dev" C-m
```

- `-n "my-server"` names the window for easy reference
- `-d` keeps it detached (runs in background)
- `C-m` sends Enter to execute the command

## 3. Inspect Output (Read Logs)

### Visible screen only

```bash
tmux capture-pane -p -t "my-server"
```

### Full scrollback history

```bash
tmux capture-pane -p -t "my-server" -S -1000
```

- `-S -1000` captures the last 1000 lines of scrollback

## 4. Interact with the Process

### Send Ctrl+C (interrupt)

```bash
tmux send-keys -t "my-server" C-c
```

### Kill the window

```bash
tmux kill-window -t "my-server"
```

## 5. Advanced: Chaining Commands

Run multiple commands in sequence:

```bash
tmux new-window -n "build" -d && \
tmux send-keys -t "build" "npm run build && npm run test" C-m
```

## Quick Reference

| Action | Command |
| ------ | ------- |
| Create window | `tmux new-window -n "ID" -d` |
| Run command | `tmux send-keys -t "ID" "CMD" C-m` |
| Read output | `tmux capture-pane -p -t "ID"` |
| Send interrupt | `tmux send-keys -t "ID" C-c` |
| Kill window | `tmux kill-window -t "ID"` |
