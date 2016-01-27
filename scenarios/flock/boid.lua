local TableUtils = require('utils.class')
local Character  = require('core.character')

-- Defines a boid character.
local Boid = TableUtils.class(Character)

-- Boid implementation of function g(d).
local gx = function (ratio) return (1 - ratio)^2 end

-- Boid implementation of function h(d).
local hx = function (ratio) return ratio^0.5 end

-- Set boid collision avoidance profile.
Boid.params_gx = TableUtils.default(gx)
Boid.params_hx = TableUtils.default(hx)

return Boid
