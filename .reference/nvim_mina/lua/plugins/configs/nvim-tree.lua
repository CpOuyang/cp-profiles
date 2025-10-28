local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
    },
  },
  filters = {
    custom = {
      ".*__pycache__",
      ".*\\.pytest_cache",
      "\\.vscode",
      "\\.git",
    },
  },
  view = {
    width = 35,
  },
}
