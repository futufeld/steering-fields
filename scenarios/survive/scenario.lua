local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local PolygonObstacle = require('geometry.polygon')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Space           = require('core.space')
local World           = require('core.world')
local ScenarioHelpers = require('scenarios.helpers')
local Prey            = require('scenarios.survive.prey')
local Predator        = require('scenarios.survive.predator')

-- Construct the environment.
local width = 800
local height = 600
local space = Space.Toroidal(width, height)
local world = World(800, 600)

-- Add trees to the environment.
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 175, 5)) do
    local radius = 25 + math.random() * 12.5
    local points = ScenarioHelpers.radial_points(Vector2(), radius, 7)
    obstacle = Obstacle(space, 'polygon', position, PolygonObstacle(points))
    world:add_obstacle(obstacle)
end

-- Crete the predator and add it to the environment.
local disk = DiskObstacle(5)
local vehicle = Vehicle(space, 'character2', Vector2(-375, 275), disk)
world:add_character(Predator(vehicle, Vector2()))

-- Crete the prey and add them to the environment.
for i = 1, 15, 1 do
    local position = Vector2.random(225 + math.random(100))
    vehicle = Vehicle(space, 'character1', position, disk)
    world:add_character(Prey(vehicle, Vector2()))
end
for i = 1, 10, 1 do
    local position = Vector2.random(50 + math.random(50))
    vehicle = Vehicle(space, 'character1', position, disk)
    world:add_character(Prey(vehicle, Vector2()))
end

return world
