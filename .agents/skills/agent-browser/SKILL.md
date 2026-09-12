---
name: agent-browser
description: "Automates real-browser workflows through the agent-browser CLI. Use for web navigation, testing, screenshots, extraction, and exploratory QA. Triggers on: agent-browser, browser automation, web testing, dogfood testing."
---

# agent-browser

Use `agent-browser` when work needs a real browser, repeatable UI checks, screenshots, exploratory testing, data extraction, or application-specific browser automation.

This checked-in skill is a discovery stub. Ask the installed CLI for current workflow details instead of vendoring fast-changing runtime instructions.

CLI instructions supplement the execution environment's service, authentication, and artifact rules. Use disposable non-production test data for mutating checks; keep credentials, saved authentication state, and sensitive captures out of commits.

## Workflow

1. Check whether the CLI is available:

   ```bash
   agent-browser --help
   ```

   If it is unavailable and the task genuinely needs it, prefer a one-off invocation or ask before adding a project dependency. dot-agents does not install the CLI or browser runtime automatically.

2. List the instructions available from the installed CLI:

   ```bash
   agent-browser skills list
   ```

3. Load the current skill for the job:

   ```bash
   agent-browser skills get core --full
   ```

   Use `core --full` for normal browser work. Select a specialized runtime skill when the task clearly matches one listed by the CLI.

   If runtime-skill discovery is unsupported or `core` is absent, use installed help and version-matched upstream documentation, and report the compatibility gap.

4. Follow the CLI-served workflow. Record commands, screenshots, videos, traces, observed errors, and known gaps in the active work item or final response.

## Runtime Skill Commands

```bash
agent-browser skills list
agent-browser skills get <name> --full
agent-browser skills get --all
agent-browser skills path [name]
```

Use `--json` when structured output helps. Treat `agent-browser skills list` as authoritative; available runtime skills change with the installed version.

## Verification

- Confirm `agent-browser --help` succeeds before relying on the workflow.
- Derive assertions from acceptance criteria and check representative visible states; a convenient selector or URL pattern may omit items the user sees.
- Verify the target behavior, final URL, and visible state in the browser, not only in source or static HTML; inspect runtime errors.
- Save and inspect reviewable evidence when a visual or running-system claim matters. A capture alone does not verify the result.
- Close only browser sessions owned by the current task and report anything that remained unverified.
