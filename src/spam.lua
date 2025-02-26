-- spam.lua --
-- Implementation file for spam functions and tables

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

--combination tables
local combination = {}
combination.donation = {
    senderTable = {{localpart.adjectives, localpart.nouns, localpart.numbers}, {domain.official, domain.test}, {extension.official}},
    subjectTable = {{scenario.money}, {topic.things}}
}
-- Functions --
local function getRandomElement(tbl)
    return tbl[math.random(#tbl)]
end

function combineRandomString(...)
    local arg = {...}
    local randomString = ""
    for i, partsTable in ipairs(arg) do
        local part =  getRandomElement(partsTable)
        randomString = tostring(randomString..part)
    end
    return randomString
end

function getRandomFrom(...)
    local arg = {...}
    return getRandomElement(getRandomElement(arg))
end

function createSender(localpart, domain, extension)
    return {
        sender = string.format("%s@%s.%s", localpart, domain, extension),
        localpart = localpart,
        doamin = domain,
        extension = extension
    }
end

function createSubject(scenario, topic)
    return {
        subject = string.format(scenario, topic),
        topic = topic
    }
end

function createBody(message, topic)
    return {
        subject = string.format(scenario, topic),
        topic = topic
    }
end

function generateRandomSender(localpartTable, domainTable, extensionTable)
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

function generateRandomSubject(scenarioTable, topicTable)
    -- local adj = spam.adjectives[math.random(#spam.adjectives)]
    -- local noun = spam.nouns[math.random(#spam.nouns)]
    -- local num = spam.numbers[math.random(#spam.numbers)]
    local scenario = getRandomFrom(unpack(scenarioTable))
    local topic = getRandomFrom(unpack(topicTable))
    
    --return string.format("%s%s%d@%s.com", adj, noun, num, domain)
    return createSubject(scenario, topic)
end

function generateSpamEmail(combination)
    local senderTable = generateRandomSender(unpack(combination.senderTable))
    local subjectTable = generateRandomSubject(unpack(combination.subjectTable))
    return {
        prereq = {},
        sender = senderTable.sender,
        subject = subjectTable.subject,
        body = subjectTable.topic,
        choices = {},
        ignored = {}
    }
end

return {
    combination = combination,
    generateRandomSender = generateRandomSender,
    generateRandomSubject = generateRandomSubject,
    generateSpamEmail = generateSpamEmail
}
