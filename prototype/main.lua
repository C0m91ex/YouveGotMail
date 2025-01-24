-- Tables --

local screen = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}
-- setting the center
screen.width = screen.width / 2
screen.height = screen.height / 2


local trashBin = {
    mode = "fill",
    x = screen.width - 380,
    y = screen.height - 250,
    width = 100,
    height = 50,
    color = {1, 0, 0} -- set color to red
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

---------------

-- Variables --
local score = 0
---------------

-- loads everything once when running this file
function love.load()
    temptY = 250
    for x = 1, 5, 1 do
        spawnEmail("fill", screen.width - 220, screen.height - temptY, 400, 50, {1, 1, 1})
        temptY = temptY - 70 -- spawns the next email on the bottom of the other email
    end
end

-- updates every frame
-- do your math stuff here
local dtotal = 0
local mouseDisable = false
local lastClickTime = 0
local clickDelay = 0.3
function love.update(dt)
    -- check if left mouse button is down
    if love.mouse.isDown(1) and mouseDisable == false then
        -- just like in the draw function, iterates each email in emails table, checking that specific email's x and y with mouse's x and y position
        -- this is for making the box draggable. it's not perfect but it gets the job done
        -- currItem: the index of the current item in the table
        -- ipairs is a lua function that iterates over the elements of a table in numberical order

        -- Note for Jimmy: Work on this later
        for currItem, email in ipairs(emails) do
            --[[
            if love.mouse.getX() > email.x and love.mouse.getX() < email.x + email.width and love.mouse.getY() > email.y and love.mouse.getY() < email.y + email.height then
                 local currentTime = love.timer.getTime()
                if currentTime - lastClickTime < clickDelay then
                    -- double clicked
                    print("Double click")
                end
                

                --lastClickTime = currentTime -- update last click time
            ]]--

            if love.mouse.getX() > email.x and love.mouse.getX() < email.x + email.width and love.mouse.getY() > email.y and love.mouse.getY() < email.y + email.height then
                email.x = love.mouse.getX() - (email.width / 2)
                email.y = love.mouse.getY() - (email.height / 2)
                print("Email: "..currItem)
            end 

            -- timer delay. Wait for .5 seconds before checking the next email is selected
            dtotal = dtotal + dt
            if dtotal >= 0.5 then
                -- Checks to see if a email is above the trash bin, if so, delete it
                if email.x > trashBin.x and email.x < trashBin.x + trashBin.width and email.y > trashBin.y and email.y < trashBin.y + trashBin.height then
                    mouseDisable = true -- temporary disable any mouse input to give the game a chance eto update the emails positions
                    table.remove(emails, currItem)
                    -- Moves emails up a position

                    -- cycles through the list, shifting each email upward
                    for i = currItem, #emails do
                        emails[i].y = emails[i].y - 70
                        print(i)
                    end
                    print("Email deleted")
                    -- after deleting, shifting, gives the player a score
                    score = score + 1
                end

                -- resets timer
                dtotal = 0

            end
        end
    -- once the player lets go the left mouse button, enables mouse interaction
    -- this prevents from "creating a chain reaction of email deletions"
    -- I believe what was happening was the player was still holding left click down, and since it's deleting the first thing on
    -- the list, it's doesn't know when to stop deleting
    elseif love.mouse.isDown(1) == false then
        mouseDisable = false
    end
end

-- similar to .update but this one is used to draw stuff onto the game screen
function love.draw()
    -- drow trash bin
    love.graphics.setColor(trashBin.color)
    love.graphics.rectangle(trashBin.mode, trashBin.x, trashBin.y, trashBin.width, trashBin.height)

    -- draw spawned email
    -- iterates through the emails table 
    -- ipairs: lua function used to iterate in a numerical order for talbes with sequential interger keys
    for currItem, email in ipairs(emails) do
        love.graphics.setColor(email.color)
        love.graphics.rectangle(email.mode, email.x, email.y, email.width, email.height)
    end

    -- Score text
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: "..score, screen.width - 390, screen.height - 280, 120, "center")
end
