local status_ok, metals = pcall(require, "metals")
if not status_ok then
  return
end

vim.opt_global.shortmess:remove("F"):append "c"

local M = {}

M.setup = function(on_attach, capabilities)
  local metals_config = metals.bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  }
  metals_config.on_attach = on_attach
  metals_config.capabilities = capabilities

  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
      metals.initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
end

return M
