return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Flash remote",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash search",
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle outline" },
    },
    opts = {
      attach_mode = "global",
      layout = { max_width = { 40, 0.25 } },
      show_guides = true,
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        providers = { "regex" },
        filetypes_denylist = {
          "dirbuf",
          "dirvish",
          "fugitive",
          "netrw",
          "TelescopePrompt",
        },
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },
}
