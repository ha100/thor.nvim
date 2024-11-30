<div align="center">

  <h1>thor.nvim</h1>
  <h5>Swift refactorings hammer</h5>

</div>

## Table of Contents

- [Features](#features)
- [Installation](#installation)
  - [Requirements](#requirements)
  - [Setup Using Lazy](#lazy)
- [Lint](#lint)

## ✨ Features<a name="features"></a>

- [x] extract class/enum/protocol/struct visual block to a new file with name based on the type name
- [x] extract variable visual block to top of a file (specify settings via templates)
- [x] toggle private/public visibility

## 📦 Installation<a name="installation"></a>

### Requirements<a name="requirements"></a>

    treesitter - to extract code via AST

### Setup Using Lazy<a name="lazy"></a>

```lua
return {
    dir = "https://github.com/ha100/thor.nvim",
    ft = "swift",
    lazy = true,
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
        require("thor").setup({
            templates = {
                {
                    file = "Package.swift",
                    from = "dependencies",
                    to = "deps",
                    type = "[Package.Dependency]"
                },
                {
                    file = "Package.swift",
                    from = "targets",
                    to = "targets",
                    type = "[Target]"
                }
            }
        })
    end,
    keys = {
        vim.keymap.set("v", "<leader>ref", ":Thor extract2file<cr>", { desc = "Extract code to file" }),
        vim.keymap.set("v", "<leader>rev", ":Thor extract2variable<cr>", { desc = "Extract code to variable" }),
        vim.keymap.set("v", "<leader>rtp", ":Thor togglePublic<cr>", { desc = "Toggle private/public visibility" }),
    },
}
```

## 🛠️ Lint<a name="lint"></a>

PRs are checked with the following software:
- [luacheck](https://github.com/luarocks/luacheck#installation)
- [stylua](https://github.com/JohnnyMorganz/StyLua)
- [selene](https://github.com/Kampfkarren/selene)

To run the linter locally:

```shell
$ make lint
```

To install tools run:
```shell
$ make install-dev
```
