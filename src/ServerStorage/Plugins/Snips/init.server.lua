-- Snips
-- brokenVectors
-- 07/30/22
local ScriptEditorService = game:GetService("ScriptEditorService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local toolbar = plugin:CreateToolbar("Snips")
local snippetEditor = script:WaitForChild("SnippetEditor");
local editSnipsBtn = toolbar:CreateButton("Edit Snips", "Add/remove snips", "rbxassetid://4458901886")
local snips = {}
function Init()
	local fancyName = "**Snips Editor**"
	local oldEditor = game:FindFirstChild(fancyName)
	if oldEditor then
		oldEditor:Destroy()
	end
	snippetEditor.Parent = game
	snippetEditor.Name = fancyName
	LoadSnips()
end
function SnipsWarn(...)
	warn("[SNIPS] ", ...)
end
function LoadSnips()
	snippetEditor.Source = plugin:GetSetting("source") or snippetEditor.Source
	ReloadSnips(true, false)
end
function SaveSnips()
	plugin:SetSetting("source", snippetEditor.Source)
end
function ReloadSnips(first, save)
	local old = snips
	local success, err = pcall(function()
		local tmp = Instance.new("ModuleScript")
		tmp.Source = snippetEditor.Source
		if save then
			SaveSnips()
		end
		snips = require(tmp)
		tmp:Destroy()
	end)
	if success then
		if not first then
			SnipsWarn("Snips successfully edited!")
		end
	else
		SnipsWarn("Could not make modifications to snips! Check for any errors in the snippet editor.")
		snips = old
	end
end
-- This function exists purely because lua "regex" is limited and won't let me do my own charsets.
function GetContent(line)
	local content = ""
	local inParens = false
	for i = 1, #line, 1 do
		local ch = string.sub(line, i, i)
		if ch == "(" then
			inParens = true
			continue
		elseif ch == ")" then
			inParens = false
			return content
		end
		if inParens then
			content = content .. ch
		end
	end
	if not inParens then
		return false
	end
	return content
end
function OnScriptEdit(doc)
	if doc:IsCommandBar() then
		return
	end
	local line = doc:GetLine()
	local lineNumber, _, _, _ = doc:GetSelection()

	local lineStartsWithExclamationMark = string.sub(string.gsub(line, "%s+", ""), 1, 1) == "!"
	if not lineStartsWithExclamationMark then
		-- Return if line does not begin with !, as checking for snips would be unnecessary
		return
	end
	for name,fn in pairs(snips) do
		local nameStartsWithExclamationMark = string.sub(name, 1, 1) == "!"
		if not nameStartsWithExclamationMark then
			continue
		end
		local snippetEntered = string.match(line, name .. "%(")
		local content = GetContent(line)
		local lineEndsWithSpace = string.sub(line, -1, -1) == " "
		if snippetEntered and content and lineEndsWithSpace then
			local args = string.split(string.gsub(content, " ", ""), ",")
			local new = fn(line, args, doc)
			local linesOfSnippet = string.split(new, "\n")

			doc:EditTextAsync(new, lineNumber, 1, lineNumber, #line)

			-- This is very hacky, hopefully API will mature and I won't need to do this
			-- For some reason EditTextAsync adds a space after edit, and cursor position lags behind
			task.wait()
			local cursorLine, cursorChar = doc:GetSelection()
			doc:EditTextAsync("", cursorLine, cursorChar-1, cursorLine, cursorChar)
			return	
		end
	end
end
function OpenEditor()
	plugin:OpenScript(snippetEditor)
end
-- Update snips when snippet editor is closed.
ScriptEditorService.TextDocumentDidClose:Connect(function(closedDocument)
	if closedDocument.Name == snippetEditor.Name then
		ReloadSnips(false, true);
	end
end)
ScriptEditorService.TextDocumentDidChange:Connect(OnScriptEdit)
editSnipsBtn.Click:Connect(OpenEditor)
Init()