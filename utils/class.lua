-- Namespace for convenience functions that create specialised tables.
local TableUtils = {}

--- Creates a class-like table.
function TableUtils.class(parent)
    -- Support instancing on call.
    local call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then self:init(...) end
        return self
    end

    -- Create class table.
    local class = {}
    class.__index = class
    local mt = { __call = call, __index = parent }
    return setmetatable(class, mt)
end

--- Creates a table that returns a default value for non-existent keys.
function TableUtils.default(default)
    local key = {}
    local result = {}
    result[key] = default
    local mt = {__index = function (t) return t[key] end}
    return setmetatable(result, mt)
end

return TableUtils
