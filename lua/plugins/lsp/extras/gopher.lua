return {
  "ray-x/go.nvim",
  ft = "go",
  config = function(_, opts)
    require("go").setup(opts)
    vim.keymap.set("n", "<leader>gmt", ":GoModTidy<cr>", {
      desc = "[Go] Tidy",
    })
  end,
  build = function()
    vim.cmd([[silent! GoModTidy]])
  end,
}
