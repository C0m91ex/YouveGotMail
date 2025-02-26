-- shop.lua --
-- Shop implementation and management file
local ui = require("src.ui")
local email = require("src.email")
local scaling = require("src.scaling")

-- global vars
local shop = {
    shopOffsetY = -410,
}

local desktopWidth, desktopHeight = love.window.getDesktopDimensions()

local scaleX, scaleY = 1, 1

<<<<<<< Updated upstream
local shopTitle = { x = love.graphics.getWidth() / 2 + 995, y = love.graphics.getHeight() / 2 - 220, width = 130, height = 40, color = {1, 0.5, 0} }
=======
local shopTitle = { x = desktopWidth / 2 + 995, y = desktopHeight / 2 - 220, width = 204, height = 66 }
>>>>>>> Stashed changes
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
        name = "",
        price = 0
    })
end

    -- Shop item setup --
local numberOfShopItems = 3
local function setUpShop()
    -- Make sure when increasing this variable to set up name and price for the added items to the shop
    for _ = 1, numberOfShopItems do
        -- createShopItem(mode, x, y, width, height, color)
<<<<<<< Updated upstream
        createShopItem("fill", love.graphics.getWidth() / 2 + 450, love.graphics.getHeight() / 2 + shop.shopOffsetY, 100, 70, {1, 0.5, 0})
=======
        createShopItem("fill", desktopWidth / 2 + 645, desktopHeight / 2 + shop.shopOffsetY, 175, 70, {0.855, 0.855, 0.855})
>>>>>>> Stashed changes
        shop.shopOffsetY = shop.shopOffsetY + 90
    end

    -- setting the name and price for item 1
    shopItems[1].name = "Increase email value"
    shopItems[1].price = 10

    -- setting the name and price for item 2
    shopItems[2].name = "item 2"
    shopItems[2].price = 20
    
    shopItems[3].name = "Item 3"
    shopItems[3].price = 30
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
    love.graphics.setColor(shopTitle.color)
    love.graphics.rectangle("fill", shopTitle.x * scaleX, shopTitle.y * scaleY, shopTitle.width * scaleX, shopTitle.height * scaleY)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("-- SHOP --", shopTitle.x * scaleX + 7, shopTitle.y * scaleY + 11, 120 * scaleX, "center")
end

--drawShopItems()
-- draws all of the shop items buttons when shop is opened
local function drawShopItems()
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    -- draws out each item box
    for _, shopItem in ipairs(shopItems) do
        love.graphics.setColor(shopItem.color)
        love.graphics.rectangle(shopItem.mode, shopItem.x * scaleX, shopItem.y * scaleY, shopItem.width * scaleX, shopItem.height * scaleY)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(shopItem.name, shopItem.x * scaleX - 13, shopItem.y * scaleY + 11, 120 * scaleX, "center")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Price: $"..shopItem.price, shopItem.x * scaleX - 13, shopItem.y * scaleY + 50, 120 * scaleX, "center")
    end
end

local function itemEffects(item)
    if item == 1 then
        print("Item 1 effect.")
        email.updateEmailValue()
    elseif item == 2 then
        print("Item 2 effect.")
    elseif item == 3 then
        print("Item 3 effect.")
    end
end

local function isShopItemclicked(x, y, gameState)
    scaleX = scaling.scaleX
    scaleY = scaling.scaleY
    for _, shopItem in ipairs(shopItems) do
        if x > shopItem.x * scaleX and x < shopItem.x * scaleX + shopItem.width * scaleX and
           y > shopItem.y * scaleY and y < shopItem.y * scaleY + shopItem.height * scaleY then
            print("Item ".._.." pressed.")

            if gameState.currency >= shopItem.price then
                itemEffects(_)
                gameState.currency = gameState.currency - shopItem.price
            end
        end
    end
end


return {
    createShopItem = createShopItem,
    setUpShop = setUpShop,
    drawShopTitle = drawShopTitle,
    drawShopItems = drawShopItems,
    itemEffects = itemEffects,
    isShopButtonClicked = isShopButtonClicked,
    isShopItemclicked = isShopItemclicked
}