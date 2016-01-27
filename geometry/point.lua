local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')

--- Defines a point obstacle.
local PointObstacle = TableUtils.class()

--- Tests if given point is inside obstacle.
function PointObstacle:is_inside(point)
    local close_in_x = math.abs(point.x) < Vector2.DELTA
    local close_in_y = math.abs(point.y) < Vector2.DELTA
    return close_in_x and close_in_y
end

--- Determines projection of given point on obstacle.
function PointObstacle:projection(point)
    return Vector2()
end

--- Renders the obstacle.
function PointObstacle:draw()
    love.graphics.point(0, 0)
end

return PointObstacle
