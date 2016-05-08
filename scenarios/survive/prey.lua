local TableUtils = require('utils.class')
local Character  = require('core.character')
local Seek       = require('steering.seek')
local Wander     = require('steering.wander')
local Escape     = require('steering.escape')

--- Defines a prey character.
local Prey = TableUtils.class(Character)

-- Prey implementation of function g(d).
local gx_default = function (ratio) return (1 - ratio)^2 end

-- Prey implementation of function h(d).
local hx_default = function (ratio) return ratio^0.5 end

-- Set the collision avoidance profile of the prey character.
Prey.params_gx = TableUtils.default(gx_default)
Prey.params_hx = TableUtils.default(hx_default)

-- Set prey-specific attributes.
Prey.HOME_RANGE = 100
Prey.SIGHT_RANGE = 150

--- Define prey state enumeration.
local PreyState = { FORAGE = 0, ESCAPE = 1, HOME = 2 }

-- Initialises a Prey instance.
function Prey:init(vehicle, home)
    Character.init(self, vehicle)
    self.home_position = home
    self:set_forage_state()
    self.knowledge = nil
end

--- Sets the state and behaviour of this prey to FORAGE.
function Prey:set_forage_state()
    self.vehicle:set_limits(75, 75)
    self.steering = Wander(75, 50, 10)
    self.state = PreyState.FORAGE
end

--- Sets the state and behaviour of this prey to ESCAPE.
function Prey:set_escape_state(predator)
    self.vehicle:set_limits(150, 150)
    self.steering = Escape({predator})
    self.state = PreyState.ESCAPE
end

--- Sets the state and behaviour of this prey to HOME.
function Prey:set_home_state()
    self.vehicle:set_limits(75, 75)
    self.steering = Seek(self.home_position)
    self.state = PreyState.HOME
end

--- Defines behaviour of this prey when in the FORAGE state.
function Prey:forage()
    local predator = self:sense_nearest('character2')
    if predator ~= nil then
        self:set_escape_state(predator)
    else
        if self:distance(self.home_position) > Prey.HOME_RANGE + 75 then
            self:set_home_state()
        end
    end
end

--- Defines behaviour of this prey when in the ESCAPE state.
function Prey:escape()
    if not self:can_sense('character2') then
        self:set_home_state()
    end
end

--- Defines behaviour of this prey when in the HOME state.
function Prey:home()
    local predator = self:sense_nearest('character2')
    if predator ~= nil then
        self:set_escape_state(predator)
    else
        if self:distance(self.home_position) < Prey.HOME_RANGE then
            self:set_forage_state()
        end
    end
end

--- Updates the state of the character.
function Prey:update(delta_time, entities)
    self.knowledge = entities

    if self.state == PreyState.FORAGE then
        self:forage()
    elseif self.state == PreyState.ESCAPE then
        self:escape()
    elseif self.state == PreyState.HOME then
        self:home()
    end

    Character.update(self, delta_time, entities)
end

--- Returns whether this character can see 'entity'.
function Prey:can_see(entity)
    return self:distance(entity.position) < Prey.SIGHT_RANGE
end

return Prey
