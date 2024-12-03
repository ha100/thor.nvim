---@class Helpers
local Helpers = {}

--Get the current position in the buffer
--
---@return number, number
local function get_cursor_position()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    return row - 1, col
end

--Utility function to split a string by newlines
--
---@param text string
---@return table<string>
Helpers.split_lines = function(text)
    local lines = {}

    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(lines, line)
    end

    return lines
end

--Function to get the visually selected range
--
---@return number, number, number, number
Helpers.get_visual_selection_range = function()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row = start_pos[2] - 1 -- Convert to 0-based index
    local start_col = start_pos[3] - 1
    local end_row = end_pos[2] - 1
    local end_col = end_pos[3]

    local max_col = vim.api.nvim_win_get_width(0)

    if end_col > max_col then
        end_col = vim.fn.col("'>") - 1
    end

    return start_row, start_col, end_row, end_col
end

--Insert text at the current cursor position
--
---@param text string
Helpers.insert_text_at_cursor = function(text)
    local bufnr = vim.api.nvim_get_current_buf()
    local row, col = get_cursor_position()
    local lines = Helpers.split_lines(text)

    vim.api.nvim_buf_set_text(bufnr, row, col, row, col, lines)
end

--Get relevant template for file and block of code
--
--template is specified by user for repeating variable extractions
--it specifies the name of the file (Package.swift), variable name,
--and the name it should be extracted to
--
---@param filename string
---@param name string
---@param templates table
---@return table<string, string>?
Helpers.get_template_for_node = function(filename, name, templates)
    for _, entry in ipairs(templates) do
        if entry.file == filename and entry.from == name then
            return entry
        end
    end

    return nil
end

--Insert specified content into target table at the position
--
---@param target table<string>
---@param content table<string>
---@param position number
---@return table<string>
Helpers.table_insert = function(target, content, position)
    for i, line in ipairs(content) do
        table.insert(target, position + i - 1, line)
    end

    return target
end

---Remove comma from behind of a code block
---
---@param str string
---@return string
Helpers.trim_last_comma = function(str)
    if str:sub(-1) == "," then
        return str:sub(1, -2)
    else
        return str
    end
end

---Remove whitesace from the start and end of the string
---
---@param str string
---@return string
Helpers.trim_whitespace = function(str)
    return str:match("^%s*(.-)%s*$")
end

return Helpers
