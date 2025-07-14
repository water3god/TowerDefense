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
local Difficulty = { "Normal", "Hard", "Insane" }

export type RewardInfo = { Units: { string }, Resources: { Types.RewardData } }

export type LevelInfo = {
	Name: string,
	GameId: string,
	Index: number, --7 is infinite
	XPMultiplier: number, -- normal XP is multiplied and given to player
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
	Image: string,
	Prerequisite: string?,
	LevelInfo: { LevelInfo },
}

local Data = {}

local GameInfo: { MapInfo } = {
	{
		MapId = "Egypt",
		Name = "Egypt",
		Image = "rbxassetid://137415330481106",
		LevelInfo = {
			{
				Name = "Desert Reconnaissance",
				GameId = "AncientEgypt_DesertReconnaissance",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 120, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 250, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "Arrow Barrage",
				GameId = "AncientEgypt_ArrowBarrage",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 60, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 140, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 280, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "Shielded Formation",
				GameId = "AncientEgypt_ShieldedFormation",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 70, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 160, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 320, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "Chariot Assault",
				GameId = "AncientEgypt_ChariotAssault",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 80, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 180, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 360, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "Sacred Ritual",
				GameId = "AncientEgypt_SacredRitual",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 90, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 400, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "Final Defense",
				GameId = "AncientEgypt_FinalDefense",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 220, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 440, UniqueId = "" },
						},
					},
				},
			},
		},
	},
	{
		MapId = "Greece",
		Name = "Greece",
		Image = "rbxassetid://87671289193280",
		LevelInfo = {
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
		},
		Prerequisite = "Egypt",
	},
	{
		MapId = "Rome",
		Name = "Rome",
		Image = "rbxassetid://81260716481225",
		LevelInfo = {
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
		},
		Prerequisite = "Greece",
	},
	{
		MapId = "China",
		Name = "China",
		Image = "rbxassetid://96878463422313",
		LevelInfo = {
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
		},
		Prerequisite = "Rome",
	},
	{
		MapId = "Medieval",
		Name = "Medieval",
		Image = "rbxassetid://74203135188399",
		LevelInfo = {
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
			{
				Name = "The Flood",
				GameId = "Hastingsv1",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 50, UniqueId = "" },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 100, UniqueId = "" },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200, UniqueId = "" },
						},
					},
				},
			},
		},
		Prerequisite = "China",
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

function Data.GetDifficultyString(DifficultyInput: string)
	local Color = Colors[DifficultyInput]
	return string.format('Difficulty: <font color = "#%s">%s</font>', Color:ToHex(), DifficultyInput)
end

return Data
