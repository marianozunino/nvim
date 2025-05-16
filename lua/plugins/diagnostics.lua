local M = {
  "stevearc/quicker.nvim",
  event = "VimEnter",
  dependencies = { "neovim/nvim-lspconfig" },
}

M.init = function()
  for severity, icon in pairs({
    [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
    [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
    [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
    [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
  }) do
    local name = "DiagnosticSign" .. vim.diagnostic.severity[severity]
    vim.fn.sign_define(name, { text = icon, texthl = name })
  end

  vim.cmd([[
    highlight DiagnosticSignError guifg=#f7768e gui=bold
    highlight DiagnosticSignWarn guifg=#e0af68 gui=bold
    highlight DiagnosticSignInfo guifg=#7dcfff gui=bold
    highlight DiagnosticSignHint guifg=#9ece6a gui=bold
  ]])
end

-- Cycle through quickfix items
local function cycle_qf(cmd)
  local qf = vim.fn.getqflist({ size = 0, idx = 0 })
  if qf.size == 0 then
    return
  end
  if cmd == "next" then
    vim.cmd(qf.idx == qf.size and "cfirst" or "cnext")
  elseif cmd == "prev" then
    vim.cmd(qf.idx == 1 and "clast" or "cprev")
  end
end

function M.config()
  -- Diagnostic configuration using _G.icons.diagnostics
  -- local icons = _G.icons.diagnostics
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      format = function(d)
        return string.format("%s %s", icons[vim.diagnostic.severity[d.severity]], d.message)
      end,
    },
    underline = true,
    update_in_insert = false,
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      },
    },
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
      format = function(d)
        return string.format(
          "%s %s: %s",
          icons[vim.diagnostic.severity[d.severity]],
          vim.diagnostic.severity[d.severity]:lower(),
          d.message
        )
      end,
    },
    severity_sort = true,
  })

  -- Quicker setup
  require("quicker").setup({
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
    type_icons = {
      E = icons.diagnostics.Error .. " ",
      W = icons.diagnostics.Warning .. " ",
      I = icons.diagnostics.Information .. " ",
      N = icons.ui.Note .. " ",
      H = icons.diagnostics.Hint .. " ",
    },
  })

  -- Quickfix navigation mappings
  vim.keymap.set("n", "<a-j>", function()
    cycle_qf("next")
  end, { desc = "Next quickfix item (cycles)" })
  vim.keymap.set("n", "<a-k>", function()
    cycle_qf("prev")
  end, { desc = "Previous quickfix item (cycles)" })
end

return M
