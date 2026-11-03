return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
          section_separators = "",
          component_separators = "",
        },
        tabline = {
          lualine_a = {
            {
              "buffers",
              show_filename_only = false,
              show_modified_status = true,
              mode = 0,
              max_length = function()
                return vim.o.columns
              end,
              buffers_color = {
                active = { fg = "#1b1d2b", bg = "#82aaff", gui = "bold" },
                inactive = { fg = "#828bb8", bg = "#1e2030" },
              },
              symbols = {
                modified = " +",
                alternate_file = "",
                directory = "[dir]",
              },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "|" },
      scope = { enabled = false },
    },
  },
}
