local M = {
  "nvimdev/lspsaga.nvim",
}

M.config = function()
  require("lspsaga").setup({
    lightbulb = {
      enable = false,
    },
  })
  nmap("K", "<cmd>Lspsaga hover_doc<cr>")
  nmap("pd", "<cmd>Lspsaga peek_definition<cr>")
end

return M
