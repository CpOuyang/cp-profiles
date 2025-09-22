#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON_DIR="$REPO_ROOT/python"
VERSIONS_FILE="$PYTHON_DIR/versions.txt"
PROJECTS_FILE="$PYTHON_DIR/projects.txt"
CONFIG_FILE="$PYTHON_DIR/poetry.toml"

die() {
  printf 'setup-python: %s\n' "$*" >&2
  exit 1
}

ensure_command() {
  local cmd="$1" install_hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    if [[ "$DRY_RUN" != "0" ]]; then
      printf '[dry-run] missing dependency: %s (%s)\n' "$cmd" "$install_hint"
    else
      die "missing dependency: $cmd. $install_hint"
    fi
  fi
}

apply_poetry_config() {
  if [[ ! -f "$CONFIG_FILE" ]]; then
    return
  fi

  local config_dir="$HOME/.config/pypoetry"
  local dest="$config_dir/config.toml"

  if [[ "$DRY_RUN" != "0" ]]; then
    printf '[dry-run] install -d %s\n' "$config_dir"
    printf '[dry-run] merge %s into %s\n' "$CONFIG_FILE" "$dest"
    return
  fi

  mkdir -p "$config_dir"
  if [[ -f "$dest" ]]; then
    # Merge by appending our config under a distinct header comment.
    if ! grep -Fq '# cp-profiles' "$dest"; then
      printf '\n# cp-profiles defaults\n' >>"$dest"
      cat "$CONFIG_FILE" >>"$dest"
    fi
  else
    printf '# cp-profiles defaults\n' >"$dest"
    cat "$CONFIG_FILE" >>"$dest"
  fi
}

install_pyenv_versions() {
  [[ -f "$VERSIONS_FILE" ]] || return

  local versions=()
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    versions+=("$line")
    if [[ "$DRY_RUN" != "0" ]]; then
      printf '[dry-run] pyenv install -s %s\n' "$line"
    else
      pyenv install -s "$line"
    fi
  done <"$VERSIONS_FILE"

  if [[ ${#versions[@]} -gt 0 ]]; then
    local primary="${versions[0]}"
    if [[ "$DRY_RUN" != "0" ]]; then
      printf '[dry-run] pyenv global %s\n' "$primary"
    else
      pyenv global "$primary"
    fi
  fi
}

sync_poetry_projects() {
  [[ -f "$PROJECTS_FILE" ]] || return

  while IFS= read -r project; do
    [[ -z "$project" || "$project" == \#* ]] && continue
    local abs_path="$REPO_ROOT/$project"
    if [[ ! -d "$abs_path" ]]; then
      printf 'setup-python: skip missing project %s\n' "$project" >&2
      continue
    fi
    if [[ ! -f "$abs_path/pyproject.toml" ]]; then
      printf 'setup-python: skip %s (no pyproject.toml)\n' "$project" >&2
      continue
    fi
    if [[ "$DRY_RUN" != "0" ]]; then
      printf '[dry-run] (cd %s && poetry install --sync)\n' "$project"
    else
      (cd "$abs_path" && poetry install --sync)
    fi
  done <"$PROJECTS_FILE"
}

main() {
ensure_command pyenv "See https://github.com/pyenv/pyenv#installation for installation options"
ensure_command poetry "See https://python-poetry.org/docs/#installation for installation options"

  apply_poetry_config
  install_pyenv_versions
  sync_poetry_projects
}

main "$@"
