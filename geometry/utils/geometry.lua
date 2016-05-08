local Vector2       = require('geometry.vector2')
local IteratorUtils = require('utils.iterator')

-- Namespace for GeometryUtils functionality.
local GeometryUtils = { DELTA = 1e-5 }

--- Tests if 'point' is on line defined by 'vertex1' and 'vertex2'.
function GeometryUtils.is_on_line(point, vertex1, vertex2)
    local ca = vertex2 - vertex1
    local ba = point - vertex1

    local cross = ca.y * ba.x - ca.x * ba.y
    return math.abs(cross) < GeometryUtils.DELTA
end

--- Tests if 'point' is on the line segment defined by 'vertex1' and 'vertex2'.
function GeometryUtils.is_on_segment(point, vertex1, vertex2)
    local ca = vertex2 - vertex1
    local ba = point - vertex1

    local cross = ca.y * ba.x - ca.x * ba.y
    if math.abs(cross) > GeometryUtils.DELTA then return false end

    local dot = ca:dot(ba) / ca:dot(ca)
    return (dot >= 0) and (dot <= 1)
end

--- Tests if 'point' is within the polygon defined by 'vertexes'.
function GeometryUtils.is_inside_polygon(point, vertexes)

    -- Tests if 'point' is left of the given vertexes.
    local is_left = function (vertex1, vertex2)
        local a = (vertex2.x - vertex1.x) * (point.y - vertex1.y)
        local b = (point.x - vertex1.x) * (vertex2.y - vertex1.y)
        return (a - b) > 0
    end

    -- Tests the direction of winding with respect to point.
    local wind = function (vertex1, vertex2)
        if vertex1.y <= point.y then
            if vertex2.y > point.y then
                if is_left(vertex1, vertex2) then return 1 end
            end
        else
            if vertex2.y <= point.y then
                if not is_left(vertex1, vertex2) then return -1 end
            end
        end
        return 0
    end

    -- Determine the number of 'windings'.
    local wind_number = 0
    for vertex1, vertex2 in IteratorUtils.pairloop(vertexes) do
        wind_number = wind_number + wind(vertex1, vertex2)
    end
    return wind_number ~= 0
end

--- Projects 'point' on the line defined by 'vertex1' and 'vertex2'.
function GeometryUtils.projection_on_line(point, vertex1, vertex2)
    local numer_a = (point.x - vertex1.x) * (vertex2.x - vertex1.x)
    local numer_b = (point.y - vertex1.y) * (vertex2.y - vertex1.y)
    local u = vertex2 - vertex1
    local denom = u.x * u.x + u.y * u.y

    -- Return nil if 'vertex1' and 'vertex2' are coincident.
    if denom < GeometryUtils.DELTA then return nil end
    return (numer_a + numer_b) / denom
end

--- Returns the point 'projection' distance along the line defined by 'vertex1'
-- and 'vertex2'.
function GeometryUtils.line_projection(projection, vertex1, vertex2)
    local x = vertex1.x + projection * (vertex2.x - vertex1.x)
    local y = vertex1.y + projection * (vertex2.y - vertex1.y)
    return Vector2(x, y)
end

--- Determines the nearest point to 'point' on the line defined by 'vertex1'
-- and 'vertex2'.
function GeometryUtils.nearest_on_line(point, vertex1, vertex2)
    local proj = GeometryUtils.projection_on_line(point, vertex1, vertex2)
    return GeometryUtils.line_projection(proj, vertex1, vertex2)
end

--- Determines the nearest point to 'point' on the line segment defined by
-- 'vertex1' and 'vertex2'.
function GeometryUtils.nearest_on_segment(point, vertex1, vertex2)
    local proj = GeometryUtils.projection_on_line(point, vertex1, vertex2)
    if proj <= 0 then return vertex1:copy() end
    if proj >= 1 then return vertex2:copy() end
    return GeometryUtils.line_projection(proj, vertex1, vertex2)
end

return GeometryUtils
