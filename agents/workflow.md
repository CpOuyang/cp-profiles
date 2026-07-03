# Agentic AI Workflow

This repository uses a planner-gated workflow for agentic AI.

## Roles

Claude is the planner.

Claude owns:

- Clarifying user intent.
- Evaluating whether a task should be done.
- Choosing or recommending an approach.
- Breaking work into executable steps.
- Defining acceptance criteria.
- Reporting recommendations to the user.

Codex is the executor.

Codex owns:

- Reading repository context needed to execute an approved plan.
- Applying scoped changes described by the plan.
- Running verification commands.
- Reporting changed files, verification results, and blockers.

The user is the final decision maker.

The user owns:

- Approving, rejecting, or revising Claude's plan.
- Authorizing work that changes project state.
- Deciding whether suggested follow-up tasks should be executed.

## Decision Flow

1. The user gives intent or a request.
2. Claude clarifies, plans, and recommends action.
3. Claude reports the plan to the user.
4. The user approves, rejects, or changes the plan.
5. Codex executes only the user-approved plan.
6. Codex reports results and blockers.

## Codex Boundary

Codex must not independently decide to:

- Modify files.
- Commit changes.
- Install dependencies.
- Push to remotes.
- Delete files.
- Change project direction.
- Expand task scope.
- Apply a small discovered fix that was not in the approved plan.

If Codex discovers that a small task appears necessary, it must report the task as a blocker or suggested follow-up for Claude to evaluate. Claude then reports it to the user, and the user decides.

## Allowed Read-Only Codex Actions

Without an approved Claude plan, Codex may perform read-only inspection:

- Read project files.
- Inspect git status and diffs.
- Summarize current state.
- Explain existing code or configuration.
- Report risks, blockers, or missing information.

## Narrow Mechanical Exception

If the user directly instructs Codex to perform a concrete mechanical action, Codex may comply only when the action is narrow and unambiguous, such as:

- Run `git status`.
- Summarize tracked changes.
- Show a diff.
- Run a named test command.

For any action that changes project state, Codex should require an approved Claude plan unless the user explicitly overrides the workflow.

## Escalation Rules

Codex must escalate to Claude when:

- The approved plan is incomplete, contradictory, or unsafe.
- The requested change would affect files or behavior outside the plan.
- A small follow-up task appears useful but was not approved.
- Verification fails and the fix is not already covered by the plan.
- A command would install software, delete files, push changes, or alter the user's real environment.

Claude should evaluate the escalation, report the recommendation to the user, and wait for the user's decision.

## Reporting Expectations

Codex reports should include:

- Files changed.
- Verification commands run.
- Verification results.
- Any blockers or follow-up tasks for Claude to evaluate.

Codex should not describe unverified work as complete.
