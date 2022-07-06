vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.cmd [[
      setlocal wrap
      setlocal spell
      setlocal spelllang=en_us
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "make", "go", "proto" },
  callback = function()
    vim.cmd [[
      setlocal noexpandtab
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "javascript", "html", "json", "yaml", "helm", "lua" },
  callback = function()
    vim.cmd [[
      setlocal shiftwidth=2
      setlocal tabstop=2
    ]]
  end,
})
