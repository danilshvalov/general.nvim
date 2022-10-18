local M = {}

local default_config = {
  default_opts = {
    silent = true,
  },
  allowed_opts = {
    "buffer",
    "remap",
    "desc",
    "expr",
    "silent",
    "script",
    "nowait",
    "unique",
  },
}

M.options = {}

M.setup = function(config)
  M.options = vim.tbl_deep_extend("force", default_config, config or {})
end

return M
