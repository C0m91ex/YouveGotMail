-- gets the current width and height of the window as well as set the scale to 1 at default
local function loadWindow()
    orignalWidth, originalHeight = love.graphics.getDimensions()
    scaleX, scaleY = 1, 1
end

function love.resize(newWidth, newHeight)
    scaleX = newWidth / orignalWidth
    scaleY = newHeight / originalHeight
end

return {
    loadWindow = loadWindow
}