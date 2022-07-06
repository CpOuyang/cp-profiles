local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = { "c", "cpp", "lua", "python", "go", "json", "yaml" },
  sync_install = false,
  highlight = {
    enable = true,
  },
}
