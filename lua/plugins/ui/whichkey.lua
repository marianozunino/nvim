local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}

M.config = function()
  require("which-key").setup({
    win = {
      border = "single",
    },
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = false,
      },
    },
  })
end

return M
