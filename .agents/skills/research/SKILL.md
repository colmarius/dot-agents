---
name: research
description: Deep research on technical topics, libraries, APIs, or concepts. Use when asked to research, investigate, explore deeply, or gather comprehensive information on a topic. Saves learnings to .agents/research/.
---

# Research Skill

Conducts deep research on technical topics, saving findings for future reference.

## Capabilities

- Web search for documentation, articles, and examples
- Deep analysis using Oracle for complex reasoning
- Cross-reference multiple sources
- Save structured learnings to `.agents/research/`

## Workflow

### 1. Clarify Scope

Before starting, confirm:

- **Topic**: What exactly needs researching?
- **Depth**: Quick overview or comprehensive deep-dive?
- **Focus**: Implementation details, best practices, comparisons, or concepts?

### 2. Research Phase

Use these tools in combination:

| Tool | Use For |
|------|---------|
| `web_search` | Find documentation, articles, tutorials |
| `read_web_page` | Extract detailed content from URLs |
| `oracle` | Deep analysis, synthesizing findings, reasoning about trade-offs |
| `librarian` | Explore open-source implementations |

**Research strategy:**

1. Start with `web_search` to find authoritative sources
2. Use `read_web_page` to extract key information
3. Consult `oracle` for analysis and synthesis
4. Use `librarian` to find real-world implementations

### 3. Document Findings

Save research to `.agents/research/[topic-slug].md`:

```markdown
# Research: [Topic Name]

**Date:** YYYY-MM-DD
**Status:** Draft | Complete
**Tags:** [relevant, tags]

## Summary

[2-3 sentence overview of key findings]

## Key Learnings

- Learning 1
- Learning 2
- Learning 3

## Details

### [Subtopic 1]

[Detailed findings]

### [Subtopic 2]

[Detailed findings]

## Sources

- [Source Title](url) - Brief description of what was learned
- [Source Title](url) - Brief description

## Open Questions

- [ ] Question that needs further research
- [ ] Another question

## Related Research

- [[other-topic.md]] - How it relates
```

### 4. Synthesize & Report

Provide the user with:

1. **Executive summary** (3-5 bullet points)
2. **Recommendations** based on findings
3. **Link to saved research file**

## File Naming Convention

Use kebab-case slugs: `.agents/research/[topic-slug].md`

Examples:

- `react-server-components.md`
- `firebase-auth-patterns.md`
- `zod-vs-yup-comparison.md`

## Deep Research Mode

For comprehensive research, use Oracle with focused prompts:

```text
task: "Analyze [topic] considering:
- Current best practices
- Common pitfalls
- Performance implications
- Security considerations"
```

## Quick Reference

**Start research:**

```text
Research [topic] - [specific focus]
```

**Check existing research:**

```bash
ls -la .agents/research/
```

**Update existing research:**
Add new sections or update status from Draft to Complete.
