local M = {
  "stevearc/quicker.nvim",
  -- Set plugin to load on VimEnter instead of FileType qf to ensure diagnostics are configured early
  event = { "VimEnter" },
  -- Add an explicit dependency for diagnostics loading
  dependencies = { "nvim-lspconfig" }, -- Assuming you're using nvim-lspconfig
}

-- Move sign registration outside of the config function to ensure it runs early
local function register_diagnostic_signs()
  -- Define diagnostic sign icons
  local sign_icons = {
    [vim.diagnostic.severity.ERROR] = "󰅙", -- Alternative error symbol
    [vim.diagnostic.severity.WARN] = "󱈸", -- Alternative warning
    [vim.diagnostic.severity.HINT] = "󰮱", -- Star for hints
    [vim.diagnostic.severity.INFO] = "󰋼", -- Info circle
  }

  -- Register signs explicitly
  for severity, icon in pairs(sign_icons) do
    local name = "DiagnosticSign" .. vim.diagnostic.severity[severity]
    vim.fn.sign_define(name, { text = icon, texthl = name })
  end

  -- Set sign highlights for better visibility
  vim.cmd([[
    highlight DiagnosticSignError guifg=#f7768e gui=bold
    highlight DiagnosticSignWarn guifg=#e0af68 gui=bold
    highlight DiagnosticSignInfo guifg=#7dcfff gui=bold
    highlight DiagnosticSignHint guifg=#9ece6a gui=bold
  ]])
end

-- This will now be called during setup() which happens at init
M.init = function()
  register_diagnostic_signs()
end

local function setup_diagnostic_config()
  -- Define prettier diagnostic icons
  local diagnostic_icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚", -- More prominent error symbol
    [vim.diagnostic.severity.WARN] = "󰀦", -- Warning triangle
    [vim.diagnostic.severity.HINT] = "󰌵", -- Lightbulb for hints
    [vim.diagnostic.severity.INFO] = "󰋽", -- Information symbol
  }

  -- Configure diagnostics
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      suffix = "",
      format = function(diagnostic)
        local icon = diagnostic_icons[diagnostic.severity] or ""
        return string.format("%s %s", icon, diagnostic.message)
      end,
    },
    underline = true, -- Enable underline for better visibility
    update_in_insert = false,
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅙", -- Alternative error symbol
        [vim.diagnostic.severity.WARN] = "󱈸", -- Alternative warning
        [vim.diagnostic.severity.HINT] = "󰮱", -- Star for hints
        [vim.diagnostic.severity.INFO] = "󰋼", -- Info circle
      },
    },
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
      format = function(diagnostic)
        local severity = vim.diagnostic.severity[diagnostic.severity]
        local icon = diagnostic_icons[diagnostic.severity] or ""
        return string.format("%s %s: %s", icon, severity:lower(), diagnostic.message)
      end,
    },
    severity_sort = true,
  })
end

local function cycle_qf(cmd)
  local qf_list_empty = vim.fn.getqflist({ size = 0 }).size == 0
  if qf_list_empty then
    return
  end
  local current_qf = vim.fn.getqflist({ idx = 0 }).idx
  local qf_size = vim.fn.getqflist({ size = 0 }).size
  if cmd == "next" then
    if current_qf == qf_size then
      vim.cmd("cfirst")
    else
      vim.cmd("cnext")
    end
  elseif cmd == "prev" then
    if current_qf == 1 then
      vim.cmd("clast")
    else
      vim.cmd("cprev")
    end
  end
end

function M.config()
  local opts = {
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
      E = "󰅚 ", -- Error
      W = "󰀦 ", -- Warning
      I = "󰋽 ", -- Info
      N = "󰎚 ", -- Note
      H = "󰌵 ", -- Hint
    },
  }
  require("quicker").setup(opts)
  setup_diagnostic_config()

  -- Replace the existing mappings with the cycling versions
  nmap("<a-j>", function()
    cycle_qf("next")
  end, { desc = "Next quickfix item (cycles)" })
  nmap("<a-k>", function()
    cycle_qf("prev")
  end, { desc = "Previous quickfix item (cycles)" })
end

return M
