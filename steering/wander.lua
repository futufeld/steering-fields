local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Seek       = require('steering.seek')

--- Implements the wander behaviour algorithm.
local Wander = TableUtils.class(Seek)

--- Initialises Wander class instances.
function Wander:init(distance, radius, jitter)
    Seek.init(self, Vector2())

    self.distance = distance
    self.radius = radius
    self.jitter = jitter

    self.offset = Vector2.random(radius)
end

--- Returns the wander desired velocity for 'vehicle'.
function Wander:desired_velocity(vehicle)
    local projected_centre = vehicle.heading * self.distance
    projected_centre = projected_centre + vehicle.position
    local jitter_vector = Vector2.random(math.random() * self.jitter)

    self.offset = (self.offset + jitter_vector):unit() * self.radius
    self.goal = projected_centre + self.offset

    return Seek.desired_velocity(self, vehicle)
end

return Wander
