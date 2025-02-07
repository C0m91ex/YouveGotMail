-- main.lua --
-- Main game function manager
local gameState = require("src.gameState")
local ui = require("src.ui")
local email = require("src.email")
local utils = require("src.utils")
local file = require("src.file")
local shop = require("src.shop")


-- global vars
local start = love.timer.getTime()
local lastSecond = math.floor(start)
local growthPeriod = 5
local growthRate = 1 / growthPeriod
local csv = {}
 
-- load()
-- Load function, calls load() from gameState.lua
function love.load()
    gameState.load()
    csv = file.loadCsvFile("data/Test CSV - Sheet1.csv")
    for row, values in ipairs(csv) do
        for i, v in ipairs(values) do
            print("row="..i.." count="..#v.." values=", unpack(v))
        end
    end
end

-- update()
-- Update function, calls timedEmailSpawn() from email.lua each 'growthPeriod' # of seconds
function love.update(dt)
    gameState.update(dt)

    local currentTime = love.timer.getTime()
    local currentSecond = math.floor(currentTime)
    local growthRate = 1 / growthPeriod

    if currentSecond ~= lastSecond then
        lastSecond = currentSecond
        if currentSecond % 5 == 0 then
            -- call a function in email
            email.timedEmailSpawn(growthPeriod)
        end
    end
end

-- draw()
-- Draw function, calls ui drawing functions
function love.draw()
    -- Currently draws the inbox scene background
    -- !!! CHANGE TO START WITH LOGIN PAGE !!! --
    --love.window.setMode(1140, 750)
    ui.drawBackground()

    -- Timer 
    love.graphics.setColor(0, 0, 0)  -- Black color
    local currentSecond = math.floor(love.timer.getTime())
    love.graphics.print("Current second: " .. currentSecond, 10, 150)
    love.graphics.print("Current # of emails: ".. email.getLengthEmails(), 10, 160)
    love.graphics.setColor(1, 1, 1)  -- White color

    if gameState.isEmailOpened() then
        ui.drawOpenedEmail(gameState.getOpenedEmail())
        file.printEmail(csv[3])
    else
        ui.drawTrashBin()
        email.drawEmails()
        shop.drawShopItems()
        ui.drawCurrency(gameState.getCurrency())
    end
end

-- mousereleased()
-- Calls gameState.handleMouseRelease()
function love.mousereleased(x, y, button)
    gameState.handleMouseRelease(x, y, button)
end
