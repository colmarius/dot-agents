---
name: research
description: "Researches technical questions with authoritative sources and saves work-local or reusable findings. Use for docs, comparisons, APIs, and architecture references. Triggers on: research, investigate, compare, gather references."
---

# Research Skill

Research a technical question, synthesize reliable evidence, and save findings either work-locally or as reusable notes in `.agents/research/`.

## Workflow

### 0. Check Existing Context

Before doing new research:

- If the work belongs to an active work item, read `.agents/work/<category>/<work-slug>/index.md` and prefer work-local `research.md` or `research/` for task-specific findings.
- Search `.agents/research/` for an existing reusable topic note.
- Check repo docs, attached files, and skill `references/` first.
- If an existing note already answers the question, update it only when stale or incomplete.

### 1. Define the Research Brief

Capture these before researching:

- **Question**: What exact question must be answered?
- **Depth**: Default to a targeted answer unless a deep-dive is explicitly requested.
- **Focus**: Implementation details, comparisons, best practices, or conceptual overview.

If the request is ambiguous but actionable, state assumptions and proceed. Ask follow-up questions only when ambiguity would materially change the recommendation.

### 2. Gather Evidence

Use the smallest toolset that can answer the question.

| Tool | Use for |
| --- | --- |
| Web search | Find authoritative sources when local docs are insufficient |
| Web page reading | Extract relevant details from specific URLs |
| Oracle or another reasoning model | Synthesize trade-offs after evidence is gathered |
| Repository search | Inspect local implementations and patterns |
| GitHub tooling | Inspect issues, PRs, releases, or external repository examples |

Guidelines:

1. Prefer local docs and existing research before external search.
2. Prefer official docs, specs, release notes, and maintainer-authored sources.
3. Use community posts only to fill gaps in official guidance.
4. Target 2-5 high-quality sources instead of broad source dumps.
5. Use deeper reasoning after collecting evidence, not as a substitute for evidence.
6. If the user asks for latest or recent information, force a fresh fetch when your tools support it.

### 3. Synthesize Recommendation

Produce:

1. The best current recommendation.
2. Key trade-offs.
3. Confidence level and uncertainty.
4. Unresolved risks or follow-up validations.

### 4. Save or Update Findings

Use work-local `.agents/work/<category>/<work-slug>/research.md` when:

- The research mainly supports one implementation task or work item.
- The findings explain task-specific constraints, alternatives, or plan decisions.
- A future agent should find the research beside `plan.md`, `prd.md`, or `progress.md`.

Use work-local `.agents/work/<category>/<work-slug>/research/<topic-slug>.md` when one work item needs multiple focused research notes.

Create or update `.agents/research/<topic-slug>.md` when:

- Findings are likely to be reused across unrelated work.
- The topic needs multiple sources or non-obvious trade-offs.
- The user explicitly asks to document reusable research.

If work-local findings later become broadly reusable, add a concise promoted synthesis to `.agents/research/` and link between the files.

Use this template:

```markdown
# Research: [Topic Name]

**Date:** YYYY-MM-DD
**Status:** draft | complete
**Question:** [What was researched]

## Recommendation

[Best current answer in 2-4 sentences]

## Key Findings

- Finding 1
- Finding 2
- Finding 3

## Evidence

### [Source or Subtopic]

[Relevant facts only]

## Sources

- [Source Title](url) — What this source established

## Open Questions

- [ ] Include only unresolved questions that materially affect the answer
```

Status definitions:

- `draft`: Useful findings exist, but material questions remain.
- `complete`: Evidence is sufficient to answer the stated question with confidence.

### 5. Report Back

Provide the user with:

1. A concise summary.
2. A clear recommendation.
3. Link to the saved research file, if saved.
4. Explicit unknowns or open questions.

## Definition Of Done

Research is complete when the question has a clear answer or recommendation, supporting evidence is cited, reusable findings are saved when warranted, and the user receives the summary plus any saved file path.
