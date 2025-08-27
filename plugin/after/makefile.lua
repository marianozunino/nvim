vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
  pattern = { "make", "makefile", "Makefile", "*.mk" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 8
    vim.opt_local.tabstop = 8
  end,
})
