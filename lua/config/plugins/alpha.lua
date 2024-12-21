local M = {
  "goolord/alpha-nvim",
}

M.config = function()
  local startify = require("alpha.themes.startify")

  startify.section.bottom_buttons.val = {
    startify.button("q", "Quit", "<cmd>q <CR>"), -- preserve the quit button
  }

  require("alpha").setup(startify.config)
end

return M
