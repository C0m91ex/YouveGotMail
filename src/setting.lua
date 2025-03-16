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

local muteToggle = { x = (love.graphics.getWidth() / 2 + 410), y = (love.graphics.getHeight() / 2 + 150), width = 30, height = 30 }

local function loadAssets()
    optionsBackground = love.graphics.newImage('assets/options/Settings Background.png')

    -- Audio set-up
    sounds.emailDelete = love.audio.newSource("assets/sounds/email-delete.mp3", "static")
    sounds.pickChoice = love.audio.newSource("assets/sounds/pick-choice.mp3", "static")
    sounds.powerUp = love.audio.newSource("assets/sounds/power-up.mp3", "static")
    sounds.music = love.audio.newSource("assets/sounds/bgmMusic01.mp3", "stream")

    sounds.masterVolume = 10
    sounds.soundVolume = 10
    sounds.musicVolume = 10
    sounds.mute = 1

    sounds.finalMusicVolume = sounds.mute * sounds.masterVolume * math.max(sounds.musicVolume, 0.01)
    sounds.finalFXVolume = sounds.mute * sounds.masterVolume * math.max(sounds.soundVolume, 0.01)
    
    sounds.emailDelete:setVolume(0.4 * math.pow(sounds.finalFXVolume, 0.5))
    sounds.pickChoice:setVolume(0.3 * math.pow(sounds.finalFXVolume, 0.5))
    sounds.powerUp:setVolume(0.4 * math.pow(sounds.finalFXVolume, 0.5))
    sounds.music:setVolume(0.1 * math.pow(sounds.finalMusicVolume, 0.5))
    
    sounds.music:setLooping(true)
    sounds.music:play()
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

local function drawMuteToggle()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(muteImage, muteToggle.x * scaling.scaleX, muteToggle.y * scaling.scaleY, 0, scaling.scaleX, scaling.scaleY)
end

local function drawOptionsBackground()
    -- scaling the options background size base off of window dimensions
    windowWidth, windowHeight = love.graphics.getDimensions()
    local optionsBackgroundWidth, optionsBackgroundHeight = optionsBackground:getDimensions()

    local optionsScaleX = windowWidth / optionsBackgroundWidth
    local optionsScaleY = windowHeight / optionsBackgroundHeight

    love.graphics.draw(optionsBackground, 0, 0, 0, optionsScaleX, optionsScaleY)
end 

local function updateVolume()
    sounds.finalMusicVolume = sounds.mute * sounds.masterVolume * math.max(sounds.musicVolume, 0.01)
    sounds.finalFXVolume = sounds.mute * sounds.masterVolume * math.max(sounds.soundVolume, 0.01)
    
    sounds.emailDelete:setVolume(0.4 * math.pow(sounds.finalFXVolume, 0.5))
    sounds.pickChoice:setVolume(0.3 * math.pow(sounds.finalFXVolume, 0.5))
    sounds.powerUp:setVolume(0.4 * math.pow(sounds.finalFXVolume, 0.5))
    sounds.music:setVolume(0.1 * math.pow(sounds.finalMusicVolume, 0.5))
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

local function isMuteButtonClicked(x, y)
    return  x > muteToggle.x * scaling.scaleX and x < muteToggle.x * scaling.scaleX + muteToggle.width * scaling.scaleX and
            y > muteToggle.y * scaling.scaleY and y < muteToggle.y * scaling.scaleY + muteToggle.height * scaling.scaleY 
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
    drawMuteToggle = drawMuteToggle,
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
    isSoundUpButtonClicked = isSoundUpButtonClicked,
    isMuteButtonClicked = isMuteButtonClicked,
    updateVolume = updateVolume
}