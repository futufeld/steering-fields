local TableUtils    = require('utils.class')
local Obstacle      = require('core.obstacle')
local Vector2       = require('geometry.vector2')
local VectorUtils   = require('geometry.utils.vector')
local FunctionUtils = require('utils.function')

--- Defines a movable obstacle that can be subject to forces.
local Vehicle = TableUtils.class(Obstacle)

-- Defines the offset by time, in terms of velocity, that is applied when
-- transforming points between world and local space.
Vehicle.OFFSET_FACTOR = 0.5

-- Defines the number of positions to be retained in position history.
Vehicle.POSITION_WINDOW = 10

--- Initialises Vehicle class instances.
function Vehicle:init(tag, position, geometry)
    Obstacle.init(self, tag, position, geometry)

    -- Set defaults.
    self.max_force = 0
    self.max_speed = 0
    self.velocity = Vector2()
    self.mass = 1

    -- Set internal fields.
    self.speed = self.velocity:len()
    if self.speed > 0 then
        self.heading = self.velocity / self.speed
    else
        self.heading = Vector2.random(1)
    end

    -- Set kinematic targets.
    self:set_targets(100, self.max_force, self.max_speed)

    -- Set display information.
    self.position_history = {}
    for index = 0,Vehicle.POSITION_WINDOW,1 do
        self.position_history[index] = nil
    end
    self.index = 1
    self.position_history[self.index] = self.position:copy()

    self.draw_tail = true
end

--- Transforms the given point in world space to the local space of the vehicle.
function Vehicle:localise(point)
    return point - (self.position + self.velocity * Vehicle.OFFSET_FACTOR)
end

--- Transforms the given point in the local space of the vehicle to global
-- space.
function Vehicle:globalise(point)
    return point + (self.position + self.velocity * Vehicle.OFFSET_FACTOR)
end

--- Sets the maximum speed and force that can be applied to the vehicle.
-- Parameter 'rate' defines how quickly (per second) the vehicle will
-- transition from its current maximum force and speed to the new limits.
function Vehicle:set_targets(rate, target_force, target_speed)
    self.rate = rate
    if rate == 0 then
        self.target_force = target_force
        self.target_speed = target_speed
        self.max_force = target_force
        self.max_speed = target_speed
    end
    self.target_force = target_force
    self.target_speed = target_speed
end

--- Updates the maximum force and maximum speed that can be experienced by the
-- vehicle.
function Vehicle:update(delta_time)
    local change = self.rate * delta_time

    if self.max_force > self.target_force then
        self.max_force = math.max(self.max_force - change, self.target_force)
    else
        self.max_force = math.min(self.max_force + change, self.target_force)
    end

    if self.max_speed > self.target_speed then
        self.max_speed = math.max(self.max_speed - change, self.target_speed)
    else
        self.max_speed = math.min(self.max_speed + change, self.target_speed)
    end
end

--- Moves the vehicle by applying the given steering force for 'delta_time'
-- duration.
function Vehicle:move(steering_force, delta_time)
    -- Constrain force to maximum.
    local magnitude = steering_force:len()
    if magnitude > self.max_force then
        steering_force = steering_force * (self.max_force / magnitude)
    end

    -- Determine acceleration.
    local acceleration = steering_force / self.mass

    -- Update velocity.
    self.velocity = self.velocity + acceleration * delta_time

    -- Constrain speed to maximum.
    self.speed = self.velocity:len()
    if self.speed > self.max_speed then

        self.velocity = self.velocity * (self.max_speed / self.speed)
    end

    -- Update position.
    self.position = self.position + self.velocity * delta_time
    self.position = self.world:constrain(self.position)
    
    -- Update kinematic properties.
    self.speed = self.velocity:len()
    if self.speed > 0 then
        self.heading = self.velocity / self.speed
    end

    -- Index position.
    self.index = self.index + 1
    local history_index = self.index % Vehicle.POSITION_WINDOW
    self.position_history[history_index + 1] = self.position:copy()
end

--- Renders the vehicle in the given colour.
function Vehicle:draw(colour)
    -- Draw vehicle tail.
    if self.draw_tail and self.index > Vehicle.POSITION_WINDOW then
        
        for index = 1,Vehicle.POSITION_WINDOW-1,1 do

            local history_index = (self.index - index) % Vehicle.POSITION_WINDOW
            self.position = self.position_history[history_index + 1]

            local faded_colour = FunctionUtils.map(function (_) return _ end, colour)
            local age_ratio = 1 - index / (Vehicle.POSITION_WINDOW-1)
            faded_colour[4] = math.floor(age_ratio * 255 * 0.25)

            love.graphics.setColor(faded_colour)
            Obstacle.draw(self)         
        end

        local history_index = self.index % Vehicle.POSITION_WINDOW
        self.position = self.position_history[history_index + 1]
    end

    -- Draw vehicle.
    love.graphics.setColor(colour)
    Obstacle.draw(self)
end

return Vehicle
