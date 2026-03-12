-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("Signal", {
  pattern = "USR1",
  callback = function()
    vim.cmd("colorscheme neopywal")
    -- vim.cmd("redraw!")
  end,
  desc = "Reload neopywal on pywal change",
})
