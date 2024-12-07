local bit = require("bit")

---@class OptionsSet : table
local OptionsSet = {}
OptionsSet.__index = OptionsSet

-- Constructor to create a new OptionsSet
---@function OptionsSet.new
---@return OptionsSet
function OptionsSet.new()
    return setmetatable({ value = 0 }, OptionsSet)
end

-- Method to add an option
---@function OptionsSet.add
---@param option number The option to add (bitmask)
function OptionsSet:add(option)
    self.value = bit.bor(self.value, option)
end

-- Method to check if an option is in the set
---@function OptionsSet.contains
---@param option number The option to check (bitmask)
---@return boolean True if the option is in the set
function OptionsSet:contains(option)
    return bit.band(self.value, option) == option
end

-- Method to remove an option
---@function OptionsSet.remove
---@param option number The option to remove (bitmask)
function OptionsSet:remove(option)
    self.value = bit.band(self.value, bit.bnot(option))
end

-- Predefined options
---@class Options
local Options = {
    File = 0x1,
    Module = 0x2,
    User = 0x4,
    Company = 0x8,
}

return {
    OptionsSet = OptionsSet,
    Options = Options,
}
