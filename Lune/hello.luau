wait()
local cc = "8.7"
local bool1 = false
local bool2 = 0
local toolbar = plugin:CreateToolbar("Ro-Defender Plugin")
local button = toolbar:CreateButton("", "Scan your game with Ro-Defender", "http://www.roblox.com/asset/?id=153192398")
local find = string.find
local num1 = 0
local tags = {
	"Infected",
	"Anti-Lag",
	"Hack",
	"Virus",
	"Hidden",
	"ROFL",
	"4D Being",
	"Guest Free Chat Script",
	"Guest_Talking_Script",
	"Spreadify",
	"Kill tem!",
	"join teh moovment!",
	"Wormed",
	"Trashed",
	"asdf",
	"Anti-Lag2",
	"Antivirus",
	"Lolzorz",
	"Guest Talking Script",
	"soz i herd u lik mudkipz",
	"Nice little scripty",
	"Harmless little scripty",
	"OH SNAP YOU GOT INFECTED XD XD XD",
	"Spread",
	"spread",
	"YOU GOT INFECTED XD XD XD",
	"virus",
	"INfecTION",
	"Vaccine",
	"IsInfected",
	"ViVrus",
	"dåååååååååååååång.........you got owned...",
	"Kraftyisback",
	"ThisScriptIsAJumpStartToAHeålthyLifestyle",
	"I am a friendly virus",
	"micolord",
	"ProperGråmmerNeededInPhilosiphalLocations;insertNoobHere",
	"FreeStyleMåyGoAnywhereIfNeeded",
	"ANTIVIRISIS",
	"ANTIVIRIS",
	"FeelFreeToIns3rtGrammåticålErrorsHere",
	"NoNoIDon'tNeedAllOfYourAwkwårdSovietArguments",
	[[""''""''""å|`ç]],
}
local c_a = {}
local function d_a(_ba)
	pcall(function()
		if _ba ~= nil then
			c_a[#c_a + 1] = _ba.Name
			_ba:Destroy()
			num1 = num1 + 1
		else
		end
	end)
end
local function _aa(_ba)
	for i = 1, #_ba do
		if i % 2 == 0 then
			_ba[i] = nil
		end
	end
end
local function aaa(_ba)
	if _ba ~= nil then
		local aba = _ba.Name:lower()
		if find(aba, "spread") ~= nil and _ba.Parent.ClassName == "Fire" then
			d_a(_ba.Parent)
			return true
		end
		for i = 1, #tags do
			local bba = tags[i]
			if aba == bba:lower() then
				d_a(_ba)
				return true
			end
		end
		return false
	end
end
local function baa(_ba)
	local aba = true
	pcall(function()
		aba = aaa(_ba)
	end)
	if aba == false then
		local bba = pcall(_ba:GetChildren())
		if bba == false then
			local cba = _ba:GetChildren()
			for i = 1, #cba do
				local dba = cba[i]
				aba = true
				pcall(function()
					aba = aaa(_ba)
				end)
				if aba == false then
					baa(dba)
				end
			end
		end
	else
		d_a(_ba)
	end
end
button.Click:connect(function()
	if bool1 == true then
		while not game do
			wait()
		end
		game:WaitForChild("Workspace")
		game.Workspace:WaitForChild("Camera")
		local _ba = tick()
		print("Scan started. Please wait a moment.")
		baa(game)
		local aba = "Ro-Defender scan completed; "
			.. tostring(num1 / 2)
			.. " viruses removed; Scan time: "
			.. tostring(_ba - tick())
		print(aba)
		local bba = Instance.new("Hint")
		bba.Text = aba
		bba.Parent = game.Workspace
		aba = nil
		plugin:SetSetting("numRemoved", bool2 + (num1 / 2))
		_aa(c_a)
		if #c_a > 0 then
			local cba = table.concat(c_a, ",  ")
			print("Viruses:  " .. cba:sub(1, cba:len()))
			cba = nil
		end
		c_a = {}
		num1 = 0
		delay(4, function()
			bba:Destroy()
		end)
	end
end)
local caa = game:GetService("MarketplaceService"):GetProductInfo(142273772)
if not caa.Name:find(cc) then
	game:GetService("TestService"):Warn(false, "Ro-Defender is outdated. Update to get the latest version.")
end
local daa = plugin:GetSetting("pluginHasLoaded")
if not daa then
	print([[
	Thank you for installing Ro-Defender!
	To scan your game for viruses and lag-causing junk, click the shield icon in the PLUGINS tab.]])
	plugin:SetSetting("pluginHasLoaded", true)
	plugin:SetSetting("numRemoved", 0)
else
	bool2 = plugin:GetSetting("numRemoved")
	print("Ro-Defender has removed a total of " .. tostring(bool2) .. " viruses and junk items from your games!")
end
bool1 = true
