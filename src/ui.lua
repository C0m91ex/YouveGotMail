-- ui.lua --
-- UI handling implemenation
local scaling = require("src.scaling")

-- global vars
local scaleX, scaleY = 1, 1
local desktopWidth, desktopHeight = love.window.getDesktopDimensions()
local trashBin = { x = (love.graphics.getWidth() / 2 - 370) * scaling.scaleX, y = (love.graphics.getHeight() / 2 - 240) * scaling.scaleY, width = 157, height = 157, color = {1, 0, 0} }
local xButton = { x = (love.graphics.getWidth() / 2 + 1093) * scaling.scaleX, y = (love.graphics.getHeight() / 2 - 302) * scaling.scaleY, width = 50 * scaling.scaleX, height = 18 * scaling.scaleY}
local inboxBackground
local loginBackground
local emailBackground
local trashBinIcon

local currencyFontSize = 30
local timerFontSize = 20
local emailCountFontSize = 20

--local orignalWidth, originalHeight
--local windowWidth, windowHeight

-- getScaleXY()
-- update the scale of the emails when window gets resized
--local function getScaleXY() return scaleX, scaleY end

-- loadAssets()
-- Loading function for loading in UI-related assets
local function loadAssets()
    inboxBackground = love.graphics.newImage('assets/inbox/Inbox Background.png')
    loginBackground = love.graphics.newImage('assets/main_menu/Login Background.png')
    emailBackground = love.graphics.newImage('assets/read_email/Read Email Background.png')
    trashBinIcon = love.graphics.newImage('assets/inbox/Trash Bin.png')
    
    -- fonts --
    mainFont = love.graphics.newFont("assets/fonts/Roboto-Medium.ttf", 15)

    currencyFont = love.graphics.newFont("assets/fonts/Roboto-Medium.ttf", currencyFontSize)

    timerFont = love.graphics.newFont("assets/fonts/Roboto-Medium.ttf", timerFontSize)

    emailCountFont = love.graphics.newFont("assets/fonts/Roboto-Medium.ttf", emailCountFontSize)
end

-- drawBackground()
-- Draws the given image as the game background. !!! CHANGE THIS LATER TO TAKE IN IMAGE AS ARGUMENT !!!
local function drawBackground()
    love.graphics.setFont(mainFont)
    -- scaling the inbox background size base off of window dimensions
    windowWidth, windowHeight = love.graphics.getDimensions()
    local inboxBackgroundWidth, inboxBackgroundHeight = inboxBackground:getDimensions()

    local inboxScaleX = windowWidth / inboxBackgroundWidth
    local inboxScaleY = windowHeight / inboxBackgroundHeight

    love.graphics.draw(inboxBackground, 0, 0, 0, inboxScaleX, inboxScaleY)
end

-- drawTrashBin()
-- Draws the trash bin icon to the game
local function drawTrashBin()
    --love.graphics.setColor(trashBin.color)
    --love.graphics.rectangle("fill", trashBin.x, trashBin.y, trashBin.width, trashBin.height)
    love.graphics.draw(trashBinIcon, trashBin.x, trashBin.y, 0, scaleX, scaleY)
end

--[[
local function drawXButton()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", xButton.x, xButton.y, xButton.width, xButton.height)
end
]]--

-- drawScore()
-- Draws the score counter label
local currencyCountMultiplier = 0
local function drawCurrency(currency)
    if currency >= 1000 * 10^currencyCountMultiplier then
        currencyFontSize = currencyFontSize - 3
        currencyFont = love.graphics.newFont(currencyFontSize)
        love.graphics.setFont(currencyFont)

        currencyCountMultiplier = currencyCountMultiplier + 1
    end
    love.graphics.setColor(1, 0.84, 0)  -- gold yellow color
    love.graphics.setFont(currencyFont)
    love.graphics.printf("$"..currency, (trashBin.x + 70) * scaling.scaleX, (trashBin.y + 215) * scaling.scaleY, 120, "left")
    love.graphics.setColor(1, 1, 1)  -- White color
    love.graphics.setFont(mainFont) -- restores back to main font
end

local emailCountMultiplier = 0
local function drawEmailCount(emailCount)
    if emailCount >= 1000 * 10^emailCountMultiplier then
        emailCountFontSize = emailCountFontSize - 3
        emailCountFont = love.graphics.newFont(emailCountFontSize)
        love.graphics.setFont(emailCountFont)

        emailCountMultiplier = emailCountMultiplier + 1
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(emailCountFont)
    love.graphics.printf(emailCount, (trashBin.x + 119) * scaling.scaleX, (trashBin.y + 303) * scaling.scaleY, 120, "left")
    love.graphics.setColor(1, 1, 1)  -- White color
    love.graphics.setFont(mainFont) -- restores back to main font
end

local timerMaxMultiplier = 0
local function drawTimer(timer)
    if timer >= 1000 * 10^timerMaxMultiplier  then
        timerFontSize = timerFontSize - 3
        timerFont = love.graphics.newFont(timerFontSize)
        love.graphics.setFont(timerFont)

        timerMaxMultiplier = timerMaxMultiplier + 1
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(timerFont)
    love.graphics.printf(timer, (trashBin.x + 24) * scaling.scaleX, (trashBin.y + 303) * scaling.scaleY, 120, "left")
    love.graphics.setColor(1, 1, 1)  -- White color
    love.graphics.setFont(mainFont) -- restores back to main font
end

-- drawOpenedEmail()
-- Brings open the 'opened email' if an email is double clicked
local function drawOpenedEmail(email)
    windowWidth, windowHeight = love.graphics.getDimensions()
    local openedEmailWidth, openedEmailHeight = emailBackground:getDimensions()

    local openedEmailScaleX = windowWidth / openedEmailWidth
    local openedEmailScaleY = windowHeight / openedEmailHeight
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.draw(emailBackground, 0, 0, 0, openedEmailScaleX, openedEmailScaleY)

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 10 * scaling.scaleX, 10 * scaling.scaleY, 100 * scaling.scaleX, 40 * scaling.scaleY)
    love.graphics.setColor(0, 0, 0)
    --love.graphics.print("This is the placeholder for email text", 300, 300)
    love.graphics.printf("Back", 10, 20, 100, "center")
end

-- isBackButtonClicked()
-- Handles mouse interaction with the back button for opened emails to close them
local function isBackButtonClicked(x, y)
    sounds.pickChoice:stop()
    return x > 10 and x < 110 and y > 10 and y < 50
end

local function isXButtonClicked(x, y)
    return  x > xButton.x and x < xButton.x + xButton.width and
            y > xButton.y and y < xButton.y + xButton.height
end


-- isOverTrashBin()
-- Checks to see if an email is hovering on top of trash bin location
-- local function isOverTrashBin(email)
--     return email.x > trashBin.x and email.x < trashBin.x + trashBin.width and
--            email.y > trashBin.y and email.y < trashBin.y + trashBin.height
-- end
local function isOverTrashBin(x, y)
    return x > trashBin.x and x < trashBin.x + trashBin.width and
           y > trashBin.y and y < trashBin.y + trashBin.height
end

-- Creates a popup near where the mouse position is hovering so long as text is provided
-- All other fields are optional and will set to default values if not provided
function hoverPopup(text, textColor, red, green, blue, alpha, width, height)
    if text == nil then return end
    if textColor == nil then textColor = {0, 0, 0} end
    if red == nil then red = 0.678 end
    if green == nil then green = 0.678 end
    if blue == nil then blue = 0.678 end
    if alpha == nil then alpha = 0.5 end
    if width == nil then width = 360 end
    if height == nil then height = 180 end

    local mouseX, mouseY = love.mouse.getPosition()
    local popupX = mouseX - width - 10
    local popupY = mouseY + 10
    
    love.graphics.setColor(red, green, blue, alpha)
    love.graphics.rectangle("fill", popupX, popupY, width, height)
    love.graphics.setColor(textColor)
    love.graphics.printf(text, popupX + 10, popupY + 10, width-10)
    love.graphics.setColor(1, 1, 1)
end

return {
    loadWindow = loadWindow,
    loadAssets = loadAssets,
    drawBackground = drawBackground,
    drawTrashBin = drawTrashBin,
    drawXButton = drawXButton,
    drawCurrency = drawCurrency,
    drawEmailCount = drawEmailCount,
    drawTimer = drawTimer,
    drawOpenedEmail = drawOpenedEmail,
    isBackButtonClicked = isBackButtonClicked,
    isXButtonClicked = isXButtonClicked,
    isOverTrashBin = isOverTrashBin,
    hoverPopup = hoverPopup
}