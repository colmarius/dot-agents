# PRD Guidelines

Lightweight product requirements for solo development with AI agent execution.

## Workflow

```
Research → PRD → Plan → Ralph executes
```

1. **Draft PRD** (15-30 min timebox) — use TEMPLATE.md
2. **Generate plan** — create `.agents/plans/todo/PLAN-XXX.md` with Ralph task format
3. **Execute** — ralph runs the plan
4. **Close** — update PRD status, move plan to completed

## Rules

- Keep PRD under 1 page (~400-700 words)
- Timebox to 30 minutes max
- Acceptance criteria must be testable
- Always include non-goals
- Link PRD ↔ Plan bidirectionally

## PRD vs Plan

| PRD | Plan |
|-----|------|
| Why / What | How / Tasks |
| Stable context | Execution checklist |
| Problem + goals | File scopes + acceptance |

## Naming

```
PRD-YYYYMMDD-short-title.md
PLAN-YYYYMMDD-short-title.md
```

Keep titles aligned between PRD and Plan.
