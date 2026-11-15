> **📝 TEMPLATE:** This is the dot-agents `AGENTS.md` template.
> Customize it for your project (or ask your agent to `Run adapt`), then delete this banner.

# Project Instructions

## Overview

[Brief project description]

## Tech Stack

- Language: [e.g., TypeScript, Rust, Go, Python]
- Framework: [e.g., React, Express, Axum, FastAPI]
- Database: [e.g., PostgreSQL, SQLite]

## Commands

```bash
# Add verified project commands, for example:
# npm install / npm run dev / npm test
```

## Conventions

- [Naming, code style, commit message format]

## Architecture Notes

[Key components and boundaries, or pointers to the docs that describe them]

## Agent Work

Keep work in the conversation when one thread can finish it. Create a work item under `.agents/work/<category>/<slug>/` when people need to review or align on direction, when the work must continue in another session, thread, or worker, or when asked. Its `index.md` records why, what is done and remains, decisions, and the next action; `log.md` keeps the dated history. Follow `.agents/work/AGENTS.md` for the contract.

| Ask | Effect |
| --- | --- |
| `Run adapt` | Fill in this file from the project |
| `Research ...` | Investigate with sources; save findings when they should last |
| `Create a work item for ...` | Start a durable record for review or continuation |
| `Continue the work item at ...` | Resume from its `index.md` |
| `Write a handoff prompt for ...` | Brief another thread or worker |
| `Close the work item at ...` | Promote outcomes and remove the completed item |

Each skill lives in `.agents/skills/<name>/SKILL.md`; load one when its description matches the request. `.agents/research/` holds findings reused across work.

## Git

Follow the user's delivery authority and project policy. A request to commit, push, merge, or deploy authorizes that action; implementing a change alone authorizes none of them, and one does not imply the next. Commit logical steps with clear messages and stage only intended changes.
