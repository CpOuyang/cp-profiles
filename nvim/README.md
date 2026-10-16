# Neovim configuration

This setup targets Neovim 0.12+ and relies on [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Layout
- `init.lua` – entry point that sets leaders, loads core settings, and bootstraps plugins.
- `lua/core/` – base editor behaviour:
  - `options.lua` – global options and providers.
  - `keymaps.lua` – non-plugin key bindings.
  - `autocmds.lua` – editor automation (highlight on yank, indent tweaks, etc.).
- `lua/plugins/init.lua` – lazy.nvim bootstrap and plugin specifications.

## Module guide
- **Core** (`lua/core/`) keeps Neovim defaults declarative. Add new settings or keymaps by extending these Lua modules so they remain testable in isolation.
- **Plugin spec** (`lua/plugins/init.lua`) groups plugin declarations. Every plugin is self-contained with its `keys`, `opts`, or `config` so lazy.nvim can load it on demand.
- **Scripts** (`scripts/test-nvim.sh`) exercise the configuration headless to ensure the bootstrap path and plugin definitions stay valid.
- **Style** (`stylua.toml`) captures code-formatting preferences used locally and in CI.

## Featured plugins
- UI: `folke/tokyonight.nvim`, `nvim-lualine/lualine.nvim`, `lukas-reineke/indent-blankline.nvim`.
- Navigation: `nvim-telescope/telescope.nvim`, built-in `netrw` via `<leader>e`, `folke/which-key.nvim`.
- Editing aids: `numToStr/Comment.nvim`, `windwp/nvim-autopairs`, `kylechui/nvim-surround`, `RRethy/vim-illuminate`, `folke/flash.nvim` for quick in-buffer jumps.
- Code intelligence: Neovim's built-in Tree-sitter highlighting for available parsers, `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `mason-lspconfig`, `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `friendly-snippets`, `stevearc/aerial.nvim` for outlines.
- Git: `lewis6991/gitsigns.nvim`.
- Philosophy: keep the config focused on editing, search, and LSP. Debugging, Git porcelain UIs, message overhauls, and terminal multiplexing are intentionally left to external tools.

## Usage
1. Launch Neovim; lazy.nvim will install itself automatically.
2. Press `<leader>ff` to search files, `<leader>e` to open the built-in explorer, `<leader>rn` to rename symbols, `<leader>tn` to toggle relative line numbers, and `<leader>ca` for code actions.
3. Run `:Lazy sync` after editing plugin specs to install or update plugins.
4. Tree-sitter highlighting starts for filetypes with an available parser; this profile does not install additional parsers. Ensure required LSP servers are installed via `:Mason`.
5. Formatting now comes from language servers directly; external formatter bridges are not part of this profile.
6. Use `<leader>lq` for the location list or `<leader>ll` for the quickfix list when you want a lightweight diagnostics view.

## Testing & CI
1. Ensure Neovim and (optionally) `stylua` are on `PATH`.
2. Run `./scripts/test-nvim-core.sh` for a quick startup check without plugin downloads. Run `make nvim-test` (or `./scripts/test-nvim.sh`) to check Lua formatting and perform a full headless `Lazy! sync`.
3. GitHub Actions (`.github/workflows/nvim.yml`) and GitLab CI (`.gitlab-ci.yml`) run Stylua and the core startup check on relevant pushes and pull or merge requests. A separate plugin sync job runs on a schedule or manually.
4. For GitLab, create a pipeline schedule under **Build > Pipeline schedules** with cron `17 3 * * 1` in UTC, targeting the default branch. Use **Build > Pipelines > New pipeline** to run the plugin sync manually.

Legacy Vimscript (`_init.vim`) is kept for reference but is no longer sourced.
