local Vector2         = require('geometry.vector2')
local DiskObstacle    = require('geometry.disk')
local SegSeqObstacle  = require('geometry.segseq')
local Obstacle        = require('core.obstacle')
local Vehicle         = require('core.vehicle')
local FollowPath      = require('steering.follow_path')
local Space           = require('core.space')
local World           = require('core.world')
local ScenarioHelpers = require('scenarios.helpers')
local Panicker        = require('scenarios.panic.panicker')

-- Construct the environment.
local width = 800
local height = 600
local space = Space.Regular(width, height)
local world = World(width, height)

-- Construct the room to be escaped.
local offset = 125
local seq = { Vector2(-offset, -15),
              Vector2(-offset, -offset),
              Vector2( offset, -offset),
              Vector2( offset,  offset),
              Vector2(-offset,  offset),
              Vector2(-offset,  15) }
world:add_obstacle(Obstacle(space, 'segseq', Vector2(), SegSeqObstacle(seq)))

-- Create panicked characters.
local disk = DiskObstacle(5)
local steering = FollowPath(Vector2(), Vector2(-10000, 0), 10)

local create_character = function (position)
    local vehicle = Vehicle(space, 'character1', position, disk, 50, 50)
    local panicker = Panicker(vehicle, 5)
    panicker.steering = steering
    return panicker
end

-- Populate room with characters.
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
