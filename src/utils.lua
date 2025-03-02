-- utils.lua --
-- Utility function implementation for UI element interaction
local utils = {}
local keyValuePat = "(%w+)%s?=%s?([+-<>~=!]*%d+)"
local choicePat = '{%(cPrereqs:%s-.-%).-,.-%(cBody:%s-.-%).-,.-%(cChanges:%s-.-%)}'
local choicePartsPat = '.*%(cPrereqs:%s*(.*)%).*,.*%(cBody:%s*(.*)%).*,.*%(cChanges:%s*(.*)%)'

-- isPointInRect()
-- Checks to see if the given point exists inside the given rectangle
function utils.isPointInRect(px, py, rx, ry, rw, rh)
    return px > rx and px < rx + rw and py > ry and py < ry + rh
end

function utils.updateTableFromString(table, string)
    for key, value in string.gmatch(string, keyValuePat) do
        table[key] = value
    end
    return table
end

function utils.createChoiceTableFromString(choiceTable, string)
    --print(string)
    print("createChoiceTableFromString test")
    for choice in string.gmatch(string, choicePat) do  
        print(choice)
        --print("createChoiceTableFromString new choice found")
        newChoice = {
            cPrereqs = {},
            cBody = "",
            cChanges = {}
        }
        for cPrereqs, cBody, cChanges in string.gmatch(choice, choicePartsPat) do
            utils.updateTableFromString(newChoice["cPrereqs"], cPrereqs)
            newChoice["cBody"] = cBody
            utils.updateTableFromString(newChoice["cChanges"], cChanges)
        end
        table.insert(choiceTable, newChoice)
    end
    return choiceTable
end

-- Creates a popup near where the mouse position is hovering so long as text is provided
-- All other fields are optional and will set to default values if not provided
function utils.hoverPopup(text, textColor, red, green, blue, alpha, width, height)
    if text == nil then return end
    if textColor == nil then textColor = {0, 0, 0} end
    if red == nil then red = 0.678 end
    if green == nil then green = 0.678 end
    if blue == nil then blue = 0.678 end
    if alpha == nil then alpha = 0.5 end
    if width == nil then width = 360 end
    if height == nil then height = 180 end

    local mouseX, mouseY = love.mouse.getPosition()
    local popupX = mouseX - width - 10
    local popupY = mouseY + 10
    
    love.graphics.setColor(red, green, blue, alpha)
    love.graphics.rectangle("fill", popupX, popupY, width, height)
    love.graphics.setColor(textColor)
    love.graphics.print(text, popupX + 10, popupY + 10)
    love.graphics.setColor(1, 1, 1)
end



return utils