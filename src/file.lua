-- file.lua --
-- implementation for incoming file management
local utils = require("src.utils")

local function csvLineToEmail(line)
	local email = {}
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
    for prereqString, senderString, subjectString, bodyString, choicesString, ignoredString in line:gmatch(emailPat) do -- Note: We won't match empty values.
        local prereq = {} utils.updateTableFromString(prereq, prereqString) table.insert(email, prereq)
		table.insert(email, senderString)
		table.insert(email, (string.gsub(subjectString, quoteMark, "\"")))
		table.insert(email, (string.gsub(bodyString, quoteMark, "\"")))
		local choices = {} utils.updateTableFromString(choices, choicesString) table.insert(email, choices)
		local ignored = {} utils.updateTableFromString(ignored, ignoredString) table.insert(email, ignored)
	end
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