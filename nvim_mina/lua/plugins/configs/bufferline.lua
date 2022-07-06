local ok, bufferline = pcall(require, "bufferline")
if not ok then
  return
end

bufferline.setup {
  options = {
    indicator_icon = "",
    modified_icon = " ",
    tab_size = 20,
    offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
    separator_style = "slant",
    show_close_icon = false,
  },
  always_show_bufferline = true,
}
