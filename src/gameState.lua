-- gameState.lua --
-- Handles main gameState behaviors
local email = require("src.email")
local ui = require("src.ui")

local gameState = {
    score = 0,
    selectedEmail = nil,
    openedEmail = nil,
    offsetX = 0,
    offsetY = 0,
    lastClickTime = 0,
    doubleClickDelay = 0.3
}

function gameState.load()
    ui.loadAssets()
    email.spawnInitialEmails()
end

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

function gameState.handleMouseRelease(x, y, button)
    if button == 1 and gameState.openedEmail then
        if ui.isBackButtonClicked(x, y) then
            gameState.openedEmail = nil
        end
    end
end

function gameState.isEmailOpened() return gameState.openedEmail end
function gameState.getOpenedEmail() return gameState.openedEmail end
function gameState.getScore() return gameState.score end

return gameState