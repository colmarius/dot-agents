# Eval scenarios

Each scenario is the user's request, sent as-is to a fresh agent in a fresh repository.

## s1 — small change

Add a PATCH /notes/:id endpoint that updates a note's title, body, or tags. Keep it consistent with the existing code, test it, and commit it.

## s2 — proposal for alignment

We're thinking about adding user accounts so each person only sees their own notes. Before anyone writes code, research the options for this API and prepare a proposal the team can review. I want to share it with them and pick it up again in a fresh session tomorrow. Commit what you produce.

## s3 — resume

Continue the work item at .agents/work/feature/notes-pagination. Commit as you go.

## s4 — finish and close

Finish and close the work item at .agents/work/feature/note-tags. You can commit.

## s5 — handoff

Write a handoff prompt so another agent thread can implement the next step of .agents/work/feature/notes-pagination on its own. Don't implement it yourself.

## s6 — quick question

Can Node's built-in test runner run just one test from test/app.test.js by name? Tell me the command.

## s7 — resume after an interrupted session

Continue the work item at .agents/work/feature/notes-pagination. Commit as you go.

## s8 — save state late

I have to stop for today. In this session we started adding PATCH /notes/:id: the store part is written but the handler, tests, and docs aren't, and Dana still has to decide whether PATCH may replace a note's tags. Save where we are so a fresh thread can finish it tomorrow. Don't push anything.

## s9 — fold in review feedback

The team reviewed the user-accounts proposal on our Notion page. Dana (eng lead) accepted the recommendation: in-house accounts with server-side bearer tokens (D1 and D2). Sam suggested dropping the idle timeout and keeping only the 8-hour absolute session lifetime (D7); Dana hasn't replied to that yet. Nobody commented on the other decisions. Update the work item and tell me what happens next. Commit it.
