# Ghostty configuration

`config.ghostty` sets only the base font (Maple Mono Normal NF CN 13, matching kitty). Everything else, including the colour theme, uses Ghostty's built-in defaults.

## Files
- `config.ghostty` – base font settings.

## Usage
1. Run `make ghostty` to install the Homebrew cask (unless `SKIP_BREW=1`), ensure the font is installed, and copy this folder to `~/.config/ghostty/`.
2. The target runs `ghostty +validate-config` on the deployed file; an `unknown field` error means a typo in a key.
3. Reload a running Ghostty with `Cmd+Shift+,` (some options only apply to new windows or after a restart).

## Notes
- On macOS Ghostty also reads `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`, loaded **after** `~/.config/ghostty/`, so any active setting there overrides this config. `make ghostty` warns when that file contains non-comment lines but never modifies it.
- To add options, see `ghostty +show-config --default --docs` and set only what you need; do not paste the full default output.
- To try a theme later, list them with `ghostty +list-themes` and add `theme = <name>`.
