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
    -- fuck this shit, 1.5Gb of RAM for this crap
    --
    -- javascript = {"eslint_d"},
    -- typescript = {"eslint_d"},
    -- javascriptreact = {"eslint_d"},
    -- typescriptreact = {"eslint_d"},
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
