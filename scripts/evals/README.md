# Guidance evals

A small regression eval for the installed guidance: nine user requests (`scenarios.md`) run against a tiny notes API (`project/`) with seeded work items (`seeds/`), graded with `rubric.md`. Run it after changing `.agents/work/AGENTS.md`, `agent-work`, or `AGENTS.template.md`.

## Run

1. Build a bundle from the repository root. Pass a git ref to test released guidance instead of the working tree:

   ```bash
   scripts/evals/build-bundle.sh /tmp/evals-bundle.tar.gz [v0.5.1]
   ```

2. For each model, start one runner thread in its own sandbox **without the dot-agents project**, so the runner's subagents do not also load this repository's `AGENTS.md`. Use `runner-prompt.md` as its prompt, replacing `{LABEL}` (for example `opus`) and `{REPLY_THREAD}` (the thread that grades), then upload the bundle to the runner as `evals-bundle.tar.gz` in its workspace root.
3. When a runner reports, fetch its `eval-results-{LABEL}.tar.gz`, extract it into its own directory, and grade each `results/<scenario>.md` against `rubric.md`. `python3 -I strip.py <file>` prints a result without the repeated contract.

To reproduce one scenario by hand, extract a bundle and run `evals/setup-scenario.sh s3 /tmp/runs/s3`.

## Known limits

- Runners start one Task subagent per scenario. Some harnesses mark research and planning subagents read-only, so a model may write the s2 proposal in its reply without saving it. Grade the proposal's content and treat persistence as untested, or run s2 in its own thread.
- The project's root `AGENTS.md` comes from `fill_agents.py`, which fills the template with notes-api facts the way `adapt` would. It says Node.js 24; runners on newer Node versions may mention the mismatch.
- Results are small samples. Compare failures across models and rounds before changing guidance for one run.

## What v0.6 learned

Five rounds on Opus 5.5, GPT-6 Astra (medium), and Fable 5.2 shaped v0.6. Keep these in mind when changing the guidance:

- Current state and history need separate files. When history shared `index.md` or `plan.md`, real items grew to hundreds or thousands of lines; with `log.md` beside `index.md`, every eval run kept the index short.
- Models follow decision rules closely, so ambiguity shows up as disagreement between models. Bundled `Proposed:` lines, unclear `blocked` versus `in-progress`, and "is writing a handoff a delegation?" each produced different behavior per model until the wording was settled.
- A worked example decides edge cases: "a bound on a new parameter is reversible; a default that changes existing responses is not" settled s3 on all three models.
- Agents open every file that looks like guidance. Keep guidance that is not for the current task out of `AGENTS.md` files and point to skills by their `SKILL.md`.
- Procedures current models already follow (verification, delegation hygiene, research method) can be left to the model and its harness; state where shared state lives, its shape, when to create it, and which actions need authority.
