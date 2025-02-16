local playerVars = {mom = 4, dad = 3}

local function getPlayerVarList()
    return playerVars
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
    print("playerCheck test")
    if playerVars[testKey] then
        local value = tonumber(string.match(testValue, "[%+%-]?%d+")) --thanks chatGPT
        local operator = string.match(testValue, "[<>~!=]*")
        print("operator is "..(operator))

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
    print("playerChange test")
    local value = tonumber(string.match(changeValue, "[%+%-]?%d+")) --thanks chatGPT
    local operator = string.match(changeValue, "[%+%-%*=]*")
    print("operator is "..(operator))

    if operator == "+=" then
        playerVars[changeKey] = (tonumber(playerVars[changeKey]) + tonumber(value))
    elseif operator == "-=" then
        playerVars[changeKey] = (tonumber(playerVars[changeKey]) - tonumber(value))
    elseif operator == "*=" then
        playerVars[changeKey] = (tonumber(playerVars[changeKey]) * tonumber(value))
    else
        playerVars[changeKey] = tonumber(value)
    end
end

return {
    playerVars,
    getPlayerVarList = getPlayerVarList,
    getPlayerMultiVars = getPlayerMultiVars,
    getPlayerSingleVar = getPlayerSingleVar,
    setPlayerVar = setPlayerVar,
    playerCheck = playerCheck,
    playerChange = playerChange
}