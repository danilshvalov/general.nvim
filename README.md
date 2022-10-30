<h1 align="center"><code>keymap.nvim</code></h1>
<p align="center">⚡ Keymap wrapper for Neovim ⚡</p>

## 🔗 Requirements

* Neovim >= 0.7.0

## 📦 Installation

```lua
use({
  "danilshvalov/keymap.nvim",
  config = function()
    require("keymap").setup()
  end,
})
```

## ⚙️  Configuration

```lua
require("keymap").setup({
  -- exactly the same opts as in `:h vim.keymap.set`
  default_opts = {
    silent = true,
  },
})
```

## 🚀 Usage

Here are the main functions of the plugin:

```lua
local map = require("keymap").map

map
    :new()
    -- the second argument is used for which-key (optional)
    :prefix("<leader>g", "+git")
    -- specify mode, accepts strings and tables
    :mode("nv")
    -- specify filetype (mapping will only work in the specified filetype)
    :ft("lua")
    -- you can pass lua functions
    :set("g", vim.cmd.Neogit, { desc = "Open neogit" })
    -- or vimscript strings
    :set("n", "<Cmd>Gitsigns next_hunk<CR>")
```

You can also use tables to configure mappings:

```lua
map
    :new({
      prefix = "<leader>g",
      label = "+git",
      mode = "nv",
      ft = "lua",
    })
    :set("g", vim.cmd.Neogit, { desc = "Open neogit" })
    :set("n", "<Cmd>Gitsigns next_hunk<CR>")

```

You can save the configuration to variables:

```lua
local leader_map = map:new():prefix("<leader>")

leader_map:set("h", function()
  vim.notify("Hello World!")
end)
```

Another example:

```lua
local lua_map = map:new({ prefix = "<leader>l", mode = "n", ft = "lua" })

lua_map
    :set("h", function()
      vim.notify("Hello lua!")
    end)
    :set("g", function()
      vim.notify("Another hello lua!")
    end)
```
