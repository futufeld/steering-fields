-- Namespace for iterator functionality.
local IteratorUtils = {}

--- Returns a function that returns pairs of consecutive elements in the given
-- array.
function IteratorUtils.pairwise(array)
    local index = 0
    local count = #array
    return function ()
            index = index + 1
            if index < count then
                return array[index], array[index+1]
            end
        end
end

--- Like 'pairwise', but treats the given array as a loop.
function IteratorUtils.pairloop(array)
    local index = 0
    local count = #array
    return function ()
            index = index + 1
            if index < count then
                return array[index], array[index+1]
            else
                if index == count then
                    return array[count], array[1]
                end
            end
        end
end

return IteratorUtils
