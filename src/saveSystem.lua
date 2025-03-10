-- saveSystem.lua --
-- save system implementation
local email = require("src.email")
local utils = require("src.utils")

local saveSystem = {}

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

function saveSystem.createSavefile(saveFolderName)
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
end

function saveSystem.autoSave()
    print("autosave test")
    print(love.filesystem.getIdentity())
    love.filesystem.createDirectory("autosave")
    saveSystem.createSavefile("autosave")
end

function saveSystem.autoLoad()
    print("autoload test")
    email.setEmailBase("autosave/EmailBase.csv")
    email.setEmailPool("autosave/EmailPool.csv")
    email.setEmailInbox("autosave/EmailInbox.csv")
end

function saveSystem.load()
    saveSystem.autoLoad()
end

return saveSystem