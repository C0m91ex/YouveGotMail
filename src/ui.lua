-- ui.lua --
-- UI handling implemenation
local trashBin = { x = love.graphics.getWidth() / 2 - 380, y = love.graphics.getHeight() / 2 - 250, width = 100, height = 50, color = {1, 0, 0} }
local background

local function loadAssets()
    background = love.graphics.newImage('assets/inbox-background.png')
end

local function drawBackground()
    love.graphics.draw(background)
end

local function drawTrashBin()
    love.graphics.setColor(trashBin.color)
    love.graphics.rectangle("fill", trashBin.x, trashBin.y, trashBin.width, trashBin.height)
end

local function drawScore(score)
    love.graphics.setColor(0, 0, 0)  -- Black color
    love.graphics.printf("Score: " .. score, trashBin.x, trashBin.y + 80, 120, "center")
    love.graphics.setColor(1, 1, 1)  -- White color
end

local function drawOpenedEmail(email)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 10, 10, 100, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Back", 10, 20, 100, "center")
end

local function isBackButtonClicked(x, y)
    return x > 10 and x < 110 and y > 10 and y < 50
end

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
