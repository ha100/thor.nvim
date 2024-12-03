local helpers = require("thor.helpers")

---@class Treesitter
local Treesitter = {}

local ts = vim.treesitter

--Checks if the extracted node is pubInit sourcery enabled
--
---@param content string
---@return boolean
Treesitter.is_node_anotated = function(content)
    local qs = [[
    (((comment) @source (class_declaration (type_identifier)))
        (#match? @source "// sourcery: PublicInit"))
    ]]
    local lang = "swift"
    local parser = ts.get_string_parser(content, lang)
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = ts.query.parse(lang, qs)

    for id, _, _ in query:iter_captures(root, content, 0, -1) do
        local name = query.captures[id]
        if name == "source" then
            return true
        end
    end

    return false
end

--Obtain name of the class or struct so that we can create a filename
--
---@param content string
---@return number?, number?
local function has_init(content)
    local qs = [[
    (init_declaration) @init
    ]]

    local lang = "swift"
    local parser = ts.get_string_parser(content, lang)
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = ts.query.parse(lang, qs)

    for _, node, _ in query:iter_matches(root, 0) do
        local row_start, _ = node[1]:start()
        local row_end, _ = node[1]:end_()

        return row_start, row_end
    end

    return nil, nil
end

--Checks if the extracted type contains functions
--
---@param content string
---@return number?
local function has_functions(content)
    local qs = [[
  (class_declaration
    (class_body
      (function_declaration
        (simple_identifier)
        (function_body)) @func))
    ]]

    local lang = "swift"
    local parser = ts.get_string_parser(content, lang)
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = ts.query.parse(lang, qs)

    for _, node, _ in query:iter_matches(root, 0) do
        local row_start, _ = node[1]:start()
        return row_start
    end

    return nil
end

--Checks if the extracted type contains specified mark
--
--NOTE: - using treesitter because the `text:find(substring)` and `string.match(text, substring)`
--did not work for me at all
--
---@param mark string
---@return number?
local function has_mark(mark, content)
    local qs = string.format([[(((comment) @com) (#match? @com "// MARK: - %s"))]], mark)
    local lang = "swift"
    local parser = ts.get_string_parser(content, lang)
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = ts.query.parse(lang, qs)

    for _, node, _ in query:iter_matches(root, 0) do
        local row_start, _ = node[1]:start()
        return row_start
    end

    return nil
end

---@param name string: name of the extracted type so that we can inject it into comment
---@param content string
---@return string
Treesitter.anotate = function(name, content)
    local qs = [[
      (class_declaration) @type
    ]]

    local lang = "swift"
    local parser = ts.get_string_parser(content, lang)
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = ts.query.parse(lang, qs)
    local postfix = string.format(
        [[// sourcery:inline:auto:%s.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end]],
        name
    )

    local node_start, node_end = has_init(content)

    -- if init is present
    if node_start ~= nil and node_end ~= nil then
        for _, node, _ in query:iter_matches(root, 0) do
            local row_start, _ = node[1]:start()
            local prefix = string.format(
                [[
// sourcery:inline:auto:%s.PublicInit
]],
                name
            )
            local post = "// sourcery:end"
            local lines = helpers.split_lines(content)
            local pre_table = helpers.split_lines(prefix)

            local has = has_mark("Init", content)
            if has == nil then
                lines = helpers.table_insert(lines, { "    // MARK: - Init", "" }, node_start + 1)
                node_end = node_end + 2
            else
                node_start = has
            end

            lines = helpers.table_insert(lines, { post }, node_end + 2)
            lines = helpers.table_insert(lines, pre_table, node_start + 1)
            lines = helpers.table_insert(lines, { "// sourcery: PublicInit" }, row_start + 1)
            table.remove(lines)
            local anotated = table.concat(lines, "\n")
            return anotated
        end
    else
        local number = has_functions(content)
        if number ~= nil then
            -- prepend the init before lifecycle
            for _, node, _ in query:iter_matches(root, 0) do
                local row_start, _ = node[1]:start()
                local lines = helpers.split_lines(content)

                local has = has_mark("LifeCycle", content)
                if has == nil then
                    lines = helpers.table_insert(lines, { "    // MARK: - LifeCycle", "" }, number + 1)
                else
                    number = has
                end

                local post_table = helpers.split_lines(postfix)
                lines = helpers.table_insert(lines, post_table, number + 1)
                lines = helpers.table_insert(lines, { "// sourcery: PublicInit" }, row_start + 1)
                table.remove(lines)
                local anotated = table.concat(lines, "\n")
                return anotated
            end
        else
            -- prepend the init before EOF
            for _, node, _ in query:iter_matches(root, 0) do
                local row_start, _ = node[1]:start()
                local row_end, _ = node[1]:end_()
                local lines = helpers.split_lines(content)
                local post_table = helpers.split_lines(postfix)
                table.remove(post_table)
                lines = helpers.table_insert(lines, post_table, row_end + 1)
                lines = helpers.table_insert(lines, { "// sourcery: PublicInit" }, row_start + 1)
                table.remove(lines)
                local anotated = table.concat(lines, "\n")
                return anotated
            end
        end
    end
end

-- Predefined options
---@class SwiftType
local SwiftType = {
    Unknown = 1,
    Actor = 2,
    Class = 3,
    Enum = 4,
    Protocol = 5,
    Struct = 6,
}

--Extract Swift type (class|enum|protocol|struct) from content and return it as SwiftType case
--
---@param buffer number
---@param content string
---@return number
Treesitter.extract_type = function(buffer, content)
    local qs = [[
      (class_declaration (type_identifier) @name) @type
    ]]

    local name = Treesitter.get_node_name(content)
    local parsers = require("nvim-treesitter.parsers")
    local parser = parsers.get_parser()
    local lang = parser:lang()
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = ts.query.parse(lang, qs)

    for _, node, _ in query:iter_matches(root, 0) do
        local capture = ts.get_node_text(node[1], 0)

        if capture == name then
            local row, _ = node[2]:start()
            local text = vim.api.nvim_buf_get_lines(buffer, row, row + 1, true)[1]

            if string.find(text, "actor") then
                return SwiftType.Actor
            elseif string.find(text, "class") then
                return SwiftType.Class
            elseif string.find(text, "enum") then
                return SwiftType.Enum
            elseif string.find(text, "protocol") then
                return SwiftType.Protocol
            elseif string.find(text, "struct") then
                return SwiftType.Struct
            end
        end
    end

    return SwiftType.Unknown
end

--Obtain name of the class or struct so that we can create a filename
--
---@param content string
---@return string
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
    local trimmed_text = helpers.trim_whitespace(content)
    local name = ""
    local body = ""
    local position = 0

    for _, match, _ in query:iter_matches(root, 0) do
        local block = ts.get_node_text(match[3], 0)

        if block == helpers.trim_last_comma(trimmed_text) then
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
