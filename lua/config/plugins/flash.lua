local M = {
  "folke/flash.nvim",
  opts = {
    jump = {
      autojump = true,
    },
    modes = {
      char = {
        jump_labels = true,
        multi_line = false,
      },
    },
  },
}

M.config = function()
  nmap("<leader>ff", function()
    require("flash").jump()
  end, { desc = "Flash" })
end

return M
