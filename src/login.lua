-- login.lua --
-- Login page manager
local login = {}

local username = ""
local password = ""
local activeField = nil
local buttonX, buttonY, buttonWidth, buttonHeight = 200, 250, 100, 40
local font

function login.start()
    love.keyboard.setKeyRepeat(true)
    
    -- Prevents rest of game from running until loop ends
    while not login.completed do
        love.event.pump()
        for e, a, b, c in love.event.poll() do
            if e == "quit" then return love.event.quit() end
            login.handleEvent(e, a, b, c)
        end

        love.graphics.clear(0.2, 0.2, 0.2)
        login.draw()
        love.graphics.present()
    end

    love.keyboard.setKeyRepeat(false)
end

function login.load()
    font = love.graphics.newFont(14)
    login.completed = false
end

function login.draw()
    love.graphics.setFont(font)
    
    -- Username text input box w/ label
    love.graphics.print("Username:", 200, 100)
    love.graphics.rectangle("line", 200, 120, 200, 30)
    love.graphics.print(username, 210, 127)

    -- Password text input box w/ label
    love.graphics.print("Password:", 200, 160)
    love.graphics.rectangle("line", 200, 180, 200, 30)
    love.graphics.print(string.rep("*", #password), 210, 187) -- Mask password input

    love.graphics.print("(Password & username both must be 15 characters or less.)", 200, 225)

    -- Login button
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.printf("Login", buttonX, buttonY + 10, buttonWidth, "center")
end

function login.handleEvent(e, a, b, c)
    if e == "mousepressed" then
        if b >= 120 and b <= 150 then
            activeField = "username"
        elseif b >= 180 and b <= 210 then
            activeField = "password"
        elseif a >= buttonX and a <= buttonX + buttonWidth and b >= buttonY and b <= buttonY + buttonHeight then
            if #username > 0 and #username <= 16 and #password > 0 and #password <= 16 then
                login.completed = true
            end
        end
    elseif e == "textinput" then
        if activeField == "username" and #username < 16 then
            username = username .. a
        elseif activeField == "password" and #password < 16 then
            password = password .. a
        end
    elseif e == "keypressed" then
        if c == "backspace" then
            if activeField == "username" then
                username = username:sub(1, -2)
            elseif activeField == "password" then
                password = password:sub(1, -2)
            end
        elseif c == "return" and #username > 0 and #username <= 16 and #password > 0 and #password <= 16 then
            login.completed = true
        end
    end
end

return login
