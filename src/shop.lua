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

local itemAmounts = {}

local items = {
    {name = "Concentrated Encryption",
    price = 10,
    inflation = 8,
    description = "Emails give more money when they are deleted, thanks to the interns. The emails encrypt themselves further now, whatever that means.",
    modifier = 1,
    effect = function(modifier)
        email.updateEmailValue(modifier)
    end
    },
    {name = "Data Scraping",
    price = 20,
    inflation = 5,
    description = "Get a bit of money when emails come in; thank you, interns. Something about emails scraping a bit of data from all the networks they pass to get to you.",
    modifier = 1,
    effect = function(modifier)
        email.updateSpawnValue(modifier)
    end
    },
    {name = "Net Speedrouting",
    price = 30,
    inflation = 15,
    description = "Emails come in faster. I didn't bother asking the interns why this time.",
    modifier = 10,
    effect = function(modifier)
        email.setSpawnPeriod(email.getSpawnPeriod() - email.getSpawnPeriod()/modifier)
        print(email.getSpawnPeriod())
       -- ui.addFloatingText((love.graphics.getWidth() / 2 - 710) * scaling.scaleX, (love.graphics.getHeight() / 2 - 30) * scaling.scaleY,"+Email rate")
    end
    }
}
local shopItems = {}

local scaleX, scaleY = 1, 1

local shopTitle = { x = (love.graphics.getWidth() / 2 + 995), y = (love.graphics.getHeight() / 2 - 220), width = 204, height = 66 }
-- Functions --

--getters and setters
local function getShopItems() return shopItems end
local function getItemAmounts() return itemAmounts end
local function setItemAmounts(amounts) itemAmounts = amounts end 

-- Table used as the bone structure for shop items
local function createShopItem(mode, x, y, width, height, color, itemTable)
    table.insert(shopItems, {
        mode = mode,
        x = x,
        y = y,
        width = width,
        height = height,
        color = color,
        itemTable = itemTable
    })
end

local function updateItemAmounts(shopItem)
    if itemAmounts[shopItem.itemTable.name] then itemAmounts[shopItem.itemTable.name] = (itemAmounts[shopItem.itemTable.name] + 1) or 1
    else itemAmounts[shopItem.itemTable.name] = 1 end
    print(itemAmounts[shopItem.itemTable.name])
end

    -- Shop item setup --
-- local numberOfShopItems = 3
local function setUpShop()
    shopItems = {}
    -- shopIcon = love.graphics.newImage('assets/inbox/Shop Button.png')
    shopIcon = shopButtonImage
    -- Make sure when increasing this variable to set up name and price for the added items to the shop
    for _, itemTable in ipairs(items) do
        -- createShopItem(mode, x, y, width, height, color)
        print("setupShopTest")
        createShopItem("fill", shopTitle.x + 15, shopTitle.y + shop.shopOffsetY, 175, 70, {0.855, 0.855, 0.855}, itemTable)
        shop.shopOffsetY = shop.shopOffsetY + 90
    end

    -- setting the name and price for item 1
    -- shopItems[1].itemTable.name = items.item1.name
    -- shopItems[1].itemTable.price = items.item1.price

    -- -- setting the name and price for item 2
    -- shopItems[2].itemTable.name = items.item2.name
    -- shopItems[2].itemTable.price = items.item2.price
    
    -- shopItems[3].itemTable.name = items.item3.name
    -- shopItems[3].itemTable.price = items.item3.price
end

local function loadShopItems()
    resetShopItems()
    for _, shopItem in ipairs(shopItems) do
        local amount = itemAmounts[shopItem.itemTable.name]
        for i=1, amount do
            itemEffects(shopItem)
        end
    end
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


local function itemEffects(shopItem)
    print("Item "..tostring(shopItem.itemTable.name).." effect.")
    shopItem.itemTable.effect(shopItem.itemTable.modifier)
    shopItem.itemTable.price = shopItem.itemTable.price + shopItem.itemTable.inflation
    -- if item == 1 then
    --     print("Item 1 effect.")
    --     items.item1.effect()
    --     updateShopItem(shopItems[1], items.item1)
    -- elseif item == 2 then
    --     print("Item 2 effect.")
    --     items.item2.effect()
    --     updateShopItem(shopItems[2], items.item2)
    -- elseif item == 3 then
    --     print("Item 3 effect.")
    --     items.item3.effect()
    --     updateShopItem(shopItems[3], items.item3)
    -- end
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
                itemEffects(shopItem)
                updateItemAmounts(shopItem)
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
            -- if index == 1 then
            --     shop.hoverPopup.text =
            --         "Item Name: " .. items.item1.name .. "\n\n" ..
            --         "Price: Starting price: $10, $8 increase for whenever\nthe item is purchased again.\n\n" ..
            --         "Description: "..items.item1.description
            -- elseif shop.hoveredItem == shopItem then
            --     if index == 2 then
            --         shop.hoverPopup.text =
            --             "Item Name: " .. items.item2.name .. "\n\n" ..
            --             "Price: Starting price: $15, $5 increase when the\nitem is purchased again.\n\n" ..
            --             "Description: "..items.item2.description
            --     elseif index == 3 then
            --         shop.hoverPopup.text =
            --             "Item Name: " .. items.item3.name .. "\n\n" ..
            --             "Price: Starting price: $30, $15 increase for\nwhenever the item is purchased again.\n\n" ..
            --             "Description: "..items.item3.description
            --     end
            -- end            
            createHoverText(shopItem)
            shop.hoverPopup.visible = true
            return
        end
    end
    shop.hoveredItem = nil
    shop.hoverPopup.visible = false
end

function createHoverText(shopItem)
    local hovertext =
            "Item Name: "..tostring(shopItem.itemTable.name).."\n\n"..
            "Price: $"..tostring(shopItem.itemTable.price)..", $"..tostring(shopItem.itemTable.inflation).." increase for\nwhenever the item is purchased again.\n\n"..
            "Description: "..tostring(shopItem.itemTable.description)
    shop.hoverPopup.text = hovertext
end

-- local 

return {
    getShopItems = getShopItems,
    getItemAmounts = getItemAmounts,
    setItemAmounts = setItemAmounts,
    createShopItem = createShopItem,
    setUpShop = setUpShop,
    loadShopItems = loadShopItems,
    drawShopTitle = drawShopTitle,
    drawShopItems = drawShopItems,
    itemEffects = itemEffects,
    isShopButtonClicked = isShopButtonClicked,
    isShopButtonHovered = isShopButtonHovered,
    isShopItemClicked = isShopItemClicked,
    isShopItemHovered = isShopItemHovered
}