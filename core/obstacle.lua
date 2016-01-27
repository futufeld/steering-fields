local TableUtils = require('utils.class')

--- Defines environmental obstacles.
local Obstacle = TableUtils.class()

--- Initialises Obstacle class instances.
function Obstacle:init(tag, position, geometry)
    self.tag = tag
    self.position = position
    self.geometry = geometry
    self.world = nil
end

--- Transforms the given point from world space to the local space of the
-- vehicle.
function Obstacle:localise(point)
    return point - self.position
end

--- Transforms the given point from local space of the vehicle to world space.
function Obstacle:globalise(point)
    return point + self.position
end

--- Returns whether the given point is inside the obstacle.
function Obstacle:is_inside(point)
    local offset = self.world:point(self.position, point)
    local point_ = self:localise(point + offset)
    return self.geometry:is_inside(point_)
end

--- Returns the projection of the given point on the obstacle's geometry.
function Obstacle:projection(point)
    local offset = self.world:point(self.position, point)
    local point_ = self:localise(point + offset)
    local proj = self.geometry:projection(point_)
    return self:globalise(proj)
end

--- Determines the source on this obstacle for the given point.
function Obstacle:source(point)
    if self:is_inside(point) then
        return point:copy()
    else
        return self:projection(point)
    end
end

--- Renders this obstacle.
function Obstacle:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    self.geometry:draw()
    love.graphics.pop()
end

return Obstacle
