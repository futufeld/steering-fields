local Vector2       = require('geometry.vector2')
local FunctionUtils = require('utils.function')

--- Namespace for VectorUtils functionality.
local VectorUtils = {}

--- Accepts an array of vectors and returns a new array containing a copy of
-- every vector in the given array.
function VectorUtils.copy_vectors(vector_array)
    local copy_array = {}
    for _, vector in pairs(vector_array) do
        table.insert(copy_array, vector:copy())
    end
    return copy_array
end

--- Accepts an array of vectors and returns a new array containing the x and y
-- values of each vector; i.e. [(x1, y1), (x2, y2)] -> [x1, y1, x2, y2].
function VectorUtils.coordinates(vector_array)
    local coordinates = {}
    for _, vector in pairs(vector_array) do
        table.insert(coordinates, vector.x)
        table.insert(coordinates, vector.y)
    end
    return coordinates
end

-- Sorts the given array of vectors in ascending order by magnitude.
function VectorUtils.sort_ascending(vector_array)
    comparator = function (vector1, vector2)
        return vector1:len() < vector2:len()
    end
    table.sort(vector_array, comparator)
end

-- Sorts the given array of vectors in descending order by magnitude.
function VectorUtils.sort_descending(vector_array)
    comparator = function (vector1, vector2)
        return vector1:len() > vector2:len()
    end
    table.sort(vector_array, comparator)
end

return VectorUtils
