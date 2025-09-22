#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
SKIP_BREW="${SKIP_BREW:-0}"
BREW_INSTALLER_URL='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

BREW_FORMULA_LIST=(
  starship
  fzf
  ripgrep
)
BREW_CASK_LIST=()

if [[ ${BREW_FORMULAS+x} ]]; then
  brew_formulas_input="${BREW_FORMULAS:-}"
  BREW_FORMULA_LIST=()
  if [[ -n "${brew_formulas_input}" ]]; then
    IFS=' ' read -r -a BREW_FORMULA_LIST <<<"${brew_formulas_input}" || true
  fi
fi

if [[ ${BREW_CASKS+x} ]]; then
  brew_casks_input="${BREW_CASKS:-}"
  BREW_CASK_LIST=()
  if [[ -n "${brew_casks_input}" ]]; then
    IFS=' ' read -r -a BREW_CASK_LIST <<<"${brew_casks_input}" || true
  fi
fi

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

run_or_echo() {
  if [[ "$DRY_RUN" != "0" ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

install_homebrew() {
  if ! is_macos; then
    printf 'setup-homebrew: automatic Homebrew installation only supported on macOS.\n' >&2
    return 1
  fi

  printf 'setup-homebrew: installing Homebrew...\n'
  if [[ "$DRY_RUN" != "0" ]]; then
    printf '[dry-run] /bin/bash -c "$(curl -fsSL %s)"\n' "$BREW_INSTALLER_URL"
    return 0
  fi

  /bin/bash -c "$(curl -fsSL "$BREW_INSTALLER_URL")"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    printf 'setup-homebrew: Homebrew installation completed but brew was not found on PATH.\n' >&2
    return 1
  fi
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi
  install_homebrew
}

ensure_packages() {
  if [[ ${#BREW_FORMULA_LIST[@]} -gt 0 ]]; then
    for pkg in "${BREW_FORMULA_LIST[@]}"; do
      [[ -z "$pkg" ]] && continue
      if brew list --formula "$pkg" >/dev/null 2>&1; then
        continue
      fi
      printf 'setup-homebrew: installing formula %s\n' "$pkg"
      run_or_echo brew install "$pkg"
    done
  fi

  if [[ ${#BREW_CASK_LIST[@]} -gt 0 ]]; then
    for cask in "${BREW_CASK_LIST[@]}"; do
      [[ -z "$cask" ]] && continue
      if brew list --cask "$cask" >/dev/null 2>&1; then
        continue
      fi
      printf 'setup-homebrew: installing cask %s\n' "$cask"
      run_or_echo brew install --cask "$cask"
    done
  fi
}

print_dry_run_plan() {
  if command -v brew >/dev/null 2>&1; then
    if [[ ${#BREW_FORMULA_LIST[@]} -gt 0 ]]; then
      for pkg in "${BREW_FORMULA_LIST[@]}"; do
        [[ -z "$pkg" ]] && continue
        printf '[dry-run] brew list --formula %s >/dev/null\n' "$pkg"
        printf '[dry-run] brew install %s\n' "$pkg"
      done
    fi
    if [[ ${#BREW_CASK_LIST[@]} -gt 0 ]]; then
      for cask in "${BREW_CASK_LIST[@]}"; do
        [[ -z "$cask" ]] && continue
        printf '[dry-run] brew list --cask %s >/dev/null\n' "$cask"
        printf '[dry-run] brew install --cask %s\n' "$cask"
      done
    fi
  else
    printf '[dry-run] /bin/bash -c "$(curl -fsSL %s)"\n' "$BREW_INSTALLER_URL"
    if [[ ${#BREW_FORMULA_LIST[@]} -gt 0 ]]; then
      for pkg in "${BREW_FORMULA_LIST[@]}"; do
        [[ -z "$pkg" ]] && continue
        printf '[dry-run] brew install %s\n' "$pkg"
      done
    fi
    if [[ ${#BREW_CASK_LIST[@]} -gt 0 ]]; then
      for cask in "${BREW_CASK_LIST[@]}"; do
        [[ -z "$cask" ]] && continue
        printf '[dry-run] brew install --cask %s\n' "$cask"
      done
    fi
  fi
}

main() {
  if [[ "$SKIP_BREW" != "0" ]]; then
    if [[ "$DRY_RUN" != "0" ]]; then
      printf '[dry-run] SKIP_BREW=1 so brew steps are omitted\n'
    fi
    return 0
  fi

  if ! is_macos; then
    if [[ "$DRY_RUN" != "0" ]]; then
      printf '[dry-run] non-macOS detected; skipping Homebrew steps (set SKIP_BREW=0 to override)\n'
    else
      printf 'setup-homebrew: non-macOS detected, skipping Homebrew steps. Install packages manually or run with SKIP_BREW=0 if you have Linuxbrew.\n'
    fi
    return 0
  fi

  if [[ "$DRY_RUN" != "0" ]]; then
    print_dry_run_plan
    return 0
  fi

  ensure_homebrew
  ensure_packages
}

main "$@"
