--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Quests = require(Shared.Quests)
local Settings = require(Shared.Settings)
export type UnitData = {
	Unit: string,
	Level: number,
	UniqueId: string,
	XP: number,
	NeededXP: number,
}

export type ProductData = {
	ProductId: number,
	IsGamepass: boolean,
	Count: number,
	UniqueId: string,
}

export type ResourceData = {
	Resource: string,
	Count: number,
	UniqueId: string,
	PartialOneLose: boolean?,
}

export type StageData = {
	FastestTime: number,
	FinishedCount: number,
}

export type Data = {
	EquippedUnits: { string },
	Units: {
		[string]: UnitData,
	},
	Gamepasses: { number },
	CachedProducts: { [number]: number },
	Products: {
		[string]: ProductData,
	},
	Resources: {
		[string]: ResourceData,
	},
	CompletedMaps: { [string]: { [number]: { [string]: StageData } } }, -- MapId, Index, Difficulty, StageData
	Level: number,
	XP: number,
	RollCount: number,
	Settings: { [Settings.Setting]: any },
	RobuxSpent: number,
	Gold: number,
	TotalGoldGained: number,
	TotalDamageDone: number,
	MaxUnitCount: number,
	DailyData: {
		Day: number,
		LastRedeemed: number,
	},
	EquippedTitle: string,
	Titles: { string },
	LeaderboardData: { [string]: number },
	Quests: Quests.Quests,
	QuestData: Quests.TotalPlayerData,
}

local Data: Data = {
	EquippedUnits = {},
	Units = {},
	Gamepasses = {},
	CachedProducts = {},
	Products = {},
	Resources = {},
	Settings = Settings.Default,
	CompletedMaps = {},
	Level = 1,
	XP = 0,
	RollCount = 0,
	RobuxSpent = 0,
	Gold = 80,
	TotalGoldGained = 80,
	TotalDamageDone = 0,
	MaxUnitCount = 100,
	DailyData = {
		Day = 1,
		LastRedeemed = 0,
	},
	EquippedTitle = "Player",
	Titles = { "Player" },
	LeaderboardData = {},
	Quests = Quests.Quests,
	QuestData = Quests.QuestPlayerData,
}

return Data
