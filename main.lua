-- main.lua --
-- Main game function manager
local gameState = require("src.gameState")
local ui = require("src.ui")
local email = require("src.email")
-- local utils = require("src.utils")

function love.load()
    gameState.load()
end

function love.update(dt)
    gameState.update(dt)
end

function love.draw()
    -- Currently draws the inbox scene background
    -- !!! CHANGE TO START WITH LOGIN PAGE !!! --
    ui.drawBackground()
    
    if gameState.isEmailOpened() then
        ui.drawOpenedEmail(gameState.getOpenedEmail())
    else
        ui.drawTrashBin()
        email.drawEmails()
        ui.drawScore(gameState.getScore())
    end
end

function love.mousereleased(x, y, button)
    gameState.handleMouseRelease(x, y, button)
end
