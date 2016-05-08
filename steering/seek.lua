local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')

--- Implements the seek behaviour algorithm.
local Seek = TableUtils.class()

--- Initialises Seek class instances.
function Seek:init(position)
    self.goal = position
end

--- Returns the seek desired velocity for 'vehicle'.
function Seek:desired_velocity(vehicle)
    local offset = vehicle.space:offset(vehicle.position, self.goal)
    local direction = (self.goal + offset) - vehicle.position

    local distance = direction:len()
    if distance < 1e-5 then return Vector2() end
    return direction * (vehicle.max_force / distance)
end

return Seek
