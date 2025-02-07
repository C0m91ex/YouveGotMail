local playerVars = {mom = 1, dad = 0}

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


return {
    playerVars,
    getPlayerVarList = getPlayerVarList,
    getPlayerMultiVars = getPlayerMultiVars,
    getPlayerSingleVar = getPlayerSingleVar,
    setPlayerVar = setPlayerVar
}