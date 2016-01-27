local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')

--- Implements seek steering behaviour.
local Seek = TableUtils.class()

--- Initialises Seek class instances.
function Seek:init(vehicle, position)
    self.vehicle = vehicle
    self.position = position
end

--- Returns the desired velocity of the vehicle if it is to seek towards a
-- target position.
function Seek:desired_velocity()
    local offset = Seek.world:point(self.vehicle.position, self.position)
    local direction = (self.position + offset) - self.vehicle.position
    
    local distance = direction:len()
    if distance < Vector2.DELTA then
        return Vector2()
    end

    return direction * (self.vehicle.max_force / distance)
end

return Seek
