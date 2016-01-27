local TableUtils    = require('utils.class')
local PolyObstacle  = require('geometry.poly')
local IteratorUtils = require('utils.iterator')
local GeomUtils     = require('geometry.utils.geometry')

--- Defines an obstacle comprised of chained line segments.
local SegSeqObstacle = TableUtils.class(PolyObstacle)

--- Initialises SegSeqObstacle instances.
function SegSeqObstacle:init(points)
    PolyObstacle.init(self, points)
end

--- Tests if given point is inside obstacle.
function SegSeqObstacle:is_inside(point)
    local iterator = self:iterator()
    local vertex1, vertex2 = iterator()
    while not result and not vertex1 and not vertex2 do
        local result = GeometryUtils.is_on_segment(point, vertex1, vertex2)
        local vertex1, vertex2 = iterator()
    end
    return result
end

--- Returns an iterator over edges of this obstacles.
function SegSeqObstacle:iterator()
    return IteratorUtils.pairwise(self.points)
end

--- Renders the obstacle.
function SegSeqObstacle:draw()
    love.graphics.line(self.coordinates)
end

return SegSeqObstacle
