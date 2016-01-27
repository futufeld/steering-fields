
local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Seek       = require('steering.seek')

--- Implements Pursue steering behaviour.
local Pursue = TableUtils.class(Seek)

--- Initialises Pursue class instances.
function Pursue:init(vehicle, target, max_prediction)
    Seek.init(self, vehicle, Vector2())

    self.target = target
    self.max_prediction = max_prediction
end

--- Returns the desired velocity of the vehicle if it is to pursue its target.
function Pursue:desired_velocity()
    -- Determine direction and distance to pursued vehicle.
    local offset = Pursue.world:point( self.vehicle.position
                                     , self.target.position )
    local direction = (self.target.position+offset) - self.vehicle.position
    local distance = direction:len()

    -- Predict how long it will take to close the gap to that vehicle.
    local prediction = self.max_prediction
    if self.vehicle.speed >= distance / self.max_prediction then
        prediction = distance / self.vehicle.speed
    end

    -- Offset seek position and seek towards it.
    local factor = self.target.velocity * prediction
    self.position = self.target.position + factor
    return Seek.desired_velocity(self)
end

return Pursue
