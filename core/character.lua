local TableUtils    = require('utils.class')
local Vector2       = require('geometry.vector2')
local VectorUtils   = require('geometry.utils.vector')
local GAX           = require('steering.gax')
local FunctionUtils = require('utils.function')

--- Defines a character.
local Character = TableUtils.class()

--- Initialises Character class instances.
function Character:init(colour, vehicle, sight_range, offset)
    self.colour = colour
    self.vehicle = vehicle
    self.sight_range = sight_range
    self.offset = offset or 0
end

--- Sets this character's steering behaviour.
function Character:set_steering(behaviour, arg_table)
    self.steering = behaviour(self.vehicle, unpack(arg_table))
end

--- Returns the orientation vector of this character.
function Character:orientation_vector()
    return self.vehicle.heading:copy()
end

--- Returns the maximum avoidance distance of this character.
function Character:get_avoid_range()
    return self.vehicle.max_force
end

--- Returns the distance to which this character can see.
function Character:get_sight_range()
    return self.sight_range
end

--- Returns the potential at the position of this character's vehicle.
function Character:determine_potentials(obstacles)
    -- Determine evaluation point.
    local prediction = self.vehicle.velocity * 0.5
    local point = self.vehicle.position + prediction

    -- Set alignment.
    local align = self:orientation_vector()

    local potentials = {}
    for _, obstacle in pairs(obstacles) do

        -- If not avoiding self...
        if not (obstacle == self.vehicle) then

            -- Determine parameter functions.
            local gx = self.params_gx[obstacle.tag]
            local hx = self.params_hx[obstacle.tag]

            -- Evaluate potential.
            local potential = GAX.perturbation( point
                                              , obstacle
                                              , align
                                              , self:get_avoid_range()
                                              , gx
                                              , hx
                                              , self.offset )

            if potential then
                table.insert(potentials, potential)
            end
        end
    end

    VectorUtils.sort_descending(potentials)
    return potentials
end

--- Returns the steering force to apply to this character, including avoidance
-- of the given obstacles.
function Character:steering_force(obstacles)
    -- Determine collision avoidance force.
    local potentials = self:determine_potentials(obstacles)
    local avoidance = GAX.priority_cap(potentials, 1)

    -- Determine goal pursuit force.
    local pursuit = self.steering:desired_velocity()

    -- Combine steering pressures.
    avoidance = avoidance * self.vehicle.max_force
    local remaining = self.vehicle.max_force - avoidance:len()
    if pursuit:len() > remaining then
        pursuit = pursuit * (remaining / pursuit:len())
    end
    local desired_velocity = avoidance + pursuit

    -- Return steering force.
    return desired_velocity - self.vehicle.velocity
end

--- Applies a steering force to this character's vehicle.
function Character:move(delta_time, obstacles)
    self.vehicle:update(delta_time)
    local steering_force = self:steering_force(obstacles)
    self.vehicle:move(steering_force, delta_time)
end

--- Updates this character.
function Character:update(delta_time, entities)
    self:move(delta_time, entities)
end

--- Returns the distance of the given point from the position of this
-- character's vehicle.
function Character:distance(point)
    local offset = self.world:point(self.vehicle.position, point)
    return ((point + offset) - self.vehicle.position):len()
end

--- Returns whether this character can sense another character.
function Character:can_see(entity)
    return self:distance(entity.position) <= self.sight_range
end

--- Returns the entity with the given tag if it can be sensed by this
-- character.
function Character:sense(tag)
    for _, entity in ipairs(self.knowledge) do
        if Character.can_see(self, entity) then
            if entity.tag == tag then
                return entity
            end
        end
    end
    return nil
end

--- Returns whether the prey can sense anything with the given tag.
function Character:can_sense(tag)
    return self:sense(tag) ~= nil
end

--- Returns the nearest entity with the given tag if it can be sensed by this
-- character.
function Character:sense_nearest(tag)
    local nearest = nil
    local nearest_dist = 0

    for _, entity in ipairs(self.knowledge) do
        if self:can_see(entity) then
            if entity.tag == tag then
                
                -- Determine if entity is nearest thus far.
                local dist = self:distance(entity.position)
                if nearest == nil or dist < nearest_dist then
                    nearest = entity
                    nearest_dist = dist
                end
            end
        end
    end
    return nearest
end

--- Renders this character.
function Character:draw(colour)
    if colour then
        self.vehicle:draw(colour)
    else
        self.vehicle:draw(self.colour)
    end
end

return Character
