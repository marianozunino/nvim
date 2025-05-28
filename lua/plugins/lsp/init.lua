local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "j-hui/fidget.nvim", opts = {} },
    "ibhagwan/fzf-lua",

    require("plugins.lsp.extras.lazydev"),
    require("plugins.lsp.extras.gopher"),
  },
}

-- Key mappings for LSP
local function setup_keymaps(bufnr)
  local BORDER = "rounded"
  local keymaps = {
    { "<C-h>", vim.lsp.buf.signature_help, "Signature Help", border = BORDER },
    { "K", vim.lsp.buf.hover, "Hover Doc", border = BORDER },
    { "<leader>cw", vim.lsp.buf.rename, "Rename" },
    { "<leader>r", vim.lsp.buf.rename, "Rename" },
    { "vd", vim.diagnostic.open_float, "Open Diagnostics" },
    { "<leader>lr", ":LspRestart<CR>", "Restart LSP" },
    { "<leader>li", ":LspInfo<CR>", "LSP Info" },
    { "gd", require("fzf-lua").lsp_definitions, "Go to Definition" },
    { "gr", require("fzf-lua").lsp_references, "Go to References" },
    { "gD", vim.lsp.buf.declaration, "Go to Declaration" },
    { "gi", require("fzf-lua").lsp_implementations, "Go to Implementation" },
    { "gt", require("fzf-lua").lsp_typedefs, "Go to Type Definition" },
    { "<leader>ca", vim.lsp.buf.code_action, "Code Action" },
    { "<leader>dl", require("fzf-lua").diagnostics_document, "Document Diagnostics" },
    { "<leader>dw", require("fzf-lua").diagnostics_workspace, "Workspace Diagnostics" },
    { "<leader>ds", require("fzf-lua").lsp_document_symbols, "Document Symbols" },
    { "<leader>ws", require("fzf-lua").lsp_workspace_symbols, "Workspace Symbols" },
  }

  for _, map in ipairs(keymaps) do
    vim.keymap.set("n", map[1], function()
      map[2](map[4] and { border = map[4] } or nil)
    end, { buffer = bufnr, desc = map[3] })
  end
end

function M.config()
  -- Mason setup
  require("mason").setup({ max_concurrent_installers = 4 })

  -- Diagnostic configuration
  vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      },
    } or {},
    virtual_text = {
      source = "if_many",
      spacing = 2,
      format = function(diagnostic)
        return diagnostic.message
      end,
    },
  })

  -- Servers and tools
  local servers = {
    "gopls",
    "jsonls",
    "lua_ls",
    "yamlls",
    "graphql",
    "html",
    "jsonls",
    "omnisharp",
    "svelte",
    "vtsls",
    "ccls",
    "templ",
  }

  local ensure_installed = vim.tbl_filter(function(s)
    return s ~= "ccls"
  end, servers)

  vim.list_extend(ensure_installed, {
    "prettierd",
    "shfmt",
    "stylua",
    "latexindent",
    "clang-format",
    "csharpier",
    "quick-lint-js",
  })

  require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

  -- Document highlight autocommands
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

  -- LspAttach autocommand
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local bufnr = event.buf
      setup_keymaps(bufnr)
      setup_autocommands(client, bufnr)

      -- Inlay hints toggle
      if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, { bufnr = bufnr }) then
        vim.keymap.set("n", "<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
      end
    end,
  })

  -- Base LSP configuration
  local base_config = {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    flags = { debounce_text_changes = 150 },
  }

  -- Setup LSP servers
  require("mason-lspconfig").setup({ ensure_installed = {}, automatic_installation = true, automatic_enable = false })
  for _, server in ipairs(servers) do
    local config = vim.deepcopy(base_config)
    local ok, server_opts = pcall(require, "config.lsp." .. server)
    if ok then
      config = vim.tbl_deep_extend("force", config, server_opts)
    end
    require("lspconfig")[server].setup(config)
  end
end

return M
