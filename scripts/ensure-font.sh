#!/usr/bin/env bash
set -euo pipefail

FONT_NAME="${1:-Maple Mono Normal NF CN}"
BREW_CASK="${2:-font-maple-mono-nerd-font}"
DRY_RUN="${DRY_RUN:-0}"
SKIP_BREW="${SKIP_BREW:-0}"

# Try to infer filename patterns from the font name (spaces removed, hyphenated variant).
normalize_font_name() {
  local name="$1"
  local compact="${name// /}"   # remove spaces
  printf '%s\n' "$compact"
}

font_exists() {
  local patterns=("$(normalize_font_name "$FONT_NAME")" "${FONT_NAME}" "MapleMonoNormal-NF-CN")
  local search_dirs=("$HOME/Library/Fonts" "/Library/Fonts")
  for dir in "${search_dirs[@]}"; do
    [[ -d "$dir" ]] || continue
    for pattern in "${patterns[@]}"; do
      if find "$dir" -maxdepth 1 -type f -iname "*${pattern}*" -print -quit >/dev/null 2>&1; then
        return 0
      fi
    done
  done
  return 1
}

if font_exists; then
  printf 'ensure-font: %s already available.\n' "$FONT_NAME"
  exit 0
fi

if [[ "$SKIP_BREW" != "0" ]]; then
  printf 'ensure-font: %s missing but SKIP_BREW=1. Install manually or unset SKIP_BREW.\n' "$FONT_NAME" >&2
  exit 0
fi

if [[ "$DRY_RUN" != "0" ]]; then
  printf '[dry-run] brew install --cask %s\n' "$BREW_CASK"
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  printf 'ensure-font: Homebrew is required to install %s (missing).\n' "$BREW_CASK" >&2
  exit 1
fi

printf 'ensure-font: installing font %s via %s\n' "$FONT_NAME" "$BREW_CASK"
brew install --cask "$BREW_CASK"

if font_exists; then
  printf 'ensure-font: %s installed successfully.\n' "$FONT_NAME"
else
  printf 'ensure-font: %s installation attempted but font not detected.\n' "$FONT_NAME" >&2
  exit 1
fi
