local M = {
  "goolord/alpha-nvim",
}

M.config = function()
  local startify = require("alpha.themes.startify")

  startify.section.top_buttons.val = {
    startify.button("e", "New file", "<cmd>ene <CR>"),
    startify.button("q", "Quit", "<cmd>q <CR>"),
  }
  startify.section.bottom_buttons.val = {}

  require("alpha").setup(startify.config)
end

return M
