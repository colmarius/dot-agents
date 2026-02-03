# Concepts

## Workflow

```text
Research → PRD → Plan → Execute
```

1. **Research:** Investigate problem space, save findings to `.agents/research/`
2. **PRD:** Define requirements and acceptance criteria in `.agents/prds/`
3. **Plan:** Break PRD into executable tasks with Ralph-ready format
4. **Execute:** Ralph runs tasks autonomously, commits after each

## Glossary

| Term | Definition |
|------|------------|
| adapt | Skill that analyzes your project and fills in AGENTS.md |
| Ralph | Autonomous execution skill that works through plans task-by-task |
| PRD | Product Requirements Document defining what to build |
| Plan | List of tasks in Ralph-ready format with scope, dependencies, acceptance criteria |
| Skills | Specialized agent instructions loaded via natural language |
| sync | Script that updates dot-agents from upstream while preserving your customizations |
