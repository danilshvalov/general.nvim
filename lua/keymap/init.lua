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

Map = {}

function Map:new(opts)
  local this = {}
  opts = vim.tbl_deep_extend("force", M.config.default_opts, opts or {})

  this.__prefix = opts.prefix or ""
  this.__label = opts.label
  this.__mode = parse_mode(opts.mode)
  this.__ft = opts.ft

  if this.__prefix and this.__label then
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.register({ name = this.__label }, { prefix = this.__prefix, mode = this.__mode })
    end
  end

  opts.ft = nil
  opts.prefix = nil
  opts.mode = nil
  opts.label = nil
  this.__opts = opts

  setmetatable(this, self)
  self.__index = self

  return this
end

function Map:set(lhs, rhs, opts)
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

function Map:amend(lhs, rhs, opts)
  local amend = require("keymap-amend")

  local prefix = self.__prefix or ""
  opts = vim.tbl_deep_extend("force", self.__opts, opts or {})

  if type(self.__ft) == "string" then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.__ft,
      group = vim.api.nvim_create_augroup(self.__ft .. "_keymap", { clear = false }),
      callback = function()
        opts.buffer = 0
        amend(self.__mode, prefix .. lhs, rhs, opts)
      end,
    })
  else
    amend(self.__mode, prefix .. lhs, rhs, opts)
  end

  return self
end

function Map:prefix(prefix, label)
  return Map:new(vim.tbl_deep_extend("force", self.__opts, {
    prefix = prefix,
    label = label,
    mode = self.__mode,
    ft = self.__ft,
  }))
end

function Map:mode(mode)
  return Map:new(vim.tbl_deep_extend("force", self.__opts, {
    prefix = self.__prefix,
    label = self.__label,
    mode = mode,
    ft = self.__ft,
  }))
end

function Map:ft(ft)
  return Map:new(vim.tbl_deep_extend("force", self.__opts, {
    prefix = self.__prefix,
    label = self.__label,
    mode = self.__mode,
    ft = ft,
  }))
end

M.map = setmetatable({}, {
  __index = function(_, key)
    return Map:new()[key]
  end,
})

M.setup()

return M
