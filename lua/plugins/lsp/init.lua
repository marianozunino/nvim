local M = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "mason-org/mason.nvim",
    "j-hui/fidget.nvim",
    "ibhagwan/fzf-lua",
    require("plugins.lsp.extras.lazydev"),
    require("plugins.lsp.extras.gopher"),
  },
}

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

local tools = {
  "prettierd",
  "shfmt",
  "stylua",
  "latexindent",
  "clang-format",
  "csharpier",
  "quick-lint-js",
}

local function setup_keymaps(bufnr)
  local fzf = require("fzf-lua")
  local opts = { buffer = bufnr }

  -- Basic LSP
  nmap("K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Doc" }))
  nmap("<C-h>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
  nmap("<leader>r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
  nmap("<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))

  -- Navigation
  nmap("gd", fzf.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
  nmap("gr", fzf.lsp_references, vim.tbl_extend("force", opts, { desc = "Go to References" }))
  nmap("gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
  nmap("gi", fzf.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
  nmap("gt", fzf.lsp_typedefs, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))

  -- Diagnostics
  nmap("vd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "View Diagnostics" }))
  nmap("<leader>dl", fzf.diagnostics_document, vim.tbl_extend("force", opts, { desc = "Document Diagnostics" }))
  nmap("<leader>dw", fzf.diagnostics_workspace, vim.tbl_extend("force", opts, { desc = "Workspace Diagnostics" }))
  nmap("<leader>ds", fzf.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))
  nmap("<leader>ws", fzf.lsp_workspace_symbols, vim.tbl_extend("force", opts, { desc = "Workspace Symbols" }))

  -- LSP management
  nmap("<leader>lr", ":LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
  nmap("<leader>li", ":LspInfo<CR>", vim.tbl_extend("force", opts, { desc = "LSP Info" }))
end

function M.config()
  require("mason").setup({ max_concurrent_installers = 4 })
  require("fidget").setup({})

  -- Diagnostics
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

  -- Mason setup
  local mason_servers = vim.tbl_filter(function(s)
    return s ~= "ccls"
  end, servers)
  require("mason-lspconfig").setup({
    ensure_installed = mason_servers,
    automatic_installation = true,
    automatic_enable = true,
  })
  require("mason-tool-installer").setup({ ensure_installed = tools })

  vim.lsp.enable(servers)

  -- LSP Attach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      setup_keymaps(args.buf)

      -- Inlay hints
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, args.buf) then
        nmap("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
        end, { buffer = args.buf, desc = "Toggle Inlay Hints" })
      end

      -- Document highlights
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = args.buf,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = args.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

return M
