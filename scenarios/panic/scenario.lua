local TableUtils      = require('utils.class')
local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local SegSeqObstacle  = require('geometry.segseq')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local Seek            = require('steering.seek')
local SeekRay         = require('steering.seek_ray')
local World           = require('core.world')
local ColourCodes     = require('visual.colours')
local ScenarioHelpers = require('scenarios.helpers')
local Panicker         = require('scenarios.panic.panicker')

-- Construct world.
local world = World(false, 800, 600)

Seek.world = world

-- Construct room to escape.
local offset = 125

local seq = {Vector2(-offset, -offset), Vector2(offset, -offset)}
local obs1 = SegSeqObstacle(seq)
world:add_obstacle(Obstacle('wall', Vector2(), obs1))

local seq = {Vector2(-offset, offset), Vector2(offset, offset)}
local obs2 = SegSeqObstacle(seq)
world:add_obstacle(Obstacle('wall', Vector2(), obs2))

local seq = {Vector2(offset, -offset), Vector2(offset, offset)}
local obs3 = SegSeqObstacle(seq)
world:add_obstacle(Obstacle('wall', Vector2(), obs3))

local seq = {Vector2(-offset, -offset), Vector2(-offset, -15)}
local obs4 = SegSeqObstacle(seq)
world:add_obstacle(Obstacle('wall', Vector2(), obs4))

local seq = {Vector2(-offset, 15), Vector2(-offset, offset)}
local obs5 = SegSeqObstacle(seq)
world:add_obstacle(Obstacle('wall', Vector2(), obs5))

-- Create character obstacle.
local character_disk = DiskObstacle(5)

-- Declare character creator function.
local create_character = function (position)
    local vehicle = Vehicle('character', position, character_disk, false)
    vehicle:set_targets(10000, 50, 50)
    vehicle.draw_tail = false

    local character = Panicker(ColourCodes.vehicle, vehicle, 50, 5)
    character:set_steering(SeekRay, {Vector2(), Vector2(-1, 0), 50})
    return character
end

-- Populate corridor with characters.
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 90, 25)) do
    world:add_character(create_character(position))
end
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 60, 15)) do
    world:add_character(create_character(position))
end
for _, position in pairs(ScenarioHelpers.radial_points(Vector2(), 30, 10)) do
    world:add_character(create_character(position))
end

return world
