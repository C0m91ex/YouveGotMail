-- main.lua --
-- Main game function manager
local gameState = require("src.gameState")
local ui = require("src.ui")
local email = require("src.email")
local utils = require("src.utils")

-- global vars
local start = love.timer.getTime()
local lastSecond = math.floor(start)

function love.load()
    gameState.load()
end

function love.update(dt)
    gameState.update(dt)

    local currentTime = love.timer.getTime()
    local currentSecond = math.floor(currentTime)

    if currentSecond ~= lastSecond then
        lastSecond = currentSecond
        if currentSecond % 5 == 0 then
            -- call a function in email
            email.test(currentSecond)
        end
    end
end

function love.draw()
    -- Currently draws the inbox scene background
    -- !!! CHANGE TO START WITH LOGIN PAGE !!! --
    ui.drawBackground()

    -- Timer 
    love.graphics.setColor(0, 0, 0)  -- Black color
    local currentSecond = math.floor(love.timer.getTime())
    love.graphics.print("Current second: " .. currentSecond, 10, 150)
    love.graphics.print("Current # of emails: ".. email.getLengthEmails(), 10, 160)
    love.graphics.setColor(1, 1, 1)  -- White color

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
