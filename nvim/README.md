# Neovim configuration

This setup targets Neovim 0.9+ and relies on [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

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
- Navigation: `nvim-telescope/telescope.nvim`, `nvim-tree/nvim-tree.lua`, `folke/which-key.nvim`.
- Editing aids: `numToStr/Comment.nvim`, `windwp/nvim-autopairs`, `kylechui/nvim-surround`, `RRethy/vim-illuminate`, `folke/flash.nvim` for quick in-buffer jumps.
- Code intelligence: `nvim-treesitter/nvim-treesitter`, `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `mason-lspconfig`, `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `friendly-snippets`, `stevearc/aerial.nvim` for outlines.
- Git: `lewis6991/gitsigns.nvim`, `folke/trouble.nvim`, `neogitorg/neogit`.
- Messaging & UX: `rcarriga/nvim-notify` (sets `vim.notify`) with `folke/noice.nvim` to modernise command-line and LSP prompts.
- Debugging: `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, `jay-babu/mason-nvim-dap.nvim`, `theHamsta/nvim-dap-virtual-text`.
- Utilities: `akinsho/toggleterm.nvim` for floating terminals.

## Usage
1. Launch Neovim; lazy.nvim will install itself automatically.
2. Press `<leader>ff` to search files, `<leader>e` to toggle the tree, `<leader>rn` to rename symbols, and `<leader>ca` for code actions.
3. Run `:Lazy sync` after editing plugin specs to install or update plugins.
4. Update treesitter parsers with `:TSUpdate` and ensure required LSP servers are installed via `:Mason`.

## Testing & CI
1. Ensure Neovim and (optionally) `stylua` are on `PATH`.
2. Run `make nvim-test` (or `./scripts/test-nvim.sh`) to format-check Lua files and perform a headless `Lazy! sync` using the repo configuration.
3. GitHub Actions (`.github/workflows/nvim.yml`) mirrors the same script and stylua check on pushes/PRs touching the Neovim folder.

Legacy Vimscript (`_init.vim`) is kept for reference but is no longer sourced.
