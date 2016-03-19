local TableUtils      = require('utils.class')
local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local PolygonObstacle = require('geometry.polygon')
local SegSeqObstacle  = require('geometry.segseq')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Seek            = require('steering.seek')
local Flock           = require('steering.flock')
local World           = require('core.world')
local ColourCodes     = require('visual.colours')
local ScenarioHelpers = require('scenarios.helpers')
local Boid            = require('scenarios.flock.boid')

-- Construct world.
local world = World(true, 800, 600)

Seek.world = world

-- Create character obstacle.
local character_disk = DiskObstacle(5)

-- Declare boid creator function.
local create_boid = function (position, colour)
    local vehicle = Vehicle('boid', position, character_disk)
    vehicle:set_targets(0, 100, 100)
    return Boid(colour, vehicle, 100)
end

-- Declare flock creator function.
local create_flock = function (centre, colour)
    -- Create boids.
    local boids = {}
    local points = ScenarioHelpers.radial_points(centre, 125, 15)
    for _, position in pairs(points) do
        table.insert(boids, create_boid(position, colour))
    end

    -- Tell flockmates about each other.
    for _, boid in pairs(boids) do
        boid:set_steering(Flock, {boids})
        world:add_character(boid)
    end
end

-- Create obstacle.
local points = ScenarioHelpers.radial_points(Vector2(), 75, 7)
local obstacle = Obstacle('obstacle', Vector2(), PolygonObstacle(points))
world:add_obstacle(obstacle)

-- Create flocks.
create_flock(Vector2(-200, 0), ColourCodes.vehicle)
create_flock(Vector2( 200, 0), ColourCodes.pursuer)

return world
