local TableUtils    = require('utils.class')
local Vector2       = require('geometry.vector2')
local GeometryUtils = require('geometry.utils.geometry')
local Seek          = require('steering.seek')

--- Implements seek-ray steering behaviour.
local SeekRay = TableUtils.class(Seek)

--- Initialises SeekRay class instances.
function SeekRay:init(vehicle, origin, ray, offset)
    Seek.init(self, vehicle, Vector2())
    self.origin = origin
    self.ray = ray
    self.reference = origin + ray
    self.offset = offset
end

--- Returns the desired velocity of the vehicle if it is to seek along a line.
function SeekRay:desired_velocity()
    -- Determine nearest point on ray.
    self.position = GeometryUtils.nearest_on_line(
        self.vehicle.position, self.origin, self.reference)

    -- Steer towards offset point.
    self.position = self.position + self.ray * self.offset
    return Seek.desired_velocity(self)
end

return SeekRay
