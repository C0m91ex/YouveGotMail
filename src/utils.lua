-- utils.lua --
-- Utility function implementation for UI element interaction
local utils = {}

-- isPointInRect()
-- Checks to see if the given point exists inside the given rectangle
function utils.isPointInRect(px, py, rx, ry, rw, rh)
    return px > rx and px < rx + rw and py > ry and py < ry + rh
end

function utils.updateTableFromString(table, string)
    print("updateTableFromString test")
    string.gsub(string, "%p*(.+)%s=%s([+-]?%d+)%p*", function(key, value) table[key] = value end)
    return table
end

return utils