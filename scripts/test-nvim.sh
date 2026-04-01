#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_CACHE_ROOT="${REPO_ROOT}/.cache/nvim-test"
TEST_CONFIG_ROOT="${TEST_CACHE_ROOT}/config"

mkdir -p \
  "${TEST_CACHE_ROOT}/data" \
  "${TEST_CACHE_ROOT}/data/nvim/lazy" \
  "${TEST_CACHE_ROOT}/state" \
  "${TEST_CACHE_ROOT}/cache"

rm -rf "${TEST_CONFIG_ROOT}"
install -d "${TEST_CONFIG_ROOT}/nvim"
cp -R "${REPO_ROOT}/nvim/." "${TEST_CONFIG_ROOT}/nvim"

export XDG_CONFIG_HOME="${TEST_CONFIG_ROOT}"
export XDG_DATA_HOME="${TEST_CACHE_ROOT}/data"
export XDG_STATE_HOME="${TEST_CACHE_ROOT}/state"
export XDG_CACHE_HOME="${TEST_CACHE_ROOT}/cache"

if ! command -v nvim >/dev/null 2>&1; then
  echo "nvim-test: Neovim is not installed or not on PATH." >&2
  echo "Install Neovim 0.9+ and retry." >&2
  exit 1
fi

if [[ "${SKIP_STYLUA:-0}" != "1" ]] && command -v stylua >/dev/null 2>&1; then
  echo "==> Running stylua check"
  stylua --check "${REPO_ROOT}/nvim"
else
  echo "==> Skipping stylua check"
fi

echo "==> Running headless Lazy sync"
nvim \
  --headless \
  "+Lazy! sync" \
  "+checkhealth" \
  +qa

if [[ ! -d "${XDG_DATA_HOME}/nvim/lazy/lazy.nvim" ]]; then
  echo "nvim-test: lazy.nvim installation missing. Check network connectivity or permissions." >&2
  exit 1
fi

echo "==> Loading lazy plugins"
nvim \
  --headless \
  -c 'lua local Config = require("lazy.core.config"); local Loader = require("lazy.core.loader"); local plugins = vim.tbl_keys(Config.plugins); table.sort(plugins); Loader.load(plugins, { cmd = "nvim-test" }, { force = true }); if vim.v.errmsg ~= "" then error(vim.v.errmsg) end' \
  -c 'qa'

echo "==> Neovim configuration validated"
