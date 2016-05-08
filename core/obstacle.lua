local TableUtils = require('utils.class')

--- Provides an abstraction for representing obstacles in xetrov fields.
local Obstacle = TableUtils.class()

--- Initialises Obstacle class instances.
function Obstacle:init(space, tag, position, geometry)
    self.space = space
    self.tag = tag
    self.position = position
    self.geometry = geometry
end

--- Returns 'point' translated from world space to the obstacle's local space.
function Obstacle:localise(point) return point - self.position end

--- Returns 'point' translated from the obstacle's local space to world space.
function Obstacle:globalise(point) return point + self.position end

--- Returns whether 'point' is inside this obstacle's geometry.
function Obstacle:is_inside(point)
    local offset = self.space:offset(self.position, point)
    local point_ = self:localise(point + offset)
    return self.geometry:is_inside(point_)
end

--- Returns the nearest point on this obstacle's geometry to 'point'.
function Obstacle:nearest(point)
    local offset = self.space:offset(self.position, point)
    local point_ = self:localise(point + offset)
    local proj = self.geometry:nearest(point_)
    return self:globalise(proj)
end

--- Returns the source on this obstacle's geometry corresponding to 'point'.
function Obstacle:source(point)
    if self:is_inside(point) then return point:copy() end
    return self:nearest(point)
end

return Obstacle
