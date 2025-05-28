local M = {
  "mson-org/mason-lspconfig.nvim",
  dependencies = {
    "mson-org/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "j-hui/fidget.nvim",
    "ibhagwan/fzf-lua",
    require("plugins.lsp.extras.lazydev"),
    require("plugins.lsp.extras.gopher"),
  },
}

local function setup_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  local keymaps = {
    { "K", vim.lsp.buf.hover, desc = "Hover Doc", border = "rounded" },
    { "<C-h>", vim.lsp.buf.signature_help, desc = "Signature Help", border = "rounded" },
    { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
    { "gd", require("fzf-lua").lsp_definitions, desc = "Go to Definition" },
    { "gr", require("fzf-lua").lsp_references, desc = "Go to References" },
    { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
    { "gi", require("fzf-lua").lsp_implementations, desc = "Go to Implementation" },
    { "gt", require("fzf-lua").lsp_typedefs, desc = "Go to Type Definition" },
    { "<leader>vd", vim.diagnostic.open_float, desc = "View Diagnostics" },
    { "<leader>dl", require("fzf-lua").diagnostics_document, desc = "Document Diagnostics" },
    { "<leader>dw", require("fzf-lua").diagnostics_workspace, desc = "Workspace Diagnostics" },
    { "<leader>ds", require("fzf-lua").lsp_document_symbols, desc = "Document Symbols" },
    { "<leader>ws", require("fzf-lua").lsp_workspace_symbols, desc = "Workspace Symbols" },
    { "<leader>lr", ":LspRestart<CR>", desc = "Restart LSP" },
    { "<leader>li", ":LspInfo<CR>", desc = "LSP Info" },
  }
  for _, map in ipairs(keymaps) do
    nmap(map[1], map[2], vim.tbl_extend("force", opts, { desc = map[3], border = map[4] }))
  end
end

function M.config()
  require("mason").setup({ max_concurrent_installers = 4 })
  require("fidget").setup({})

  -- Diagnostic configuration
  vim.diagnostic.config({
    virtual_text = { spacing = 2, source = "if_many" },
    float = { border = "rounded", source = "if_many" },
    severity_sort = true,
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚",
        [vim.diagnostic.severity.WARN] = "󰀪",
        [vim.diagnostic.severity.INFO] = "󰋽",
        [vim.diagnostic.severity.HINT] = "󰌶",
      },
    } or {},
  })

  -- List of servers to enable (matching files in ~/.config/nvim/lsp/)
  local servers = {
    "gopls",
    "jsonls",
    "lua_ls",
    "yamlls",
    "graphql",
    "html",
    "omnisharp",
    "svelte",
    "vtsls",
    "ccls",
    "templ",
  }

  -- Servers not supported by mason-lspconfig
  local mason_unsupported = { "ccls" }

  -- Filter supported servers for mason-lspconfig
  local mason_servers = vim.tbl_filter(function(server)
    return not vim.tbl_contains(mason_unsupported, server)
  end, servers)

  -- Tools
  local tools = {
    "prettierd",
    "shfmt",
    "stylua",
    "latexindent",
    "clang-format",
    "csharpier",
    "quick-lint-js",
  }

  -- Mason-LSPconfig setup for automatic installation
  require("mason-lspconfig").setup({
    ensure_installed = mason_servers,
    automatic_installation = true,
    automatic_enable = true,
  })

  -- Mason tool installer for tools and ccls
  require("mason-tool-installer").setup({ ensure_installed = tools })

  -- Enable LSP servers
  vim.lsp.enable(servers)

  -- LSP Attach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf

      setup_keymaps(bufnr)

      -- Inlay hints
      if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.keymap.set("n", "<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
      end

      -- Document highlights
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

return M
