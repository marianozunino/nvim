local M = {
  "mbbill/undotree",
  cmd = {
    "UndotreeToggle",
  },
}

M.config = function()
  vim.opt.undodir = vim.fn.expand("~/.config/undodir")
  nmap("<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
end

return M
