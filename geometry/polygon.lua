local TableUtils    = require('utils.class')
local PolyObstacle  = require('geometry.poly')
local IteratorUtils = require('utils.iterator')
local GeometryUtils = require('geometry.utils.geometry')

--- Defines a polygonal obstacle.
local PolygonObstacle = TableUtils.class(PolyObstacle)

--- Initialises PolygonObstacle instances.
function PolygonObstacle:init(points)
    PolyObstacle.init(self, points)
end

--- Tests if given point is inside obstacle.
function PolygonObstacle:is_inside(point)
    return GeometryUtils.is_inside_polygon(point, self.points)
end

--- Returns an iterator over the edges of this obstacle.
function PolygonObstacle:iterator()
    return IteratorUtils.pairloop(self.points)
end

--- Renders the obstacle.
function PolygonObstacle:draw()
    love.graphics.polygon('fill', self.coordinates)
end

return PolygonObstacle
