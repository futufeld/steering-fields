local TableUtils      = require('utils.class')
local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Seek            = require('steering.seek')
local Pursue          = require('steering.pursue')
local Escape          = require('steering.escape')
local World           = require('core.world')
local ColourCodes     = require('visual.colours')
local ScenarioHelpers = require('scenarios.helpers')
local Prey            = require('scenarios.escape.prey')
local Predator        = require('scenarios.escape.predator')

-- Construct world.
local world = World(true, 800, 600)

Seek.world = world
Pursue.world = world

-- Create character obstacle.
local character_disk = DiskObstacle(5)

-- Declare predator creator function.
local create_predator = function (position)
    local vehicle = Vehicle('predator', position, character_disk)
    vehicle:set_targets(0, 100, 100)
    return Predator(ColourCodes.pursuer, vehicle, 100)
end

-- Create predators.
local predators = {}
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 225, 10)) do
    table.insert(predators, create_predator(position))
end
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 275, 10)) do
    table.insert(predators, create_predator(position))
end

-- Add predators to world.
for _, predator in pairs(predators) do
    world:add_character(predator)
end

-- Create prey.
local vehicle = Vehicle('prey', Vector2(), character_disk)
vehicle:set_targets(0, 150, 150)
local prey = Prey(ColourCodes.vehicle, vehicle, 150)

-- Set prey steering.
local predator_vehicles = {}
for _, predator in pairs(predators) do
    table.insert(predator_vehicles, predator.vehicle)
end
prey:set_steering(Escape, {predator_vehicles})
world:add_character(prey)

-- Set predator steering.
for _, predator in pairs(predators) do
    predator:set_steering(Pursue, {prey.vehicle, 0.25})
end

return world
