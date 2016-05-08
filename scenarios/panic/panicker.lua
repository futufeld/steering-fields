local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Character  = require('core.character')

-- Define a character that panics.
local Panicker = TableUtils.class(Character)

-- Panic character implementation of function g(d).
local gx = function (ratio) return (1-ratio)^2 end

-- Panic character implementation of function h(d).
local hx = function (ratio) return ratio^0.5 end

-- Set panic character collision avoidance profile.
Panicker.params_gx = TableUtils.default(gx)
Panicker.params_hx = TableUtils.default(hx)

-- Sets the character's perturbation alignment to its desired velocity.
function Panicker:alignment()
    return self.steering:desired_velocity(self.vehicle)
end

return Panicker
