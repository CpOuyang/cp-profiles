# Agent Workflow

This directory defines how agentic AI tools are used in this repository.

The project uses a strict role split:

- Claude plans the work.
- Codex executes approved plans.
- The user makes final decisions.

The root `AGENTS.md` is the short mandatory entrypoint. This directory holds the fuller workflow, implementation conventions, and future templates.

## Files

- `workflow.md`: Role boundaries, decision flow, allowed actions, and escalation rules.
- `conventions.md`: Shell and Python implementation conventions for agent execution.
