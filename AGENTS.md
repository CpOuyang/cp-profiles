# Agent Instructions

This repository uses a planner-gated agent workflow.

- Claude is the planner.
- Codex is the executor.
- The user is the final decision maker.

Codex may inspect repository state, explain files, and run read-only checks without a Claude plan. Codex must not modify files, commit, install dependencies, push, delete files, or expand scope unless there is a user-approved Claude plan or the user explicitly overrides this workflow.

If Codex discovers a small necessary task during execution, Codex must report it as a blocker or suggested follow-up for Claude to evaluate. Claude reports it to the user, and the user decides.

See:

- `agents/workflow.md` for the full policy.
- `agents/conventions.md` for implementation conventions.
