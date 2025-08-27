local M = {
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })

      local function pre_hook(ctx)
        local U = require("Comment.utils")

        -- Check filetype
        local ft = vim.bo.filetype
        if ft == "c" or ft == "cpp" then
          if ctx.ctype == U.ctype.linewise then
            return "// %s"
          elseif ctx.ctype == U.ctype.blockwise then
            return "/* %s */"
          end
        end

        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
      end

      require("Comment").setup({
        pre_hook = pre_hook,
        opleader = {
          line = "gc",
          block = "gC",
        },
        mappings = {
          basic = true,
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup({
        keywords = {
          BAD = { icon = "󰇷 ", color = "error" },
          FUCK = { icon = "󰇷 ", color = "error" },
          SHITTY = { icon = "󰇷 ", color = "error" },
        },
      })
    end,
  },
}

return M
