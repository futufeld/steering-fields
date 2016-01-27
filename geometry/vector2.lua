local TableUtils = require('utils.class')

--- Defines a two-dimensional vector.
local Vector2 = TableUtils.class()

-- Threshold at which scalar values are considered equal.
Vector2.DELTA = 1e-5

--- Initialises Vector2 instances.
function Vector2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

--- Returns a vector pointing in a pseudo-random direction with the given
-- magnitude.
function Vector2.random(magnitude)
    local angle = math.random() * math.pi * 2
    return Vector2.from_angle(angle, magnitude)
end

--- Returns the vector defined by the given polar coordinates.
function Vector2.from_angle(angle, magnitude)
    local x = math.cos(angle)
    local y = math.sin(angle)
    return Vector2(x, y) * magnitude
end

--- Returns a copy of this vector.
function Vector2:copy()
    return Vector2(self.x, self.y)
end

--- Returns the reverse of this vector.
function Vector2:__unm()
    return Vector2(-self.x, -self.y)
end

--- Returns the result of adding 'other' to this vector.
function Vector2:__add(other)
    return Vector2(self.x + other.x, self.y + other.y)
end

--- Returns the result of subtracting 'other' from this vector.
function Vector2:__sub(other)
    return Vector2(self.x - other.x, self.y - other.y)
end

--- Returns a copy of this vector with coordinates multiplied by 'scalar'.
function Vector2:__mul(scalar)
  return Vector2(self.x * scalar, self.y * scalar)
end

--- Returns a copy of this vector with coordinates divided by 'scalar'.
function Vector2:__div(scalar)
    return Vector2(self.x / scalar, self.y / scalar)
end

--- Returns the magnitude of this vector.
function Vector2:len()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

--- Returns the magnitude of this vector squared.
function Vector2:len_sq()
    return self.x * self.x + self.y * self.y
end

--- Returns the unit vector corresponding to this vector.
function Vector2:unit()
    return self / self:len()
end

--- Returns the unit vector corresponding to this vector. If the length of the
-- vector is zero, a vector with pseudo-random direction and the given magnitude
-- is returned instead.
function Vector2:unit_safe(magnitude)
    local norm = self:len()
    if norm > 0 then
        return self / norm
    else
        return Vector2.random(magnitude)
    end
end

--- Returns a vector perpendicular to this vector.
function Vector2:perp()
    return Vector2(-self.y, self.x)
end

--- Returns the dot product of this vector and 'other'.
function Vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

--- Returns a copy of this vector with magnitude truncated to 'limit'.
function Vector2:truncate(limit)
    local magnitude = self:len()
    if magnitude <= limit then
        return self:copy()
    end
    return self * (limit / magnitude)
end

--- Returns a string representation of this vector.
function Vector2:__tostring()
    return '(' .. self.x .. ', ' .. self.y .. ')'
end

return Vector2
