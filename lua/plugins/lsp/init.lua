local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    require("plugins.lsp.extras.lazydev"),
    require("plugins.lsp.extras.gopher"),
    require("plugins.lsp.extras.typescript"),
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
  local keymaps = {
    { "<C-h>", vim.lsp.buf.signature_help, "Signature Help" },
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
local function on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_keymaps(bufnr)
end

local BORDER = "rounded"

-- Customize hover and signature help handlers
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = BORDER }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = BORDER }),
}

function M.config()
  -- Set up Mason
  require("mason").setup({
    max_concurrent_installers = 4,
  })

  -- Ensure all tools are installed
  local ensure_installed = {
    -- LSP servers
    "gopls",
    "graphql-language-service-cli",
    "html-lsp",
    "htmx-lsp",
    "json-lsp",
    "lua-language-server",
    "omnisharp",
    "vtsls",
    "yaml-language-server",

    -- Formatters
    "prettierd",
    "shfmt",
    "stylua",
    "latexindent",
    "clang-format",

    -- Additional tools
    "eslint_d",
    "templ",
  }

  -- Install missing tools
  local registry = require("mason-registry")
  for _, tool in ipairs(ensure_installed) do
    if not registry.is_installed(tool) then
      vim.cmd("MasonInstall " .. tool)
    end
  end

  -- Set up Mason LSP config
  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = {
      "gopls",
      "html",
      "htmx",
      "jsonls",
      "lua_ls",
      "omnisharp",
      "yamlls",
      "graphql",
    },
    handlers = {
      function(server_name)
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Enable folding capabilities
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }

        local base_opts = {
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
          flags = { debounce_text_changes = 150 },
        }

        -- Load server-specific configuration if it exists
        local ok, server_opts = pcall(require, "plugins.lsp.servers." .. server_name)
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
    require("lspconfig")[server].setup({
      on_attach = on_attach,
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      handlers = handlers,
      flags = { debounce_text_changes = 150 },
    })
  end
end

return M
