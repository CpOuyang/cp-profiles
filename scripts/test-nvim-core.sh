#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export NVIM_TEST_CONFIG="$REPO_ROOT/nvim"
export NVIM_LOG_FILE="${NVIM_LOG_FILE:-/dev/null}"

if ! command -v nvim >/dev/null 2>&1; then
  echo "nvim-core-test: Neovim is not installed or not on PATH." >&2
  exit 1
fi

# Load the core configuration without bootstrapping lazy.nvim or downloading plugins.
nvim --headless -u NONE -i NONE \
  -c 'lua local ok, err = pcall(function() vim.opt.rtp:prepend(vim.env.NVIM_TEST_CONFIG); vim.g.mapleader = " "; vim.g.maplocalleader = ","; require("core.options"); require("core.autocmds"); require("core.keymaps") end); if not ok then vim.api.nvim_err_writeln(err); vim.cmd("cquit 1") end' \
  -c 'qa!'

echo "==> Neovim core configuration validated"
