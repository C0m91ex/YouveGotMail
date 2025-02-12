-- file.lua --
-- implementation for incoming file management
local utils = require("src.utils")

local function csvLineToEmail(line)
	local email = {prereq = {}, sender = "", subject = "", body = "", choices = {}, ignored = {}}
	local emailPat = '.*%(prereq: (.*)%).*,.*%(sender: (.*)%).*,.*%(subject: (.*)%).*,.*%(body: (.*)%).*,.*%(choices: (.*)%).*,.*%(ignored: (.*)%)'
    local quotePat = '%"(.-)%",'
    local quoteMark = "\"\""
    local flag = false;
	-- for value in line:gmatch(quotePat) do -- Note: We won't match empty values.
	-- 	-- Convert the value string to other Lua types in a "smart" way.
	-- 	if     tonumber(value)  then  table.insert(values, tonumber(value)) -- Number.
	-- 	elseif value == "true"  then  table.insert(values, true)            -- Boolean.
	-- 	elseif value == "false" then  table.insert(values, false)           -- Boolean.
	-- 	else                          table.insert(values, (string.gsub(value, quoteMark, "\"")))           -- String.
	-- 	end
	-- end
    for prereqString, senderString, subjectString, bodyString, choicesString, ignoredString in string.gmatch(line, emailPat) do -- Note: We won't match empty values.
        utils.updateTableFromString(email["prereq"], prereqString)
		email["sender"] = senderString
		email["subject"] = string.gsub(subjectString, quoteMark, "\"")
		email["body"] = string.gsub(bodyString, quoteMark, "\"")
		utils.updateTableFromString(email["choices"], choicesString)
		utils.updateTableFromString(email["ignored"], ignoredString)
	end

	--{mom = >=3, dad = >2, money>10}
	--mom@mom.com
	--Hey your dad needs some money
	--Hey! It's been a while... love, mom
	--{{{money>10},Sure thing mom,{money = -=10, mom = +=1, dad = +=1}},{{},Nope,{mom = -=1, dad = -=2}}}
	--{mom -= 1, dad -=2 }

    --table.insert(values, (string.gsub(line, quoteMark, "test")))
	return email
end

local function loadEmailFile(filename)
	print("loadEmailFile test")
	local emails = {}
	for line in love.filesystem.lines(filename) do
		table.insert(emails, csvLineToEmail(line))
	end
	return emails --table of tables of each line
end

--[[ cool.csv:
Foo,Bar
true,false,11.8
]]



return {
    csvLineToEmail = csvLineToEmail,
	loadEmailFile = loadEmailFile
}