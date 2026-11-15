---
name: research
description: "Researches technical questions with authoritative sources and saves findings when they should last. Use for docs, comparisons, APIs, and architecture references. Triggers on: research, investigate, compare, gather references."
---

# Research

Answer a technical question with reliable evidence. The answer can stay in the conversation; save a note only when people must review it, the work continues elsewhere, or the findings will be reused.

## Workflow

1. **Check what exists.** Read the active work item's `index.md` and its research, search `.agents/research/`, and check repository docs. Update an existing note instead of starting a parallel one.
2. **Frame the question.** State the exact question and the depth needed; default to a targeted answer. If the request is ambiguous but actionable, state your assumptions and proceed.
3. **Gather evidence.** Prefer the repository, official docs, specifications, release notes, and maintainer sources; use community posts only to fill gaps. Fetch fresh copies when the user asks for the latest information. For audits and verification, read full sources, since excerpts can omit qualifications.
4. **Synthesize.** Give the recommendation, key trade-offs, confidence, and open risks. Separate sourced facts from your inference, and name coverage gaps.
5. **Save when useful.**
   - Findings for one work item go in its `research.md`, or `research/<topic>.md` with a `research/index.md` map when there are several.
   - Findings reused across unrelated work go in `.agents/research/<topic>.md`. Make them stand alone with primary-source citations, so they survive the work item's removal.
6. **Report.** Summarize the answer and recommendation, link any saved note, and list open questions.

## Note Shape

```markdown
# Research: [Topic]

Date: YYYY-MM-DD
Question: [What was researched]

## Recommendation

[Best current answer in 2-4 sentences, with confidence.]

## Findings

- [Finding, with its source]

## Sources

- [Title](https://example.com) — what it established

## Open Questions

- [Only questions that change the answer]
```
