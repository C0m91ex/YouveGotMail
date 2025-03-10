-- saveSystem.lua --
-- save system implementation
local email = require("src.email")
local utils = require("src.utils")

local saveSystem = {}

function saveSystem.createSavefile()
    local savefileString = ""
    savefileString = savefileString..utils.emailBaseToString(email.getEmailBase())
    return savefileString
end

function saveSystem.autoSave(filename)
    print("autosave test")
    print(love.filesystem.getIdentity())
    success, message = love.filesystem.write(filename, saveSystem.createSavefile())
    if success then 
        print ('file created')
    else 
        print ('file not created: '..message)
    end
end

function saveSystem.autoLoad()
    print("autoload test")
    email.setEmailBase("EmailBase.csv")
end

function saveSystem.load()
    saveSystem.autoLoad()
end

return saveSystem