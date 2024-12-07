local helpers = require("thor.helpers")
local treesitter = require("thor.treesitter")

---@toc thor.contents

---@mod thor.intro Introduction
---@brief [[
---
---a plugin to help me with frequent refactorings of Swift code
---
---@brief ]]

--Default options for the Module
--
local Module = {
    anotate = true,
    templates = {},
}

---@class Template
---@field file string: file in which the refactor will take action
---@field from string: name of the extracted variable
---@field to string: name of the new variable
---@field type string: explicit type of the new variable

---@usage lua [[
---{
---    file = "Package.swift",
---    from = "dependencies",
---    to = "deps",
---    type = "[Package.Dependency]"
---}
---@usage ]]

---@class Options
---@field anotate boolean: whether types extracted to a new file should get sourcery anotation
---@field templates table<Template>: table of user specified Templates

---@mod thor.setup Setup
---@brief [[
---
---Setup the Module with user specified overrides for settings
---
---@brief ]]
---@param opts Options
---@usage lua [[
--- return {
---     "https://github.com/ha100/thor.nvim",
---     ft = "swift",
---     lazy = true,
---     dependencies = {
---         "nvim-treesitter/nvim-treesitter",
---         "David-Kunz/gen.nvim",
---         "tpope/vim-dispatch",
---     },
---     config = function()
---         require("thor").setup({
---             anotate = true,
---             templates = {
---                 {
---                     file = "Package.swift",
---                     from = "dependencies",
---                     to = "deps",
---                     type = "[Package.Dependency]"
---                 },
---                 {
---                     file = "Package.swift",
---                     from = "targets",
---                     to = "targets",
---                     type = "[Target]"
---                 }
---             }
---         })
---         require("gen").setup({
---             model = "qwen2.5-coder:7b",
---             quit_map = "q",
---             retry_map = "<c-r>",
---             accept_map = "<c-cr>",
---             host = "localhost",
---             port = "11434",
---             display_mode = "split",
---             show_prompt = false,
---             show_model = false,
---             no_auto_close = false,
---             file = true,
---             hidden = false,
---             init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
---             command = function(options)
---                 local body = { model = options.model, stream = true }
---                 return "curl --silent --no-buffer -X POST http://" ..
---                     options.host .. ":" .. options.port .. "/api/chat -d $body"
---             end,
---             debug = true -- Prints errors and the command which is run.
---         })
---         require('gen').prompts['Swift_Docstring'] = {
---             prompt =
--- [[
--- Ignore any previous code formatting specifications. 我不会说中文，请说英语 Generate Xcode-style
--- docstring documentation for the following INPUT function based on the FORMAT specification.
--- Respond only with one of the OPTIONs based on the number of input function arguments used in
--- function declaration. Replace the <placeholders> with relevant comments then follow with the
--- original code snippet. If there is any Swift type mentioned in the comments, make sure to
--- surround it with backticks. Don't forget that each Swift argument in the function declaration
--- can have input argument label and input parameter name used for one input argument so pick the
--- OPTION based on the number of arguments. When responding, make sure the original code snippet
--- is not altered. Multiline comments with stars are not an option, since they are not specified
--- in a FORMAT. The response should NOT be inside markdown backticks and each line MUST have same
--- indentation as the original code snippet. Use the EXAMPLES to better understand which format
--- OPTION to use for which INPUT. If the function returns Void or has no return value, remove the
--- comment line with Returns section in OPTION.
---
--- INPUT
--- -----
---
--- $text
---
--- FORMAT
--- ------
---
--- OPTION 1 - for function with no arguments in declaration use this format
---     /// <Brief Function Description>
---     ///
---     /// - Returns: <description>
---     ///
--- $text
---
--- OPTION 2 - for function with one argument in declaration use this format
---     /// <Brief Function Description>
---     ///
---     /// - Parameter <argument label>: <value description>
---     ///
---     /// - Returns: <description>
---     ///
--- $text
---
--- OPTION 3 - for function with multiple arguments in declaration use this format
---     /// <Brief Function Description>
---     ///
---     /// - Parameters:
---     ///   - <1st argument label>: <value description>
---     ///   - <2nd argument label>: <value description>
---     ///
---     /// - Returns: <description>
---     ///
--- $text
--- ]],
---             hidden = true,
---             replace = true,
---             model = "qwen2.5:latest"
---         }
---     end,
---keys = {
---    vim.keymap.set("v", "<leader>ref", ":Thor extract2file<cr>", { desc = "Extract code to file" }),
---    vim.keymap.set("v", "<leader>rev", ":Thor extract2variable<cr>", { desc = "Extract code to variable" }),
---    vim.keymap.set("n", "<leader>rtv", ":Thor toggle_visibility<cr>", { desc = "Toggle private/public visibility" }),
---    vim.keymap.set("n", "<leader>rpi", ":Thor update_init<cr>", { desc = "recreate public init for current file" }),
---    vim.keymap.set("n", "<leader>rdt", ":Thor dispatch test<cr>", { desc = "dispatch test" }),
---    vim.keymap.set("n", "<leader>rdg", ":Thor dispatch generate<cr>", { desc = "dispatch generate" }),
---    vim.keymap.set("n", "<leader>rdb", ":Thor dispatch build<cr>", { desc = "dispatch build" }),
---    vim.keymap.set("n", "<leader>rdr", ":Thor dispatch run<cr>", { desc = "dispatch run" }),
---    vim.keymap.set("v", "<leader>rdf", ":Thor docstring<cr>", { desc = "Document function" }),
---},
--- }
---@usage ]]
Module.setup = function(opts)
    if opts then
        for key, value in pairs(opts) do
            Module[key] = value
        end
    end
end

---@mod thor.type Extract swift type to file
---@brief [[
---
---Extract class/enum/protocol/struct visual block to a file with name based on the type name
---
---@brief ]]
--
--Get the visually selected range, Get the text in the selected range,
--Delete the selected text, Open the file named by the class/struct & paste the text
Module.extract_to_file = function()
    local start_row, start_col, end_row, end_col = helpers.get_visual_selection_range()
    local curr_buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_text(curr_buffer, start_row, start_col, end_row, end_col, {})
    local content = table.concat(lines, "\n")
    local name = treesitter.get_node_name(content)

    -- clear the visual block from current file
    vim.api.nvim_buf_set_text(curr_buffer, start_row, start_col, end_row, end_col, {})
    local current_dir = vim.fn.expand("%:p:h")
    vim.api.nvim_command("edit " .. current_dir .. "/" .. name .. ".swift")
    helpers.insert_text_at_cursor(content)

    local new_buffer = vim.api.nvim_get_current_buf()
    local new_lines = vim.api.nvim_buf_get_lines(new_buffer, 0, -1, false)
    local new_content = table.concat(new_lines, "\n")

    local node_type = treesitter.extract_type(new_buffer, new_content)
    -- if node is actor, class or struct - we don't anotate enums & protocol
    if node_type == 2 or node_type == 3 or node_type == 6 then
        local anotated = treesitter.is_node_anotated(new_content)
        if anotated == false then
            new_content = treesitter.anotate(name, new_content)
            local linez = helpers.split_lines(new_content)
            vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, linez)
            vim.api.nvim_buf_set_option(new_buffer, "modified", true)
        end
    end
    vim.cmd("write!")
end

---@mod thor.variable Extract variable locally
---@brief [[
---
---Extract visual block to a local variable. Frequently refactored types can
---be specified with a template that will fill in info necessary during the refactoring.
---all the variables of the template need to be specified and met.
---
---@brief ]]
--
--Get the visually selected range, Get the text in the selected range,
--Replace variable body with `to` template, Paste the `to` variable with body to new place
Module.extract_to_variable = function()
    local start_row, start_col, end_row, end_col = helpers.get_visual_selection_range()
    local curr_buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_text(curr_buffer, start_row, start_col, end_row, end_col, {})
    local content = table.concat(lines, "\n")
    local name, body, col = treesitter.get_variable_name_and_body(content)
    local filename = vim.fn.expand("%:t")
    local result = helpers.get_template_for_node(filename, name, Module.templates)

    if result == nil then
        return
    end

    vim.api.nvim_buf_set_text(
        curr_buffer,
        start_row,
        col,
        end_row,
        end_col,
        { result.from .. ": " .. result.to .. "," }
    )
    local position = treesitter.get_package_position()
    lines = helpers.split_lines(body)
    local prefix = "let " .. result.to .. ": " .. result.type .. " = "
    lines[1] = prefix .. lines[1]
    table.insert(lines, 1, "")
    vim.api.nvim_buf_set_text(curr_buffer, position - 1, 0, position - 1, 0, lines)
    vim.api.nvim_buf_set_option(curr_buffer, "modified", true)
end

---@mod thor.visibility Toggle private/public visibility
---@brief [[
---
---Toggle the current visibility for function/variable/class
---
---@brief ]]
Module.toggle_visibility = function()
    local row = vim.fn.line(".")
    local col = vim.fn.col(".")
    local line_text = vim.fn.getline(row)

    if string.find(line_text, "public") then
        local new_line_text = string.gsub(line_text, "public", "private")
        vim.fn.setline(row, new_line_text)
    elseif string.find(line_text, "private") then
        local new_line_text = string.gsub(line_text, "private", "public")
        vim.fn.setline(row, new_line_text)
    end

    vim.cmd("normal! " .. col .. "G" .. col)
end

---@mod thor.init_update Update Init
---@brief [[
---
---Update file init to reflect the changes of props
---
---@brief ]]
Module.update_init = function()
    local current_file_path = vim.api.nvim_buf_get_name(0)
    local plugin_directory = helpers.get_plugin_directory()
    local stencil_path = plugin_directory .. "init.stencil"

    vim.fn.system("sourcery --sources " .. current_file_path .. " --templates " .. stencil_path .. " --output inlined")
end

---@mod thor.dispatch Dispatch Action
---@brief [[
---
---Dispatch build/generate/run/test actions via Makefile
---
---@brief ]]
---@param action string: what Makefile action should be dispatched
Module.dispatch = function(action)
    vim.notify(action)
    local quickfix_open = false
    -- Iterate through all windows to check if quickfix is open
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_option(buf, "buftype") == "quickfix" then
                quickfix_open = true
                vim.cmd("cclose")
                break
            end
        end
    end
    if not quickfix_open then
        vim.cmd("Dispatch make " .. action)
    end
end

---@mod thor.docstring Generate Function Docstring
---@brief [[
---
---Utilise llm to document function
---
---@brief ]]
Module.docstring = function()
    vim.cmd("'<,'>Gen Swift_Docstring")
end

return Module
