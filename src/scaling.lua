local orignalWidth = 1600
local originalHeight = 900

local newWidth = 1
local newHeight = 1

local scaling = {
    scaleX = 1, 
    scaleY = 1
}

-- gets the current width and height of the window as well as set the scale to 1 at default
function scaling.loadWindow()
    --orignalWidth, originalHeight = love.graphics.getDimensions()
    newWidth, newHeight = love.window.getDesktopDimensions()
    scaling.scaleX = newWidth / orignalWidth
    scaling.scaleY = newHeight / originalHeight

end

-- this is used to rescale all of the images and objects on the game screen whenever the user changes the window size
function love.resize(newWidth, newHeight)
    scaling.scaleX = newWidth / orignalWidth
    scaling.scaleY = newHeight / originalHeight
end

return scaling