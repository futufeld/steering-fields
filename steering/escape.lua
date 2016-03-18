local TableUtils  = require('utils.class')
local Vector2     = require('geometry.vector2')
local VectorUtils = require('geometry.utils.vector')
local GAX         = require('steering.gax')
local Seek        = require('steering.seek')

--- Implements Escape steering behaviour.
local Escape = TableUtils.class(Seek)

--- Initialises Escape class instances.
function Escape:init(vehicle, pursuers)
    Seek.init(self, vehicle, Vector2())
    self.pursuers = pursuers
end

--- Escape-specific implementation for g(x).
function Escape.gx(ratio)
    return (1 - ratio)^2
end

--- Escape-specific implementation for h(x).
function Escape.hx(ratio)
    return ratio^0.5
end

--- Returns the desired velocity of the vehicle if it is to escape its
-- pursuers.
function Escape:desired_velocity()
    -- Determine evaluation point.
    local prediction = self.vehicle.velocity * 0.5
    local point = self.vehicle.position + prediction

    local max_distance = self.vehicle.max_force
    local align = self.vehicle.heading:unit()

    -- Initialise pursuer information.
    local potentials = {}
    self.position = Vector2()

    -- Calculate avoidance potentials.
    for _, pursuer in pairs(self.pursuers) do
        -- Evaluate potential.
        local potential = GAX.perturbation(
            point, pursuer, align, max_distance, Escape.gx, Escape.hx)

        -- Add non-null potential.
        if potential then
            table.insert(potentials, potential)
        end

        -- Add pursuer position to accumulated position.
        self.position = self.position + pursuer.position
    end

    -- Determine avoidance force.
    VectorUtils.sort_descending(potentials)
    local avoid = GAX.priority_cap(potentials, 1)

    -- Determine flee force.
    self.position = self.position / #self.pursuers
    local flee = -Seek.desired_velocity(self)

    -- Combine forces.
    local ratio = 1 - avoid:len()
    return avoid * self.vehicle.max_force + flee * ratio
end

return Escape
