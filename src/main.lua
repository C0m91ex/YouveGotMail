-- Tables --
local screen = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}
-- setting the center
screen.width = screen.width / 2
screen.height = screen.height / 2

-- Background Image --
local myBackground = nil

local trashBin = {
    mode = "fill",
    x = screen.width,
    y = screen.height,
    width = 100,
    height = 50,
    color = {1, 0, 0} -- set color to red
}
trashBin.x = (trashBin.x - trashBin.width / 2) - 300
trashBin.y = (trashBin.y - trashBin.height / 2) - 225

local emails = {}
function spawnEmail(mode, x, y, width, height, color)
    local email = {
        mode = mode,
        x = x,
        y = y,
        width = width,
        height = height,
        color = color,
        content = "This is a sample email content!" -- Placeholder email content
    }
    table.insert(emails, email)
end

-- Variables --
local score = 0
local selectedEmail = nil -- Track the currently dragged email
local openedEmail = nil -- Track the currently opened email (if any)
local offsetX, offsetY = 0, 0 -- Offset to keep email anchored correctly while dragging
local lastClickTime = 0
local doubleClickDelay = 0.3 -- Max time between clicks for a double click

-- Loads everything once when running this file
function love.load()
    myBackground = love.graphics.newImage('inbox-background.png') -- sets the background image for the inbox screen
    temptY = 250
    for x = 1, 9, 1 do
        spawnEmail("fill", screen.width - 220, screen.height - temptY, 400, 50, {1, 1, 1})
        temptY = temptY - 70 -- spawns the next email on the bottom of the other email
    end
end

-- Updates every frame
function love.update(dt)
    if openedEmail then
        -- If an email is opened, no other interactions should happen
        return
    end

    local mouseX, mouseY = love.mouse.getPosition()

    -- Check if the mouse is clicked
    if love.mouse.isDown(1) then
        if not selectedEmail then
            local currentTime = love.timer.getTime()
            for _, email in ipairs(emails) do
                if mouseX > email.x and mouseX < email.x + email.width and
                   mouseY > email.y and mouseY < email.y + email.height then
                    -- Check for double-click
                    if currentTime - lastClickTime < doubleClickDelay then
                        openedEmail = email -- Open the email
                        return
                    end

                    -- Select the email for dragging
                    selectedEmail = email
                    offsetX = mouseX - email.x
                    offsetY = mouseY - email.y
                    lastClickTime = currentTime -- Update last click time
                    break
                end
            end
        elseif selectedEmail then
            -- Drag the selected email
            selectedEmail.x = mouseX - offsetX
            selectedEmail.y = mouseY - offsetY

            -- Check if the email is over the trash bin
            if selectedEmail.x > trashBin.x and selectedEmail.x < trashBin.x + trashBin.width and
               selectedEmail.y > trashBin.y and selectedEmail.y < trashBin.y + trashBin.height then
                -- Remove the selected email
                for i, email in ipairs(emails) do
                    if email == selectedEmail then
                        table.remove(emails, i)

                        -- Adjust positions of remaining emails upward
                        for j = i, #emails do
                            emails[j].y = emails[j].y - 70 -- Move each remaining email up
                        end
                        break
                    end
                end
                selectedEmail = nil -- Deselect after deletion
                score = score + 1 -- Increase score
            end
        end
    else
        -- Release the selected email when the mouse is released
        selectedEmail = nil
    end
end


-- Draws everything
function love.draw()
    love.graphics.draw(myBackground)

    if openedEmail then
        -- Draw the opened email screen
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw back button
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 10, 10, 100, 40)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Back", 10, 20, 100, "center")
        return
    end

    -- Draw trash bin
    love.graphics.setColor(trashBin.color)
    love.graphics.rectangle(trashBin.mode, trashBin.x, trashBin.y, trashBin.width, trashBin.height)

    -- Draw emails
    for _, email in ipairs(emails) do
        love.graphics.setColor(email.color)
        love.graphics.rectangle(email.mode, email.x, email.y, email.width, email.height)
    end

    -- Draw score
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: " .. score, screen.width - 390, screen.height - 280, 120, "center")

    print("Hello")
end

-- Mouse released logic for handling the back button
function love.mousereleased(x, y, button)
    if button == 1 and openedEmail then
        -- Check if the back button is clicked
        if x > 10 and x < 110 and y > 10 and y < 50 then
            openedEmail = nil -- Close the opened email
        end
    end
end
