---@class Treesitter
local Treesitter = {}

local ts = vim.treesitter

---Remove comma from behind of a code block
---
---@param str string
---@return string
local function trim_last_comma(str)
    if str:sub(-1) == "," then
        return str:sub(1, -2) -- Remove the last character
    else
        return str
    end
end

local function trim_whitespace(str)
    return str:match("^%s*(.-)%s*$")
end

--Obtain name of the class or struct so that we can create a filename
--
---@return string?
Treesitter.get_node_name = function(content)
    local class_enum_struct_query = "(class_declaration (type_identifier) @name)"
    local protocol_query = [[
     (protocol_declaration
    (modifiers
      (visibility_modifier))
    (type_identifier) @name
    (protocol_body)) @body
    ]]

    local lang = "swift"
    local parser = ts.get_string_parser(content, lang)
    local tree = parser:parse()
    local root = tree[1]:root()

    for _, qs in ipairs({ class_enum_struct_query, protocol_query }) do
        local query = ts.query.parse(lang, qs)

        for id, match, _ in query:iter_captures(root, content, 0, -1) do
            local capture = query.captures[id]

            if capture == "name" then
                local name = ts.get_node_text(match, content)
                return name
            end
        end
    end

    return "UNKNOWN"
end

--Get the original variable name from the visual selection block with the var body
--
---@param content string
---@return string, string, number
Treesitter.get_variable_name_and_body = function(content)
    local qs = [[
(value_argument
  (value_argument_label
    (simple_identifier) @var)
  (array_literal) @body) @block
  ]]
    local parsers = require("nvim-treesitter.parsers")
    local parser = parsers.get_parser()
    local lang = parser:lang()
    local tree = parser:parse()[1]
    local root = tree:root()
    local query = ts.query.parse(lang, qs)
    local trimmed_text = trim_whitespace(content)
    local name = ""
    local body = ""
    local position = 0

    for _, match, _ in query:iter_matches(root, 0) do
        local block = ts.get_node_text(match[3], 0)

        if block == trim_last_comma(trimmed_text) then
            name = ts.get_node_text(match[1], 0)
            body = ts.get_node_text(match[2], 0)

            local _, col = match[1]:start()
            position = col
            break
        end
    end

    return name, body, position
end

--Get the line number where the Package definition starts
--
---@return number
Treesitter.get_package_position = function()
    local qs = [[
    (property_declaration
  (value_binding_pattern)
  (pattern (simple_identifier))
  (call_expression (simple_identifier) @package) (#match? @package "Package"))
    ]]
    local parsers = require("nvim-treesitter.parsers")
    local parser = parsers.get_parser()
    local lang = parser:lang()
    local tree = parser:parse()[1]
    local root = tree:root()
    local query = ts.query.parse(lang, qs)

    for _, match, _ in query:iter_matches(root, 0) do
        local node = match[1]
        local row, _ = node:start()
        return row
    end
end

return Treesitter
