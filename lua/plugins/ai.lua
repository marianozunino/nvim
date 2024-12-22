local M = {
  "Exafunction/codeium.vim",
  cmd = "CodeiumEnable",
  keys = {
    { "<leader>ce", "<cmd>CodeiumEnable<cr>", desc = "Codeium Enable" },
  },
}

M.config = function()
  vim.g.codeium_disable_bindings = 1

  imap("<Tab>", function()
    return vim.fn["codeium#Accept"]()
  end, { expr = true, silent = true, desc = "[codeium] Accept completion" })

  imap("<M-;>", function()
    return vim.fn["codeium#CycleCompletions"](1)
  end, { expr = true, silent = true, desc = "[codeium] Cycle completions" })

  imap("<M-,>", function()
    return vim.fn["codeium#CycleCompletions"](-1)
  end, { expr = true, silent = true, desc = "[codeium] Cycle completions" })
end

return M
