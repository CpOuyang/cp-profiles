# Neovim configuration

This setup targets Neovim 0.12+ and relies on [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Layout
- `init.lua` – entry point that sets leaders and loads core settings and lazy.nvim.
- `lua/core/` – base editor behaviour:
  - `options.lua` – global options and providers.
  - `keymaps.lua` – non-plugin key bindings.
  - `autocmds.lua` – editor automation (highlight on yank, indent tweaks, etc.).
- `lua/config/lazy.lua` – lazy.nvim bootstrap and setup.
- `lua/plugins/` – plugin specifications grouped by UI, editing, search, Git, LSP, completion, and Tree-sitter.

## Module guide
- **Core** (`lua/core/`) keeps Neovim defaults declarative. Add new settings or keymaps by extending these Lua modules so they remain testable in isolation.
- **Plugin specs** (`lua/plugins/`) keep each plugin self-contained with its `keys`, `opts`, or `config`.
- **Scripts** (`scripts/test-nvim.sh`) exercise the configuration headless to ensure the bootstrap path and plugin definitions stay valid.
- **Style** (`stylua.toml`) captures code-formatting preferences used locally and in CI.

## Featured plugins
- UI: `folke/tokyonight.nvim`, `nvim-lualine/lualine.nvim`, `lukas-reineke/indent-blankline.nvim`.
- Navigation: `nvim-telescope/telescope.nvim`, built-in `netrw` via `<leader>e`, `folke/which-key.nvim`.
- Editing aids: built-in `gc`/`gcc` commenting, `windwp/nvim-autopairs`, `kylechui/nvim-surround`, `RRethy/vim-illuminate`, `folke/flash.nvim` for quick in-buffer jumps.
- Code intelligence: `nvim-treesitter/nvim-treesitter` parsers with Neovim's built-in highlighting, `neovim/nvim-lspconfig`, `mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim`, `saghen/blink.cmp`, `friendly-snippets` with `vim.snippet`, and `stevearc/aerial.nvim` for outlines.
- Git: `lewis6991/gitsigns.nvim`.
- Philosophy: keep the config focused on editing, search, and LSP. Debugging, Git porcelain UIs, message overhauls, and terminal multiplexing are intentionally left to external tools.

## Usage
1. Launch Neovim; lazy.nvim will install itself automatically.
2. Press `<leader>ff` to search files, `<leader>e` to open the built-in explorer, `<leader>rn` to rename symbols, `<leader>tn` to toggle relative line numbers, and `<leader>ca` for code actions.
3. Run `:Lazy sync` after editing plugin specs to install or update plugins.
4. Use `[b` and `]b` to move between buffers; `<leader>bn` and `<leader>bp` also remain available.
5. Tree-sitter installs parsers for Python, JavaScript, TypeScript, TSX, Go, JSON, YAML, Bash, TOML, HTML, and CSS when the `tree-sitter` CLI is available. Parser installation requires the `tree-sitter` CLI, a C compiler, `tar`, and `curl`. Highlighting starts when a parser is available. Ensure required LSP servers are installed via `:Mason`.
6. Formatting comes from language servers via `<leader>lf`; Ruff provides Python formatting.
7. Use `<leader>lq` for the location list or `<leader>ll` for the quickfix list when you want a lightweight diagnostics view.
8. Use `Ctrl-h/j/k/l` to move between windows, including the explorer. With the explorer on the left, `Ctrl-h` focuses it and `Ctrl-l` returns to the file window.

## Testing & CI
1. Ensure Neovim and (optionally) `stylua` are on `PATH`.
2. Run `./scripts/test-nvim-core.sh` to check startup and explorer window navigation without plugin downloads. Run `make nvim-test` (or `./scripts/test-nvim.sh`) to check Lua formatting and perform a full headless `Lazy! sync`.
3. GitHub Actions (`.github/workflows/nvim.yml`) and GitLab CI (`.gitlab-ci.yml`) run Stylua and the core startup check on relevant pushes and pull or merge requests. A separate plugin sync job runs on a schedule or manually.
4. For GitLab, create a pipeline schedule under **Build > Pipeline schedules** with cron `17 3 * * 1` in UTC, targeting the default branch. Use **Build > Pipelines > New pipeline** to run the plugin sync manually.
