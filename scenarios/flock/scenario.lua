local TableUtils      = require('utils.class')
local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local PolygonObstacle = require('geometry.polygon')
local SegSeqObstacle  = require('geometry.segseq')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Flock           = require('steering.flock')
local Space           = require('core.space')
local World           = require('core.world')
local ScenarioHelpers = require('scenarios.helpers')
local Boid            = require('scenarios.flock.boid')

-- Construct the environment.
local width = 800
local height = 600
local space = Space.Toroidal(width, height)
local world = World(800, 600)

-- Declare the flock creator function.
local disk = DiskObstacle(5)
local create_flock = function (centre, tag)

    -- Create boids.
    local boids = {}
    local vehicles = {}

    local points = ScenarioHelpers.radial_points(centre, 125, 15)
    for _, position in pairs(points) do
        local vehicle = Vehicle(space, tag, position, disk, 50, 50)
        local boid = Boid(vehicle, 5)
        table.insert(boids, Boid(vehicle, 5))
        table.insert(vehicles, vehicle)
    end

    -- Tell flockmates about each other.
    local steering = Flock(vehicles)
    for _, boid in pairs(boids) do
        boid.steering = steering
        world:add_character(boid)
    end
end

-- Create an obstacle and add it to the environment.
local points = ScenarioHelpers.radial_points(Vector2(), 75, 7)
local obstacle = Obstacle(space, 'polygon', Vector2(), PolygonObstacle(points))
world:add_obstacle(obstacle)

-- Create flocks.
create_flock(Vector2(-200, 0), 'character1')
create_flock(Vector2( 200, 0), 'character2')

return world
