local M = {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
}

M.config = function()
  local lint = require("lint")

  lint.linters_by_ft = {
    javascript = {},
    typescript = {},
    javascriptreact = {},
    typescriptreact = {},
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  nmap("<leader>ll", function()
    lint.try_lint()
  end, { desc = "Trigger linting for current file" })
end

return M
