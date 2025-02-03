-- utils.lua --
-- Utility function implementation for UI element interaction
local utils = {}

function utils.isPointInRect(px, py, rx, ry, rw, rh)
    return px > rx and px < rx + rw and py > ry and py < ry + rh
end

return utils
