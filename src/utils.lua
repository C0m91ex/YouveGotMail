-- utils.lua --
-- Utility function implementation for UI element interaction
local utils = {}
local keyValuePat = "(%w+)%s?=%s?([+-<>~=!]*%d+)"

-- isPointInRect()
-- Checks to see if the given point exists inside the given rectangle
function utils.isPointInRect(px, py, rx, ry, rw, rh)
    return px > rx and px < rx + rw and py > ry and py < ry + rh
end

function utils.updateTableFromString(table, string)
    for key, value in string.gmatch(string, keyValuePat) do
        table[key] = value
    end
    return table
end

return utils