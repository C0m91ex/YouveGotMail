local file = require("src.file")
local utils = require("src.utils")

local playerVars = {}
playerVars = file.serializeStateTest(playerVars)

local function getPlayerVarList() return playerVars end
local function setPlayerVarList(newPlayerVars)
    utils.updateTableFromString(playerVars, newPlayerVars)
end

local function getPlayerMultiVars(...)
    local arg = {...}
    varTable = {}
    for _, variable in pairs(arg) do
        varTable[variable] = playerVars[variable]
    end
    return varTable
end

local function getPlayerSingleVar(variable)
    return playerVars[variable]
end

local function setPlayerVar(variable, value)
    playerVars[variable] = value
end

function playerCheck(testKey, testValue)
    --print("playerCheck test")
    if playerVars[testKey] then
        local value = tonumber(string.match(testValue, "[%+%-]?%d+")) --thanks chatGPT
        local operator = string.match(testValue, "[<>~!=]*")
        --print("operator is "..(operator))

        if operator == "<" then
            return tonumber(playerVars[testKey]) < value
        elseif operator == "<=" then
            return tonumber(playerVars[testKey]) <= value
        elseif operator == ">" then
            return tonumber(playerVars[testKey]) > value
        elseif operator == ">=" then
            return tonumber(playerVars[testKey]) >= value
        elseif operator == "~" or operator == "~=" or operator == "!" or operator == "!=" then
            return tonumber(playerVars[testKey]) < value
        else
            return tonumber(playerVars[testKey]) == value
        end
    else return false end
end

function playerChange(changeKey, changeValue)
    --print("playerChange test")
    local value = tonumber(string.match(changeValue, "[%+%-]?%d+")) --thanks chatGPT
    local operator = string.match(changeValue, "[%+%-%*=]*")
    local newOp = ""
    --print("operator is "..(operator))

    if operator == "+=" then
        newOp = "+"
        if not playerVars[changeKey] then playerVars[changeKey] = 0 + tonumber(value)
        else playerVars[changeKey] = (tonumber(playerVars[changeKey]) + tonumber(value))
        end
    elseif operator == "-=" then
        newOp = "-"
        if not playerVars[changeKey] then playerVars[changeKey] = 0 - tonumber(value)
        else playerVars[changeKey] = (tonumber(playerVars[changeKey]) - tonumber(value))
        end
    elseif operator == "*=" then
        newOp = "*"
        if not playerVars[changeKey] then playerVars[changeKey] = 0 * tonumber(value)
        else playerVars[changeKey] = (tonumber(playerVars[changeKey]) * tonumber(value))
        end
    else
        newOp = "="
        playerVars[changeKey] = tonumber(value)
    end

    return changeKey.." "..newOp..""..value
end

return {
    playerVars,
    getPlayerVarList = getPlayerVarList,
    setPlayerVarList = setPlayerVarList,
    getPlayerMultiVars = getPlayerMultiVars,
    getPlayerSingleVar = getPlayerSingleVar,
    setPlayerVar = setPlayerVar,
    playerCheck = playerCheck,
    playerChange = playerChange
}