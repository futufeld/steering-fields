local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local PolygonObstacle = require('geometry.polygon')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Seek            = require('steering.seek')
local Pursue          = require('steering.pursue')
local World           = require('core.world')
local ColourCodes     = require('visual.colours')
local ScenarioHelpers = require('scenarios.helpers')
local Prey            = require('scenarios.survive.prey')
local Predator        = require('scenarios.survive.predator')

-- Construct world.
local world = World(true, 800, 600)

Seek.world = world
Pursue.world = world

-- Declare tree creator function.
local create_tree = function (position, radius, num)
    local points = ScenarioHelpers.radial_points(Vector2(), radius, num)
    return Obstacle('obstacle', position, PolygonObstacle(points))
end

-- Declare obstacle geometry.
local character_disk = DiskObstacle(5)

-- Set home for prey and predator characters.
local home_position = Vector2()

-- Declare prey creator function.
local create_prey = function (position)
    local vehicle = Vehicle('prey', position, character_disk)
    return Prey(ColourCodes.vehicle, vehicle, 150, home_position)
end

-- Declare predator creator function.
local create_predator = function (position)
    local vehicle = Vehicle('predator', position, character_disk)
    return Predator(ColourCodes.pursuer, vehicle, 200, home_position)
end

-- Add trees.
local radial_offset = 175
local points = ScenarioHelpers.radial_points(Vector2(), radial_offset, 5)

for _, point in pairs(points) do
    local radius = 25 + math.random() * 12.5
    world:add_obstacle(create_tree(point, radius, 7))
end

-- Add predator to world.
world:add_character(create_predator(Vector2(-400, -300)))

-- Create prey and add to world.
for i = 1, 25, 1 do
    local position = Vector2.random(200 + math.random(100))
    local prey = create_prey(position)
    world:add_character(prey)
end

return world
