local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Seek       = require('steering.seek')

--- Implements Flock steering behaviour.
local Flock = TableUtils.class(Seek)

--- Initialises Flock class instances.
function Flock:init(vehicle, flockmates)
    Seek.init(self, vehicle, Vector2())
    self.flockmates = flockmates
end

--- Returns the desired velocity of the vehicle if it is to flock with its
-- flockmates.
function Flock:desired_velocity()
    -- Set accumulators.
    self.position = Vector2()
    local heading = Vector2()
    
    -- Accumulate flock positions and headings.
    for _, flockmate in pairs(self.flockmates) do
        self.position = self.position + flockmate.vehicle.position
        heading = heading + flockmate.vehicle.heading
    end

    -- Normalise flock position and heading.
    self.position = self.position / #self.flockmates
    heading = heading / #self.flockmates
    
    -- Determine cohesion and alignment.
    cohesion = Seek.desired_velocity(self)
    alignment = heading * self.vehicle.max_force

    -- Combine cohesion and alignment in 1:2 ratio.
    return cohesion * 0.34 + alignment * 0.66
end

return Flock
