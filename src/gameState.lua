-- gameState.lua --
-- Handles main gameState behaviors
local email = require("src.email")
local ui = require("src.ui")
local shop = require("src.shop")

-- global vars
local gameState = {
    score = 0,
    selectedEmail = nil,
    openedEmail = nil,
    offsetX = 0,
    offsetY = 0,
    lastClickTime = 0,
    doubleClickDelay = 0.3,
    shopOffsetY = 10
}

-- load()
-- Load function for the gameState, calls ui.loadAssets() & email.spawnInitialEmails()
-- Handles loading UI assets and the initial email spawning
function gameState.load()
    ui.loadAssets()

    -- Make sure when increasing this variable to set up name and price for the added items to the shop *see shop.lua*
    for _ = 1, numberOfShopItems do
        -- createShopItem(mode, x, y, width, height, color)
        ui.createShopItem("fill", love.graphics.getWidth() / 2 - 380, love.graphics.getHeight() / 2 + gameState.shopOffsetY, 100, 50, {1, 0.5, 0})
        gameState.shopOffsetY = gameState.shopOffsetY + 70
    end

    -- Shop item stuff 
    -- Will put all of this into a different lua file called "shop.lua"
    -- setting the name and price for item 1
    --[[
    ui.shopItems[1].name = "item 1"
    ui.shopItems[1].price = 10

    -- setting the name and price for item 2
    ui.shopItems[2].name = "item 2"
    ui.shopItems[2].price = 20
    ]]--
    shop.setUpShop()

    email.spawnInitialEmails()
end

-- update()
-- Update function for gameState, calls email.handleEmailselection & email.handleDragging
-- Handles mouse interaction player actions in regards to current gamestate
function gameState.update(dt)
    if gameState.openedEmail then return end

    local mouseX, mouseY = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        email.handleEmailSelection(mouseX, mouseY, gameState)
        email.handleDragging(mouseX, mouseY, gameState)
    else
        gameState.selectedEmail = nil
    end
end

-- handleMouseRelease()
-- Mouse click & release handler
function gameState.handleMouseRelease(x, y, button)
    if button == 1 then
        if gameState.openedEmail then
            if ui.isBackButtonClicked(x, y) then
                gameState.openedEmail = nil
            end
        end

       -- ui.isShopItemclicked(x, y)
    end
end

function gameState.isEmailOpened() return gameState.openedEmail end
function gameState.getOpenedEmail() return gameState.openedEmail end
function gameState.getScore() return gameState.score end

return gameState