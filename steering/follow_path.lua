local TableUtils    = require('utils.class')
local Vector2       = require('geometry.vector2')
local GeometryUtils = require('geometry.utils.geometry')
local Seek          = require('steering.seek')

--- Implements a simple version of the 'follow path' behaviour algorithm for
-- a path that consists of one edge.
local FollowPath = TableUtils.class(Seek)

--- Initialises FollowPath class instances.
function FollowPath:init(endpoint1, endpoint2, offset)
    Seek.init(self, Vector2())
    self.endpoint1 = endpoint1
    self.endpoint2 = endpoint2
    self.direction = (self.endpoint2 - self.endpoint1):unit()
    self.offset = offset
end

--- Returns the follow-path desired velocity for 'vehicle'.
function FollowPath:desired_velocity(vehicle)
    -- Determine nearest point on ray.
    self.goal = GeometryUtils.nearest_on_line(
        vehicle.position, self.endpoint1, self.endpoint2)

    -- Steer towards offset point.
    self.goal = self.goal + self.direction * self.offset
    return Seek.desired_velocity(self, vehicle)
end

return FollowPath
