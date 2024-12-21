local M = {
  { "lewis6991/gitsigns.nvim" },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {

    "ruifm/gitlinker.nvim",
  },
}

M.config = function()
  require("gitsigns").setup({
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    current_line_blame = true,
    signs = {
      add = { text = icons.ui.BoldLineMiddle },
      change = { text = icons.ui.BoldLineDashedMiddle },
      delete = { text = icons.ui.TriangleShortArrowRight },
      topdelete = { text = icons.ui.TriangleShortArrowRight },
      changedelete = { text = icons.ui.BoldLineMiddle },
    },
  })

  require("gitlinker").setup({
    message = false,
    console_log = false,
  })

  nmap("<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>")
  namp("<leader>gY", "<cmd>lua require('gitlinker').get_buf_range_url('n', 'blame')<cr>")
end

return M
