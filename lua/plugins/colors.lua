local M = {
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme nightfox")
      vim.api.nvim_set_hl(0, "Visual", { bg = "#1f4b6d", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#1f4b6d", fg = "#ffffff" })
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = false,
    priority = 1000,
    opts = {
      variant = "auto",
      dark_variant = "main",
      groups = {
        border = "muted",
        panel = "surface",
        error = "love",
        hint = "iris",
        info = "foam",
      },
    },
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
}

return M
