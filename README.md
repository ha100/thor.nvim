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
- [x] add MARK & sourcery anotations to types extracted to new file
- [x] update type initializer after the properties has been added/removed to the type
- [x] dispatch build/generate/run/test Makefile actions
- [x] use llm to generate Xcode style docstring for function
- [ ] auto-insert cases to TCA reducers after they have been added to Action enum

## 📦 Installation<a name="installation"></a>

### Requirements<a name="requirements"></a>

    nvim-treesitter - to extract code via AST
    vim-dispatch - to dispatch Makefile actions
    sourcery - to automatically update swift type initializer after type properties have changed
    ollama - to run llm models locally

### Setup Using Lazy<a name="lazy"></a>

```lua
return {
    "https://github.com/ha100/thor.nvim",
    ft = "swift",
    lazy = true,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "David-Kunz/gen.nvim",
        "tpope/vim-dispatch",
    },
    config = function()
        require("thor").setup({
            anotate = true,
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
        require("gen").setup({
            model = "qwen2.5-coder:7b",
            quit_map = "q",                  -- set keymap to close the response window
            retry_map = "<c-r>",             -- set keymap to re-send the current prompt
            accept_map = "<c-cr>",           -- set keymap to replace the previous selection with the last result
            host = "localhost",              -- The host running the Ollama service.
            port = "11434",                  -- The port on which the Ollama service is listening.
            display_mode = "split",          -- The display mode. Can be "float" or "split" or "horizontal-split".
            show_prompt = false,             -- Shows the prompt submitted to Ollama.
            show_model = false,              -- Displays which model you are using at the beginning of your chat session.
            no_auto_close = false,           -- Never closes the window automatically.
            file = true,                     -- Write the payload to a temporary file to keep the command short. - coz curl is token limited
            hidden = false,                  -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
            init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
            command = function(options)
                local body = { model = options.model, stream = true }
                return "curl --silent --no-buffer -X POST http://" ..
                    options.host .. ":" .. options.port .. "/api/chat -d $body"
            end,
            debug = true -- Prints errors and the command which is run.
        })
        require('gen').prompts['Swift_Docstring'] = {
            prompt =
[[
Ignore any previous code formatting specifications. 我不会说中文，请说英语 Generate Xcode-style docstring documentation for the following INPUT function based on the FORMAT specification. Respond only with one of the OPTIONs based on the number of input function arguments used in function declaration. Replace the <placeholders> with relevant comments then follow with the original code snippet. If there is any Swift type mentioned in the comments, make sure to surround it with backticks. Don't forget that each Swift argument in the function declaration can have input argument label and input parameter name used for one input argument so pick the OPTION based on the number of arguments. When responding, make sure the original code snippet is not altered. Multiline comments with stars are not an option, since they are not specified in a FORMAT. The response should NOT be inside markdown backticks and each line MUST have same indentation as the original code snippet. Use the EXAMPLES to better understand which format OPTION to use for which INPUT. If the function returns Void or has no return value, remove the comment line with Returns section in OPTION.

INPUT
-----

$text

FORMAT
------

OPTION 1 - for function with no arguments in declaration use this format
    /// <Brief Function Description>
    ///
    /// - Returns: <description>
    ///
$text

OPTION 2 - for function with one argument in declaration use this format
    /// <Brief Function Description>
    ///
    /// - Parameter <argument label>: <value description>
    ///
    /// - Returns: <description>
    ///
$text

OPTION 3 - for function with multiple arguments in declaration use this format
    /// <Brief Function Description>
    ///
    /// - Parameters:
    ///   - <1st argument label>: <value description>
    ///   - <2nd argument label>: <value description>
    ///
    /// - Returns: <description>
    ///
$text
]],
            hidden = true,
            replace = true,
            model = "qwen2.5:latest"
        }
    end,
    keys = {
        vim.keymap.set("v", "<leader>ref", ":Thor extract2file<cr>", { desc = "Extract code to file" }),
        vim.keymap.set("v", "<leader>rev", ":Thor extract2variable<cr>", { desc = "Extract code to variable" }),
        vim.keymap.set("n", "<leader>rtv", ":Thor toggle_visibility<cr>", { desc = "Toggle private/public visibility" }),
        vim.keymap.set("n", "<leader>rpi", ":Thor update_init<cr>", { desc = "recreate public init for current file" }),
        vim.keymap.set("n", "<leader>rdt", ":Thor dispatch test<cr>", { desc = "dispatch test" }),
        vim.keymap.set("n", "<leader>rdg", ":Thor dispatch generate<cr>", { desc = "dispatch generate" }),
        vim.keymap.set("n", "<leader>rdb", ":Thor dispatch build<cr>", { desc = "dispatch build" }),
        vim.keymap.set("n", "<leader>rdr", ":Thor dispatch run<cr>", { desc = "dispatch run" }),
        vim.keymap.set("v", "<leader>rdf", ":Thor docstring<cr>", { desc = "Document function" }),
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
