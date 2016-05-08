local TableUtils     = require('utils.class')
local Vector2        = require('geometry.vector2')
local DiskObstacle   = require('geometry.disk')
local SegSeqObstacle = require('geometry.segseq')
local Obstacle       = require('core.obstacle')
local Vehicle        = require('core.vehicle')
local Seek           = require('steering.seek')
local Space          = require('core.space')
local World          = require('core.world')
local Pedestrian     = require('scenarios.ambulate.pedestrian')

-- Construct the environment.
local width = 800
local height = 600
local space = Space.Toroidal(width, height)
local world = World(width, height)

-- Construct a corridor and add it to the environment.
local min_x = -world.width * 0.5
local max_x =  world.width * 0.5
local half_width = 75

local pts = {Vector2(-min_x, 0), Vector2(-max_x, 0)}

local wall1 = SegSeqObstacle(pts)
world:add_obstacle(Obstacle(space, 'segseq', Vector2(0, half_width), wall1))

local wall2 = SegSeqObstacle(pts)
world:add_obstacle(Obstacle(space, 'segseq', Vector2(0, -half_width), wall2))

-- Create pedestrians.
local disk = DiskObstacle(5)
local num_pedestrians = 40
local gap = (max_x - min_x) / num_pedestrians

for i = 0, num_pedestrians, 1 do

    -- Determine a position for the pedestrian.
    local offset = math.random(-100, 100) / 100
    local position = Vector2(min_x + i * gap, offset * 0.8 * half_width)

    -- Configure pedestrian based on its direction of motion.
    local point = nil
    local tag = nil

    if math.random() < 0.5 then
        point = Vector2(10000, 0)
        tag = 'character1'
    else
        point = Vector2(-10000, 0)
        tag = 'character2'
    end

    -- Create pedestrian's vehicle.
    local speed = 20 + 10 * math.random()
    local vehicle = Vehicle(space, tag, position, disk, speed, speed)

    -- Create pedestrian.
    local pedestrian = Pedestrian(vehicle, 5, point)
    pedestrian.steering = Seek(point)
    world:add_character(pedestrian)
end

return world
