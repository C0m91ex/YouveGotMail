local email = require("src.email")

-- global vars
local scaleX, scaleY

local function loadWindow()
    orignalWidth, originalHeight = love.graphics.getDimensions()

    scaleX, scaleY = 1, 1
end
--[[
function love.resize(newWidth, newHeight)
    scaleX = newWidth / orignalWidth
    scaleY = newHeight / originalHeight
    print("newWidth: "..newWidth)
    print("newHeight: "..newHeight)

    print("scaleX: "..scaleX)
    print("scaleY: "..scaleY)
    
    email.updateEmailScaling(scaleX, scaleY)
end
]]--
return {
    loadWindow = loadWindow
}