-- ui.lua --
-- UI handling implemenation

-- global vars
local trashBin = { x = love.graphics.getWidth() / 2 - 360, y = love.graphics.getHeight() / 2 - 250, width = 157, height = 157, color = {1, 0, 0} }
local inboxBackground
local loginBackground
local trashBinIcon

local orignalWidth, originalHeight
local scaleX, scaleY

local windowWidth, windowHeight

local function loadWindow()
    orignalWidth, originalHeight = love.graphics.getDimensions()

    scaleX, scaleY = 1, 1
end

function love.resize(newWidth, newHeight)
    scaleX = newWidth / orignalWidth
    scaleY = newHeight / originalHeight
end

-- loadAssets()
-- Loading function for loading in UI-related assets
local function loadAssets()
    inboxBackground = love.graphics.newImage('assets/inbox_background.png')
    loginBackground = love.graphics.newImage('assets/login-background.png')
    trashBinIcon = love.graphics.newImage('assets/Delete Button.png')
end

-- drawBackground()
-- Draws the given image as the game background. !!! CHANGE THIS LATER TO TAKE IN IMAGE AS ARGUMENT !!!
local function drawBackground()
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

-- drawScore()
-- Draws the score counter label
local function drawCurrency(currency)
    love.graphics.setColor(0, 0, 0)  -- Black color
    love.graphics.printf("Currency: $" .. currency, trashBin.x, trashBin.y + 180, 120, "center")
    love.graphics.setColor(1, 1, 1)  -- White color
end

-- drawOpenedEmail()
-- Brings open the 'opened email' if an email is double clicked
local function drawOpenedEmail(email)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    --local scaleX = 800/loginBackground:getWidth() 
    --local scaleY = 400/loginBackground:getHeight() 
    love.graphics.draw(loginBackground, 0, 0, 0, scaleX, scaleY)

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 10, 10, 100, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("This is the placeholder for email text", 300, 300)
    love.graphics.printf("Back", 10, 20, 100, "center")
end

-- isBackButtonClicked()
-- Handles mouse interaction with the back button for opened emails to close them
local function isBackButtonClicked(x, y)
    return x > 10 and x < 110 and y > 10 and y < 50
end

-- isOverTrashBin()
-- Checks to see if an email is hovering on top of trash bin location
local function isOverTrashBin(email)
    return email.x > trashBin.x and email.x < trashBin.x + trashBin.width and
           email.y > trashBin.y and email.y < trashBin.y + trashBin.height
end

return {
    loadWindow = loadWindow,
    loadAssets = loadAssets,
    drawBackground = drawBackground,
    drawTrashBin = drawTrashBin,
    drawCurrency = drawCurrency,
    drawOpenedEmail = drawOpenedEmail,
    isBackButtonClicked = isBackButtonClicked,
    isOverTrashBin = isOverTrashBin
}
