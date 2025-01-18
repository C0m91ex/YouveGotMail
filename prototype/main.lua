local screen = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}
-- setting the center
screen.width = screen.width / 2
screen.height = screen.height / 2

local spawnButton = {
    mode = "fill",
    x = screen.width - 300,
    y = screen.height,
    width = 100,
    height = 50,
    color = {1, 1, 0} -- set color to yellow
}

local emails = {}
function spawnEmail(mode, x, y, width, height, color)
    local email = {
        mode = mode,
        x = x,
        y = y,
        width = width,
        height = height,
        color = color
    }
    table.insert(emails, email)
end

-- loads everything once when runningthis file
function love.load()
    --spawnEmail("fill", screen.width + screen.width / 2, screen.height + screen.height / 2, 50, 50, {1, 1, 1})
end

-- updates every frame
-- do your math stuff here
function love.update(dt)
    -- check if left mouse button is down
    if love.mouse.isDown(1) then
        -- just like in the draw function, iterates each email in emails table, checking that specific email's x and y with mouse's x and y position
        for _, email in ipairs(emails) do
            if love.mouse.getX() > email.x and love.mouse.getX() < email.x + email.height and love.mouse.getY() > email.y and love.mouse.getY() < email.y + email.height then
                email.x = love.mouse.getX() - (email.width / 2)
                email.y = love.mouse.getY() - (email.height / 2)
            end
        end
    end
end

-- similar to .update but this one is used to draw stuff onto the game screen
function love.draw()
    -- draw spawned email
    -- iterates through the emails table 
    -- ipairs: lua function used to iterate in a numerical order for talbes with sequential interger keys
    for _, email in ipairs(emails) do
        love.graphics.setColor(email.color)
        love.graphics.rectangle(email.mode, email.x, email.y, email.width, email.height)
    end

    -- draw spawn button
    love.graphics.setColor(spawnButton.color)
    love.graphics.rectangle(spawnButton.mode, spawnButton.x, spawnButton.y, spawnButton.width, spawnButton.height)
end

function love.mousepressed(x, y, button, istouch)
    -- checks if the left mouse button is pressed
    if button == 1 then
        -- checks if the mouse is on the yellow spawn button
        if x > spawnButton.x and x < spawnButton.x + spawnButton.width and y > spawnButton.y and y < spawnButton.y + spawnButton.height then
            spawnEmail("fill", screen.width + 300, screen.height, 50, 50, {1, 1, 1})
        end
    end
end