local M = {
  "ibhagwan/fzf-lua",
}

M.config = function()
  local fzf_lua = require("fzf-lua")

  -- Basic fzf-lua setup
  fzf_lua.setup({
    layout = "fzf-vim",
    keymap = {
      fzf = {
        ["CTRL-Q"] = "select-all+accept",
      },
    },
    grep = {
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
      },
    },
  })

  nmap("gd", function()
    fzf_lua.lsp_definitions({ jump1 = true })
  end, { desc = "Goto Definition" })
  nmap("gr", function()
    fzf_lua.lsp_references({ ignore_current_line = true })
  end, { desc = "Goto References" })
  nmap("gi", function()
    fzf_lua.lsp_implementations({ jump1 = true })
  end, { desc = "Goto Implementation" })
  nmap("<leader>D", fzf_lua.lsp_typedefs, { desc = "Type Definition" })
  nmap("<leader>ca", fzf_lua.lsp_code_actions, { desc = "Code Action" })
  nmap("<leader>ds", fzf_lua.lsp_document_symbols, { desc = "Document Symbols" })
  nmap("<leader>ws", fzf_lua.lsp_workspace_symbols, { desc = "Workspace Symbols" })
  nmap("<leader>ic", fzf_lua.lsp_incoming_calls, { desc = "Incoming Calls" })
  nmap("<leader>oc", fzf_lua.lsp_outgoing_calls, { desc = "Outgoing Calls" })
  nmap("<leader>gf", fzf_lua.live_grep, { desc = "Find Live Grep" })

  local exclusions = {
    "node_modules",
    ".git",
    "dist",
    "build",
    "coverage",
    "public",
  }

  local exclude_opts = ""
  for _, item in ipairs(exclusions) do
    exclude_opts = exclude_opts .. " --exclude " .. item
  end

  nmap("<leader>/", function()
    fzf_lua.files({
      cwd_prompt = false,
      silent = true,
      fd_opts = "--hidden --no-ignore --type f" .. exclude_opts,
    })
  end, { desc = "Find Files" })
  nmap(";", fzf_lua.buffers, { desc = "Find Buffers" })
  nmap("sb", fzf_lua.grep_curbuf, { desc = "Search Current Buffer" })
  nmap("gw", fzf_lua.grep_cword, { desc = "Search word under cursor" })
  nmap("gW", fzf_lua.grep_cWORD, { desc = "Search WORD under cursor" })
  nmap("sk", fzf_lua.keymaps, { desc = "Search Keymaps" })
  nmap("sh", fzf_lua.help_tags, { desc = "Search help" })

  -- Automatic sizing of height/width of vim.ui.select
  fzf_lua.register_ui_select(function(_, items)
    local min_h, max_h = 0.60, 0.80
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.80, row = 0.40 } }
  end)
end

return M
