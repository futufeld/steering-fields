local TableUtils = require('utils.class')
local Vector2    = require('geometry.vector2')
local Seek       = require('steering.seek')

--- Implements the pursue behaviour algorithm.
local Pursue = TableUtils.class(Seek)

--- Initialises Pursue class instances.
function Pursue:init(target, max_prediction)
    Seek.init(self, Vector2())
    self.target = target
    self.max_prediction = max_prediction
end

--- Returns the pursue desired velocity for 'vehicle'.
function Pursue:desired_velocity(vehicle)
    -- Determine direction and distance to pursued vehicle.
    local offset = vehicle.space:offset( vehicle.position,
                                         self.target.position )
    local position = self.target.position + offset
    local distance = (position - vehicle.position):len()

    -- Predict how long it will take to reach the target.
    local prediction = self.max_prediction
    if vehicle.speed >= distance / self.max_prediction then
        prediction = distance / vehicle.speed
    end

    -- Set the goal point to the predicted position and invoke Seek.
    self.goal = self.target.position + self.target.velocity * prediction
    return Seek.desired_velocity(self, vehicle)
end

return Pursue
