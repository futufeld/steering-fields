-- Namespace for GAX functionality.
local FunctionUtils = {}

--- Returns an array of func applied to ever element in array.

--- Returns an array containing each element of the given array with 'func'
-- applied to each element.
function FunctionUtils.map(func, array)
    local new_list = {}
    for key, value in pairs(array) do
        new_list[key] = func(value)
    end
    return new_list
end

--- Applies 'func' to each element of the given array.
function FunctionUtils.imap(func, array)
    for key, value in pairs(array) do
        array[key] = func(value)
    end
end

--- Returns a copy of the given array omitting each element for which 'func'
-- returns false.
function FunctionUtils.filter(func, array)
    local new_list = {}
    for _, value in ipairs(array) do
        if func(value) then
            table.insert(new_list, value)
        end
    end
    return new_list
end

--- Returns true if there are any elements in the given array for which 'func'
-- returns true.
function FunctionUtils.any(func, array)
    for _, value in pairs(array) do
        if func(value) then
            return true
        end
    end
    return false
end

--- Returns true if 'func' returns true for every element in the given array.
function FunctionUtils.all(func, array)
    for _, value in pairs(array) do
        if not func(value) then
            return false
        end
    end
    return true
end

--- Groups all elements in the given array that produce the same value when
-- evaluated using 'func'.
function FunctionUtils.bucket(func, array)
    local buckets = {}
    for key, value in pairs(array) do
        local label = func(value)
        
        if buckets[label] then
            table.insert(buckets[label], value)
        else
            buckets[label] = { value }
        end
    end
    return buckets
end

return FunctionUtils
