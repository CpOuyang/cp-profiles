local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded",
  },
}

return packer.startup(function(use)
  -- packer
  use "wbthomason/packer.nvim"

  -- general
  use "sheerun/vim-polyglot"
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "plugins.configs.nvim-treesitter"
    end,
  }
  use {
    "farmergreg/vim-lastplace",
    config = function()
      require "plugins.configs.vim-lastplace"
    end,
  }

  -- navigation
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require "plugins.configs.telescope"
    end,
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require "plugins.configs.nvim-tree"
    end,
  }
  use { "jremmen/vim-ripgrep" }
  use {
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    config = function()
      require "plugins.configs.bufferline"
    end,
  }

  -- ui
  use "rmehri01/onenord.nvim"
  use {
    "catppuccin/nvim",
    as = "catppuccin",
  }
  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require "plugins.configs.lualine"
    end,
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "plugins.configs.indent-blankline"
    end,
  }

  -- lsp
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  use "ray-x/lsp_signature.nvim"
  use "jose-elias-alvarez/null-ls.nvim"
  use "folke/lua-dev.nvim"
  use {
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
  }
  use {
    "danymat/neogen",
    config = function()
      require "plugins.configs.neogen"
    end,
  }

  -- cmp
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "plugins.configs.cmp"
    end,
  }
  use { "tzachar/cmp-tabnine", run = "./install.sh" }

  -- edit
  use {
    "phaazon/hop.nvim",
    branch = "v1",
    config = function()
      require("hop").setup {}
    end,
  }
  use "scrooloose/nerdcommenter"
  use "terryma/vim-multiple-cursors"
  use {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require "plugins.configs.clip"
    end,
  }

  -- terminal
  use {
    "akinsho/toggleterm.nvim",
    tag = "v1.*",
    config = function()
      require "plugins.configs.toggleterm"
    end,
  }

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
