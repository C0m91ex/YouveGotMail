-- file.lua --
-- implementation for incoming file management
local utils = require("src.utils")

-- csvLineToEmail()
-- Function to convert a line of a CSV file to an email table
local function csvLineToEmail(line)
	local email = {prereq = {}, sender = "", subject = "", body = "", choices = {}, ignored = {}}
	local emailPat = '.*%(prereq: (.*)%).*,.*%(sender: (.*)%).*,.*%(subject: (.*)%).*,.*%(body: (.*)%).*,.*%(choices: (.*)%).*,.*%(ignored: (.*)%)'
    local quotePat = '%"(.-)%",'
    local quoteMark = "\"\""
    local flag = false;

    for prereqString, senderString, subjectString, bodyString, choicesString, ignoredString in string.gmatch(line, emailPat) do -- Note: We won't match empty values.
        utils.updateTableFromString(email["prereq"], prereqString)
		email["sender"] = senderString
		email["subject"] = string.gsub(subjectString, quoteMark, "\"")
		email["body"] = string.gsub(bodyString, quoteMark, "\"")
		utils.createChoiceTableFromString(email["choices"], choicesString)
		utils.updateTableFromString(email["ignored"], ignoredString)
	end

	return email
end

-- loadEmailFile()
-- Function to load a CSV file of emails into a table of email tables
local function loadEmailFile(filename)
	print("loadEmailFile test")
	local emails = {}
	for line in love.filesystem.lines(filename) do
		table.insert(emails, csvLineToEmail(line))
	end
	return emails --table of tables of each line
end

return {
    csvLineToEmail = csvLineToEmail,
	loadEmailFile = loadEmailFile
}