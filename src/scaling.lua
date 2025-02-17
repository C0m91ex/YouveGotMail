local orignalWidth = 0
local originalHeight = 0

local scaling = {
    scaleX = 1, 
    scaleY = 1
}

-- gets the current width and height of the window as well as set the scale to 1 at default
function scaling.loadWindow()
    orignalWidth, originalHeight = love.graphics.getDimensions()
end

function love.resize(newWidth, newHeight)
    scaling.scaleX = newWidth / orignalWidth
    scaling.scaleY = newHeight / originalHeight
end

return scaling