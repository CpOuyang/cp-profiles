# Neovim configuration

This setup targets Neovim 0.9+ and relies on [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Layout
- `init.lua` – entry point that sets leaders, loads core settings, and bootstraps plugins.
- `lua/core/` – base editor behaviour:
  - `options.lua` – global options and providers.
  - `keymaps.lua` – non-plugin key bindings.
  - `autocmds.lua` – editor automation (highlight on yank, indent tweaks, etc.).
- `lua/plugins/init.lua` – lazy.nvim bootstrap and plugin specifications.

## Featured plugins
- UI: `folke/tokyonight.nvim`, `nvim-lualine/lualine.nvim`, `lukas-reineke/indent-blankline.nvim`.
- Navigation: `nvim-telescope/telescope.nvim`, `nvim-tree/nvim-tree.lua`, `folke/which-key.nvim`.
- Editing aids: `numToStr/Comment.nvim`, `windwp/nvim-autopairs`, `kylechui/nvim-surround`, `RRethy/vim-illuminate`.
- Code intelligence: `nvim-treesitter/nvim-treesitter`, `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `mason-lspconfig`, `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `friendly-snippets`.
- Git: `lewis6991/gitsigns.nvim`, `folke/trouble.nvim`.
- Utilities: `akinsho/toggleterm.nvim` for floating terminals.

## Usage
1. Launch Neovim; lazy.nvim will install itself automatically.
2. Press `<leader>ff` to search files, `<leader>e` to toggle the tree, `<leader>rn` to rename symbols, and `<leader>ca` for code actions.
3. Run `:Lazy sync` after editing plugin specs to install or update plugins.
4. Update treesitter parsers with `:TSUpdate` and ensure required LSP servers are installed via `:Mason`.

Legacy Vimscript (`_init.vim`) is kept for reference but is no longer sourced.
