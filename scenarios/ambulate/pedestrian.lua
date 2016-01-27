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

--- Initialises a Pedestrian instance.
function Pedestrian:init(colour, vehicle, sight_range, destination)
    Character.init(self, colour, vehicle, sight_range)
    self.destination = destination
end

--- Returns the orientation vector of the GAX field for this pedestrian.
function Pedestrian:orientation_vector()
    return (self.destination - self.vehicle.position):unit()
end

--- Returns the maximum avoidance distance of this character.
function Pedestrian:get_avoid_range()
    return self.vehicle.max_force * 2
end

return Pedestrian
