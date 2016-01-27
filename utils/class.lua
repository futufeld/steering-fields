-- Namespace for convenience functions that create specialised tables.
local TableUtils = {}

--- Creates a class-like table.
function TableUtils.class(parent)
    -- Support instancing on call.
    local call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then
            self:init(...)
        end
        return self
    end

    -- Create class table.
    local class = {}
    class.__index = class

    -- Create metatable.
    local mt = { __call = call, __index = parent }

    -- Bind and return metatable.
    return setmetatable(class, mt)
end

--- Creates a table with a default value for non-existent keys.
function TableUtils.default(default)
    local result = {}

    local key = {}
    local mt = { __index = function (t) return t[key] end }
    
    result[key] = default
    return setmetatable(result, mt)
end

return TableUtils