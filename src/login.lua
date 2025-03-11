-- login.lua --
-- Login page manager
local login = {}

-- local variables
local username = ""
local password = ""
local activeField = nil
local buttonX, buttonY, buttonWidth, buttonHeight = 50, 350, 100, 40 -- Shifted left 150px, down 100px
local font

-- global variables
keySounds = {}

-- start()
-- Initiates the login screen scene (terminates when login is completed)
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

-- load()
-- Load function for loading the login screen
function login.load()
    font = love.graphics.newFont(14)
    login.completed = false
    login.background = love.graphics.newImage("assets/main_menu/smaller.png")
    love.window.setMode(800, 450, { resizable = false })
    keySounds.key1 = love.audio.newSource("assets/sounds/Key Presses/Key1.mp3", "static")
    keySounds.key2 = love.audio.newSource("assets/sounds/Key Presses/Key2.mp3", "static")
    keySounds.key3 = love.audio.newSource("assets/sounds/Key Presses/Key3.mp3", "static")
    keySounds.key4 = love.audio.newSource("assets/sounds/Key Presses/Key4.mp3", "static")
    keySounds.key5 = love.audio.newSource("assets/sounds/Key Presses/Key5.mp3", "static")
    keySounds.key6 = love.audio.newSource("assets/sounds/Key Presses/Key6.mp3", "static")
    keySounds.key7 = love.audio.newSource("assets/sounds/Key Presses/Key7.mp3", "static")
end

-- draw()
-- Draws the login screen
function login.draw()
    love.graphics.draw(login.background, 0, 0)

    love.graphics.setFont(font)

    -- Set text box color to black
    love.graphics.setColor(0, 0, 0)
    
    -- Username text input box w/ label
    love.graphics.print("Username:", 50, 200) -- Shifted left 150px, down 100px
    love.graphics.rectangle("line", 50, 220, 200, 30) -- Shifted
    love.graphics.print(username, 60, 227)

    -- Set text box color to black again
    love.graphics.setColor(0, 0, 0)

    -- Password text input box w/ label
    love.graphics.print("Password:", 50, 260) -- Shifted
    love.graphics.rectangle("line", 50, 280, 200, 30) -- Shifted
    love.graphics.print(string.rep("*", #password), 60, 287) -- Mask password input

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("(Password & username both must be 15 characters or less.)", 50, 325) -- Shifted

    -- Login button
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.printf("Login", buttonX, buttonY + 10, buttonWidth, "center")

    love.graphics.setColor(1, 1, 1)
end

function login.playRandomKeySound()
    local sounds = {}
    for _, sound in pairs(keySounds) do
        table.insert(sounds, sound)
    end

    -- Randomly picks & plays a key sound
    if #sounds > 0 then
        local randomSound = sounds[love.math.random(#sounds)]
        randomSound:play()
    end
end


-- handleEvent()
-- Handles events for the login screen
function login.handleEvent(e, a, b, c)
    if e == "mousereleased" then
        if b >= 220 and b <= 250 then -- Adjusted for new position
            activeField = "username"
        elseif b >= 280 and b <= 310 then -- Adjusted for new position
            activeField = "password"
        elseif a >= buttonX and a <= buttonX + buttonWidth and b >= buttonY and b <= buttonY + buttonHeight then
            if #username > 0 and #username <= 16 and #password > 0 and #password <= 16 then
                login.completed = true
            end
        end
    elseif e == "textinput" then
        if activeField == "username" and #username < 16 then
            username = username .. a
            login.playRandomKeySound()
        elseif activeField == "password" and #password < 16 then
            password = password .. a
            login.playRandomKeySound()
        end
    elseif e == "keypressed" then
        if a == "backspace" then
            if activeField == "username" and #username > 0 then
                username = username:sub(1, -2) 
                login.playRandomKeySound() 
            elseif activeField == "password" and #password > 0 then
                password = password:sub(1, -2)
                login.playRandomKeySound()
            end
        elseif a == "return" and #username > 0 and #username <= 16 and #password > 0 and #password <= 16 then
            login.completed = true
        elseif a == "tab" then
            if activeField == "username" then
                activeField = "password"
            else
                activeField = "username"
            end
        end
    end
end

return login
