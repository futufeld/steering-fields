local TableUtils    = require('utils.class')
local GeometryUtils = require('geometry.utils.geometry')

--- Defines the base class for obstacles with multiple edges.
local PolyObstacle = TableUtils.class()

--- Initialises a PolyObstacle instances.
function PolyObstacle:init(points)
    self.points = points
    self.coordinates = {}
    for _, vector in pairs(self.points) do
        table.insert(self.coordinates, vector.x)
        table.insert(self.coordinates, vector.y)
    end
end

--- Determines the nearest point on this obstacle to 'point'.
function PolyObstacle:nearest(point)
    local closest_point = nil
    local closest_distance = 0

    local iterator = self:iterator()

    local v1, v2 = iterator()
    repeat
        local nearest_point = GeometryUtils.nearest_on_segment(point, v1, v2)

        if closest_point then
            local point_distance = (point - nearest_point):len()
            if point_distance < closest_distance then
                closest_distance = point_distance
                closest_point = nearest_point
            end
        else
            closest_point = nearest_point
            closest_distance = (point - nearest_point):len()
        end

        v1, v2 = iterator()
    until not (v1 or v2)

    return closest_point
end

return PolyObstacle
