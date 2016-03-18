local TableUtils     = require('utils.class')
local Vector2        = require('geometry.vector2')
local DiskObstacle   = require('geometry.disk')
local SegSeqObstacle = require('geometry.segseq')
local Obstacle       = require('core.obstacle')
local Vehicle        = require('core.vehicle')
local Seek           = require('steering.seek')
local World          = require('core.world')
local ColourCodes    = require('visual.colours')
local Pedestrian     = require('scenarios.ambulate.pedestrian')

-- Construct world.
local world = World(true, 800, 600)

Seek.world = world

-- Construct pedestrian corridor.
local min_x = -world.width * 0.5
local max_x =  world.width * 0.5
local offset = 75

local obs1 = SegSeqObstacle({Vector2(min_x, offset), Vector2(max_x, offset)})
world:add_obstacle(Obstacle('corridor', Vector2(), obs1))

local obs2 = SegSeqObstacle({Vector2(min_x, -offset), Vector2(max_x, -offset)})
world:add_obstacle(Obstacle('corridor', Vector2(), obs2))

-- Define direction enumeration.
local Direction = {}
Direction.LEFT = 0
Direction.RIGHT = 1

-- Declare obstacle geometry.
local character_disk = DiskObstacle(5)

-- Declare pedestrian creator function.
local create_pedestrian = function(position, direction)
    -- Configure pedestrian based on intended direction of motion.
    local colour = ColourCodes.vehicle
    local point = Vector2(-10000, 0)
    local obstacle_tag = 'left'

    if direction == Direction.RIGHT then
        colour = ColourCodes.pursuer
        point = Vector2(10000, 0)
        obstacle_tag = 'right'
    end

    -- Create vehicle.
    local vehicle = Vehicle('pedestrian', position, character_disk)
    speed = 20 + 10 * math.random()
    rate = 3 + 3 * math.random()
    vehicle:set_targets(rate, speed, speed)

    -- Create pedestrian.
    local pedestrian = Pedestrian(colour, vehicle, 50, point)
    pedestrian:set_steering(Seek, {point})
    return pedestrian
end

-- Declare function returning random direction.
local randomDirection = function ()
    if math.random() < 0.5 then
        return Direction.LEFT
    else
        return Direction.RIGHT
    end
end

-- Declare function for generating pedestrian positions.
local positionGenerator = function (numPedestrians)
    local positions = {}
    local y_direction = 1

    local gap = (max_x - min_x) / numPedestrians

    for i = 1,numPedestrians,1 do
        local x = min_x + i * gap
        local y = math.random(offset) * 0.8 * y_direction
        table.insert(positions, Vector2(x, y))
        y_direction = y_direction * -1
    end
    return positions
end

-- Populate pedestrian corridor with pedestrians.
for _, position in pairs(positionGenerator(40)) do
    local pedestrian = create_pedestrian(position, randomDirection())
    world:add_character(pedestrian)
end

return world
