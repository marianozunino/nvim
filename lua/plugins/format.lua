return {
  "stevearc/conform.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        graphql = { "prettierd", "prettier" },
        njk = { "prettierd", "prettier" },
        svelte = { lsp_format = "fallback" },
        html = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        tex = { "latexindent" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        cs = { "csharpier" },
        templ = { "templ" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
        async = false,
      },
      notify_on_error = false,
    })
  end,
}
