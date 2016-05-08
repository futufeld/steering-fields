local TableUtils    = require('utils.class')
local Obstacle      = require('core.obstacle')
local Vector2       = require('geometry.vector2')

--- Defines a movable obstacle that can be subject to forces.
local Vehicle = TableUtils.class(Obstacle)

-- Defines the time delta for predicting vehicles' positions in xetrov fields.
Vehicle.PREDICTION = 0.5

-- Defines the size of the window of past vehicle positions to maintain.
Vehicle.WINDOW = 4

--- Initialises Vehicle class instances.
function Vehicle:init(space, tag, position, geometry, max_force, max_speed)
    Obstacle.init(self, space, tag, position, geometry)

    self.mass = 1
    self.speed = 0
    self.velocity = Vector2()
    self.heading = Vector2.random(1)

    self:set_limits(max_force or 0, max_speed or 0)

    self.history = {}
end

--- Sets the maximum force and maximum speed of this vehicle.
function Vehicle:set_limits(max_force, max_speed)
    self.max_force = max_force
    self.max_speed = max_speed
end

--- Returns 'point' translated from world space to the vehicle's local space,
-- adjusted according to the vehicle's predicted position.
function Vehicle:localise(point)
    return point - (self.position + self.velocity * Vehicle.PREDICTION)
end

--- Returns 'point' translated from the vehicle's local space to world space,
-- adjusted according to the vehicle's predicted position.
function Vehicle:globalise(point)
    return point + (self.position + self.velocity * Vehicle.PREDICTION)
end

--- Moves the vehicle by applying 'steering_force' for 'delta_time' duration.
function Vehicle:move(steering_force, delta_time)

    -- Determine acceleration.
    local magnitude = steering_force:len()
    if magnitude > self.max_force then
        steering_force = steering_force * (self.max_force / magnitude)
    end
    local acceleration = steering_force / self.mass

    -- Update velocity.
    self.velocity = self.velocity + acceleration * delta_time
    self.speed = self.velocity:len()
    if self.speed > self.max_speed then
        self.velocity = self.velocity * (self.max_speed / self.speed)
        self.speed = self.max_speed
    end

    -- Update position and heading.
    self.position = self.position + self.velocity * delta_time
    self.position = self.space:constrain(self.position)
    if self.speed > 0 then self.heading = self.velocity / self.speed end

    -- Update history.
    if #self.history > Vehicle.WINDOW then table.remove(self.history, 1) end
    table.insert(self.history, self.position:copy())
end

return Vehicle
