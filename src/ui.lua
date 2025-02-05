-- ui.lua --
-- UI handling implemenation

-- global vars
local trashBin = { x = love.graphics.getWidth() / 2 - 380, y = love.graphics.getHeight() / 2 - 250, width = 100, height = 50, color = {1, 0, 0} }
local inboxBackground
local loginBackground

-- loadAssets()
-- Loading function for loading in UI-related assets
local function loadAssets()
    inboxBackground = love.graphics.newImage('assets/inbox-background.png')
    loginBackground = love.graphics.newImage('assets/login-background.png')
end

-- drawBackground()
-- Draws the given image as the game background. !!! CHANGE THIS LATER TO TAKE IN IMAGE AS ARGUMENT !!!
local function drawBackground()
    love.graphics.draw(inboxBackground)
end

-- drawTrashBin()
-- Draws the trash bin icon to the game
local function drawTrashBin()
    love.graphics.setColor(trashBin.color)
    love.graphics.rectangle("fill", trashBin.x, trashBin.y, trashBin.width, trashBin.height)
end

-- drawScore()
-- Draws the score counter label
local function drawScore(score)
    love.graphics.setColor(0, 0, 0)  -- Black color
    love.graphics.printf("Score: " .. score, trashBin.x, trashBin.y + 80, 120, "center")
    love.graphics.setColor(1, 1, 1)  -- White color
end

-- drawOpenedEmail()
-- Brings open the 'opened email' if an email is double clicked
local function drawOpenedEmail(email)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local scaleX = 800/loginBackground:getWidth() 
    local scaleY = 400/loginBackground:getHeight() 
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
    loadAssets = loadAssets,
    drawBackground = drawBackground,
    drawTrashBin = drawTrashBin,
    drawScore = drawScore,
    drawOpenedEmail = drawOpenedEmail,
    isBackButtonClicked = isBackButtonClicked,
    isOverTrashBin = isOverTrashBin
}
