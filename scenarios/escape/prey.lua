local TableUtils = require('utils.class')
local Character  = require('core.character')

-- Define prey character.
local Prey = TableUtils.class(Character)

-- Prey implementation of function g(d).
local gx = function (ratio) return 0 end

-- Prey implementation of function h(d).
local hx = function (ratio) return 1 end

-- Set prey collision avoidance profile.
Prey.params_gx = TableUtils.default(gx)
Prey.params_hx = TableUtils.default(hx)

return Prey
