local M = {
  "laytan/cloak.nvim",
}

M.config = function()
  require("cloak").setup({
    cloak_character = "*",
    highlight_group = "Comment",
    patterns = {
      {
        file_pattern = {
          ".env*",
          "wrangler.toml",
          ".dev.vars",
        },
        cloak_pattern = "=.+",
      },
    },
  })

  nmap("<Leader>cc", ":CloakToggle<cr>")
end

return M
