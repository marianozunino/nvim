local M = {
  "Exafunction/windsurf.vim",
}

M.config = function()
  vim.g.codeium_disable_bindings = 1
  vim.g.codeium_enabled = 0

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

  nmap("<leader>ce", function()
    vim.cmd("Codeium Toggle")
    Snacks.notifier.notify("Codeium " .. (vim.g.codeium_enabled == 1 and "enabled" or "disabled"))
  end, { expr = true, silent = true, desc = "[codeium] Toggle" })
end

return M
