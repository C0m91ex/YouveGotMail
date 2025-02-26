local spam = {}

function spam.generateRandomSender()
    local adj = spam.adjectives[math.random(#spam.adjectives)]
    local noun = spam.nouns[math.random(#spam.nouns)]
    local num = spam.numbers[math.random(#spam.numbers)]
    local domain = spam.domains[math.random(#spam.domains)]
    
    return string.format("%s%s%d@%s.com", adj, noun, num, domain)
end

spam.adjectives = { "fast", "lucky", "happy" }
spam.nouns = { "cat", "dog", "panda" }
spam.numbers = { 123, 456, 789 }
spam.domains = { "example", "test", "mail" }

return spam
