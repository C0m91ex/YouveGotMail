-- utils.lua --
-- Utility function implementation for UI element interaction
local utils = {}

-- isPointInRect()
-- Checks to see if the given point exists inside the given rectangle
function utils.isPointInRect(px, py, rx, ry, rw, rh)
    return px > rx and px < rx + rw and py > ry and py < ry + rh
end

return utils
