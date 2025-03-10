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

function utils.tableToString(table)
    local returnString = "{"
    if next(table) then
        for key, value in pairs(table) do
            returnString = returnString..tostring(key).." = "..tostring(value)
            if next(table) then returnString = returnString..", " end
        end
    end
    returnString = returnString.."}"
    return returnString
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

function utils.choiceToString(choiceTable)
    -- local prereqs = choiceTable.cPrereqs
    -- local body = choiceTable.cBody
    -- local changes = choiceTable.cChanges
    --"(choices: {{(cPrereqs: {}),(cBody: Not right now),(cChanges:{mom=-=1,dad=-=1})}})"
    local choiceString = ""
    choiceString = choiceString.."{(cPrereqs: "
    choiceString = choiceString..utils.tableToString(choiceTable.cPrereqs)
    choiceString = choiceString.."),(cBody: "
    choiceString = choiceString..tostring(choiceTable.cBody)
    choiceString = choiceString.."),(cChanges: "
    choiceString = choiceString..utils.tableToString(choiceTable.cChanges)
    choiceString = choiceString..")}"
    return choiceString
end

function utils.choiceListToString(choiceList)
    --(choices: {})
    local returnList = "{"
    if next(choiceList) then
        for i, choice in ipairs(choiceList) do
            returnList = returnList..utils.choiceToString(choice)
        end
    end
    returnList = returnList.."}"
    return returnList
end

function utils.emailToString(emailContentTable)
    --(prereq: {}),(sender: test@email.com),(subject: This is a test!),"(body: Do not be alarmed, instead be amazed.)",(choices: {}),(ignored: {})
    local emailString = ""
    emailString = emailString.."\"(prereq: "
    emailString = emailString..utils.tableToString(emailContentTable.prereq)
    emailString = emailString..")\",\"(sender: "
    emailString = emailString..tostring(emailContentTable.sender)
    emailString = emailString..")\",\"(subject: "
    emailString = emailString..tostring(emailContentTable.subject)
    emailString = emailString..")\",\"(body: "
    emailString = emailString..tostring(emailContentTable.body)
    emailString = emailString..")\",\"(choices: "
    emailString = emailString..utils.choiceListToString(emailContentTable.choices)
    emailString = emailString..")\",\"(ignored: "
    emailString = emailString..utils.tableToString(emailContentTable.ignored)
    emailString = emailString..")\""
    return emailString
end

function utils.emailBaseToString(emailBaseTable)
    local emailBaseString = ""
    for i, email in ipairs(emailBaseTable) do
        emailBaseString = emailBaseString..utils.emailToString(email).."\r\n"
    end
    return emailBaseString
end

return utils