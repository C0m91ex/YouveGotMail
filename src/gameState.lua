-- gameState.lua --
-- Handles main gameState behaviors
local email = require("src.email")
local ui = require("src.ui")
local shop = require("src.shop")
local scaling = require("src.scaling")

-- local variables
local start = love.timer.getTime()
local gameState = {
    currency = 0,
    selectedEmail = nil,
    openedEmail = nil,
    offsetX = 0,
    offsetY = 0,
    lastClickTime = 0,
    doubleClickDelay = 0.3,
    shopButtonOpen = false,
    lastTime = start
}
local shopButtonNormal = love.graphics.newImage('assets/inbox/Shop Button.png')
local shopButtonHovered = love.graphics.newImage('assets/inbox/Shop Button Hover.png')
local shopButtonClicked = love.graphics.newImage('assets/inbox/Shop Button Click.png')

-- global variables
shopButtonImage = shopButtonNormal

-- isEmailOpened()
-- Access function for email 'opened' status
function gameState.isEmailOpened() return gameState.openedEmail end

-- isShopOpened()
-- Access function for shop 'opened' status
function gameState.isShopOpened() return gameState.shopButtonOpen end

-- getOpenedEmail()
-- Getter function for opened email
function gameState.getOpenedEmail() return gameState.openedEmail end

-- getCurrency()
-- Getter function for currency
function gameState.getCurrency() return gameState.currency end

-- load()
-- Load function for the gameState, calls ui.loadAssets() & email.spawnInitialEmails()
-- Handles loading UI assets and the initial email spawning
function gameState.load()
    scaling.loadWindow()
    ui.loadAssets()
    shop.setUpShop()
    email.spawnInitialEmails()
end

-- setShopButtonClicked()
-- Function to change the button image when clicked
function shop.setShopButtonClicked()
    shopButtonImage = shopButtonClicked
end

-- isShopButtonClicked()
-- Function to change the button image when hovered
function shop.setShopButtonHovered()
    shopButtonImage = shopButtonHovered
end

-- resetShopButton()
-- Function to reset button to normal
function shop.resetShopButton()
    shopButtonImage = shopButtonNormal
end

-- update()
-- Update function for gameState, calls email.handleEmailselection & email.handleDragging
-- Handles mouse interaction player actions in regards to current gamestate
function gameState.update(dt)
    ui.updateFloatingTexts(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    if gameState.openedEmail then
        email.isEmailChoiceHovered(mouseX, mouseY, gameState)
        return
    end
    email.autospawnEmail(email, gameState)
    
    if love.mouse.isDown(1) then
        email.handleEmailSelection(mouseX, mouseY, gameState)
        email.handleDragging(mouseX, mouseY, gameState)
    else
        gameState.selectedEmail = nil
        shop.isShopItemHovered(mouseX, mouseY)
        if shop.isShopButtonHovered(mouseX, mouseY) and not gameState.openedEmail then
            shop.setShopButtonHovered()
        else
            shop.resetShopButton()
        end
    end
end

-- handleMouseRelease()
-- Mouse click & release handler
function gameState.handleMouseRelease(x, y, button)
    if button == 1 then
        if gameState.openedEmail then
            if ui.isBackButtonClicked(x, y) then
                gameState.openedEmail = nil
                email.choiceReset()
            else
                email.isEmailChoiceClicked(x, y, gameState)
            end
        end

        -- Toggle shop button state
        if shop.isShopButtonClicked(x, y) and not gameState.openedEmail then
            if not gameState.shopButtonOpen then
                gameState.shopButtonOpen = true
                shop.setShopButtonClicked()  -- Change to clicked image
            else
                gameState.shopButtonOpen = false
                shop.resetShopButton()  -- Reset to normal image
            end
        end

        if gameState.shopButtonOpen then
            shop.isShopItemClicked(x, y, gameState)
        end

        if ui.isXButtonClicked(x, y) then
            love.event.quit()
        end

        if ui.isOverTrashBin(x, y) then
            email.deleteEmail(gameState)
        else
            email.snapBack(gameState)
        end
    end
end

-- handleMousePress()
-- Mouse click handler
function gameState.addMoney(value)
    gameState.currency = gameState.currency + value
end

return gameState