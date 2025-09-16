# CP Profiles

Personal configuration profiles for my terminal and development environment on macOS. The repository centralises dotfiles and tool settings so a new machine can be bootstrapped quickly and kept in sync.

## Goals
- Track tmux, Neovim, shell, VS Code, pyenv, and terminal emulator preferences in one place
- Keep platform-specific tweaks alongside shared defaults while avoiding sensitive data
- Automate syncing to `$HOME` with simple helper targets

## Layout
- `shell/bash_profile` – Bash login shell setup with local override support
- `shell/zshrc` – Zsh configuration mirroring the Bash behaviour
- `shell/config.fish` – Fish shell configuration with equivalent environment setup
- `terminal/alacritty/` – Alacritty terminal profile ready to sync to `~/.config/alacritty/`
- `terminal/kitty/` – Kitty terminal profile ready to sync to `~/.config/kitty/`
- `nvim/` – standalone Neovim configuration split into Lua modules plus helper script
- `.reference/` – archived or third-party configuration examples kept for reference
- `starship.toml` – Starship prompt configuration
- `Makefile` – small task runner for syncing selected configs to the home directory
- `scripts/` – helper scripts for bootstrap tasks (e.g. ensuring local Bash overrides)

## Planned additions
- `tmux/` for status line, key bindings, and plugins
- `vscode/` for editor settings, keymaps, and snippets
- `pyenv/` for preferred Python versions and plugin defaults
- `nodejs/` for version management (e.g. asdf, fnm) and global toolchain setup scripts

## Usage
1. Review the files and adjust any machine-specific values.
2. Run `make help` to see available sync commands.
3. Use `make shell bash`, `make shell zsh`, or `make shell fish` to copy the desired shell profile into place (Bash runs `~/.bash_profile.local` initialisation automatically).
4. Use `make terminal alacritty`, `make terminal kitty`, and `make starship` to install terminal emulator configs and the prompt theme.
5. Prefix commands with `DRY_RUN=1` (e.g. `DRY_RUN=1 make shell bash`) to preview actions without touching the filesystem; Makefile prints `[dry-run]` before each simulated command so you know nothing was changed.

## Notes
- These dotfiles target macOS; other operating systems are out of scope for now.
- Machine-specific exports or secrets should live in `~/.bash_profile.local`; running `make shell bash` will (re)create the stub if missing.
- Secrets or machine-specific overrides should live in files ignored by Git (e.g. `*.local` or `.env` variants).
- Each configuration is intended to be idempotent—rerunning the sync targets should leave the system in a consistent state.
- Keep the `.reference/` directory for experiments only; production-ready files should move into the main structure above.
