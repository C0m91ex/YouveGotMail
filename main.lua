-- main.lua --
-- Main game function manager
local gameState = require("src.gameState")
local ui = require("src.ui")
local email = require("src.email")
local utils = require("src.utils")
local file = require("src.file")
local shop = require("src.shop")
local playerState = require("src.playerState")
local login = require("src.login")

-- global vars
local start = love.timer.getTime()
local lastSecond = math.floor(start)
local growthPeriod = 5
local growthRate = 1 / growthPeriod
local csv = {}
 
-- load()
-- Load function, calls load() from gameState.lua
function love.load()
    --login.load()
    --login.start()  -- Block here until login is complete
    -- set window size and settings
    -- smaller window, use 800x600
    -- bigger window, use 1600x900
    love.window.setMode(1600, 900, {
        resizable = true,
        fullscreen = true
    }) -- set window to 800x600 pixels

    gameState.load()
    csv = file.loadEmailFile("data/EmailBase.csv")

    -- for i, v in pairs (csv[1]) do
    --     print(i.."="..tostring(v))
    -- end
    -- local testString = "{mom = 2, dad = 2, brother = 3, sister = <=4}"
    -- local testTable = {mom = 2, dad = 1}
    -- for i, v in pairs (testTable) do
    --     print(i.."="..v)
    -- end
    
    -- utils.updateTableFromString(testTable, testString)
    -- for i, v in pairs (testTable) do
    --     print(i.."="..v)
    -- end

    -- print(playerState.getPlayerSingleVar("mom"))
    -- utils.updateTableFromString(playerState.getPlayerVarList(), "mom = 2")
    -- print(playerState.getPlayerSingleVar("mom"))
    -- print("2<3 expected: "..tostring(2<3)..", actual: "..tostring(playerState.playerCheck("mom", "<3")))
    -- print("2<=3 expected: "..tostring(2<=3)..", actual: "..tostring(playerState.playerCheck("mom", "<=3")))
    -- print("2<1 expected: "..tostring(2<1)..", actual: "..tostring(playerState.playerCheck("mom", "<1")))
    -- print("2<=1 expected: "..tostring(2<=1)..", actual: "..tostring(playerState.playerCheck("mom", "<=1")))
    -- print("2<2 expected: "..tostring(2<2)..", actual: "..tostring(playerState.playerCheck("mom", "<2")))
    -- print("2<=2 expected: "..tostring(2<=2)..", actual: "..tostring(playerState.playerCheck("mom", "<=2")))
    -- print("2>2 expected: "..tostring(2>2)..", actual: "..tostring(playerState.playerCheck("mom", ">2")))
    -- print("2>=2 expected: "..tostring(2>=2)..", actual: "..tostring(playerState.playerCheck("mom", ">=2")))
    -- print("2!=3 expected: "..tostring(2~=3)..", actual: "..tostring(playerState.playerCheck("mom", "!=3")))
    -- print("2!3 expected: "..tostring(2~=3)..", actual: "..tostring(playerState.playerCheck("mom", "!3")))
    -- print("2~=3 expected: "..tostring(2~=3)..", actual: "..tostring(playerState.playerCheck("mom", "~=3")))
    -- print("2~3 expected: "..tostring(2~=3)..", actual: "..tostring(playerState.playerCheck("mom", "~3")))
    -- print("2=3 expected: "..tostring(2==3)..", actual: "..tostring(playerState.playerCheck("mom", "3")))
    -- print("2!=2 expected: "..tostring(2~=2)..", actual: "..tostring(playerState.playerCheck("mom", "!=2")))
    -- print("2!2 expected: "..tostring(2~=2)..", actual: "..tostring(playerState.playerCheck("mom", "!2")))
    -- print("2~=2 expected: "..tostring(2~=2)..", actual: "..tostring(playerState.playerCheck("mom", "~=2")))
    -- print("2~2 expected: "..tostring(2~=2)..", actual: "..tostring(playerState.playerCheck("mom", "~2")))
    -- print("2=2 expected: "..tostring(2==2)..", actual: "..tostring(playerState.playerCheck("mom", "2")))


    -- print("expected: 1")
    -- print(playerState.getPlayerSingleVar("mom")) --passes--
    -- playerState.setPlayerVar("mom", 2)
    -- print("expected: 2")
    -- print(playerState.getPlayerSingleVar("mom")) --passes--
    -- print("expected: 0")
    -- print(playerState.getPlayerSingleVar("dad")) --passes--

    -- for i, v in pairs(playerState.getPlayerMultiVars("dad")) do
    --     print(i..'='..v)
    -- end

    -- for i, v in pairs(playerState.getPlayerVarList()) do
    --     print(i..'='..v)
    -- end
    
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
    love.graphics.print("Current second: " .. currentSecond, 60, 350)
    love.graphics.print("Current # of emails: ".. email.getLengthEmails(), 50, 400)
    love.graphics.setColor(1, 1, 1)  -- White color

    if gameState.isEmailOpened() then
        ui.drawOpenedEmail(gameState.getOpenedEmail())
        email.printEmailContent(gameState.getOpenedEmail())
    else
        ui.drawCurrency(gameState.getCurrency())
        ui.drawTrashBin()
        email.drawEmails()

        shop.drawShopTitle()
        if gameState.isShopOpened() then
            shop.drawShopItems()
        end
    end
end

-- mousereleased()
-- Calls gameState.handleMouseRelease()
function love.mousereleased(x, y, button)
    gameState.handleMouseRelease(x, y, button)
end

-- https://love2d.org/wiki/love.keypressed
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
    if key == "space" then
        email.timedEmailSpawn(1)
    end
 end