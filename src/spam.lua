-- spam.lua --
-- Implementation file for spam functions and tables

local localpart = {}
local domain = {}
local extension = {}

localpart.adjectives = { "fast", "lucky", "happy" }
localpart.nouns = { "cat", "dog", "panda" }
localpart.numbers = { 123, 456, 789 }

domain.official = { "example", "test", "mail" }

extension.official = {"com", "org", "net"}

-- Functions --
local function getRandomElement(tbl)
    return tbl[math.random(#tbl)]
end

function generateRandomString(...)
    local arg = {...}
    local randomString = ""
    for i, partsTable in ipairs(arg) do
        local part =  getRandomElement(partsTable)
        randomString = tostring(randomString..part)
    end
    return randomString
end

function createSender(localpart, domain, extension)
    return string.format("%s@%s.%s", localpart, domain, extension)
end

function generateRandomSender()
    -- local adj = spam.adjectives[math.random(#spam.adjectives)]
    -- local noun = spam.nouns[math.random(#spam.nouns)]
    -- local num = spam.numbers[math.random(#spam.numbers)]
    local localpart = generateRandomString(localpart.adjectives, localpart.nouns, localpart.numbers)
    local domain = generateRandomString(domain.official)
    local extension = generateRandomString(extension.official)
    
    --return string.format("%s%s%d@%s.com", adj, noun, num, domain)
    return createSender(localpart, domain, extension)
end

return {
    generateRandomSender = generateRandomSender
}
