local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Seek       = require('steering.seek')

--- Implements wander steering behaviour.
local Wander = TableUtils.class(Seek)

--- Initialises Wander class instances.
function Wander:init(vehicle, distance, radius, jitter)
    Seek.init(self, vehicle, Vector2())

    self.distance = distance
    self.radius = radius
    self.jitter = jitter

    self.offset = Vector2.random(radius)
end

--- Returns the desired velocity of the vehicle if it is to wander aimlessly.
function Wander:desired_velocity()
    local projected_centre = self.vehicle.heading * self.distance
    projected_centre = projected_centre + self.vehicle.position
    local jitter_vector = Vector2.random(math.random() * self.jitter)
    
    self.offset = (self.offset + jitter_vector):unit() * self.radius
    self.point = projected_centre + self.offset

    return Seek.desired_velocity(self)
end

return Wander
