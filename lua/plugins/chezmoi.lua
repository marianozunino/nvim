return {
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      -- This option is required.
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("chezmoi").setup({
        -- your configurations
        edit = {
          watch = true, -- Set true to automatically apply on save.
          force = true, -- Set true to force apply. Works only when watch = true.
        },
        notification = {
          on_open = true, -- vim.notify when start editing chezmoi-managed file.
          on_apply = true, -- vim.notify on apply.
        },
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function()
          -- invoke with vim.schedule() for better startup time
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })

      -- Auto-apply chezmoi changes
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        command = [[silent! !chezmoi apply --source-path "%"]],
      })
    end,
  },
}
