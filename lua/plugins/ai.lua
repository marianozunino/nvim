local M = {
  "monkoose/neocodeium",
  cmd = "NeoCodeium",
  keys = {
    { "<leader>ce", "<cmd>NeoCodeium toggle<cr>", desc = "Codeium Enable" },
  },
}

M.config = function()
  local neocodeium = require("neocodeium")
  local blink = require("blink.cmp")
  neocodeium.setup()

  vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuOpen",
    callback = function()
      neocodeium.clear()
    end,
  })

  neocodeium.setup({
    filter = function()
      return not blink.is_visible()
    end,
  })

  vim.g.codeium_disable_bindings = 1

  imap("<Tab>", neocodeium.accept, { expr = true, silent = true, desc = "[codeium] Accept completion" })

  imap("<M-;>", function()
    return neocodeium.cycle(1)
  end, { expr = true, silent = true, desc = "[codeium] Cycle completions" })

  imap("<M-,>", function()
    return neocodeium.cycle(-1)
  end, { expr = true, silent = true, desc = "[codeium] Cycle completions" })
end

return M
