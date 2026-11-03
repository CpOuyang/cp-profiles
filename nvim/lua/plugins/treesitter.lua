return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = vim.fn.executable("tree-sitter") == 1 and ":TSUpdate" or nil,
    config = function()
      if vim.fn.executable("tree-sitter") == 1 then
        require("nvim-treesitter").install({
          "python",
          "javascript",
          "typescript",
          "tsx",
          "go",
          "json",
          "yaml",
          "bash",
          "toml",
          "html",
          "css",
        })
      end
    end,
  },
}
