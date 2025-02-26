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

extension.official = {"com", "org", "net"}

--subject tables
local scenario = {}
local topic = {}

scenario.money = {
    "Lost my %s. Spare some change?",
    "Need a new %s. Won't you please donate today?"
}

topic.things = {"bicycle", "briefcase", "credit card"}

--body tables

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

function generateRandomSubject()
    -- local adj = spam.adjectives[math.random(#spam.adjectives)]
    -- local noun = spam.nouns[math.random(#spam.nouns)]
    -- local num = spam.numbers[math.random(#spam.numbers)]
    local scenario = generateRandomString(scenario.money)
    local topic = generateRandomString(topic.things)
    
    --return string.format("%s%s%d@%s.com", adj, noun, num, domain)
    return createSubject(scenario, topic)
end

function generateSpamEmail()
    local senderTable = generateRandomSender()
    local subjectTable = generateRandomSubject()
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
    generateRandomSender = generateRandomSender,
    generateRandomSubject = generateRandomSubject,
    generateSpamEmail = generateSpamEmail
}
