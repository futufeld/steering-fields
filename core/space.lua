local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')

--- Represents a 'regular' game space.
local Regular = TableUtils.class()

--- Initialises Regular instances.
function Regular:init(width, height) end

--- Returns the offset of 'target' with respect to 'source'.
function Regular:offset(source, target)
    return Vector2()
end

--- Returns 'point' constrained to the bounds of the space.
function Regular:constrain(point)
    return point:copy()
end

--- Represents a toroidal game space.
local Toroidal = TableUtils.class()

--- Initialises Toroidal instances.
function Toroidal:init(width, height)
    self.width = width
    self.halfwidth = width / 2
    self.height = height
    self.halfheight = height / 2

    self.point_matrix = {}
    self.point_matrix[1] = Vector2(0, -height)
    self.point_matrix[2] = Vector2(width, 0)
    self.point_matrix[3] = Vector2(0, height)
    self.point_matrix[4] = Vector2(-width, 0)
end

--- Returns the offset of 'target' with respect to 'source'.
function Toroidal:offset(source, target)
    local min_offset = Vector2()
    local min_distance = (source - target):len()

    for _, offset in ipairs(self.point_matrix) do
        local distance = (source - (target + offset)):len()
        if distance < min_distance then
            min_distance = distance
            min_offset = offset
        end
    end
    return min_offset
end

--- Returns 'point' constrained to the bounds of the space.
function Toroidal:constrain(point)
    x = (point.x + self.halfwidth) % self.width - self.halfwidth
    y = (point.y + self.halfheight) % self.height - self.halfheight
    return Vector2(x, y)
end

return { Regular = Regular, Toroidal = Toroidal }
