local TableUtils = require('utils.class')

--- Defines a disk obstacle.
local DiskObstacle = TableUtils.class()

--- Initialises DiskObstacle instances.
function DiskObstacle:init(radius)
    self.radius = radius
end

--- Tests if given point is inside obstacle.
function DiskObstacle:is_inside(point)
    return point:len() <= self.radius
end

--- Determines projection of given point on obstacle.
function DiskObstacle:projection(point)
    return point:unit_safe(self.radius) * self.radius
end

--- Renders the obstacle.
function DiskObstacle:draw()
    love.graphics.circle('fill', 0, 0, self.radius, 25)
end

return DiskObstacle
