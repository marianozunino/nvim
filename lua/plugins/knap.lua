return {
  {
    "frabjous/knap",
    lazy = false,
    config = function()
      -- Configure KNAP settings
      vim.g.knap_settings = {
        mdoutputext = "pdf",
        mdtopdf = "pandoc -o %outputfile% --pdf-engine=xelatex",
        mdtopdfviewerlaunch = "zathura %outputfile%",
        mdtopdfviewerrefresh = "none",
        mdtopdfbufferasstdin = true,
      }

      -- Set up keymappings for all markdown files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "pandoc", "md" },
        callback = function()
          vim.keymap.set("n", "<leader>kt", function()
            require("knap").toggle_autopreviewing()
          end, { buffer = true, desc = "KNAP toggle auto-preview" })
        end,
      })
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    lazy = false, -- or ft = 'typst'
    version = "1.*",
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },
}
