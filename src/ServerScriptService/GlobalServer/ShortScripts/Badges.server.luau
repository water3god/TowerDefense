--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BadgeService = game:GetService("BadgeService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local PlayerData = require(ServerScriptService.GlobalModules.PlayerData)

local BadgeData = {
	Welcome = 4381897908637819,
	Level10 = 3800543921660518,
	Level25 = 598657326040391,
	Level50 = 47866740261609,
	Level100 = 14518831314970,
}

local Levels = {
	Level10 = 10,
	Level25 = 25,
	Level50 = 50,
	Level100 = 100,
}

local Ids: { number } = HelperFunctions.ConvertDictToArrayWithValues(BadgeData)

local function HandleData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data
	local UserId = PData.Player.UserId

	local BadgeCache = {}

	local function CheckLevel()
		for BadgeName, BadgeId in pairs(BadgeData) do
			local Level = Data.Level
			if table.find(BadgeCache, BadgeId) then
				continue
			end
			local RequiredLevel = Levels[BadgeName]
			if RequiredLevel and Level >= RequiredLevel then
				BadgeService:AwardBadge(UserId, BadgeId)
				table.insert(BadgeCache, BadgeId)
			end
		end
	end

	Promise.try(function()
		return BadgeService:CheckUserBadgesAsync(UserId, Ids)
	end)
		:andThen(function(Badges: { number })
			BadgeCache = Badges
			local Promises = {}
			for BadgeName, BadgeId in pairs(BadgeData) do
				local NewPromise = Promise.try(function()
					if not table.find(Badges, BadgeId) then
						if BadgeName == "Welcome" then
							BadgeService:AwardBadge(UserId, BadgeId)
							table.insert(BadgeCache, BadgeId)
						else
							CheckLevel()
						end
					end
				end)

				table.insert(Promises, NewPromise)

				return Promise.all(Promises)
			end
		end)
		:catch(function(Err)
			warn("Error when checking/awarding badges: " .. Err)
		end)

	PData.LeveledUp:Connect(CheckLevel)
end

for _, PData in pairs(PlayerData.GetDatas()) do
	HandleData(PData)
end

PlayerData.DataAdded:Connect(HandleData)
