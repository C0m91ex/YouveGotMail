-- file.lua --
-- implementation for incoming file management
local function splitCsvLine(line)
	local values = {}
	local emailPat = '.*%(prereq: (.*)%).*,.*%(sender: (.*)%).*,.*%(subject: (.*)%).*,.*%(body: (.*)%).*,.*%(choices: (.*)%)'
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
    for v1, v2, v3, v4, v5 in line:gmatch(emailPat) do -- Note: We won't match empty values.
		local t = {}
        table.insert(t, v1) table.insert(t, v2) table.insert(t, (string.gsub(v3, quoteMark, "\""))) table.insert(t, (string.gsub(v4, quoteMark, "\""))) table.insert(t, v5)
		table.insert(values, t)
	end
    --table.insert(values, (string.gsub(line, quoteMark, "test")))
	return values
end

local function loadCsvFile(filename)
	local csv = {}
	for line in love.filesystem.lines(filename) do
		table.insert(csv, splitCsvLine(line))
	end
	return csv --table of tables of each line
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

local function printEmail(email)
		--print(unpack(email))
        for section, content in ipairs(email) do 
			--print(unpack(content))
            prereq, sender, subject, body, choices = unpack(content)
            love.graphics.setColor(0, 0, 0)
			love.graphics.printf(prereq, 0, 50, 120, "center")
			love.graphics.printf(sender, 0, 100, 120, "center")
			love.graphics.printf(subject, 0, 150, 120, "center")
			love.graphics.printf(body, 0, 200, 120, "center")
			love.graphics.printf(choices, 0, 250, 120, "center")
        end
end

return {
    loadCsvFile = loadCsvFile,
    splitCsvLine = splitCsvLine,
	printEmail = printEmail
}