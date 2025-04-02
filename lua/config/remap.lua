nmap("<Space>", "")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

nmap("Y", "yy")
nmap("<leader><leader>", "<c-^>", { desc = "Switch to last buffer" })
nmap("<M-h>", ":vertical resize +3<CR>", { desc = "Resize window" })
nmap("<M-l>", ":vertical resize -3<CR>", { desc = "Resize window" })
nmap("<M-k>", ":resize +3<CR>", { desc = "Resize window" })
nmap("<M-j>", ":resize -3<CR>", { desc = "Resize window" })

vim.cmd([[
  nnoremap <silent> <C-j> <C-d>
  nnoremap <silent> <C-k> <C-u>
]])

nmap("n", "nzz", { desc = "Move to next search match" })
nmap("N", "Nzz", { desc = "Move to previous search match" })
nmap("*", "*zz", { desc = "Move to next search match" })
nmap("#", "#zz", { desc = "Move to previous search match" })
nmap("g*", "g*zz", { desc = "Move to next search match" })
nmap("g#", "g#zz", { desc = "Move to previous search match" })

-- stay in indent mode
vmap("<", "<gv", { desc = "Indent left" })
vmap(">", ">gv", { desc = "Indent right" })

-- keep register after paste
map("x", "p", [["_dP]])

map({ "n", "o", "x" }, "<s-h>", "^", { desc = "Move to first non-blank character" })
map({ "n", "o", "x" }, "<s-l>", "g_", { desc = "Move to last non-blank character" })

nmap("<leader>q", ":q<CR>", { desc = "Quit" })
nmap("<leader>Q", function()
  vim.api.nvim_command("bd!|qall!")
end, { desc = "Quit all" })

-- create a user command to save without formatting :noa w
vim.api.nvim_create_user_command("W", function()
  if vim.fn.empty(vim.fn.expand("%:t")) == 1 then
    Snacks.notifier.notify("Buffer is empty, not saving", vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_command("noa w")
end, { nargs = 0, desc = "Save without formatting" })

-- move lines
vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- undo tree
nmap("<leader>u", vim.cmd.UndotreeToggle)

-- nnoremap yl :let @" = expand("%:p")<cr>
nmap("yl", function()
  local file = vim.fn.expand("%:p")
  print("Copied path to clipboard: " .. file)
  -- copy to os clipboard
  vim.fn.setreg("+", file)
end, { desc = "Copy file path to clipboard" })

nmap("<Leader>x", "<cmd>!chmod +x %<cr>", { desc = "Make file executable" })

vim.g.user_emmet_leader_key = ","

nmap("<leader>gp", "<CMD>Git push<CR>", { desc = "Git push" })

-- reset cmdheight
nmap("<leader>ch", function()
  vim.o.cmdheight = 1
end, { desc = "Reset cmdheight" })

nmap("<leader>w", function()
  vim.api.nvim_command("w")
end, { desc = "Save" })

nmap("<leader>W", function()
  vim.api.nvim_command("wa")
end, { desc = "Save all" })

-- format json using jq
nmap("<leader>jq", ":%!jq '.'<CR>", { desc = "Format json using jq" })
vmap("<leader>jq", ":!jq '.'<CR>", { desc = "Format json using jq" })

-- Navigate quickfix list
nmap("qj", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
nmap("qk", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

nmap("<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Launch lazygit in a new tmux pane, exits when done
nmap("<leader>lg", "<cmd>!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>", { desc = "LazyGit" })
