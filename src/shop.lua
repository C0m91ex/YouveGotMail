-- shop.lua --
-- Shop implementation and management file
local ui = require("src.ui")
local email = require("src.email")
local scaling = require("src.scaling")

-- Shop Button Images
shopButtonNormal = love.graphics.newImage('assets/inbox/Shop Button.png')
shopButtonHover = love.graphics.newImage('assets/inbox/Shop Button Hover.png')
shopButtonClicked = love.graphics.newImage('assets/inbox/Shop Button Click.png')

-- global vars
local shop = {
    shopOffsetY = 105,
}

shop.hoverPopup = { x = 0, y = 0, visible = false }

local items = {}
items.item1 = {
    price = 10,
    inflation = 8,
    name = "Concentrated Encryption",
    description = "Emails give more money when they are deleted, thanks to the interns. The emails encrypt themselves further now, whatever that means.",
    modifier = 1,
    effect = function()
        email.updateEmailValue(items.item1.modifier)
    end
}
items.item2 = {
    price = 20,
    inflation = 5,
    name = "Data Scraping",
    description = "Get a bit of money when emails come in; thank you, interns. Something about emails scraping a bit of data from all the networks they pass to get to you.",
    modifier = 1,
    effect = function()
        email.updateSpawnValue(items.item2.modifier)
    end
}
items.item3 = {
    price = 30,
    inflation = 15,
    name = "Net Speedrouting",
    description = "Emails come in faster. I didn't bother asking the interns why this time.",
    modifier = email.getSpawnPeriod()/10,
    effect = function()
        email.setSpawnPeriod(email.getSpawnPeriod() - items.item3.modifier)
        items.item3.modifier = email.getSpawnPeriod()/10
        print(email.getSpawnPeriod())
        ui.addFloatingText((love.graphics.getWidth() / 2 - 910) * scaling.scaleX, (love.graphics.getHeight() / 2 - 180) * scaling.scaleY,"Spawn period: "..string.format("%.2f", email.getSpawnPeriod()))
    end
}

local scaleX, scaleY = 1, 1

local shopTitle = { x = (love.graphics.getWidth() / 2 + 995), y = (love.graphics.getHeight() / 2 - 220), width = 204, height = 66 }
-- Functions --

-- Table used as the bone structure for shop items
local shopItems ={}
local function createShopItem(mode, x, y, width, height, color)
    table.insert(shopItems, {
        mode = mode,
        x = x,
        y = y,
        width = width,
        height = height,
        color = color,
        itemTable = {}
    })
end

local function updateShopItem(shopItem, item)
    item.price = item.price + item.inflation
    shopItem.itemTable.name = item.name
    shopItem.itemTable.price = item.price
end

    -- Shop item setup --
local numberOfShopItems = 3
local function setUpShop()
    -- shopIcon = love.graphics.newImage('assets/inbox/Shop Button.png')
    shopIcon = shopButtonImage
    -- Make sure when increasing this variable to set up name and price for the added items to the shop
    for _ = 1, numberOfShopItems do
        -- createShopItem(mode, x, y, width, height, color)
        createShopItem("fill", shopTitle.x + 15, shopTitle.y + shop.shopOffsetY, 175, 70, {0.855, 0.855, 0.855})
        shop.shopOffsetY = shop.shopOffsetY + 90
    end

    -- setting the name and price for item 1
    shopItems[1].itemTable.name = items.item1.name
    shopItems[1].itemTable.price = items.item1.price

    -- setting the name and price for item 2
    shopItems[2].itemTable.name = items.item2.name
    shopItems[2].itemTable.price = items.item2.price
    
    shopItems[3].itemTable.name = items.item3.name
    shopItems[3].itemTable.price = items.item3.price
end

local function isShopButtonClicked(x, y)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    return  x > shopTitle.x * scaleX and x < shopTitle.x * scaleX + shopTitle.width * scaleX and
            y > shopTitle.y * scaleY and y < shopTitle.y * scaleY + shopTitle.height * scaleY
end

local function isShopButtonHovered(x, y)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    return  x > shopTitle.x * scaleX and x < shopTitle.x * scaleX + shopTitle.width * scaleX and
            y > shopTitle.y * scaleY and y < shopTitle.y * scaleY + shopTitle.height * scaleY  
end

-- Function to draw the shop button dynamically based on state
local function drawShopTitle()
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", shopTitle.x * scaleX, shopTitle.y * scaleY, shopTitle.width * scaleX, shopTitle.height * scaleY)
    love.graphics.draw(shopButtonImage, shopTitle.x * scaleX, shopTitle.y * scaleY, 0, scaleX, scaleY)
end

--drawShopItems()
-- draws all of the shop items buttons when shop is opened
local function drawShopItems()
    local borderYOffset = 45
    local priceYOffset = 50
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    love.graphics.setColor(0.616, 0.671, 0.788, 1)
    love.graphics.rectangle("fill", shopTitle.x * scaleX, (shopTitle.y + 66) * scaleY, 203 * scaleX, 700 * scaleY)
    
    for _, shopItem in ipairs(shopItems) do
        if shop.hoveredItem == shopItem then
            love.graphics.setColor(0.9, 0.9, 0.9) -- Lighten color when hovering
        else
            love.graphics.setColor(shopItem.color)
        end

        love.graphics.rectangle(shopItem.mode, shopItem.x * scaleX, shopItem.y * scaleY, shopItem.width * scaleX, shopItem.height * scaleY)
        love.graphics.setColor(0.490, 0.525, 0.608)
        love.graphics.rectangle("fill", shopItem.x * scaleX, (shopItem.y + borderYOffset) * scaleY, shopItem.width * scaleX, 25 * scaleY)
        borderYOffset = borderYOffset + 1
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(shopItem.itemTable.name, (shopItem.x + 30) * scaleX , (shopItem.y + 8) * scaleY, 120 * scaleX, "center")
        love.graphics.printf("Price: $"..shopItem.itemTable.price, (shopItem.x + 30) * scaleX, (shopItem.y + priceYOffset) * scaleY, 120 * scaleX, "center")
        priceYOffset = priceYOffset + 1
    end

    -- Draw popup if hovering over an item
    if shop.hoveredItem then
        ui.hoverPopup(shop.hoverPopup.text, nil, nil, nil, nil, nil, nil, nil, nil)
    end
end


local function itemEffects(item)
    if item == 1 then
        print("Item 1 effect.")
        items.item1.effect()
        updateShopItem(shopItems[1], items.item1)
    elseif item == 2 then
        print("Item 2 effect.")
        items.item2.effect()
        updateShopItem(shopItems[2], items.item2)
    elseif item == 3 then
        print("Item 3 effect.")
        items.item3.effect()
        updateShopItem(shopItems[3], items.item3)
    end
end

local function isShopItemClicked(x, y, gameState)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for _, shopItem in ipairs(shopItems) do
        if x > shopItem.x * scaleX and x < shopItem.x * scaleX + shopItem.width * scaleX and
           y > shopItem.y * scaleY and y < shopItem.y * scaleY + shopItem.height * scaleY then
            print("Item ".._.." pressed.")

            if gameState.currency >= shopItem.itemTable.price then
                gameState.currency = gameState.currency - shopItem.itemTable.price
                itemEffects(_)
                sounds.powerUp:stop()
                sounds.powerUp:play()
            end
        end
    end
end

function isShopItemHovered(x, y)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for index = 1, #shopItems do
        local shopItem = shopItems[index]
        if x > shopItem.x * scaleX and x < shopItem.x * scaleX + shopItem.width * scaleX and
           y > shopItem.y * scaleY and y < shopItem.y * scaleY + shopItem.height * scaleY then
            shop.hoveredItem = shopItem
            shop.hoverPopup.x = (x - 120) * scaleX 
            shop.hoverPopup.y = (y + 10) * scaleY 
            -- shop.hoverPopup.text = "Hello world" 
            if index == 1 then
                shop.hoverPopup.text =
                    "Item Name: " .. items.item1.name .. "\n\n" ..
                    "Price: Starting price: $10, $8 increase for whenever\nthe item is purchased again.\n\n" ..
                    "Description: "..items.item1.description
            elseif shop.hoveredItem == shopItem then
                if index == 2 then
                    shop.hoverPopup.text =
                        "Item Name: " .. items.item2.name .. "\n\n" ..
                        "Price: Starting price: $15, $5 increase when the\nitem is purchased again.\n\n" ..
                        "Description: "..items.item2.description
                elseif index == 3 then
                    shop.hoverPopup.text =
                        "Item Name: " .. items.item3.name .. "\n\n" ..
                        "Price: Starting price: $30, $15 increase for\nwhenever the item is purchased again.\n\n" ..
                        "Description: "..items.item3.description
                end
            end            

            shop.hoverPopup.visible = true
            return
        end
    end
    shop.hoveredItem = nil
    shop.hoverPopup.visible = false
end

-- local 

return {
    createShopItem = createShopItem,
    setUpShop = setUpShop,
    drawShopTitle = drawShopTitle,
    drawShopItems = drawShopItems,
    itemEffects = itemEffects,
    isShopButtonClicked = isShopButtonClicked,
    isShopButtonHovered = isShopButtonHovered,
    isShopItemClicked = isShopItemClicked,
    isShopItemHovered = isShopItemHovered
}