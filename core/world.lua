local TableUtils    = require('utils.class')
local Vector2       = require('geometry.vector2')
local Vehicle       = require('core.vehicle')
local FunctionUtils = require('utils.function')
local ColourCodes   = require('visual.colours')

--- Representation of game world.
local World = TableUtils.class()

--- Initialises World instances. If 'toroidal' is true, the world instance is
-- a toroidal space.
function World:init(toroidal, width, height, scale)
    self.width = width
    self.height = height

    self.obstacles = {}
    self.vehicles = {}
    self.characters = {}

    -- configure presentation
    self.scale = scale or Vector2(1, 1)
    self.camera = Vector2(width / 2, height / 2)

    -- configure data for implementing toroidal space
    self.toroidal = toroidal

    if self.toroidal then
        self.point_matrix = {}

        self.point_matrix[1] = Vector2(0, -height)
        self.point_matrix[2] = Vector2(width, 0)
        self.point_matrix[3] = Vector2(0, height)
        self.point_matrix[4] = Vector2(-width, 0)
    end
end

--- Returns the position of 'target' with respect to 'source' assuming a
-- toroidal representation of space.
function World:point(source, target)
    if not self.toroidal then
        return Vector2()
    end

    local min_offset = Vector2()
    local min_distance = (source - target):len_sq()

    for _, offset in ipairs(self.point_matrix) do
        local mapped = target + offset
        local distance = (source - mapped):len_sq()

        if distance < min_distance then
            min_offset = offset
            min_distance = distance
        end
    end
    return min_offset
end

--- Constrains positions to the bounds of the game world.
function World:constrain(point)
    if not self.toroidal then
        return point:copy()
    end

    local x = point.x + self.camera.x
    local y = point.y + self.camera.y

    x = x % self.width - self.camera.x
    y = y % self.height - self.camera.y

    return Vector2(x, y)
end

--- Adds an obstacle to the game world.
function World:add_obstacle(obstacle)
    table.insert(self.obstacles, obstacle)
    obstacle.world = self
end

--- Adds a character to the game world.
function World:add_character(character)
    table.insert(self.vehicles, character.vehicle)
    table.insert(self.characters, character)
    character.vehicle.world = self
    character.world = self
end

--- Updates the state of all characters in the game world.
function World:update(delta_time)
    for _, character in ipairs(self.characters) do
        local position = character.vehicle.position
        local distance = character:get_sight_range()

        -- Identify near vehicles.
        local near_obstacles = {}
        for _, object in pairs(self.vehicles) do
            if object ~= character.vehicle then
                local offset = self:point(position, object.position)
                local pt = object.position + offset

                if (pt - position):len() < distance then
                    table.insert(near_obstacles, object)
                end
            end
        end

        -- Identify near obstacles.
        for _, object in pairs(self.obstacles) do
            table.insert(near_obstacles, object)
        end

        character:update(delta_time, near_obstacles)
    end
end

--- Determines if a character is colliding with any object in the world.
function World:is_colliding(character)
    local vehicle = character.vehicle
    local point = vehicle.position

    -- Store vehicle prediction then disable it.
    local offset = Vehicle.OFFSET_FACTOR
    Vehicle.OFFSET_FACTOR = 0

    -- Create collision test function.
    local test_collision = function (obstacle)
        local source = obstacle:source(point)
        if vehicle:is_inside(source) then
            if not (vehicle == obstacle) then
                return true
            end
        end
        return false
    end

    -- Test obstacle collision.
    local collision = FunctionUtils.any(test_collision, self.obstacles)
    if not collision then
        collision = FunctionUtils.any(test_collision, self.vehicles)
    end

    -- Re-enable vehicle prediction.
    Vehicle.OFFSET_FACTOR = offset

    return collision
end

--- Renders the state of the game world.
function World:draw()
    -- Determine the mouse position in the graphical window.
    local mouse_pos = Vector2(love.mouse.getPosition())
    mouse_pos = mouse_pos - self.camera

    love.graphics.push()

    -- Apply global geometric transformations.
    local x_pos = self.camera.x * self.scale.x
    local y_pos = self.camera.y * self.scale.x
    love.graphics.translate(x_pos, y_pos)
    love.graphics.scale(self.scale.x, self.scale.y)

    -- Draw all obstacles.
    love.graphics.setLineWidth(5)
    love.graphics.setColor(ColourCodes.obstacle)

    for _, obstacle in ipairs(self.obstacles) do
        obstacle:draw()
    end

    -- Generate lists of colliding and not-colliding vehicles.
    local vehicle_collision = function (character)
        return self:is_colliding(character)
    end
    collision_map = FunctionUtils.bucket(vehicle_collision, self.characters)

    love.graphics.setLineWidth(1)

    -- Draw colliding vehicles.
    if collision_map[true] then
        for _, character in ipairs(collision_map[true]) do
            character:draw(ColourCodes.collision)
        end
    end

    -- Draw not-colliding vehicles.
    if collision_map[false] then
        for _, character in ipairs(collision_map[false]) do
            character:draw()
        end
    end
    
    -- Render cursor at mouse position.
    love.graphics.push()
    love.graphics.translate(mouse_pos.x, mouse_pos.y)
    love.graphics.point(0, 0)
    love.graphics.pop()

    love.graphics.pop()
end

return World
