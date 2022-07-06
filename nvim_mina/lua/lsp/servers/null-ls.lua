local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local M = {}
M.setup = function(on_attach)
  null_ls.setup {
    debug = false,
    on_attach = on_attach,
    sources = {
      -- general
      formatting.trim_whitespace,
      -- python
      diagnostics.pylint.with {
        extra_args = { "--disable=C0114,C0115,C0116,C0301,C0103,R0913,R0902,R0903,R0914,W0511" },
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        timeout = 10000,
      },
      formatting.black.with {
        extra_args = { "-l 120", "--skip-string-normalization" },
      },
      formatting.isort.with {
        extra_args = { "-l", "120", "--profile", "black" },
      },
      -- c, cpp, java
      formatting.astyle.with {
        extra_args = { "--style=attach", "--pad-oper", "--indent=spaces" },
      },
      -- golang
      formatting.gofmt,
      formatting.goimports,
      -- lua
      formatting.stylua,
      -- scala
      formatting.scalafmt,
    },
  }
end

return M
