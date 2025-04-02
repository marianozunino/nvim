-- Create autogroups first
local MZuninoGroup = vim.api.nvim_create_augroup("mzunino", {})
local yank_group = vim.api.nvim_create_augroup("HighlightYank", {})

-- Set bigfile size threshold
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Netrw diagnostic disable
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Template files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.templ",
  command = "set filetype=templ",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = MZuninoGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Bigfile detection
vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf].filetype ~= "bigfile" and path and vim.fn.getfsize(path) > vim.g.bigfile_size and "bigfile"
          or nil
      end,
    },
  },
})
