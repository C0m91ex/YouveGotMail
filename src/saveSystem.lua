-- saveSystem.lua --
-- save system implementation
local email = require("src.email")
local utils = require("src.utils")
local playerState = require("src.playerState")
local gameState = require("src.gameState")

local saveSystem = {}
saveSystem.saveFileNames = {"/EmailBase.csv","/EmailPool.csv","/EmailInbox.csv","/PlayerState.csv","/GameState.csv"}
saveSystem.initialEmailBase = "data/EmailBase.csv"

function saveSystem.saveEmailBase()
    local emailBaseString = ""
    emailBaseString = emailBaseString..utils.emailListToString(email.getEmailBase())
    return emailBaseString
end

function saveSystem.saveEmailPool()
    local emailPoolString = ""
    emailPoolString = emailPoolString..utils.emailListToString(email.getEmailPool())
    return emailPoolString
end

function saveSystem.saveEmailInbox()
    local emailInboxString = ""
    emailInboxString = emailInboxString..utils.emailListToString(email.getEmailInbox())
    return emailInboxString
end

function saveSystem.savePlayerState()
    local playerStateString = ""
    playerStateString = playerStateString..utils.tableToString(playerState.getPlayerVarList())
    return playerStateString
end

function saveSystem.saveGameState()
    local gameStateString = ""
    gameStateString = gameStateString..utils.tableToString(gameState.getGameState())
    return gameStateString
end

function saveSystem.updateSaveFile(saveFolderName)
    success, message = love.filesystem.write(saveFolderName.."/EmailBase.csv", saveSystem.saveEmailBase())
    if success then 
        print ('EmailBase created')
    else 
        print ('EmailBase not created: '..message)
    end
    success, message = love.filesystem.write(saveFolderName.."/EmailPool.csv", saveSystem.saveEmailPool())
    if success then 
        print ('EmailPool created')
    else 
        print ('EmailPool not created: '..message)
    end
    success, message = love.filesystem.write(saveFolderName.."/EmailInbox.csv", saveSystem.saveEmailInbox())
    if success then 
        print ('EmailInbox created')
    else 
        print ('EmailInbox not created: '..message)
    end
    success, message = love.filesystem.write(saveFolderName.."/PlayerState.csv", saveSystem.savePlayerState())
    if success then 
        print ('PlayerState created')
    else 
        print ('PlayerState not created: '..message)
    end
    success, message = love.filesystem.write(saveFolderName.."/GameState.csv", saveSystem.saveGameState())
    if success then 
        print ('GameState created')
    else 
        print ('GameState not created: '..message)
    end
end

function saveSystem.initializeSave(saveFolderName)
    print("init test")
    success, message = love.filesystem.write(saveFolderName.."/EmailBase.csv", love.filesystem.read("data/EmailBase.csv"))
    if success then 
        print ('EmailBase created')
    else 
        print ('EmailBase not created: '..message)
    end
    for i, name in ipairs(saveSystem.saveFileNames) do
        local saveFileName = tostring(saveFolderName)..tostring(name)
        if not (love.filesystem.getInfo(saveFileName)) then
            love.filesystem.write(saveFileName, "")
        end
    end
end

function saveSystem.createNewSave(saveFolderName)
    if not love.filesystem.getInfo(saveFolderName) then
        love.filesystem.createDirectory(saveFolderName)
        saveSystem.initializeSave(saveFolderName)
    end
end

function saveSystem.autoSave()
    print("autosave test")
    print(love.filesystem.getIdentity())
    love.filesystem.createDirectory("autosave")
    saveSystem.updateSaveFile("autosave")
end

function saveSystem.autoLoad()
    print("autoload test")
    email.setEmailBase("autosave/EmailBase.csv")
    email.setEmailPool("autosave/EmailPool.csv")
    email.setEmailInbox("autosave/EmailInbox.csv")
    playerState.setPlayerVarList(love.filesystem.read("autosave/PlayerState.csv"))
    gameState.setGameState(love.filesystem.read("autosave/GameState.csv"))
end

function saveSystem.load()
    if not love.filesystem.getInfo("autosave") then
        saveSystem.createNewSave("autosave")
    end
    saveSystem.autoLoad()
end

return saveSystem