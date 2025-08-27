--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

export type QuestType =
	"Kills"
	| "DamageByUnit"
	| "Playtime"
	| "Leaderboard"
	| "Resources"
	| "Damage"
	| "Wins"
	| "Map"
	| "MapStage"
	| "Level"
	| "RobuxSpent"
	| "Summon"
	| "EnemyKills"

export type RewardType = "Title" | "Resource" | "Product" | "Unit"

export type QuestSubs = "DailyQuests" | "WeeklyQuests" | "EventQuests" | "GlobalQuests"

export type QuestReward = {
	Type: RewardType | string,
	Value: string,
	Count: number,
}

-- Quest Types Data --

export type PlayTimeData = {
	Type: "Seconds" | "Minutes" | "Hours" | "Days",
}

export type LeaderboardData = {
	LeaderboardName: string,
	Position: number,
}

export type ResourceData = {
	Resource: string,
}

export type DamageByUnitData = {
	UnitName: string,
}

export type KillsByUnitData = {
	UnitName: string,
}

export type BossKillData = {
	BossName: string,
}

export type MapData = {
	MapName: string,
}

export type MapStageData = {
	MapName: string,
	Stage: number,
}

export type EnemyKillData = {
	EnemyName: string,
}

-- Quests Data --

export type QuestData<T> = {
	Type: QuestType | string,
	Id: string, -- Has To Be Unique --
	Name: string,
	Description: string,
	Data: T,
	CurrentValue: number,
	NeededValue: number,
	Redeemed: boolean,
	QuestReward: QuestReward,
}

export type DefaultQuestData = QuestData<unknown>

export type QuestSubType = { DefaultQuestData }

export type Quests = {
	DailyQuests: QuestSubType,
	WeeklyQuests: QuestSubType,
	EventQuests: QuestSubType,
	GlobalQuests: QuestSubType,
	MetaData: {
		DailyRegenerated: number,
		WeeklyRegenerated: number,
		CurrentEvent: string,
	},
}

export type QuestRemoteInfo = {
	Id: string,
	Data: unknown,
	CurrentValue: number,
	Redeemed: boolean,
}

export type QuestPlayerData = {
	Kills: number,
	DamageByUnit: { [string]: number },
	Resources: { [string]: number },
	Leaderboard: { [string]: number },
	Playtime: number,
	-- Maps (in DataStore) --
	Damage: number,
	Wins: number,
	RobuxSpent: number,
	Summon: number,
	EnemyKills: { [string]: number },
}

local DefaultQuestPlayerData: QuestPlayerData = {
	Kills = 0,
	DamageByUnit = {},
	Resources = {},
	Leaderboard = {},
	Playtime = 0,
	Damage = 0,
	Wins = 0,
	RobuxSpent = 0,
	Summon = 0,
	EnemyKills = {},
}

export type TotalPlayerData = {
	DailyQuests: QuestPlayerData,
	WeeklyQuests: QuestPlayerData,
	EventQuests: QuestPlayerData,
	GlobalQuests: QuestPlayerData,
}

local Quests: Quests = {
	DailyQuests = table.freeze({
		{
			Type = "Playtime",
			Id = "Daily_Playtime_1",
			Name = "Play for 1 Hour",
			Description = "Play for 1 Hour to earn rewards.",
			Data = { Type = "Hours" } :: any,
			CurrentValue = 0,
			NeededValue = 3600,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Gold", Count = 100 },
		},
		{
			Type = "Damage",
			Id = "Daily_Damage_1",
			Name = "Deal 2500 Damage",
			Description = "Deal 2500 Damage to enemies to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 2500,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Fighter", Count = 1 },
		},
		{
			Type = "Damage",
			Id = "Daily_Damage_2",
			Name = "Deal 5000 Damage",
			Description = "Deal 5000 Damage to enemies to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 5000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Veteran", Count = 1 },
		},
		{
			Type = "Damage",
			Id = "Daily_Damage_3",
			Name = "Deal 10000 Damage",
			Description = "Deal 10000 Damage to enemies to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 1000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Furious", Count = 1 },
		},
		{
			Type = "Wins",
			Id = "Daily_Wins_1",
			Name = "Win 1 Game",
			Description = "Win 1 Game to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 1,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Rookie", Count = 1 },
		},
		{
			Type = "Kills",
			Id = "Daily_Playtime_1",
			Name = "Eliminate 50",
			Description = "Eliminate 50 enemies for rewards.",
			Data = { Type = "Hours" } :: any,
			CurrentValue = 0,
			NeededValue = 50,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Gold", Count = 184 },
		},
		{
			Type = "Kills",
			Id = "Daily_Playtime_1",
			Name = "Eliminate 100",
			Description = "Eliminate 100 enemies for rewards.",
			Data = { Type = "Hours" } :: any,
			CurrentValue = 0,
			NeededValue = 50,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Omen Coins", Count = 5 },
		},
		{
			Type = "MapStage",
			Id = "Daily_MapStage_1",
			Name = "Infinite mode",
			Description = "Play Infinite mode for the first time.",
			Data = { Type = "Hours" } :: any,
			CurrentValue = 0,
			NeededValue = 1,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Wave Defender", Count = 5 },
		},
	}),
	WeeklyQuests = table.freeze({
		{
			Type = "Kills",
			Id = "Weekly_Kills_1",
			Name = "Slayer",
			Description = "Kill 10K Enemies to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 10000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Slayer", Count = 1 },
		},
		{
			Type = "Kills",
			Id = "Weekly_Kills_2",
			Name = "Theif",
			Description = "Deal 1000 Damage in total on enemies.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 10000,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Gold", Count = 284 },
		},
		{
			Type = "Damage",
			Id = "Weekly_Kills_3",
			Name = "Hitlist",
			Description = "Execute 25k enemies.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 25000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Executer", Count = 1 },
		},
		{
			Type = "Damage",
			Id = "Weekly_Kills_4",
			Name = "Atrocity",
			Description = "Eradicate 50k enemies.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 50000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Eradicator", Count = 1 },
		},
		{
			Type = "Damage",
			Id = "Weekly_Kills_5",
			Name = "Havoc",
			Description = "Annahilate 100k Enemies.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 100000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Annahilator", Count = 1 },
		},
		{
			Type = "Summon",
			Id = "Weekly_Summon_1",
			Name = "Advanced Summoner",
			Description = "Summon 100 units.",
			Data = {} :: any,
			CurrentValue = 0,

			NeededValue = 100,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Advanced Summoner", Count = 1 },
		},
		{
			Type = "Win",
			Id = "Weekly_Win_1",
			Name = "Win 5 Games",
			Description = "Win 5 Games to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 5,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Competitor", Count = 1 },
		},
	}),
	EventQuests = table.freeze({}),
	GlobalQuests = table.freeze({
		{
			Type = "Playtime",
			Id = "Global_Playtime_1",
			Name = "Play for 10 Hours",
			Description = "Play for 10 hours to earn rewards.",
			Data = { Type = "Hours" } :: PlayTimeData,
			CurrentValue = 0,
			NeededValue = 36000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Player", Count = 1 },
		},
		{
			Type = "Robux Spent",
			Id = "Global_Robux_Spent_1",
			Name = "Spend 1000 Robux",
			Description = "Spend 1000 Robux to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 1000,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Gold", Count = 5000 },
		},
		{
			Type = "Robux Spent 2",
			Id = "Global_Robux_Spent_2",
			Name = "Money Spender",
			Description = "Spend 2000 Robux to earn rewards.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 2000,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Gold", Count = 10000 },
		},
		{
			Type = "Kills",
			Id = "Global_Kills_1",
			Name = "Destroyer Of Worlds",
			Description = "Delete 1 Million Enemies.",
			Data = {} :: any,
			CurrentValue = 0,
			NeededValue = 1000000,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "Destroyer Of Worlds", Count = 1 },
		},
		{
			Type = "Leaderboard",
			Id = "Global_Leaderboard_1",
			Name = "Top 100",
			Description = "Reach Top 100 in the Damage Leaderboard.",
			Data = { LeaderboardName = Constants.DamageStore, Position = 100 } :: any,
			CurrentValue = 0,
			NeededValue = 100,
			Redeemed = false,
			QuestReward = { Type = "Title", Value = "TOP 100", Count = 1 },
		},
	}),
	MetaData = {
		DailyRegenerated = 0,
		WeeklyRegenerated = 0,
		CurrentEvent = "None",
	},
}

local ValidFunctions: { [string]: (QuestData: QuestData<any>, ExtraData: { [any]: any }) -> boolean } = {
	Leaderboard = function(QuestData: QuestData<LeaderboardData>, ExtraData: { [any]: any })
		return ExtraData.LeaderboardName == QuestData.Data.LeaderboardName
			and ExtraData.Position <= QuestData.Data.Position
	end,
	DamageByUnit = function(QuestData: QuestData<DamageByUnitData>, ExtraData: { [any]: any })
		return ExtraData.UnitName == QuestData.Data.UnitName
	end,
	Map = function(QuestData: QuestData<MapData>, ExtraData: { [any]: any })
		return ExtraData.MapName == QuestData.Data.MapName
	end,
	MapStage = function(QuestData: QuestData<MapStageData>, ExtraData: { [any]: any })
		return ExtraData.MapName == QuestData.Data.MapName and ExtraData.Stage >= QuestData.Data.Stage
	end,
	Resource = function(QuestData: QuestData<ResourceData>, ExtraData: { [any]: any })
		return ExtraData.Resource == QuestData.Data.Resource
	end,
	EnemyKills = function(QuestData: QuestData<EnemyKillData>, ExtraData: { [any]: any })
		return ExtraData.EnemyName == QuestData.Data.EnemyName
	end,
}

return {
	Quests = Quests,
	QuestsOnly = {
		DailyQuests = Quests.DailyQuests,
		WeeklyQuests = Quests.WeeklyQuests,
		EventQuests = Quests.EventQuests,
		GlobalQuests = Quests.GlobalQuests,
	} :: { [string]: { DefaultQuestData } },
	QuestPlayerData = {
		DailyQuests = DefaultQuestPlayerData,
		WeeklyQuests = DefaultQuestPlayerData,
		EventQuests = DefaultQuestPlayerData,
		GlobalQuests = DefaultQuestPlayerData,
	} :: TotalPlayerData,
	ValidFunctions = ValidFunctions,
}
