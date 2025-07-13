--!strict

-- By Wa1er_God --

-- Services --

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
			Name = "Play for 30 Minutes",
			Description = "Play for 30 minutes to earn rewards.",
			Data = { Type = "Minutes" } :: PlayTimeData,
			CurrentValue = 0,
			NeededValue = 30,
			Redeemed = false,
			QuestReward = { Type = "Resource", Value = "Gold", Count = 100 },
		},
	}),
	WeeklyQuests = table.freeze({}),
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
