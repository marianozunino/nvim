local M = {
  "mbbill/undotree",
  cmd = {
    "UndotreeToggle",
  },
}

M.config = function()
  vim.opt.undodir = vim.fn.expand("~/.config/undodir")
end

return M
