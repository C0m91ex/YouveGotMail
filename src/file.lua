-- file.lua --
-- implementation for incoming file management
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
    for prereq, sender, subject, body, choices, ignored in line:gmatch(emailPat) do -- Note: We won't match empty values.
		local tempTable = {}
        table.insert(tempTable, prereq) table.insert(tempTable, sender) table.insert(tempTable, (string.gsub(subject, quoteMark, "\""))) table.insert(tempTable, (string.gsub(body, quoteMark, "\""))) table.insert(tempTable, choices) table.insert(tempTable, ignored)
		table.insert(email, tempTable)
	end
    --table.insert(values, (string.gsub(line, quoteMark, "test")))
	return email
end

local function loadEmailFile(filename)
	print("test")
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
-- local csv = loadCsvFile("cool.csv")
-- for row, values in ipairs(csv) do
--     for i, v in ipairs(values) do
-- 	    print("row="..i.." count="..#v.." values=", unpack(v))
--     end
-- end



return {
    
    csvLineToEmail = csvLineToEmail,
	loadEmailFile = loadEmailFile
}