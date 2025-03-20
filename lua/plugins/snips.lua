local M = {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
}

M.config = function()
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node

  ls.setup({
    history = true, -- Allow jumping back into snippets
    update_events = "TextChanged,TextChangedI", -- Update snippets as you type

    -- Make sure LuaSnip works well with blink.cmp
    region_check_events = "CursorMoved,CursorHold,InsertEnter",
    delete_check_events = "TextChanged,InsertLeave",
  })

  -- Markdown code block snippets with multiple language support
  local code_block_langs = {
    bash = "bash",
    go = "go",
    python = "python",
    javascript = "javascript",
    typescript = "typescript",
    rust = "rust",
    lua = "lua",
    cpp = "cpp",
    json = "json",
    html = "html",
    css = "css",
  }

  local code_block_snippets = {}
  for trigger, lang in pairs(code_block_langs) do
    table.insert(
      code_block_snippets,
      s({ trig = "`" .. trigger, regTrig = false, snippetType = "autosnippet" }, {
        t({ "", "```" .. lang }),
        t({ "", "" }),
        i(1, "# your " .. lang .. " code here"),
        t({ "", "```" }),
      })
    )
  end

  ls.add_snippets("markdown", code_block_snippets)

  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/plugins/snippets/" })
end

return M
