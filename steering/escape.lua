local TableUtils  = require('utils.class')
local Vector2     = require('geometry.vector2')
local Xetrov      = require('steering.xetrov')
local Seek        = require('steering.seek')

--- Implements the escape behaviour algorithm.
local Escape = TableUtils.class(Seek)

--- Initialises Escape class instances.
function Escape:init(pursuers)
    Seek.init(self, Vector2())
    self.pursuers = pursuers
end

--- Escape-specific implementation of g(d).
function Escape.gx(ratio) return (1 - ratio)^2 end

--- Escape-specific implementation of h(d).
function Escape.hx(ratio) return ratio^0.5 end

--- Returns the escape desired velocity for 'vehicle'.
function Escape:desired_velocity(vehicle)
    -- Determine the point at which to evaluate the pursuer-only field.
    local prediction = vehicle.velocity * 0.5
    local point = vehicle.position + prediction

    local range = vehicle.max_speed
    local align = vehicle.heading

    -- Initialise pursuer information.
    local potentials = {}
    self.goal = Vector2()

    for _, pursuer in pairs(self.pursuers) do
        -- Evaluate the potential produced by the pursuer.
        local source = pursuer:source(point)
        local potential = Xetrov.perturbation(vehicle.space, point,
            source, align, range, Escape.gx, Escape.hx)
        if potential then table.insert(potentials, potential) end

        -- Add the pursuer's position to accumulated position.
        self.goal = self.goal + pursuer.position
    end

    -- Determine the desired velocity for fleeing the pursuers' mean position.
    self.goal = self.goal / #self.pursuers
    local desired = -Seek.desired_velocity(self, vehicle)

    -- Combine flee desired velocity with the xetrov field desired velocity.
    local avoidance = Xetrov.field(potentials) * vehicle.max_force
    return avoidance + desired * (vehicle.max_force - avoidance:len())
end

return Escape
