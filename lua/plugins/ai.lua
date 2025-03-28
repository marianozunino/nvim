local M = {
  "Exafunction/codeium.vim",
  cmd = "Codeium",
  keys = {
    { "<leader>ce", "<cmd>Codeium Toggle<cr>", desc = "Codeium Enable" },
  },
}

M.config = function()
  vim.g.codeium_disable_bindings = 1

  imap("<C-g>", function()
    return vim.fn["codeium#Accept"]()
  end, { expr = true, silent = true, desc = "[codeium] Accept completion" })

  imap("<M-;>", function()
    return vim.fn["codeium#CycleCompletions"](1)
  end, { expr = true, silent = true, desc = "[codeium] Cycle completions" })

  imap("<M-,>", function()
    return vim.fn["codeium#CycleCompletions"](-1)
  end, { expr = true, silent = true, desc = "[codeium] Cycle completions" })

  imap("<c-x>", function()
    return vim.fn["codeium#Clear"]()
  end, { expr = true, silent = true, desc = "[codeium] Clear" })
end

return M
