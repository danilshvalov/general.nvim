local M = {}

local function parse_mode(mode)
  mode = mode or "n"

  if type(mode) == "string" and #mode > 1 then
    local splitted_value = {}
    mode:gsub(".", function(c)
      table.insert(splitted_value, c)
    end)
    mode = splitted_value
  end

  return mode
end

local default_config = {
  default_opts = {
    silent = true,
  },
}

M.config = {}

M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", default_config, config or {})
end

M.map = {}

function M.map:new(opts)
  local this = {}
  opts = vim.tbl_deep_extend("force", M.config.default_opts, opts or {})

  self:prefix(opts.prefix or "", opts.label)
  self:mode(opts.mode or "n")
  self:ft(opts.ft)

  opts.ft = nil
  opts.prefix = nil
  opts.mode = nil
  opts.label = nil
  this.__opts = opts

  this.__mappings = {}

  setmetatable(this, self)
  self.__index = self

  return this
end

function M.map:set(lhs, rhs, opts)
  local prefix = self.__prefix or ""
  opts = vim.tbl_deep_extend("force", self.__opts, opts or {})

  if type(self.__ft) == "string" then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.__ft,
      group = vim.api.nvim_create_augroup(self.__ft .. "_keymap", { clear = false }),
      callback = function()
        opts.buffer = 0
        vim.keymap.set(self.__mode, prefix .. lhs, rhs, opts)
      end,
    })
  else
    vim.keymap.set(self.__mode, prefix .. lhs, rhs, opts)
  end

  return self
end

function M.map:prefix(prefix, label)
  self.__prefix = prefix

  if prefix and label then
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.register({ name = label }, { prefix = prefix, mode = self.__mode })
    end
  end

  return self
end

function M.map:mode(mode)
  self.__mode = parse_mode(mode)
  return self
end

function M.map:ft(filetype)
  if filetype == "all" then
    self.__ft = nil
  else
    self.__ft = filetype
  end
  return self
end

return M
