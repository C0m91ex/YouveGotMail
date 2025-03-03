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



return utils