-- email.lua --
-- Implementation file for email class
local scaling = require("src.scaling")
local ui = require("src.ui")
local file = require("src.file")
local playerState = require("src.playerState")
local emailTables = require("src.spam")

local function generateRandomSender()
    local adj = emailTables.adjectives[math.random(#emailTables.adjectives)]
    local noun = emailTables.nouns[math.random(#emailTables.nouns)]
    local num = emailTables.numbers[math.random(#emailTables.numbers)]
    local domain = emailTables.domains[math.random(#emailTables.domains)]
    
    local sender = string.format("%s%s%d@%s.com", adj, noun, num, domain)
    print("Generated sender:", sender) -- DEBUG OUTPUT
    return sender
end

-- global vars
local defaultEmail = {
    prereq = {},
    sender = generateRandomSender(),
    subject = "Pelase clik thia linkl!!!",
    body = "link hehe",
    choices = {},
    ignored = {}
}

local emailBase = file.loadEmailFile('data/EmailBase.csv')
local emailPool = {}
local emails = {} --emails shown--
local choiceButtons = {}
local screen = { width = love.graphics.getWidth() / 2, height = love.graphics.getHeight() / 2 }
local globalOffsetY = 0
local spawnPeriod = 0
local emailValue = 1

local buttonWidth = 175
local buttonHeight = 70
local scaleX, scaleY = 1, 1

-- Functions --
local function getRandomElement(tbl)
    return tbl[math.random(#tbl)]
end

local function generateRandomSender()
    local adj = getRandomElement(emailTables.adjectives)
    local noun = getRandomElement(emailTables.nouns)
    local num = getRandomElement(emailTables.numbers)
    local domain = getRandomElement(emailTables.domains)
    
    return string.format("%s%s%d@%s.com", adj, noun, num, domain)
end

-- getLengthEmails()
-- Getter function that returns length of emails table
local function getLengthEmails()
    return #emails
end

local function fillEmailPool()
    -- print("fillEmailPool test")
    for i, emailContent in ipairs(emailBase) do
        local prereq = emailContent["prereq"]
        local prereqCheckFlag = true
        -- print(next(prereq))
        if next(prereq) then
            -- for k,v in pairs(prereq) do
            --     print(k.." = "..v)
            -- end
            for key, value in pairs(prereq) do
                if not playerState.playerCheck(key, value) then prereqCheckFlag = false break end
            end
        end
        if prereqCheckFlag then
            table.insert(emailPool, emailContent)
            table.remove(emailBase, i)
        end
    end
    -- for i,v in ipairs(emailPool) do
    --     print(unpack(v))
    -- end
end

local function getFromPool()
    if next(emailPool) ~= nil then
        local email = table.remove(emailPool)
        email.sender = generateRandomSender() -- Assign a random sender
        print("Assigned sender:", email.sender) -- DEBUG OUTPUT
        return email
    else 
        return defaultEmail
    end
end

-- spawnEmail()
-- Spawns an email with the given mode, x & y position, dimensions, and color
local function spawnEmail(mode, x, y, width, height, color, content)
    fillEmailPool()
    table.insert(emails, {
        mode = mode,
        x = x,
        originX = x,
        y = y,
        originY = y,
        width = width,
        height = height,
        color = color,
        content = getFromPool(),
        respond = false
    })
end

local function updateEmailValue()
    emailValue = emailValue + 1
    print("Email value has been updated to "..emailValue..".")
end

-- timedEmailSpawn()
-- Spawns an email 

local function timedEmailSpawn(period)
    spawnEmail("fill", screen.width - 120, screen.height - globalOffsetY, 1080, 50, {1, 1, 1})
    spawnPeriod = period
    globalOffsetY = globalOffsetY - 70
end

-- spawnInitialEmails()
-- Spawns the initial 9 emails for the gamestart setup
-- Only gets called once at gamestart
local function spawnInitialEmails()
local yOffset = 130
    for _ = 1, 4 do
        spawnEmail("fill", screen.width - 120, screen.height - yOffset, 1080, 50, {1, 1, 1})
        yOffset = yOffset - 70
    end
    globalOffsetY = yOffset
end

-- handleEmailSelection()
-- Handler function for email selection & opening
local function handleEmailSelection(mouseX, mouseY, gameState)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    if not gameState.selectedEmail then
        for _, email in ipairs(emails) do
            if mouseX > email.x * scaleX and mouseX < email.x * scaleX + email.width * scaleX and
               mouseY > email.y * scaleY and mouseY < email.y * scaleY + email.height * scaleY then

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
                gameState.offsetX = mouseX - email.x
                gameState.offsetY = mouseY - email.y
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
        gameState.selectedEmail.x = mouseX - gameState.offsetX
        gameState.selectedEmail.y = mouseY - gameState.offsetY

        -- if ui.isOverTrashBin(gameState.selectedEmail) then
        --     globalOffsetY = globalOffsetY + 70
        --     for i, email in ipairs(emails) do
        --         if email == gameState.selectedEmail then
        --             -- insert ignored code here
        --             if not email.respond then
        --                 for key, value in pairs(email.content.ignored) do
        --                     playerState.playerChange(key, value)
        --                 end
        --                 print("email ignored")
        --                 for k, v in pairs(playerState.getPlayerVarList()) do
        --                     print(k.." = "..v)
        --                 end
        --             end
        --             table.remove(emails, i)
        --             for j = i, #emails do
        --                 emails[j].y = emails[j].y - 70
        --             end
        --             gameState.selectedEmail = nil
        --             gameState.currency = gameState.currency + emailValue
        --             break
        --         end
        --     end
        -- end
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

local function printEmail(email)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for row, values in ipairs(email) do
        print(unpack(values))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("content", screen.width * scaleX - 390, screen.height * scaleY - 280, 120 * scaleX, "center")
        for section, content in ipairs(values) do 
            print(unpack(content))
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(unpack(content), screen.width - 390, screen.height - 280, 120, "center")
        end
    end
end

local function printEmailContent(email)
    local content = {}
    content = email["content"]
    -- for section, content in ipairs(email) do
    --     prereq, sender, subject, body, choices, ignored = unpack(content)
    --     love.graphics.setColor(0, 0, 0)
    --     love.graphics.printf(unpack(prereq), 50, 50, 120, "center")
    --     love.graphics.printf(sender, 50, 100, 120, "center")
    --     love.graphics.printf(subject, 50, 150, 120, "center")
    --     love.graphics.printf(body, 50, 200, 120, "center")
    --     love.graphics.printf(unpack(choices), 50, 250, 120, "center")
    --     love.graphics.printf(unpack(ignored), 50, 300, 120, "center")


    love.graphics.setColor(0, 0, 0)
    --love.graphics.printf("prereq: ", 50, 50, 120, "center")
    --for k, v in pairs(content["prereq"]) do love.graphics.printf(k.." = "..v, 100, 50, 120, "center") end
    love.graphics.printf(content["sender"], 275, 100, 600, "left")
    love.graphics.printf(content["subject"], 275, 175, 600, "left")
    love.graphics.printf(content["body"], 125, 230, 600, "left")
    --love.graphics.printf("choices: ", 50, 250, 120, "center")
    for i, choiceButton in ipairs(choiceButtons) do    
        drawChoiceButton(choiceButton)
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

function setBlockedColor()
    love.graphics.setColor(love.math.colorFromBytes(188, 188, 188, 255)) end

function makeChoiceButton(x, y, choiceTable, gameState)
    local unlockFlag = true
    local prereqs = choiceTable.cPrereqs
    local body = choiceTable.cBody
    local changes = choiceTable.cChanges

    if next(prereqs) then
        --print("mcb test1")
        for key, value in pairs(prereqs) do
            if not playerCheck(key, value) then unlockFlag = false end
        end
        
    end

    if gameState.getOpenedEmail().respond == true then unlockFlag = false end

    return {
        x = x,
        y = y,
        width = buttonWidth,
        height = heightWidth,
        prereqs = prereqs,
        body = body,
        changes = changes,
        unlockFlag = unlockFlag
    }
end

function drawChoiceButton(choiceButton)
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

    -- if gameState.getOpenedEmail().respond == true then unlockFlag = false end

    if choiceButton.unlockFlag then setAvailableColor() else setBlockedColor() end
    love.graphics.rectangle("fill", choiceButton.x, choiceButton.y, buttonWidth, buttonHeight)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(choiceButton.body, choiceButton.x, choiceButton.y, buttonWidth, "center")
end

function emailResponded(gameState)
    gameState.getOpenedEmail().respond = true
    for i, choiceButton in ipairs(choiceButtons) do
        choiceButton.unlockFlag = false
    end
end

local function isEmailChoiceClicked(x, y, gameState)
    for _, choiceButton in ipairs(choiceButtons) do
        local changes = choiceButton.changes
        if (choiceButton.unlockFlag) then
            if x > choiceButton.x and x < choiceButton.x + buttonWidth and
            y > choiceButton.y and y < choiceButton.y + buttonHeight then
                for key, value in pairs(changes) do
                    playerState.playerChange(key, value)
                    print("choice clicked "..key.." "..value)
                    for k, v in pairs(playerState.getPlayerVarList()) do
                        print(k.." = "..v)
                    end
                end
                emailResponded(gameState)
            end
        end
    end
end

function choiceReset()
    choiceButtons = {}
end

function deleteEmail(gameState)
    if gameState.selectedEmail then
        globalOffsetY = globalOffsetY + 70
        for i, email in ipairs(emails) do
            if email == gameState.selectedEmail then
                -- insert ignored code here
                if not email.respond then
                    for key, value in pairs(email.content.ignored) do
                        playerState.playerChange(key, value)
                    end
                    print("email ignored")
                    for k, v in pairs(playerState.getPlayerVarList()) do
                        print(k.." = "..v)
                    end
                end
                table.remove(emails, i)
                for j = i, #emails do
                    emails[j].y = emails[j].y - 70
                    emails[j].originY = emails[j].y
                end
                gameState.selectedEmail = nil
                gameState.currency = gameState.currency + emailValue
                break
            end
        end
    end
end

function snapBack(gameState)
    if gameState.selectedEmail then
        gameState.selectedEmail.x = gameState.selectedEmail.originX
        gameState.selectedEmail.y = gameState.selectedEmail.originY
    end
end

return {
    getLengthEmails = getLengthEmails,
    spawnEmail = spawnEmail,
    timedEmailSpawn = timedEmailSpawn,
    spawnInitialEmails = spawnInitialEmails,
    handleEmailSelection = handleEmailSelection,
    handleDragging = handleDragging,
    drawEmails = drawEmails,
    updateEmailValue = updateEmailValue,
    printEmailContent = printEmailContent,
    fillEmailPool = fillEmailPool,
    isEmailChoiceClicked = isEmailChoiceClicked,
    choiceReset = choiceReset,
    deleteEmail = deleteEmail,
    snapBack = snapBack
}