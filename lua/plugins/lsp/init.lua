local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    require("plugins.lsp.extras.lazydev"),
    require("plugins.lsp.extras.gopher"),
  },
}

-- Set up autocommands for document highlights
local function setup_autocommands(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Set up key mappings for LSP functionality
local function setup_keymaps(bufnr)
  local BORDER = "rounded"
  local keymaps = {
    {
      "<C-h>",
      function()
        vim.lsp.buf.signature_help({ border = BORDER })
      end,
      "Signature Help",
    },
    {
      "K",
      function()
        vim.lsp.buf.hover({ border = BORDER })
      end,
      "Hover Doc",
    },
    { "<leader>cw", vim.lsp.buf.rename, "Rename" },
    { "<leader>r", vim.lsp.buf.rename, "Rename" },
    { "vd", vim.diagnostic.open_float, "Open Diagnostics" },
    { "<leader>lr", ":LspRestart<CR>", "Restart LSP" },
    { "<leader>li", ":LspInfo<CR>", "LSP Info" },
  }

  for _, map in ipairs(keymaps) do
    nmap(map[1], map[2], {
      buffer = bufnr,
      desc = map[3],
    })
  end
end

-- Function called when LSP attaches to a buffer
function M.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_keymaps(bufnr)
end

-- Function to get common LSP configuration
function M.get_common_config()
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  -- Enable folding capabilities
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return {
    on_attach = M.on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }
end

function M.config()
  -- Set up Mason
  require("mason").setup({
    max_concurrent_installers = 4,
  })

  -- Ensure all tools are installed
  local ensure_installed = {
    -- LSP servers
    "gopls",
    "jsonls",
    "lua_ls",
    "yamlls",
    "graphql-language-service-cli",
    "html-lsp",
    "htmx-lsp",
    "json-lsp",
    "lua-language-server",
    "omnisharp",
    "yaml-language-server",
    "svelte-language-server",
    "vtsls",

    -- Formatters
    "prettierd",
    "shfmt",
    "stylua",
    "latexindent",
    "clang-format",
    "csharpier",
    "quick-lint-js",

    -- Additional tools
    "templ",
  }

  require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

  -- Set up Mason LSP config
  require("mason-lspconfig").setup({
    ensure_installed = {}, -- explicitly set to an empty table (populated via mason-tool-installer)
    automatic_installation = false,
    handlers = {
      function(server_name)
        local base_opts = M.get_common_config()

        -- Load server-specific configuration if it exists
        local ok, server_opts = pcall(require, "config.lsp." .. server_name)
        if ok then
          base_opts = vim.tbl_deep_extend("force", base_opts, server_opts)
        end

        -- Set up the LSP server with the combined options
        require("lspconfig")[server_name].setup(base_opts)
      end,
    },
  })

  -- Set up non-Mason LSP servers
  local non_mason_servers = { "ccls" }
  for _, server in ipairs(non_mason_servers) do
    require("lspconfig")[server].setup(M.get_common_config())
  end
end

return M
