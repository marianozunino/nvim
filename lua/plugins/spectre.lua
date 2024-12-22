local M = {
  "nvim-pack/nvim-spectre",
}

M.config = function()
  require("spectre").setup()

  nmap("<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre",
  })
  nmap("<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "[Spectre] Search current word",
  })
  nmap("<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "[Spectre] Search current word",
  })
  nmap("<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "[Spectre] Search on current file",
  })
end

return M
