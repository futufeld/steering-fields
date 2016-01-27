local TableUtils = require('utils.class')

--- Defines a circular obstacle.
local CircleObstacle = TableUtils.class()

--- Initialises CircleObstacle instances.
function CircleObstacle:init(radius)
    self.radius = radius
end

--- Tests if given point is inside obstacle.
function CircleObstacle:is_inside(point)
    return math.abs(point:len() - self.radius) < 1e-5
end

--- Determines projection of given point on obstacle.
function CircleObstacle:projection(point)
    return point:unit_safe(self.radius) * self.radius
end

--- Renders the obstacle.
function CircleObstacle:draw()
    love.graphics.circle('line', 0, 0, self.radius, 25)
end

return CircleObstacle
