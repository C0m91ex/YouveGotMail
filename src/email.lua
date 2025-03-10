-- email.lua --
-- Implementation file for email class
local scaling = require("src.scaling")
local ui = require("src.ui")
local file = require("src.file")
local playerState = require("src.playerState")
local spam = require("src.spam")

-- local variables
local defaultEmail = {                                                                          -- Email data 
    prereq = {},
    sender = "spam@spam.spam",
    subject = "Pelase clik thia linkl!!!",
    body = "spam hehe",
    choices = {},
    ignored = {},
    respond = false
}
-- local emailBase = {}--file.loadEmailFile('data/EmailBase.csv')                            
-- local emailPool = {}
local emails = {} 
local emailValue = 1
local choiceButtons = {}
local spawnPeriod = 5                                                                           -- Email spawning
local spawnValue = 0

local hoverPopup = { x = 0, y = 0, visible = false }

local screen =                                                                                  -- UI/Screen stuff
    { width = love.graphics.getWidth() / 2, height = love.graphics.getHeight() / 2 } 
local buttonWidth = 175
local buttonHeight = 70
local scaleX, scaleY = 1, 1
local globalOffsetY = 0
local emailSpawnPoint = 
    {x = (screen.width - 100) * scaling.scaleX, y = (screen.height - 100) * scaling.scaleY} 
local emailBox = {width = 1080, height = 50, ySpacing = 20}                                     -- Email box dimensions 

-- getSpawnPeriod()
-- Access function for email spawnPeriod
local function getSpawnPeriod() return spawnPeriod end

-- setSpawnPeriod()
-- Modifier/setter function for email spawnPeriod
local function setSpawnPeriod(value) spawnPeriod = value end

-- autospawnEmail()
-- Handles procedural generation of emails, uses currentTime and spawnPeriod
local function autospawnEmail(email, gameState)
    local currentTime = love.timer.getTime()
    if currentTime >= gameState.lastTime + email.getSpawnPeriod() then
        email.receiveEmail(gameState)
        gameState.lastTime = currentTime
    end
end

-- getLengthEmails()
-- Access function that returns length of emails table
local function getLengthEmails()
    return #emails
end

-- fillEmailPool()
-- Fills the email pool with emails that meet the prereqs
local function fillEmailPool()
    for i, emailContent in ipairs(emailBase) do
        local prereq = emailContent["prereq"]
        local prereqCheckFlag = true
        if next(prereq) then
            for key, value in pairs(prereq) do
                if not playerState.playerCheck(key, value) then prereqCheckFlag = false break end
            end
        end
        if prereqCheckFlag then
            table.insert(emailPool, emailContent)
            table.remove(emailBase, i)
        end
    end
end

-- getNextEmailContent()
-- Returns the next email content from the email pool
local function getNextEmailContent(targetPool)
    local emailContent = {}
    if next(targetPool) ~= nil then
        emailContent = table.remove(targetPool)
        file.serializeEmailTest(emailContent)
    else
        emailContent = spam.generateRandomSpamEmail()
    end
    return emailContent
end

-- spawnEmailEvent()
-- Spawns an email event that adds money to the player's currency
local function spawnEmailEvent(gameState)
    gameState.addMoney(spawnValue)
end

-- spawnEmail()
-- Spawns an email with the given mode, x & y position, dimensions, and color
local function spawnEmail(mode, x, y, width, height, color, targetPool, content)
    fillEmailPool()
    moveEmailsDown()
    if targetPool == nil then targetPool = emailPool end
    if content == nil then content = getNextEmailContent(targetPool) end
    local emailToAdd = {
        mode = mode,
        x = x,
        originX = x,
        y = y,
        originY = y,
        emailAbove = nil,
        emailBelow = nil,
        width = width,
        height = height,
        color = color,
        targetPool = targetPool,
        content = content
    }
    local _, topEmail = next(emails)
    if topEmail then
        emailToAdd.emailBelow = topEmail
        topEmail.emailAbove = emailToAdd
    end
    table.insert(emails, 1, emailToAdd)
end

-- updateEmailValue()
-- Updates the email value by the given value
local function updateEmailValue(value)
    emailValue = emailValue + value
    print("Email value has been updated to "..emailValue..".")
end

-- updateSpawnValue()
-- Spawn value modifier function
local function updateSpawnValue(value)
    spawnValue = spawnValue + value
    print("Spawn value has been updated to "..spawnValue..".")
end

-- receiveEmail()
-- Spawns an email with the given mode, x & y position, dimensions, and color
local function receiveEmail(gameState)
    spawnEmail("fill", emailSpawnPoint.x, emailSpawnPoint.y, emailBox.width, emailBox.height, {1, 1, 1})
    spawnEmailEvent(gameState)
end

-- spawnInitialEmails()
-- Spawns the initial 9 emails for the gamestart setup
-- Only gets called once at gamestart
local function spawnInitialEmails(amount, targetPool)
    for _ = 1, amount do
        spawnEmail("fill", emailSpawnPoint.x, emailSpawnPoint.y, emailBox.width, emailBox.height, {1, 1, 1}, targetPool)
    end
end

-- handleEmailSelection()
-- Handler function for email selection & opening
local function handleEmailSelection(mouseX, mouseY, gameState)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY

    -- convert mouse position to match scaled coordinates
    local scaledMouseX = mouseX / scaleX
    local scaledMouseY = mouseY / scaleY

    if not gameState.selectedEmail then
        for _, email in ipairs(emails) do
            if scaledMouseX > email.x and scaledMouseX < email.x + email.width and
               scaledMouseY > email.y and scaledMouseY < email.y + email.height then
                if love.timer.getTime() - gameState.lastClickTime < gameState.doubleClickDelay then
                    gameState.openedEmail = email
                    for i, t in ipairs(gameState.openedEmail.content["choices"]) do
                        local choiceButton = makeChoiceButton(115+((i-1)*(buttonWidth+25)), 775, t, gameState)
                        table.insert(choiceButtons, choiceButton)
                    end
                    fillEmailPool()
                    return
                end
                gameState.selectedEmail = email
                gameState.offsetX = scaledMouseX - email.x
                gameState.offsetY = scaledMouseY - email.y
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
        local scaledMouseX = mouseX / scaling.scaleX
        local scaledMouseY = mouseY / scaling.scaleY

        -- Update email postion correctly
        gameState.selectedEmail.x = scaledMouseX - gameState.offsetX
        gameState.selectedEmail.y = scaledMouseY - gameState.offsetY
    end
end

-- drawEmails()
-- Draw function for drawing emails to the screen (in their respective colors)
local function drawEmails()
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for _, email in ipairs(emails) do
        love.graphics.setColor(email.color)
        love.graphics.rectangle(email.mode, email.x * scaleX, email.y * scaleY, email.width * scaleX, email.height * scaleY)
        love.graphics.setColor(0,0,0)
        love.graphics.printf(email.content.sender, email.x * scaleX, email.y * scaleY, email.width * scaleX, "left")
        love.graphics.printf(email.content.subject, email.x * scaleX, email.y * scaleY + 20, email.width * scaleX, "left")
    end
end

-- printEmail()
-- Print function for email content
local function printEmail(email)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for row, values in ipairs(email) do
        print(unpack(values))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("content", (screen.width * scaleX) - 390, (screen.height * scaleY) - 280, 120 * scaleX, "center")
        for section, content in ipairs(values) do 
            print(unpack(content))
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(unpack(content), (screen.width *scaleX) - 390, (screen.height * scaleY) - 280, 120 * scaleX, "center")
        end
    end
end

-- printEmailContent()
-- Print function for email content
local function printEmailContent(email)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    local content = {}
    content = email["content"]
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(content["sender"], 275 * scaleX, 100 * scaleY, 600 * scaleX, "left")
    love.graphics.printf(content["subject"], 275 * scaleX, 175 * scaleY, 600 * scaleX, "left")
    love.graphics.printf(content["body"], 125 * scaleX, 230 * scaleY, 600 * scaleX, "left")
    for i, choiceButton in ipairs(choiceButtons) do    
        drawChoiceButton(choiceButton)
    end
    if hoverPopup.visible then
        ui.hoverPopup(hoverPopup.text, nil, nil, nil, nil, nil, nil, nil, "tr")
    end
    -- for i, t in ipairs(content["choices"]) do
        -- local choiceButton = makeChoiceButton(100+((i-1)*150), 300, 120, 120, t)
        -- drawChoiceButton(choiceButton)
        -- for k, v in pairs(t["cPrereqs"]) do
        --     love.graphics.printf(k.." = "..v, 100*i, 250, 120, "center")
        -- end
        -- love.graphics.printf(t["cBody"], 100*i, 300, 120, "center")
        -- for k, v in pairs(t["cChanges"]) do
        --     love.graphics.printf(k.." = "..v, 100*i, 350, 120, "center")
        -- end
    --love.graphics.printf("ignored: ", 50, 400, 120, "center")
    --for k, v in pairs(content["ignored"]) do love.graphics.printf(k.." = "..v, 100, 400, 120, "center") end
    
end


function setAvailableColor()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255)) end

function setHoverColor()
    love.graphics.setColor(love.math.colorFromBytes(220, 220, 220, 255)) end

function setBlockedColor()
    love.graphics.setColor(love.math.colorFromBytes(188, 188, 188, 255)) end

-- makeChoiceButton()
-- Creates a choice button with the given x, y, choiceTable, and gameState
function makeChoiceButton(x, y, choiceTable, gameState)
    local unlockFlag = true
    local prereqs = choiceTable.cPrereqs
    local body = choiceTable.cBody
    local changes = choiceTable.cChanges

    if next(prereqs) then
        for key, value in pairs(prereqs) do
            if not playerCheck(key, value) then unlockFlag = false end
        end
        
    end

    if gameState.getOpenedEmail().content.respond == true then unlockFlag = false end

    return {
        x = x + 10,
        y = y + 30,
        width = buttonWidth,
        height = heightWidth,
        prereqs = prereqs,
        body = body,
        changes = changes,
        unlockFlag = unlockFlag
    }
end

-- drawChoiceButton()
-- Draw function for choice buttons
function drawChoiceButton(choiceButton)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    x,y = love.mouse.getPosition()
    -- local function setAvailableColor()
    --     love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255)) end
    -- local function setBlockedColor()
    --     love.graphics.setColor(love.math.colorFromBytes(188, 188, 188, 255)) end
    -- local unlockFlag = true
    -- local prereqs = choiceButton.choiceTable.cPrereqs
    -- local body = choiceButton.choiceTable.cBody

    -- if next(prereqs) ~= nil then
    --     for i, prereq in prereqs do 
    --         if not playerCheck(prereqs) then unlockFlag = false
    --         end
    --     end
    -- end

    -- if gameState.getOpenedEmail().content.respond == true then unlockFlag = false end

    if choiceButton.unlockFlag then
        setAvailableColor()
        if x > choiceButton.x * scaleX and x < choiceButton.x * scaleX + buttonWidth * scaleX and
           y > choiceButton.y * scaleY and y < choiceButton.y * scaleY + buttonHeight * scaleY then
            setHoverColor()
        end
    else 
        setBlockedColor()
    end
    love.graphics.rectangle("fill", choiceButton.x * scaleX, choiceButton.y * scaleY, buttonWidth * scaleX, buttonHeight * scaleY)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(choiceButton.body, choiceButton.x * scaleX, choiceButton.y * scaleY, buttonWidth * scaleX, "center")
end

-- isEmailChoiceClicked()
-- Checks if an email choice has been clicked
function emailResponded(gameState)
    gameState.getOpenedEmail().content.respond = true
    for i, choiceButton in ipairs(choiceButtons) do
        choiceButton.unlockFlag = false
    end
end

-- isEmailChoiceClicked()
-- Checks if an email choice has been clicked
local function isEmailChoiceClicked(x, y, gameState)
    for _, choiceButton in ipairs(choiceButtons) do
        local changes = choiceButton.changes
        if (choiceButton.unlockFlag) then
            if x > choiceButton.x * scaling.scaleX and x < choiceButton.x * scaling.scaleX + buttonWidth * scaling.scaleX and
            y > choiceButton.y * scaling.scaleY and y < choiceButton.y * scaling.scaleY + buttonHeight * scaling.scaleY then
                local i = 0
                for key, value in pairs(changes) do
                    
                    ui.addFloatingText((choiceButton.x + math.random(-10, 300)) * scaling.scaleX, (choiceButton.y - math.random(0, 100) - (i*20)) * scaling.scaleY, playerState.playerChange(key, value))
                    print("choice clicked "..key.." "..value)
                    for k, v in pairs(playerState.getPlayerVarList()) do
                        print(k.." = "..v)
                    end
                    i = i+1
                end
                emailResponded(gameState)
                sounds.pickChoice:stop()
                sounds.pickChoice:play()
            end
        end
    end
end

local function printChoiceButtonPrereqs(choiceButton)
    if next(choiceButton.prereqs) then
        local returnString = ""
        for prereqKey, prereqString in pairs(choiceButton.prereqs) do
            local value = tonumber(string.match(prereqString, "[%+%-]?%d+")) --thanks chatGPT
            local operator = string.match(prereqString, "[<>~!=]*")
            --print("operator is "..(operator))

            if operator == "<" then
                returnString = returnString.."having "..tostring(prereqKey).." less than ".. tostring(value).."\n"
            elseif operator == "<=" then
                returnString = returnString.."having "..tostring(prereqKey).." less than ".. tostring(value).."\n"
            elseif operator == ">" then
                returnString = returnString.."having "..tostring(prereqKey).." greater than ".. tostring(value).."\n"
            elseif operator == ">=" then
                returnString = returnString.."having "..tostring(prereqKey).." greater than ".. tostring(value).."\n"
            elseif operator == "~" or operator == "~=" or operator == "!" or operator == "!=" then
                returnString = returnString.."not having "..tostring(prereqKey).." equal to ".. tostring(value).."\n"
            else
                returnString = returnString.."having "..tostring(prereqKey).." equal to ".. tostring(value).."\n"
            end
        end
    return tostring(returnString)
    end
end

local function isEmailChoiceHovered(x, y, gameState)
    for _, choiceButton in ipairs(choiceButtons) do
        if x > choiceButton.x * scaling.scaleX and x < choiceButton.x * scaling.scaleX + buttonWidth * scaling.scaleX and
           y > choiceButton.y * scaling.scaleY and y < choiceButton.y * scaling.scaleY + buttonHeight * scaling.scaleY then
            hoverPopup.x = (x - 120) * scaling.scaleX 
            hoverPopup.y = (y + 10) * scaling.scaleY 
            -- shop.hoverPopup.text = "Hello world" 
            if not gameState.getOpenedEmail().content.respond then
                if not choiceButton.unlockFlag then
                    hoverPopup.text = "You can unlock this by\n"..printChoiceButtonPrereqs(choiceButton)
                    hoverPopup.visible = true
                elseif next(choiceButton.prereqs) then
                    hoverPopup.text = "You've unlocked this by\n"..printChoiceButtonPrereqs(choiceButton)
                    hoverPopup.visible = true
                end
            end
            return
        end
    end
    hoverPopup.visible = false
end

local function printChoiceButtonPrereqs(choiceButton)
    if next(choiceButton.prereqs) then
        local returnString = ""
        for prereqKey, prereqString in pairs(choiceButton.prereqs) do
            local value = tonumber(string.match(prereqString, "[%+%-]?%d+")) --thanks chatGPT
            local operator = string.match(prereqString, "[<>~!=]*")
            --print("operator is "..(operator))

            if operator == "<" then
                returnString = returnString.."having "..tostring(prereqKey).." less than ".. tostring(value).."\n"
            elseif operator == "<=" then
                returnString = returnString.."having "..tostring(prereqKey).." less than ".. tostring(value).."\n"
            elseif operator == ">" then
                returnString = returnString.."having "..tostring(prereqKey).." greater than ".. tostring(value).."\n"
            elseif operator == ">=" then
                returnString = returnString.."having "..tostring(prereqKey).." greater than ".. tostring(value).."\n"
            elseif operator == "~" or operator == "~=" or operator == "!" or operator == "!=" then
                returnString = returnString.."not having "..tostring(prereqKey).." equal to ".. tostring(value).."\n"
            else
                returnString = returnString.."having "..tostring(prereqKey).." equal to ".. tostring(value).."\n"
            end
        end
    return tostring(returnString)
    end
end

-- choiceReset()
-- Resets the choice buttons
function choiceReset()
    choiceButtons = {}
end

-- deleteEmail()
-- Deletes the selected email
function deleteEmail(gameState)
    if gameState.selectedEmail then
        globalOffsetY = globalOffsetY + (emailBox.height + emailBox.ySpacing)
        for i, email in ipairs(emails) do
            if email == gameState.selectedEmail then
                -- insert ignored code here
                if not email.content.respond then
                    for key, value in pairs(email.content.ignored) do
                        playerState.playerChange(key, value)
                    end
                    print("email ignored")
                    for k, v in pairs(playerState.getPlayerVarList()) do
                        print(k.." = "..v)
                    end
                end

                if email.emailAbove then
                    email.emailAbove.emailBelow = nil
                end
                if email.emailBelow then
                    email.emailBelow.emailAbove = nil
                end

                if email.emailAbove and email.emailBelow then
                    email.emailAbove.emailBelow = email.emailBelow
                    email.emailBelow.emailAbove = email.emailAbove
                end
                moveEmailsUp(email)
                table.remove(emails, i)
                gameState.selectedEmail = nil
                gameState.currency = gameState.currency + emailValue
                sounds.emailDelete:stop()
                sounds.emailDelete:play()

                local mouseX, mouseY = love.mouse.getPosition()
                ui.addFloatingText(mouseX, mouseY, "+"..emailValue)
                break
            end
        end
    end
end

-- moveEmailsDown()
-- Moves all emails down
function moveEmailsDown()
    for i, email in ipairs(emails) do
        updateOrigin(email, email.x, email.y + (emailBox.height + emailBox.ySpacing))
        moveToOrigin(email)
    end
end

-- moveEmailsUp()
-- Moves all emails up
function moveEmailsUp(email)
    if email.emailBelow then
            updateOrigin(email.emailBelow, email.emailBelow.x, email.emailBelow.y - (emailBox.height + emailBox.ySpacing))
            moveToOrigin(email.emailBelow)
            moveEmailsUp(email.emailBelow)
    end
end

-- resetOrigin()
-- Resets the origin of the email
function resetOrigin(email)
    if email.emailAbove then
        email.originX = email.emailAbove.originX
        email.originY = email.emailAbove.originY + (emailBox.height + emailBox.ySpacing)
    elseif email.emailBelow then
        email.originX = email.emailBelow.originX
        email.originY = email.emailBelow.originY - (emailBox.height + emailBox.ySpacing)
    end
end

-- updateOrigin()
-- Updates the origin of the email
function updateOrigin(email, x, y)
    email.originX = x
    email.originY = y
end

-- moveToOrigin()
-- Moves the email to its origin
function moveToOrigin(email)
    email.x = email.originX
    email.y = email.originY
end

-- snapBack()
-- Snaps the email back to its origin
function snapBack(gameState)
    if gameState.selectedEmail then
        resetOrigin(gameState.selectedEmail)
        moveToOrigin(gameState.selectedEmail)
    end
end

--getters and setters

local function getEmailBase() return emailBase end
local function setEmailBase(filename) emailBase = file.loadEmailFile(filename) end

local function getEmailPool() return emailPool end
local function setEmailPool(filename) emailPool = file.loadEmailFile(filename) end

local function getEmailInbox()
    local emailInbox = {}
    for i, email in ipairs(emails) do
        table.insert(emailInbox, email.content)
    end
    return emailInbox
end

local function setEmailInbox(filename)
    emailInbox = file.loadEmailFile(filename)
    spawnInitialEmails(#emailInbox, emailInbox)
end

return {
    getSpawnPeriod = getSpawnPeriod,
    setSpawnPeriod = setSpawnPeriod,
    autospawnEmail = autospawnEmail,
    getLengthEmails = getLengthEmails,
    spawnEmail = spawnEmail,
    receiveEmail = receiveEmail,
    spawnInitialEmails = spawnInitialEmails,
    handleEmailSelection = handleEmailSelection,
    handleDragging = handleDragging,
    drawEmails = drawEmails,
    updateEmailValue = updateEmailValue,
    updateSpawnValue = updateSpawnValue,
    printEmailContent = printEmailContent,
    fillEmailPool = fillEmailPool,
    isEmailChoiceClicked = isEmailChoiceClicked,
    isEmailChoiceHovered = isEmailChoiceHovered,
    choiceReset = choiceReset,
    deleteEmail = deleteEmail,
    moveEmailsDown = moveEmailsDown,
    moveEmailsUp = moveEmailsUp,
    resetOrigin = resetOrigin,
    updateOrigin = updateOrigin,
    moveToOrigin = moveToOrigin,
    snapBack = snapBack,
    getEmailBase = getEmailBase,
    setEmailBase = setEmailBase,
    getEmailPool = getEmailPool,
    setEmailPool = setEmailPool,
    getEmailInbox = getEmailInbox,
    setEmailInbox = setEmailInbox
}