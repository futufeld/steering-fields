local Vector2 = require('geometry.vector2')

-- Namespace for utility functions that aid the creation of scenarios.
local ScenarioHelpers = {}

--- Returns 'num' number of points spread around a virtual circle with the given
-- position and radius.
function ScenarioHelpers.radial_points(position, radius, num)
    local gap = (2 * math.pi) / num

    local points = {}
    for i = 1, num, 1 do
        local angle = (i - (0.25 * math.random() * 0.5)) * gap
        local vector = Vector2.from_angle(angle, radius)
        table.insert(points, position + vector)
    end
    return points
end

return ScenarioHelpers
