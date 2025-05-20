--!strict

-- By Wa1er_God --

--[[

player joins in, can select who he he wants to play with in story mode. Also, in the new infinite mode,
it rotates between maps, they should have health depending on the stage in infinite mode. ALL of these gives boosts,
which are temporary boosts that give you a higher chance of getting somthing rare for a certain amount of time. There
are some boosts that grant certain units a higher chance of obtaining it. Infinite Mode is locked until player is level
5. Levels give you a higher chance of obtaining units.

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)
local RarityInfo = require(Shared.RarityInfo)

export type Difficulty = "Normal" | "Hard" | "Insane"
local Difficulty = { "Normal", "Hard", "Hard" }

export type RewardInfo = { Units: { string }, Resources: { Types.RewardData } }

export type LevelInfo = {
	Name: string,
	GameId: string,
	Index: number, --7 is infinite
	XPMultiplier: number,
	Prerequisite: { Map: string, Index: number }?,
	RewardInfo: { [Difficulty | string]: RewardInfo },
}

export type ResourceData = {
	Units: { string },
	Resources: { { Resource: string, Count: number } },
	ExistingUnits: { { Name: string, OldLevel: number, NewLevel: number, OldXP: number, NewXP: number } },
}

export type MapInfo = {
	Name: string,
	MapId: string,
	LevelInfo: { LevelInfo },
	Image: string,
	Prerequisite: string?,
}

local Data = {}

local GameInfo: { MapInfo } = {
	{
		Name = "Battle of Hastings",
		MapId = "BattleOfHastings",
		LevelInfo = {
			{
				Name = "Hastings1",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 3, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 3, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 3, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "Hastings2",
				GameId = "Hastingsv2",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 3, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {},
					},
					Insane = {
						Units = {},
						Resources = {},
					},
				},
			},
			{
				Name = "Hastings3",
				GameId = "Hastingsv3",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {},
					},
					Hard = {
						Units = {},
						Resources = {},
					},
					Insane = {
						Units = {},
						Resources = {},
					},
				},
			},
			{
				Name = "Hastings4",
				GameId = "Hastingsv4",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {},
					},
					Hard = {
						Units = {},
						Resources = {},
					},
					Insane = {
						Units = {},
						Resources = {},
					},
				},
			},
			{
				Name = "Hastings5",
				GameId = "Hastingsv5",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {},
					},
					Hard = {
						Units = {},
						Resources = {},
					},
					Insane = {
						Units = {},
						Resources = {},
					},
				},
			},
		},
		Image = "rbxassetid://136581013754707",
		Prerequisite = nil,
	},
}

export type RewardData = {
	Image: string,
	Rarity: RarityInfo.Rarity | string,
}

local RewardInfo: { [string]: RewardData } = {
	["Gold"] = {
		Image = "rbxassetid://123591871678972",
		Rarity = "Common",
	},
}

local Colors: { [string]: Color3 } = {
	Normal = Color3.fromRGB(88, 226, 65),
	Hard = Color3.fromRGB(224, 47, 57),
	Insane = Color3.fromRGB(187, 85, 211),
}

Data.Difficulty = Difficulty
Data.GameInfo = GameInfo
Data.RewardInfo = RewardInfo

local XPData = {}

XPData.UnitMaxLevel = 100

local UnitXPCache = {}
local PlayerXPCache = {}

function XPData.CalculateUnitXP(Level: number)
	local Multiplier = 1.04
	local BaseXP = 100

	if UnitXPCache[Level] then
		return UnitXPCache[Level]
	end

	local Value = math.round(BaseXP * math.pow(Multiplier, Level))
	UnitXPCache[Level] = Value
	return Value
end

function XPData.CalculatePlayerXP(Level: number)
	local Multiplier = 1.03
	local BaseXP = 100

	if PlayerXPCache[Level] then
		return PlayerXPCache[Level]
	end

	local Value = math.round(BaseXP * math.pow(Multiplier, Level))
	PlayerXPCache[Level] = Value

	return Value
end

Data.XPData = XPData

function Data.GetMapFromId(MapId: string): MapInfo?
	for _, Item in ipairs(GameInfo) do
		if Item.MapId == MapId then
			return Item
		end
	end

	return
end

function Data.GetDataFromInfo(MapId: string, LevelId: string): (MapInfo?, LevelInfo?)
	local MapInfo = Data.GetMapFromId(MapId)

	if MapInfo then
		for _, Info in ipairs(MapInfo.LevelInfo) do
			if Info.GameId == LevelId then
				return MapInfo, Info
			end
		end
	end

	return
end

function Data.GetFullName(MapName: string, Index: number, LevelName: string)
	return string.format("%s: %u - %s", MapName, Index, LevelName)
end

function Data.GetDifficultyString(Difficulty: string)
	local Color = Colors[Difficulty]
	return string.format('Difficulty: <font color = "#%s">%s</font>', Color:ToHex(), Difficulty)
end

return Data
