local status_ok, lastplace = pcall(require, "vim-lastplace")
if not status_ok then
  return
end

vim.g.lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"

lastplace.setup {}
