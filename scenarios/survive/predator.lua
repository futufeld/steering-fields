local TableUtils    = require('utils.class')
local Character     = require('core.character')
local Seek          = require('steering.seek')
local Pursue        = require('steering.pursue')

--- Defines a predator character.
local Predator = TableUtils.class(Character)

-- Predator implementation of function g(d).
local gx_default = function (ratio)
    return (1 - ratio)^2
end

-- Predator implementation of function h(d).
local hx_default = function (ratio)
    return ratio^0.5
end

-- Set the default collision avoidance profile of the predator.
Predator.params_gx = TableUtils.default(gx_default)
Predator.params_hx = TableUtils.default(hx_default)

-- Create predator-prey avoidance profile.
Predator.params_gx['prey'] = function (_) return 0 end

-- Set predator-specific attributes.
Predator.prediction = 0.25

--- Define predator state enumeration.
local PredatorState = {}
PredatorState.HUNT = 0
PredatorState.PURSUE = 1

-- Initialises Predator instance.
function Predator:init(colour, vehicle, sight_range, home)
    Character.init(self, colour, vehicle, sight_range)
    self.home_position = home
    self:set_hunt_state()
    self.knowledge = nil
end

--- Sets the state and behaviour of this predator to HUNT.
function Predator:set_hunt_state()
    self.vehicle:set_targets(0, 50, 50)
    self:set_steering(Seek, {self.home_position})
    self.state = PredatorState.HUNT
end

--- Sets the state and behaviour of this predator to PURSUE.
function Predator:set_pursue_state(prey)
    self.vehicle:set_targets(0, 200, 200)
    self:set_steering(Pursue, {prey, Predator.prediction})
    self.state = PredatorState.PURSUE
end

--- Defines the behaviour of this predator when it is in the HUNT state.
function Predator:hunt()
    local prey = self:sense_nearest('prey')
    if prey ~= nil then
        self:set_pursue_state(prey)
    end
end

--- Defines the behaviour of this predator when it is in the PURSUE state.
function Predator:pursue()
    local prey = self:sense_nearest('prey')
    if prey ~= nil then
        self:set_pursue_state(prey)
    else
        self:set_hunt_state()
    end
end

--- Updates the state of the predator.
function Predator:update(delta_time, entities)
    self.knowledge = entities

    if self.state == PredatorState.HUNT then
        self:hunt()
    elseif self.state == PredatorState.PURSUE then
        self:pursue()
    end

    self:move(delta_time, entities)
end


return Predator
