return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function(_, opts)
    require("gopher").setup(opts)
    vim.keymap.set("n", "<leader>gmt", ":GoMod tidy<cr>", {
      desc = "[Go] Tidy",
    })
  end,
  build = function()
    vim.cmd([[silent! GoInstallDeps]])
  end,
}
