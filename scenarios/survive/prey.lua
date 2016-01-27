local TableUtils = require('utils.class')
local Character  = require('core.character')
local Seek       = require('steering.seek')
local Wander     = require('steering.wander')
local Escape     = require('steering.escape')

--- Defines a prey character.
local Prey = TableUtils.class(Character)

-- Prey implementation of function g(d).
local gx_default = function (ratio)
    return 1 - ratio
end

-- Prey implementation of function h(d).
local hx_default = function (ratio)
    return ratio^0.5
end

-- Set the collision avoidance profile of the prey character.
Prey.params_gx = TableUtils.default(gx_default)
Prey.params_hx = TableUtils.default(hx_default)

-- Set prey-specific attributes.
Prey.sight_distance = 150
Prey.home_range = 100

--- Define prey state enumeration.
local PreyState = {}
PreyState.FORAGE = 0
PreyState.ESCAPE = 1
PreyState.HOME   = 2

-- Initialises a Prey instance.
function Prey:init(colour, vehicle, sight_range, home)
    Character.init(self, colour, vehicle, sight_range)
    self.home_position = home
    self:set_forage_state()
    self.knowledge = nil
end

--- Returns the prey's distance from its home.
function Prey:home_distance()
    return (self.vehicle.position - self.home_position):len()
end

--- Sets the state and behaviour of this prey to FORAGE.
function Prey:set_forage_state()
    self.vehicle:set_targets(0, 75, 75)
    self:set_steering(Wander, {75, 50, 10})
    self.state = PreyState.FORAGE
end

--- Sets the state and behaviour of this prey to ESCAPE.
function Prey:set_escape_state(predator)
    self.vehicle:set_targets(0, 150, 150)
    self:set_steering(Escape, {{predator}})
    self.state = PreyState.ESCAPE
end

--- Sets the state and behaviour of this prey to HOME.
function Prey:set_home_state()
    self.vehicle:set_targets(0, 75, 75)
    self:set_steering(Seek, {self.home_position})
    self.state = PreyState.HOME
end

--- Defines behaviour of this prey when in the FORAGE state.
function Prey:forage()
    if self:home_distance() > Prey.home_range + 75 then
        self:set_home_state()
    end

    local predator = self:sense('predator')
    if predator ~= nil then
        self:set_escape_state(predator)
    end
end

--- Defines behaviour of this prey when in the ESCAPE state.
function Prey:escape()
    if not self:can_sense('predator') then
        self:set_home_state()
    end
end

--- Defines behaviour of this prey when in the HOME state.
function Prey:home()
    if self:home_distance() < Prey.home_range then
        self:set_forage_state()
    end
    
    local predator = self:sense('predator')
    if predator ~= nil then
        self:set_escape_state(predator)
    end
end

--- Updates the state of the character.
function Prey:update(delta_time, entities)
    self.knowledge = entities

    if self.state == PreyState.FORAGE then
        self:forage()
    end
    if self.state == PreyState.ESCAPE then
        self:escape()
    end
    if self.state == PreyState.HOME then
        self:home()
    end

    self:move(delta_time, entities)
end

return Prey
