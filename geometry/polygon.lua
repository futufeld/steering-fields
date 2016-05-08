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

--- Returns whether 'point' is inside this polygon.
function PolygonObstacle:is_inside(point)
    return GeometryUtils.is_inside_polygon(point, self.points)
end

--- Returns a pairwise iterator over the edges of this polygon.
function PolygonObstacle:iterator()
    return IteratorUtils.pairloop(self.points)
end

return PolygonObstacle
