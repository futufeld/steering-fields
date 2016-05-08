local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Seek       = require('steering.seek')

--- Implements the flock behaviour algorithm.
local Flock = TableUtils.class(Seek)

--- Initialises Flock class instances.
-- For the sake of simplicity, this implementation does not enable boids to
-- sense each other. Instead, each boid has explicit knowledge of its flock.
function Flock:init(flockmates)
    Seek.init(self, Vector2())
    self.flockmates = flockmates
end

--- Returns the flock desired velocity for 'vehicle'.
function Flock:desired_velocity(vehicle)
    -- Set accumulators.
    self.goal = Vector2()
    local heading = Vector2()

    -- Accumulate flock positions and headings.
    for _, flockmate in pairs(self.flockmates) do
        if flockmate ~= vehicle then
            local offset = vehicle.space:offset(
                vehicle.position, flockmate.position)
            self.goal = self.goal + flockmate.position + offset
            heading = heading + flockmate.heading
        end
    end

    -- Normalise flock position and heading.
    self.goal = self.goal / #self.flockmates
    heading = heading / #self.flockmates

    -- Determine cohesion and alignment.
    cohesion = Seek.desired_velocity(self, vehicle)
    alignment = heading * vehicle.max_force

    -- Combine cohesion and alignment in 1:2 ratio.
    return cohesion * 0.34 + alignment * 0.66
end

return Flock
