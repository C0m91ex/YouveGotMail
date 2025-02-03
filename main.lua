-- main.lua --
-- Main game function manager
local start = love.timer.getTime()
local gameState = require("src.gameState")
local ui = require("src.ui")
local email = require("src.email")
-- local utils = require("src.utils")

-- To track the time and the last second
local lastSecond = math.floor(start)

function love.load()
    gameState.load()
end

function love.update(dt)
    gameState.update(dt)

    -- Get the current time
    local currentTime = love.timer.getTime()

    -- Check if a second has passed (if the current time is a new second)
    local currentSecond = math.floor(currentTime)

    -- Only update if the second has changed
    if currentSecond ~= lastSecond then
        lastSecond = currentSecond
        -- Check if it's an even second and perform actions if needed
        if currentSecond % 2 == 0 then
            -- Do something on even seconds, e.g., print a message
            print("Even second: " .. currentSecond)
        end
    end
end

function love.draw()
    -- Currently draws the inbox scene background
    -- !!! CHANGE TO START WITH LOGIN PAGE !!! --
    ui.drawBackground()

    -- Set the text color to black for the timer
    love.graphics.setColor(0, 0, 0)  -- Black color

    -- Print the current second on the screen
    local currentSecond = math.floor(love.timer.getTime())
    love.graphics.print("Current second: " .. currentSecond, 10, 150)

    -- Reset the color to white (default) for other elements
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
