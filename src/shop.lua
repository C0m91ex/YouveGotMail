-- shop.lua --
-- Shop implementation and management file
local ui = require("src.ui")
local email = require("src.email")
local scaling = require("src.scaling")

-- global vars
local shop = {
    shopOffsetY = 105,
}

local items = {}
items.item1 = {
    price = 10,
    name = "Concentrated Encryption",
    description = "Emails give more money when they are deleted",
    modifier = 1,
    effect = function()
        email.updateEmailValue(items.item1.modifier)
    end
}
items.item2 = {
    price = 20,
    name = "Data Scraping",
    description = "Get a bit of money when emails come in.",
    modifier = 1,
    effect = function()
        email.updateSpawnValue(items.item2.modifier)
    end
}
items.item3 = {
    price = 30,
    name = "Net Speedrouting",
    description = "Emails come in faster.",
    modifier = email.getSpawnPeriod()/10,
    effect = function()
        email.setSpawnPeriod(email.getSpawnPeriod() - items.item3.modifier)
        items.item3.modifier = email.getSpawnPeriod()/10
        print(email.getSpawnPeriod())
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
    -- Shop item setup --
local numberOfShopItems = 3
local function setUpShop()
    shopIcon = love.graphics.newImage('assets/inbox/Shop Button.png')
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

local function drawShopTitle()
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", shopTitle.x * scaleX, shopTitle.y * scaleY, shopTitle.width * scaleX, shopTitle.height * scaleY)
    love.graphics.draw(shopIcon, shopTitle.x * scaleX, shopTitle.y * scaleY, 0, scaleX, scaleY)
end

--drawShopItems()
-- draws all of the shop items buttons when shop is opened
local function drawShopItems()
    local borderYOffset = 45
    local priceYOffset = 50
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    love.graphics.setColor(0.616, 0.671, 0.788, 1)
    love.graphics.rectangle("fill", shopTitle.x * scaleX, (shopTitle.y + 52) * scaleY, 203 * scaleX, 700 * scaleY)
    
    for _, shopItem in ipairs(shopItems) do
        -- Change color if this item is being hovered over
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
end

local function itemEffects(item)
    if item == 1 then
        print("Item 1 effect.")
        items.item1.effect()
    elseif item == 2 then
        print("Item 2 effect.")
        items.item2.effect()
    elseif item == 3 then
        print("Item 3 effect.")
        items.item3.effect()
    end
end

local function isShopItemclicked(x, y, gameState)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for _, shopItem in ipairs(shopItems) do
        if x > shopItem.x * scaleX and x < shopItem.x * scaleX + shopItem.width * scaleX and
           y > shopItem.y * scaleY and y < shopItem.y * scaleY + shopItem.height * scaleY then
            print("Item ".._.." pressed.")

            if gameState.currency >= shopItem.itemTable.price then
                itemEffects(_)
                gameState.currency = gameState.currency - shopItem.itemTable.price
                sounds.powerUp:stop()
                sounds.powerUp:play()
            end
        end
    end
end

local function isShopItemHovered(x, y)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for _, shopItem in ipairs(shopItems) do
        if x > shopItem.x * scaleX and x < shopItem.x * scaleX + shopItem.width * scaleX and
           y > shopItem.y * scaleY and y < shopItem.y * scaleY + shopItem.height * scaleY then
            -- Placeholder: Perform actions when hovering over a shop item
            print("Hovering over item: " .. shopItem.itemTable.name)
            -- You can set a flag like `shop.hoveredItem = shopItem` to use it elsewhere
            shop.hoveredItem = shopItem
            return
        end
    end
    -- Reset hovered item if not hovering over anything
    shop.hoveredItem = nil
end

return {
    createShopItem = createShopItem,
    setUpShop = setUpShop,
    drawShopTitle = drawShopTitle,
    drawShopItems = drawShopItems,
    itemEffects = itemEffects,
    isShopButtonClicked = isShopButtonClicked,
    isShopItemclicked = isShopItemclicked,
    isShopItemHovered = isShopItemHovered
}