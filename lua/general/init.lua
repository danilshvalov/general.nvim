local config = require("general.config")

local M = {}

M.setup = config.setup

M.map = function(mappings)
  local prefix = ""
  local mode = ""

  local parsed_mappings = {}
  local mappings_opts = config.options.default_opts or {}

  for key, value in pairs(mappings) do
    if vim.tbl_contains(config.options.allowed_opts, key) or type(value) == "boolean" then
      mappings_opts[key] = value
    elseif key == "mode" then
      mode = value
    elseif key == "prefix" then
      prefix = value
    else
      parsed_mappings[key] = value
    end
  end

  for key, value in pairs(parsed_mappings) do
    vim.keymap.set(mode, prefix .. key, value, mappings_opts)
  end
end

M.make_mapper = function(opts)
  return function(raw_mappings)
    M.map(vim.tbl_deep_extend("force", opts, raw_mappings))
  end
end

M.nmap = M.make_mapper({ mode = "n" })
M.vmap = M.make_mapper({ mode = "v" })
M.xmap = M.make_mapper({ mode = "x" })
M.smap = M.make_mapper({ mode = "s" })
M.omap = M.make_mapper({ mode = "o" })
M.imap = M.make_mapper({ mode = "i" })
M.lmap = M.make_mapper({ mode = "l" })
M.cmap = M.make_mapper({ mode = "c" })
M.tmap = M.make_mapper({ mode = "t" })

return M
