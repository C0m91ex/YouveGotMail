-- email.lua --
-- Implementation file for email class
local ui = require("src.ui") 
local emails = {}
local screen = { width = love.graphics.getWidth() / 2, height = love.graphics.getHeight() / 2 }

local function spawnEmail(mode, x, y, width, height, color)
    table.insert(emails, {
        mode = mode,
        x = x,
        y = y,
        width = width,
        height = height,
        color = color,
        content = "Sample email content!"
    })
end

local function spawnInitialEmails()
    local yOffset = 250
    for _ = 1, 9 do
        spawnEmail("fill", screen.width - 220, screen.height - yOffset, 400, 50, {1, 1, 1})
        yOffset = yOffset - 70
    end
end

local function handleEmailSelection(mouseX, mouseY, gameState)
    if not gameState.selectedEmail then
        for _, email in ipairs(emails) do
            if mouseX > email.x and mouseX < email.x + email.width and
               mouseY > email.y and mouseY < email.y + email.height then

                if love.timer.getTime() - gameState.lastClickTime < gameState.doubleClickDelay then
                    gameState.openedEmail = email
                    return
                end

                gameState.selectedEmail = email
                gameState.offsetX = mouseX - email.x
                gameState.offsetY = mouseY - email.y
                gameState.lastClickTime = love.timer.getTime()
                break
            end
        end
    end
end

local function handleDragging(mouseX, mouseY, gameState)
    if gameState.selectedEmail then
        gameState.selectedEmail.x = mouseX - gameState.offsetX
        gameState.selectedEmail.y = mouseY - gameState.offsetY

        if ui.isOverTrashBin(gameState.selectedEmail) then
            for i, email in ipairs(emails) do
                if email == gameState.selectedEmail then
                    table.remove(emails, i)
                    for j = i, #emails do
                        emails[j].y = emails[j].y - 70
                    end
                    gameState.selectedEmail = nil
                    gameState.score = gameState.score + 1
                    break
                end
            end
        end
    end
end

local function drawEmails()
    for _, email in ipairs(emails) do
        love.graphics.setColor(email.color)
        love.graphics.rectangle(email.mode, email.x, email.y, email.width, email.height)
    end
end

return {
    spawnInitialEmails = spawnInitialEmails,
    handleEmailSelection = handleEmailSelection,
    handleDragging = handleDragging,
    drawEmails = drawEmails
}