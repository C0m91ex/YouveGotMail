-- shop.lua --
-- Shop implementation and management file
local ui = require("src.ui")

-- global variable
numberOfShopItems = 2 -- this is used in gamestate.lua, line 26

    -- Shop item setup
local function setUpShop()
    -- setting the name and price for item 1
    ui.shopItems[1].name = "item 1"
    ui.shopItems[1].price = 10

    -- setting the name and price for item 2
    ui.shopItems[2].name = "item 2"
    ui.shopItems[2].price = 20
    
end

local function checkItemPrice()
    print("button works")
end


return {
    setUpShop = setUpShop,
    checkItemPrice = checkItemPrice
}