Run an evaluation of agent guidance. You are the eval runner, not the agent under test.

`evals-bundle.tar.gz` in your workspace root is uploaded from another thread right after this one starts; if it is missing, run `sleep 20` and check again (up to a few minutes). Extract it to `/tmp/evals` (`mkdir -p /tmp/evals && tar -xzf evals-bundle.tar.gz -C /tmp/evals --strip-components=1`). It contains a small Node project, the dot-agents guidance under test in `guidance/`, seeded work items, `setup-scenario.sh`, and `scenarios.md` with user requests s1–s9.

Run all scenarios s1 through s9. For each:

1. Create a fresh repository: `/tmp/evals/setup-scenario.sh <scenario> /tmp/runs/<scenario>`.
2. Start one Task subagent per run with exactly this prompt, filling in the path and the scenario text verbatim from `scenarios.md`:

   > You are working in the git repository at /tmp/runs/<scenario>. Treat it as your workspace root and run every command there. You may create, edit, and commit files in this repository as the request requires; this is a coding task, not a read-only one. First read its AGENTS.md and follow it, as you would project instructions. Skills live in `.agents/skills/<name>/SKILL.md`; read a skill's SKILL.md when its description matches the request, and follow any nested AGENTS.md in directories you work in. The user is not available for questions; make reasonable assumptions and state them. The user's request:
   >
   > <scenario text>

   Run the subagents in parallel batches. Do not give them the scenario name or any hint about what is being evaluated.
3. When a subagent finishes, continue it (Task with its `id`) with: "Thanks. Briefly, for the people who maintain this repository's agent guidance: which guidance files did you read, what in them helped, and what was unclear, conflicting, missing, or unnecessary for this request?"
4. Collect into `/tmp/results/<scenario>.md`: the subagent's final message, its feedback answer, `git log --stat` since the first commit, `git status --short`, `git diff --stat` for any uncommitted changes, and the full contents of every file under `.agents/work/` except `.agents/work/AGENTS.md` (or a note that none exist; for a deleted item, add its last committed files from git history). Capture the state with read-only git commands; do not edit the run repositories yourself.

Do not grade the runs and do not change the guidance. When every run is collected, create `eval-results-{LABEL}.tar.gz` from `/tmp/results` in the same directory where `evals-bundle.tar.gz` arrived, then use send_thread_message to tell thread {REPLY_THREAD} that the archive is ready, giving its absolute path, listing any run that failed or was incomplete. Do the work yourself; do not create other threads.
