-- spam.lua --
-- Implementation file for spam functions and tables
local utils = require("src.utils")

--sender tables
local localpart = {}
local domain = {}
local extension = {}

localpart.adjectives = { "fast", "lucky", "happy" }
localpart.nouns = { "cat", "dog", "panda" }
localpart.numbers = { 123, 456, 789 }

domain.official = { "example", "test", "mail" }
domain.test = {"wow", "woah"}

extension.official = {"com", "org", "net"}

--subject tables
local scenario = {}
local topic = {}

scenario.money = {
    "Lost my %s. Spare some change?",
    "Need a new %s. Won't you please donate today?"
}

topic.things = {"bicycle", "briefcase", "credit card"}

--body tables--
--note to spam writer. one topic only please
local message = {}
message.money = {"This is a test message. Please give me money so I can afford a %s."}


--combination tables
local combination = {}
combination.donation = {
    senderTable = {{localpart.adjectives, localpart.nouns, localpart.numbers}, {domain.official, domain.test}, {extension.official}},
    subjectTable = {{scenario.money}, {topic.things}},
    bodyTable = {{message.money}}
}

-- Functions --
local function getRandomElement(tbl)
    return tbl[math.random(#tbl)]
end

local function combineRandomString(...)
    local arg = {...}
    local randomString = ""
    for i, partsTable in ipairs(arg) do
        local part =  getRandomElement(partsTable)
        randomString = tostring(randomString..part)
    end
    return randomString
end

local function getRandomFrom(...)
    local arg = {...}
    return getRandomElement(getRandomElement(arg))
end

local function createSender(localpart, domain, extension)
    return {
        sender = string.format("%s@%s.%s", localpart, domain, extension),
        localpart = localpart,
        doamin = domain,
        extension = extension
    }
end

local function createSubject(scenario, topic)
    return {
        subject = string.format(scenario, topic),
        topic = topic
    }
end

local function createBody(message, topic)
    return {
        body = string.format(message, topic),
        topic = topic
    }
end

local function generateRandomSender(localpartTable, domainTable, extensionTable)
    -- local adj = spam.adjectives[math.random(#spam.adjectives)]
    -- local noun = spam.nouns[math.random(#spam.nouns)]
    -- local num = spam.numbers[math.random(#spam.numbers)]
    -- test1 = {localpart.adjectives, localpart.nouns, localpart.numbers}
    -- test2 = {domain.official}
    -- test3 = {extension.official}
    -- test1 = localpartTable
    -- test2 = domainTable
    -- test3 = extensionTable
    local localpart = combineRandomString(unpack(localpartTable))
    local domain = getRandomFrom(unpack(domainTable))
    local extension = getRandomFrom(unpack(extensionTable))
    
    --return string.format("%s%s%d@%s.com", adj, noun, num, domain)
    return createSender(localpart, domain, extension)
end

local function generateRandomSubject(scenarioTable, topicTable)
    -- local adj = spam.adjectives[math.random(#spam.adjectives)]
    -- local noun = spam.nouns[math.random(#spam.nouns)]
    -- local num = spam.numbers[math.random(#spam.numbers)]
    local scenario = getRandomFrom(unpack(scenarioTable))
    local topic = getRandomFrom(unpack(topicTable))
    
    --return string.format("%s%s%d@%s.com", adj, noun, num, domain)
    return createSubject(scenario, topic)
end

local function generateRandomBody(messageTable, topic)
    local message = getRandomFrom(unpack(messageTable))
    return createBody(message, topic)
end

local function getCombination()
    return combination
end

local function generateSpamEmail(combination)
    local senderTable = generateRandomSender(unpack(combination.senderTable))
    local subjectTable = generateRandomSubject(unpack(combination.subjectTable))
    local bodyTable = generateRandomBody(unpack(combination.bodyTable), subjectTable.topic)
    return {
        prereq = {},
        sender = senderTable.sender,
        subject = subjectTable.subject,
        body = bodyTable.body,
        choices = {},
        ignored = {}
    }
end

function generateRandomSpamEmail()
    local tempTable = {}
    for _, combo in pairs(combination) do
        table.insert(tempTable, combo)
    end
    return generateSpamEmail(getRandomElement(tempTable))
end

return {
    getCombination = getCombination,
    generateSpamEmail = generateSpamEmail,
    generateRandomSpamEmail = generateRandomSpamEmail
}
