local M = {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.g.fugitive_git_executable = "env GPG_TTY=$(tty) git"
      vim.env.GPG_TTY = vim.fn.system("tty"):gsub("\n", "")

      nmap("<leader>lg", ":G<cr>", { desc = "Git Status" })

      nmap("<leader>gs", function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.b[bufnr].fugitive_status then
          local winnr = vim.fn.bufwinid(bufnr)
          vim.api.nvim_win_close(winnr, true)
        else
          vim.cmd("G")
        end
      end, { desc = "Toggle Git Status" })

      -- override the push command to use the --fore-with-lease
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fugitive", "fugitiveblame", "fugitive-status" },
        callback = function()
          nmap("P", ":G push --force-with-lease<CR>", { buffer = true, desc = "Git Push Force With Lease" })
          nmap("<C-c>", function()
            local win_id = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win_id, false)
          end, { buffer = true, desc = "Close window" })
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
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
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitlinker").setup({
        message = false,
        console_log = false,
      })

      nmap("<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>")
    end,
  },
}

return M
