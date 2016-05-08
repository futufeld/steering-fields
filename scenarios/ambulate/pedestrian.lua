local TableUtils = require('utils.class')
local Character  = require('core.character')

-- Defines Pedestrian class.
local Pedestrian = TableUtils.class(Character)

-- Pedestrian implementation of function g(d).
local gx_default = function (ratio) return (1 - ratio)^2 end

-- Pedestrian implementation of function h(d).
local hx_default = function (ratio) return ratio^0.5 end

-- Set pedestrian collision avoidance profile.
Pedestrian.params_gx = TableUtils.default(gx_default)
Pedestrian.params_hx = TableUtils.default(hx_default)

-- Sets the character's perturbation alignment to its desired velocity.
function Pedestrian:alignment()
    return self.steering:desired_velocity(self.vehicle)
end

return Pedestrian
