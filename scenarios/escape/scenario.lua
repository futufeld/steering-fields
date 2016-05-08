local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Pursue          = require('steering.pursue')
local Escape          = require('steering.escape')
local Space           = require('core.space')
local World           = require('core.world')
local ScenarioHelpers = require('scenarios.helpers')
local Prey            = require('scenarios.escape.prey')
local Predator        = require('scenarios.escape.predator')

-- Construct world.
local width = 800
local height = 600
local space = Space.Toroidal(width, height)
local world = World(width, height)

-- Create character obstacle.
local disk = DiskObstacle(5)

-- Create prey.
local prey = Prey(Vehicle(space, 'character1', Vector2(0, 0), disk, 150, 150))

-- Declare predator creator function.
local create_predator = function (position)
    local vehicle = Vehicle(space, 'character2', position, disk, 100, 100)
    local predator = Predator(vehicle, 5)
    predator.steering = Pursue(prey.vehicle, 0.25)
    return predator
end

-- Create predators and add them to the world.
local predator_vehicles = {}
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 100, 8)) do
    local predator = create_predator(position)
    table.insert(predator_vehicles, predator.vehicle)
    world:add_character(predator)
end
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 250, 12)) do
    local predator = create_predator(position)
    table.insert(predator_vehicles, predator.vehicle)
    world:add_character(predator)
end

-- Set prey steering and add prey character to world.
prey.steering = Escape(predator_vehicles)
world:add_character(prey)

-- Create obstacle.
local geometry = DiskObstacle(50)
world:add_obstacle(Obstacle(space, 'disk', Vector2(-250, -200), geometry))
world:add_obstacle(Obstacle(space, 'disk', Vector2(-250,  200), geometry))
world:add_obstacle(Obstacle(space, 'disk', Vector2( 250, -200), geometry))
world:add_obstacle(Obstacle(space, 'disk', Vector2( 250,  200), geometry))

return world
