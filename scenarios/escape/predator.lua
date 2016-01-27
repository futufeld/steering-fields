local TableUtils = require('utils.class')
local Character  = require('core.character')

-- Define Prey class.
local Predator = TableUtils.class(Character)

-- Predator implementation of function g(d).
local gx = function (ratio) return (1 - ratio)^2 end

-- Predator implementation of function h(d).
local hx = function (ratio) return ratio^0.5 end

-- Set predator collision avoidance profile.
Predator.params_gx = TableUtils.default(gx)
Predator.params_hx = TableUtils.default(hx)

-- Configure prey avoidance (or lack thereof).
Predator.params_gx['prey'] = function (ratio) return 0 end

return Predator
