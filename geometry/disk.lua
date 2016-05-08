local TableUtils = require('utils.class')

--- Defines a disk obstacle.
local DiskObstacle = TableUtils.class()

--- Initialises DiskObstacle instances.
function DiskObstacle:init(radius)
    self.radius = radius
end

--- Returns whether 'point' is inside this disk.
function DiskObstacle:is_inside(point)
    return point:len() <= self.radius
end

--- Returns the nearest point on this disk to 'point'.
function DiskObstacle:nearest(point)
    return point:unit() * self.radius
end

return DiskObstacle
