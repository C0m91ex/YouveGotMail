playerVars = {}

local function getPlayerVars(...)
    varTable = {}
    for i,variable in ipairs(arg) do
        varTable:insert(playerVars[variable])
    end
    return varTable
end

local function getPlayerVars()
    return playerVars
end

local function setPlayerVar(variable, value)
    playerVars[variable] = value
end

return {
    playerVars,
    getPlayerVars = getPlayerVars
}