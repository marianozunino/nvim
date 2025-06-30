local M = {
  {
    "tpope/vim-fugitive",
    config = function()
      local git_status = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.b[bufnr].fugitive_status then
          local winnr = vim.fn.bufwinid(bufnr)
          vim.api.nvim_win_close(winnr, true)
        else
          vim.cmd("G")
        end
      end

      vim.g.fugitive_git_executable = "env GPG_TTY=$(tty) git"
      vim.env.GPG_TTY = vim.fn.system("tty"):gsub("\n", "")

      nmap("<leader>lg", ":G<cr>", { desc = "Git Status" })
      nmap("<leader>gs", git_status, { desc = "Toggle Git Status" })
      nmap("gs", git_status, { desc = "Toggle Git Status" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fugitive", "fugitiveblame", "fugitive-status" },
        callback = function()
          nmap("P", function()
            local cmd = "git push --force-with-lease"
            Snacks.notifier.notify("Pushing...", vim.log.levels.INFO)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, code)
                if code == 0 then
                  Snacks.notifier.notify("Push completed successfully", vim.log.levels.INFO)
                else
                  Snacks.notifier.notify("Push failed with exit code: " .. code, vim.log.levels.ERROR)
                end
              end,
              detach = true,
            })
          end, { buffer = true, desc = "Git Push Force With Lease (Async)" })

          nmap("<C-c>", function()
            local win_id = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win_id, false)
          end, { buffer = true, desc = "Close window" })

          -- Git Pull
          nmap("gp", function()
            local cmd = "git pull"
            Snacks.notifier.notify("Pulling...", vim.log.levels.INFO)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, code)
                if code == 0 then
                  Snacks.notifier.notify("Pull completed successfully", vim.log.levels.INFO)
                else
                  Snacks.notifier.notify("Pull failed with exit code: " .. code, vim.log.levels.ERROR)
                end
              end,
              detach = true,
            })
          end, { buffer = true, desc = "Close window" })
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        current_line_blame = true,
        signs = {
          add = { text = icons.ui.BoldLineMiddle },
          change = { text = icons.ui.BoldLineDashedMiddle },
          delete = { text = icons.ui.TriangleShortArrowRight },
          topdelete = { text = icons.ui.TriangleShortArrowRight },
          changedelete = { text = icons.ui.BoldLineMiddle },
        },
      })
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitlinker").setup({
        message = false,
        console_log = false,
      })

      nmap("<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>")
    end,
  },
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua", "folke/snacks.nvim" },
    config = function()
      local fzf_lua = require("fzf-lua")
      local git_worktree = require("git-worktree")

      -- Basic hooks
      local Hooks = require("git-worktree.hooks")
      Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)

      -- Switch worktrees
      local function switch_worktree()
        vim.system({ "git", "worktree", "list" }, {}, function(result)
          if result.code ~= 0 then
            return
          end

          local items = {}
          for line in result.stdout:gmatch("[^\n]+") do
            local path, branch = line:match("^([^%s]+)%s+%[?([^%]]*)")
            if path and branch then
              table.insert(items, path .. " (" .. (branch ~= "" and branch or "detached") .. ")")
            end
          end

          vim.schedule(function()
            fzf_lua.fzf_exec(items, {
              prompt = "Worktrees> ",
              actions = {
                default = function(selected)
                  local path = selected[1]:match("^([^%(]+)")
                  git_worktree.switch_worktree(path:gsub("%s+$", ""))
                end,
              },
            })
          end)
        end)
      end

      -- Create worktree
      local function create_worktree()
        -- Get the git directory (works for both regular and bare repos)
        vim.system({ "git", "rev-parse", "--git-dir" }, {}, function(result)
          if result.code ~= 0 then
            vim.schedule(function()
              vim.notify("Not in a git repository", vim.log.levels.ERROR)
            end)
            return
          end

          local git_dir = result.stdout:gsub("\n", "")
          -- For bare repos, git-dir is the repo itself; for regular repos, get parent
          local repo_root = git_dir:match("%.git$") and git_dir:gsub("/%.git$", "") or git_dir

          vim.system({ "git", "branch", "-a" }, { cwd = repo_root }, function(branch_result)
            if branch_result.code ~= 0 then
              return
            end

            local branches = {}
            for line in branch_result.stdout:gmatch("[^\n]+") do
              local branch = line:gsub("^%s*%*?%s*", ""):gsub("^remotes/", "")
              if branch ~= "" and not branch:match("HEAD") then
                table.insert(branches, branch)
              end
            end

            vim.schedule(function()
              fzf_lua.fzf_exec(branches, {
                prompt = "Base Branch> ",
                actions = {
                  default = function(selected)
                    if not selected or #selected == 0 then
                      return
                    end
                    local base_branch = selected[1]
                    local default_name = base_branch:gsub(".*/", "")

                    require("snacks").input({
                      prompt = "Worktree name",
                      default = default_name,
                      icon = "🌿",
                    }, function(name)
                      if name then
                        git_worktree.create_worktree(name, base_branch, "origin")
                      end
                    end)
                  end,
                },
              })
            end)
          end)
        end)
      end

      -- Delete worktree
      local function delete_worktree()
        local cwd = vim.fn.getcwd() -- Get this before async call

        vim.system({ "git", "worktree", "list" }, {}, function(result)
          if result.code ~= 0 then
            return
          end

          local items = {}

          for line in result.stdout:gmatch("[^\n]+") do
            local path, branch = line:match("^([^%s]+)%s+%[?([^%]]*)")
            if path and path ~= cwd then
              table.insert(items, path .. " (" .. (branch ~= "" and branch or "detached") .. ")")
            end
          end

          vim.schedule(function()
            fzf_lua.fzf_exec(items, {
              prompt = "Delete> ",
              actions = {
                default = function(selected)
                  local path = selected[1]:match("^([^%(]+)"):gsub("%s+$", "")

                  -- Simple vim.ui.select for yes/no
                  vim.ui.select({ "Yes", "No" }, {
                    prompt = "Delete worktree '" .. path .. "'?",
                  }, function(choice)
                    if choice == "Yes" then
                      git_worktree.delete_worktree(path, true)
                    end
                  end)
                end,
              },
            })
          end)
        end)
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>ws", switch_worktree, { desc = "Switch Worktree" })
      vim.keymap.set("n", "<leader>wc", create_worktree, { desc = "Create Worktree" })
      vim.keymap.set("n", "<leader>wd", delete_worktree, { desc = "Delete Worktree" })
    end,
  },
}

return M
