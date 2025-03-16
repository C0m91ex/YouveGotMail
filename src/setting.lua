-- Setting.lua
-- The options menu that allows users to control the settings of the game
local scaling = require("src.scaling")

local optionsButton = { x = (love.graphics.getWidth() / 2 - 390), y = (love.graphics.getHeight() / 2 + 540), width = 197, height = 50 }
local optionsBackButton = { x = (love.graphics.getWidth() / 2 + 239), y = (love.graphics.getHeight() / 2 + 300), width = 320, height = 40 }
local restartButton = { x = (love.graphics.getWidth() / 2 + 320), y = (love.graphics.getHeight() / 2 + 230), width = 156, height = 45 }

local masterVolumeUp = { x = (love.graphics.getWidth() / 2 + 550), y = (love.graphics.getHeight() / 2 - 6), width = 41, height = 30 }
local masterVolumeDown = { x = (love.graphics.getWidth() / 2 + 495), y = (love.graphics.getHeight() / 2 - 6), width = 41, height = 30 }

local musicVolumeUp = { x = (love.graphics.getWidth() / 2 + 550), y = (love.graphics.getHeight() / 2 + 45), width = 41, height = 30 }
local musicVolumeDown = { x = (love.graphics.getWidth() / 2 + 495), y = (love.graphics.getHeight() / 2 + 45), width = 41, height = 30 }

local soundVolumeUp = { x = (love.graphics.getWidth() / 2 + 550), y = (love.graphics.getHeight() / 2 + 96), width = 41, height = 30 }
local soundVolumeDown = { x = (love.graphics.getWidth() / 2 + 495), y = (love.graphics.getHeight() / 2 + 96), width = 41, height = 30 }

local function loadAssets()
    optionsBackground = love.graphics.newImage('assets/options/Settings Background.png')
    optionBackButton = love.graphics.newImage('assets/options/Back Button.png')
end

local function drawOptionsButton()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(optionsButtonImage, optionsButton.x * scaling.scaleX, optionsButton.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawOptionsBackButton()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(optionsBackButtonImage, optionsBackButton.x * scaling.scaleX, optionsBackButton.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawRestartButton()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(restartButtonImage, restartButton.x * scaling.scaleX, restartButton.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawMasterVolume()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(masterDecreaseVolumeImage, masterVolumeDown.x * scaling.scaleX, masterVolumeDown.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
    love.graphics.draw(masterIncreaseVolumeImage, masterVolumeUp.x * scaling.scaleX, masterVolumeUp.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawMusicVolume()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(musicDecreaseVolumeImage, musicVolumeDown.x * scaling.scaleX, musicVolumeDown.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
    love.graphics.draw(musicIncreaseVolumeImage, musicVolumeUp.x * scaling.scaleX, musicVolumeUp.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawSoundVolume()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(soundDecreaseVolumeImage, soundVolumeDown.x * scaling.scaleX, soundVolumeDown.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
    love.graphics.draw(soundIncreaseVolumeImage, soundVolumeUp.x * scaling.scaleX, soundVolumeUp.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawOptionsBackground()
    -- scaling the options background size base off of window dimensions
    windowWidth, windowHeight = love.graphics.getDimensions()
    local optionsBackgroundWidth, optionsBackgroundHeight = optionsBackground:getDimensions()

    local optionsScaleX = windowWidth / optionsBackgroundWidth
    local optionsScaleY = windowHeight / optionsBackgroundHeight

    love.graphics.draw(optionsBackground, 0, 0, 0, optionsScaleX, optionsScaleY)
end
    

local function isOptionsButtonHovered(x, y)
    return  x > optionsButton.x * scaling.scaleX and x < optionsButton.x * scaling.scaleX + optionsButton.width * scaling.scaleX and
            y > optionsButton.y * scaling.scaleY and y < optionsButton.y * scaling.scaleY + optionsButton.height * scaling.scaleY  
end

local function isOptionsButtonClicked(x, y)
    return  x > optionsButton.x * scaling.scaleX and x < optionsButton.x * scaling.scaleX + optionsButton.width * scaling.scaleX and
            y > optionsButton.y * scaling.scaleY and y < optionsButton.y * scaling.scaleY + optionsButton.height * scaling.scaleY 
end 

local function isOptionsBackButtonHovered(x, y)
    return  x > optionsBackButton.x * scaling.scaleX and x < optionsBackButton.x * scaling.scaleX + optionsBackButton.width * scaling.scaleX and
            y > optionsBackButton.y * scaling.scaleY and y < optionsBackButton.y * scaling.scaleY + optionsBackButton.height * scaling.scaleY  
end

local function isOptionsBackButtonClicked(x, y)
    return  x > optionsBackButton.x * scaling.scaleX and x < optionsBackButton.x * scaling.scaleX + optionsBackButton.width * scaling.scaleX and
            y > optionsBackButton.y * scaling.scaleY and y < optionsBackButton.y * scaling.scaleY + optionsBackButton.height * scaling.scaleY  
end

local function isRestartButtonHovered(x, y)
    return  x > restartButton.x * scaling.scaleX and x < restartButton.x * scaling.scaleX + restartButton.width * scaling.scaleX and
            y > restartButton.y * scaling.scaleY and y < restartButton.y * scaling.scaleY + restartButton.height * scaling.scaleY  
end

local function isRestartButtonClicked(x, y)
    return  x > restartButton.x * scaling.scaleX and x < restartButton.x * scaling.scaleX + restartButton.width * scaling.scaleX and
            y > restartButton.y * scaling.scaleY and y < restartButton.y * scaling.scaleY + restartButton.height * scaling.scaleY  
end

local function isMasterDownButtonHovered(x, y)
    return  x > masterVolumeDown.x * scaling.scaleX and x < masterVolumeDown.x * scaling.scaleX + masterVolumeDown.width * scaling.scaleX and
            y > masterVolumeDown.y * scaling.scaleY and y < masterVolumeDown.y * scaling.scaleY + masterVolumeDown.height * scaling.scaleY  
end

local function isMasterDownButtonClicked(x, y)
    return  x > masterVolumeDown.x * scaling.scaleX and x < masterVolumeDown.x * scaling.scaleX + masterVolumeDown.width * scaling.scaleX and
            y > masterVolumeDown.y * scaling.scaleY and y < masterVolumeDown.y * scaling.scaleY + masterVolumeDown.height * scaling.scaleY  
end

local function isMasterUpButtonClicked(x, y)
    return  x > masterVolumeUp.x * scaling.scaleX and x < masterVolumeUp.x * scaling.scaleX + masterVolumeUp.width * scaling.scaleX and
            y > masterVolumeUp.y * scaling.scaleY and y < masterVolumeUp.y * scaling.scaleY + masterVolumeUp.height * scaling.scaleY  
end

local function isMasterUpButtonHovered(x, y)
    return  x > masterVolumeUp.x * scaling.scaleX and x < masterVolumeUp.x * scaling.scaleX + masterVolumeUp.width * scaling.scaleX and
            y > masterVolumeUp.y * scaling.scaleY and y < masterVolumeUp.y * scaling.scaleY + masterVolumeUp.height * scaling.scaleY  
end

local function isMusicDownButtonHovered(x, y)
    return  x > musicVolumeDown.x * scaling.scaleX and x < musicVolumeDown.x * scaling.scaleX + musicVolumeDown.width * scaling.scaleX and
            y > musicVolumeDown.y * scaling.scaleY and y < musicVolumeDown.y * scaling.scaleY + musicVolumeDown.height * scaling.scaleY  
end

local function isMusicDownButtonClicked(x, y)
    return  x > musicVolumeDown.x * scaling.scaleX and x < musicVolumeDown.x * scaling.scaleX + musicVolumeDown.width * scaling.scaleX and
            y > musicVolumeDown.y * scaling.scaleY and y < musicVolumeDown.y * scaling.scaleY + musicVolumeDown.height * scaling.scaleY  
end

local function isMusicUpButtonHovered(x, y)
    return  x > musicVolumeUp.x * scaling.scaleX and x < musicVolumeUp.x * scaling.scaleX + musicVolumeUp.width * scaling.scaleX and
            y > musicVolumeUp.y * scaling.scaleY and y < musicVolumeUp.y * scaling.scaleY + musicVolumeUp.height * scaling.scaleY  
end

local function isMusicUpButtonClicked(x, y)
    return  x > musicVolumeUp.x * scaling.scaleX and x < musicVolumeUp.x * scaling.scaleX + musicVolumeUp.width * scaling.scaleX and
            y > musicVolumeUp.y * scaling.scaleY and y < musicVolumeUp.y * scaling.scaleY + musicVolumeUp.height * scaling.scaleY  
end

local function isSoundDownButtonHovered(x, y)
    return  x > soundVolumeDown.x * scaling.scaleX and x < soundVolumeDown.x * scaling.scaleX + soundVolumeDown.width * scaling.scaleX and
            y > soundVolumeDown.y * scaling.scaleY and y < soundVolumeDown.y * scaling.scaleY + soundVolumeDown.height * scaling.scaleY  
end

local function isSoundDownButtonClicked(x, y)
    return  x > soundVolumeDown.x * scaling.scaleX and x < soundVolumeDown.x * scaling.scaleX + soundVolumeDown.width * scaling.scaleX and
            y > soundVolumeDown.y * scaling.scaleY and y < soundVolumeDown.y * scaling.scaleY + soundVolumeDown.height * scaling.scaleY  
end

local function isSoundUpButtonHovered(x, y)
    return  x > soundVolumeUp.x * scaling.scaleX and x < soundVolumeUp.x * scaling.scaleX + soundVolumeUp.width * scaling.scaleX and
            y > soundVolumeUp.y * scaling.scaleY and y < soundVolumeUp.y * scaling.scaleY + soundVolumeUp.height * scaling.scaleY  
end

local function isSoundUpButtonClicked(x, y)
    return  x > soundVolumeUp.x * scaling.scaleX and x < soundVolumeUp.x * scaling.scaleX + soundVolumeUp.width * scaling.scaleX and
            y > soundVolumeUp.y * scaling.scaleY and y < soundVolumeUp.y * scaling.scaleY + soundVolumeUp.height * scaling.scaleY  
end

return {
    loadAssets = loadAssets,
    drawOptionsButton = drawOptionsButton,
    drawOptionsBackButton = drawOptionsBackButton,
    drawOptionsBackground = drawOptionsBackground,
    drawRestartButton = drawRestartButton,
    drawMasterVolume = drawMasterVolume,
    drawMusicVolume = drawMusicVolume,
    drawSoundVolume = drawSoundVolume,
    isOptionsButtonHovered = isOptionsButtonHovered,
    isOptionsButtonClicked = isOptionsButtonClicked,
    isOptionsBackButtonHovered = isOptionsBackButtonHovered,
    isOptionsBackButtonClicked = isOptionsBackButtonClicked,
    isRestartButtonHovered = isRestartButtonHovered,
    isRestartButtonClicked = isRestartButtonClicked,
    isMasterDownButtonHovered = isMasterDownButtonHovered,
    isMasterDownButtonClicked = isMasterDownButtonClicked,
    isMasterUpButtonClicked = isMasterUpButtonClicked,
    isMasterUpButtonHovered = isMasterUpButtonHovered,
    isMusicDownButtonHovered = isMusicDownButtonHovered,
    isMusicDownButtonClicked = isMusicDownButtonClicked,
    isMusicUpButtonHovered = isMusicUpButtonHovered,
    isMusicUpButtonClicked = isMusicUpButtonClicked,
    isSoundDownButtonHovered = isSoundDownButtonHovered,
    isSoundDownButtonClicked = isSoundDownButtonClicked,
    isSoundUpButtonHovered = isSoundUpButtonHovered,
    isSoundUpButtonClicked = isSoundUpButtonClicked
}