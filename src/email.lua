-- email.lua --
-- Implementation file for email class
local ui = require("src.ui")
local file = require("src.file")

-- global vars
local emails = {}
local screen = { width = love.graphics.getWidth() / 2, height = love.graphics.getHeight() / 2 }
local globalOffsetY = 0
local spawnPeriod = 0

-- Functions --

-- getLengthEmails()
-- Getter function that returns length of emails table
local function getLengthEmails()
    return #emails
end

-- spawnEmail()
-- Spawns an email with the given mode, x & y position, dimensions, and color
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

-- timedEmailSpawn()
-- Spawns an email 
local function timedEmailSpawn(period)
    spawnEmail("fill", screen.width - 220, screen.height - globalOffsetY, 400, 50, {1, 1, 1})
    spawnPeriod = period
    globalOffsetY = globalOffsetY - 70
end

-- spawnInitialEmails()
-- Spawns the initial 9 emails for the gamestart setup
-- Only gets called once at gamestart
local function spawnInitialEmails()
    local yOffset = 250
    for _ = 1, 4 do
        spawnEmail("fill", screen.width - 220, screen.height - yOffset, 400, 50, {1, 1, 1})
        yOffset = yOffset - 70
    end
    globalOffsetY = yOffset
end

-- handleEmailSelection()
-- Handler function for email selection & opening
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

-- handleDragging()
-- Handler function for dragging emails w/mouse
local function handleDragging(mouseX, mouseY, gameState)
    if gameState.selectedEmail then
        gameState.selectedEmail.x = mouseX - gameState.offsetX
        gameState.selectedEmail.y = mouseY - gameState.offsetY

        if ui.isOverTrashBin(gameState.selectedEmail) then
            globalOffsetY = globalOffsetY + 70
            for i, email in ipairs(emails) do
                if email == gameState.selectedEmail then
                    table.remove(emails, i)
                    for j = i, #emails do
                        emails[j].y = emails[j].y - 70
                    end
                    gameState.selectedEmail = nil
                    gameState.currency = gameState.currency + 1
                    break
                end
            end
        end
    end
end

-- drawEmails()
-- Draw function for drawing emails to the screen (in their respective colors)
local function drawEmails()
    for _, email in ipairs(emails) do
        love.graphics.setColor(email.color)
        love.graphics.rectangle(email.mode, email.x, email.y, email.width, email.height)
    end
end

local function printEmail(email)
    for row, values in ipairs(email) do
        print(unpack(values))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("content", screen.width - 390, screen.height - 280, 120, "center")
        for section, content in ipairs(values) do 
            print(unpack(content))
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(unpack(content), screen.width - 390, screen.height - 280, 120, "center")
        end
    end
end

return {
    getLengthEmails = getLengthEmails,
    spawnEmail = spawnEmail,
    timedEmailSpawn = timedEmailSpawn,
    spawnInitialEmails = spawnInitialEmails,
    handleEmailSelection = handleEmailSelection,
    handleDragging = handleDragging,
    drawEmails = drawEmails
}

