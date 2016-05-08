local TableUtils = require('utils.class')
local Xetrov     = require('steering.xetrov')
local Vehicle    = require('core.vehicle')

--- Defines a character.
local Character = TableUtils.class()

--- Initialises Character class instances.
function Character:init(vehicle, offset)
    self.vehicle = vehicle
    self.offset = offset or 0
end

--- Sets the alignment of the character.
function Character:alignment()
    return self.vehicle.heading
end

--- Returns the potential at the position of this character's vehicle.
function Character:determine_potentials(obstacles)
    -- Determine the point at which to evaluate the xetrov field.
    local prediction = self.vehicle.velocity * Vehicle.PREDICTION
    local point = self.vehicle.position + prediction

    -- Set perturbation alignment and range.
    local space = self.vehicle.space
    local range = self.vehicle.max_speed

    -- Evaluate potentials.
    local potentials = {}
    for _, obstacle in pairs(obstacles) do
        if not (obstacle == self.vehicle) then

            -- Select parameter functions according to obstacle tag.
            local gx = self.params_gx[obstacle.tag]
            local hx = self.params_hx[obstacle.tag]

            -- Evaluate the potential corresponding to the obstacle.
            local source = obstacle:source(point)
            local potential = Xetrov.perturbation(space, point, source,
                self:alignment(), range, gx, hx, self.offset)
            if potential then table.insert(potentials, potential) end
        end
    end
    return potentials
end

--- Returns the steering force to apply to this character's vehicle.
function Character:steering_force(obstacles)
    -- Determine collision avoidance and goal pursuit desired velocities.
    local potentials = self:determine_potentials(obstacles)
    local avoidance = Xetrov.field(potentials)
    local pursuit = self.steering:desired_velocity(self.vehicle)

    -- Combine desired velocities into a steering field.
    avoidance = avoidance * self.vehicle.max_force
    local remaining = self.vehicle.max_force - avoidance:len()
    if pursuit:len() > remaining then
        pursuit = pursuit * (remaining / pursuit:len())
    end

    -- Return the force required to match desired and actual velocities.
    return avoidance + pursuit - self.vehicle.velocity
end

--- Applies a steering force to this character's vehicle.
function Character:update(delta_time, entities)
    self.vehicle:move(self:steering_force(entities), delta_time)
end

--- Returns the distance between this character and 'point'.
function Character:distance(point)
    local offset = self.vehicle.space:offset(self.vehicle.position, point)
    return ((point + offset) - self.vehicle.position):len()
end

--- Returns whether this character can see 'entity'.
function Character:can_see(entity)
    return false
end

--- Returns a list of detected entities that match 'tag'.
function Character:sense(tag)
    local sensed = {}
    for _, entity in ipairs(self.knowledge) do
        if entity.tag == tag and self:can_see(entity) then
            table.insert(sensed, entity)
        end
    end
    return sensed
end

--- Returns whether the character can detect any entity that matches 'tag'.
function Character:can_sense(tag)
    return #self:sense(tag) ~= 0
end

--- Returns the nearest detected entity that matches 'tag'.
function Character:sense_nearest(tag)
    local sensed = self:sense(tag)
    local nearest = { entity = nil, distance = 0 }

    for _, entity in ipairs(sensed) do
        local distance = (self.vehicle.position - entity.position):len()
        if nearest.entity == nil or distance < nearest.distance then
            nearest = { entity = entity, distance = distance }
        end
    end
    return nearest.entity
end

return Character
