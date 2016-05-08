local TableUtils    = require('utils.class')
local Vector2       = require('geometry.vector2')
local Vehicle       = require('core.vehicle')

--- Represents the navigation environment.
local World = TableUtils.class()

--- Initialises World instances.
function World:init(width, height, scale)
    self.width = width
    self.height = height

    self.obstacles = {}
    self.characters = {}
end

--- Adds an obstacle to the game world.
function World:add_obstacle(obstacle)
    table.insert(self.obstacles, obstacle)
end

--- Adds a character to the game world.
function World:add_character(character)
    table.insert(self.obstacles, character.vehicle)
    table.insert(self.characters, character)
end

--- Updates the state of all characters in the game world.
function World:update(delta_time)
    for _, character in ipairs(self.characters) do
        local near_obstacles = {}
        for _, entity in pairs(self.obstacles) do
            if entity ~= character.vehicle then
                table.insert(near_obstacles, entity)
            end
        end
        character:update(delta_time, near_obstacles)
    end
end

--- Determines if a character is colliding with any object in the world.
function World:is_colliding(character)
    -- Disable vehicle position prediction.
    local offset = Vehicle.PREDICTION
    Vehicle.PREDICTION = 0

    -- Test for collisions.
    colliding = false
    for _, obstacle in ipairs(self.obstacles) do
        if character.vehicle ~= obstacle then
            local position = character.vehicle.position
            local source = obstacle:source(position)
            if character.vehicle:is_inside(source) then
                colliding = true
                break
            end
        end
    end

    -- Re-enable vehicle position prediction.
    Vehicle.PREDICTION = offset
    return colliding
end

--- Draws the circular 'obstacle' using the given colour.
function World:draw_disk(obstacle, colour)
    love.graphics.setColor(unpack(colour))
    love.graphics.push()
    love.graphics.translate(obstacle.position.x, obstacle.position.y)
    love.graphics.circle('fill', 0, 0, obstacle.geometry.radius, 25)
    love.graphics.pop()
end

--- Draws the segment sequence 'obstacle' using the given colour.
function World:draw_segseq(obstacle, colour)
    love.graphics.setColor(unpack(colour))
    love.graphics.push()
    love.graphics.translate(obstacle.position.x, obstacle.position.y)
    love.graphics.line(obstacle.geometry.coordinates)
    love.graphics.pop()
end

--- Draws the polygon 'obstacle' using the given colour.
function World:draw_polygon(obstacle, colour)
    love.graphics.setColor(unpack(colour))
    love.graphics.push()
    love.graphics.translate(obstacle.position.x, obstacle.position.y)
    love.graphics.polygon('fill', obstacle.geometry.coordinates)
    love.graphics.pop()
end

--- Draws a coloured disk at the character's position. If the character is
-- colliding with something, the 'colour' argument is ignored.
function World:draw_character(character, colour)
    if self:is_colliding(character) then colour = {153, 23, 60, 255} end

    -- Set opacity and opacity step.
    local radius = character.vehicle.geometry.radius
    local opacity_step = 1 / (character.vehicle.WINDOW + 1)
    local opacity = opacity_step

    -- Render character at previous and current positions.
    for _, point in pairs(character.vehicle.history) do
        colour[4] = opacity * 255
        opacity = opacity + opacity_step

        love.graphics.setColor(unpack(colour))
        love.graphics.push()
        love.graphics.translate(point.x, point.y)
        love.graphics.circle('fill', 0, 0, radius, 25)
        love.graphics.pop()
    end
end

--- Renders the state of the game world.
function World:draw()
    love.graphics.push()

    -- Apply global geometric transformations.
    love.graphics.translate(self.width / 2, self.height / 2)

    -- Draw obstacles.
    for _, obstacle in ipairs(self.obstacles) do
        if obstacle.tag == 'disk' then
            self:draw_disk(obstacle, {89, 168, 15, 255})
        elseif obstacle.tag == 'segseq' then
            self:draw_segseq(obstacle, {89, 168, 15, 255})
        elseif obstacle.tag == 'polygon' then
            self:draw_polygon(obstacle, {89, 168, 15, 255})
        end
    end

    -- Draw characters.
    for _, character in ipairs(self.characters) do
        if character.vehicle.tag == 'character1' then
            self:draw_character(character, {2, 143, 118, 255})
        elseif character.vehicle.tag == 'character2' then
            self:draw_character(character, {28, 33, 48, 255})
        end
    end

    love.graphics.pop()
end

return World
