local TableUtils = require('utils.class')

--- Defines a two-dimensional vector.
local Vector2 = TableUtils.class()

--- Initialises Vector2 instances.
function Vector2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

--- Returns a random vector with the given magnitude.
function Vector2.random(magnitude)
    return Vector2.from_angle(math.random() * math.pi * 2, magnitude)
end

--- Returns the vector defined by the given polar coordinates.
function Vector2.from_angle(angle, magnitude)
    return Vector2(math.cos(angle), math.sin(angle)) * magnitude
end

--- Returns the magnitude of this vector.
function Vector2:len()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

--- Returns a copy of this vector.
function Vector2:copy()
    return Vector2(self.x, self.y)
end

--- Returns the reverse of this vector.
function Vector2:__unm()
    return Vector2(-self.x, -self.y)
end

--- Returns the result of adding 'vector' to this vector.
function Vector2:__add(vector)
    return Vector2(self.x + vector.x, self.y + vector.y)
end

--- Returns the result of subtracting 'vector' from this vector.
function Vector2:__sub(vector)
    return Vector2(self.x - vector.x, self.y - vector.y)
end

--- Returns the result of multiplying this vector by 'scalar'.
function Vector2:__mul(scalar)
    return Vector2(self.x * scalar, self.y * scalar)
end

--- Returns the result of dividing this vector by 'scalar'.
function Vector2:__div(scalar)
    return Vector2(self.x / scalar, self.y / scalar)
end

--- Returns the unit vector corresponding to this vector.
function Vector2:unit()
    return self / self:len()
end

--- Returns a vector perpendicular to this vector.
function Vector2:perp()
    return Vector2(-self.y, self.x)
end

--- Returns the dot product of this vector and 'vector'.
function Vector2:dot(vector)
    return self.x * vector.x + self.y * vector.y
end

return Vector2
