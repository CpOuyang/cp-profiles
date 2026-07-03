# Agent Coding Conventions

These conventions are personal preferences for agent execution. Target project rules still win.

Only record non-default preferences here. Do not add behavior that competent coding agents already perform by default.

## Python

- Avoid `from __future__ import annotations` unless the target project already uses it or explicitly requires it.

## Shell

- Prefer Bash for repository automation scripts.
- New Bash scripts should use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Setup/scaffold commands should support `DRY_RUN=1` when practical.
