_G.map = function(mode, keys, func, opts)
  opts = opts or {}
  opts.desc = opts.desc or nil
  vim.keymap.set(mode, keys, func, opts)
end

_G.nmap = function(keys, func, opts)
  _G.map("n", keys, func, opts)
end

_G.imap = function(keys, func, opts)
  _G.map("i", keys, func, opts)
end

_G.vmap = function(keys, func, opts)
  _G.map("v", keys, func, opts)
end

_G.dd = function(...)
  Snacks.debug.inspect(...)
end

_G.bt = function()
  Snacks.debug.backtrace()
end

vim.print = _G.dd
