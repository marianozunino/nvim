local M = {
  {
    "tpope/vim-fugitive",
    config = function()
      local git_status = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.b[bufnr].fugitive_status then
          local winnr = vim.fn.bufwinid(bufnr)
          vim.api.nvim_win_close(winnr, true)
        else
          vim.cmd("G")
        end
      end

      vim.g.fugitive_git_executable = "env GPG_TTY=$(tty) git"
      vim.env.GPG_TTY = vim.fn.system("tty"):gsub("\n", "")

      nmap("<leader>lg", ":G<cr>", { desc = "Git Status" })
      nmap("<leader>gs", git_status, { desc = "Toggle Git Status" })
      nmap("gs", git_status, { desc = "Toggle Git Status" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fugitive", "fugitiveblame", "fugitive-status" },
        callback = function()
          nmap("P", function()
            local cmd = "git push --force-with-lease"
            Snacks.notifier.notify("Pushing...", vim.log.levels.INFO)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, code)
                if code == 0 then
                  Snacks.notifier.notify("Push completed successfully", vim.log.levels.INFO)
                else
                  Snacks.notifier.notify("Push failed with exit code: " .. code, vim.log.levels.ERROR)
                end
              end,
              detach = true,
            })
          end, { buffer = true, desc = "Git Push Force With Lease (Async)" })

          nmap("<C-c>", function()
            local win_id = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win_id, false)
          end, { buffer = true, desc = "Close window" })

          -- Git Pull
          nmap("gp", function()
            local cmd = "git pull"
            Snacks.notifier.notify("Pulling...", vim.log.levels.INFO)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, code)
                if code == 0 then
                  Snacks.notifier.notify("Pull completed successfully", vim.log.levels.INFO)
                else
                  Snacks.notifier.notify("Pull failed with exit code: " .. code, vim.log.levels.ERROR)
                end
              end,
              detach = true,
            })
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
