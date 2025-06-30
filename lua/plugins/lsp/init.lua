return {
  "neovim/nvim-lspconfig",
  dependencies = {
    require("plugins.lsp.extras.lazydev"),
    require("plugins.lsp.extras.gopher"),
    "mason-org/mason-lspconfig.nvim",
    "mason-org/mason.nvim",
    "j-hui/fidget.nvim",
    "ibhagwan/fzf-lua",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  config = function()
    -- Mason setup
    require("mason").setup({ max_concurrent_installers = 4 })
    require("fidget").setup({})

    -- Enhance floating preview windows
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      opts.max_width = opts.max_width or 80
      opts.max_height = opts.max_height or 20
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- Diagnostics configuration
    vim.diagnostic.config({
      virtual_text = { spacing = 2, source = "if_many" },
      float = { border = "rounded", source = "if_many" },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪",
          [vim.diagnostic.severity.INFO] = "󰋽",
          [vim.diagnostic.severity.HINT] = "󰌶",
        },
      } or true,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
    })

    -- Global floating options
    _G.floating_options = {
      focusable = true,
      focus = false,
      max_height = 50,
      max_width = 100,
    }

    -- Auto-format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        if vim.lsp.buf_is_attached() then
          vim.lsp.buf.format()
        end
      end,
    })

    -- Filter out unwanted code actions
    vim.lsp.buf.code_action = (function(orig)
      return function(opts)
        opts = opts or {}
        opts.filter = function(action)
          if not action then
            return false
          end
          -- Ignore gopls "Browse" actions
          if action.title and action.title:match("Browse gopls") then
            return false
          end
          return true
        end
        return orig(opts)
      end
    end)(vim.lsp.buf.code_action)

    -- Keymaps setup function
    local function setup_keymaps(bufnr)
      local fzf = require("fzf-lua")
      local opts = { buffer = bufnr }

      -- Helper function for mapping
      local function nmap(key, func, desc_opts)
        vim.keymap.set("n", key, func, desc_opts)
      end

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
      nmap("<leader>lr", function()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if #clients == 0 then
          vim.notify("No LSP clients attached to buffer", vim.log.levels.WARN)
          return
        end

        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
          vim.cmd("LspRestart " .. client.name)
        end
        vim.notify("Restarted LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
      end, vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
      nmap("<leader>li", ":LspInfo<CR>", vim.tbl_extend("force", opts, { desc = "LSP Info" }))
    end

    -- LSP servers configuration
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
      "tinymist",
    }

    -- Tools for mason-tool-installer
    local tools = {
      "prettierd",
      "shfmt",
      "stylua",
      "latexindent",
      "clang-format",
      "csharpier",
      "quick-lint-js",
    }

    -- Servers not supported by mason
    local mason_unsupported = { "ccls" }

    local mason_servers = vim.tbl_filter(function(server)
      return not vim.tbl_contains(mason_unsupported, server)
    end, servers)

    -- Mason setup
    require("mason-lspconfig").setup({
      ensure_installed = mason_servers,
      automatic_installation = true,
      automatic_enable = false,
    })
    require("mason-tool-installer").setup({ ensure_installed = tools })

    -- Enable LSP servers
    vim.lsp.enable(servers)

    -- LSP Attach autocmd
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        -- Setup keymaps
        setup_keymaps(args.buf)

        -- Inlay hints
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, args.buf) then
          vim.keymap.set("n", "<leader>th", function()
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
  end,
}
