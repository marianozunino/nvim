local M = {
  "SmiteshP/nvim-navic",
}

M.config = function()
  require("nvim-navic").setup({
    icons = icons.kind,
    highlight = true,
    lsp = {
      auto_attach = true,
    },
    click = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  })
end

return M
