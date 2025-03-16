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
local saveSystem = require("src.saveSystem")
local setting = require("src.setting")

-- global variables
sounds = {}

-- local variables
-- start = love.timer.getTime()      -- Timer related
--local lastSecond = math.floor(start)  

-- load()
-- Load function, calls gamestate.load()
function love.load()
    login.load()    -- Requires login scene to be loaded first
    login.start() 

    -- tutorial.load()  -- Requires tutorial scene to be loaded first
    -- tutorial.start() -- NOT IMPLEMENTED

    -- Window settings
    windowWidth, windowHeight = love.window.getDesktopDimensions()
    love.window.setMode(windowWidth, windowHeight, {
        resizable = true,
        fullscreen = true
    })
    
    saveSystem.load()
    gameState.load()
end

-- update()
-- Update function, calls gameState.update()
function love.update(dt)
  if login.completed then
    gameState.update(dt)
end

-- This is for the restart button found in the options menu
-- placed here cause I was having looping issues and didn't want to bother figuring out a fix to get it to work in gameState.lua, lol
function love.mousepressed( x, y, button)
    if button == 1 then
        if setting.isRestartButtonClicked(x, y) and not gameState.openedEmail and gameState.optionsOpen then 
            saveSystem.resetGame()
            print("reset game")
        end
    end
end

-- draw()
-- Draw function, calls ui, email, and shop drawing functions
function love.draw()
    ui.drawBackground()

    -- Timer & e-mail delete (money) counter
    local currentSecond = math.floor(love.timer.getTime()-gameState.start)
    local timeTilSpawn = tonumber(string.format("%.2f",email.getSpawnPeriod()))
    ui.drawEmailCount(email.getLengthEmails())
    ui.drawTimer(timeTilSpawn)

    -- Checks if current gamestate is in email opened state or not
    if gameState.isEmailOpened() then
        ui.drawOpenedEmail(gameState.getOpenedEmail())
        email.printEmailContent(gameState.getOpenedEmail())
    else
        ui.drawCurrency(gameState.getCurrency())
        ui.drawTrashBin()
        email.drawEmails()
        --ui.drawXButton()

        setting.drawOptionsButton()

        ui.drawStatsButton()
        if gameState.isStatsBarOpened() then
           ui.drawStatsBar()
        end

        shop.drawShopTitle()
        if gameState.isShopOpened() then
           shop.drawShopItems()
        end

        if gameState.isOptionsOpened() then
            setting.drawOptionsBackground()
            setting.drawOptionsBackButton()
            setting.drawRestartButton()
            setting.drawMasterVolume()
            setting.drawMusicVolume()
            setting.drawSoundVolume()
            setting.drawMuteToggle()
            ui.drawOptionText()
        end
    end
    ui.drawFloatingTexts()
end

-- mousereleased()
-- Game mouse release event handler
-- Calls gameState.handleMouseRelease()
function love.mousereleased(x, y, button)
    gameState.handleMouseRelease(x, y, button)
end

-- keypressed()
-- Game key press event handler
-- https://love2d.org/wiki/love.keypressed
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        saveSystem.autoSave()
        love.event.quit()
    end
    if key == "space" then
        email.receiveEmail(gameState)
    end
    if key == "=" then
        gameState.currency = gameState.currency + 100
    end

    if key == "r" then
        saveSystem.resetGame()
    end
 end