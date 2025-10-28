# iTerm2 configuration

This folder stores dynamic profiles so iTerm2 can pick up the same colour palette and font settings used elsewhere in cp-profiles.

## Files
- `DynamicProfiles/cp-profiles.json` – a dynamic profile that targets Hack Nerd Font Mono, enables a subtle badge colour, and applies a tokyonight-inspired palette.

## Usage
1. Run `make iterm2` to install the Homebrew cask (unless `SKIP_BREW=1`) and copy the dynamic profile into `~/Library/Application Support/iTerm2/DynamicProfiles/`.
2. Launch iTerm2 and enable the profile via `Profiles → Open Profiles…`.
3. (Optional) Set the profile as default so new windows use the same theme.

If iTerm2 is already open when the profile is copied, reload the profile list (`Profiles → Open Profiles…`) or restart the app to pick up the changes.
