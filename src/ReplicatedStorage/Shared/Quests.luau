--!strict

-- By Wa1er_God --

-- Services --

export type QuestType = "Kill" | "Playtime" | "Leaderboard" | "Resource"
export type RewardType = "Title" | "Resource" | "Product" | "Unit"

export type QuestReward = {
	Type: RewardType,
	Value: string,
	Count: number,
}

-- Quest Types Data --

export type PlayTimeData = {
	Type: "Seconds" | "Minutes" | "Hours" | "Days",
	Seconds: number,
}

-- Quests Data --

export type QuestData<T> = {
	Type: QuestType,
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
	},
}

export type QuestRemoteInfo = {
	Id: string,
	Data: unknown,
	CurrentValue: number,
	Redeemed: boolean,
}

local Quests: Quests = {
	DailyQuests = table.freeze({}),
	WeeklyQuests = table.freeze({}),
	EventQuests = table.freeze({}),
	GlobalQuests = table.freeze({}),
	MetaData = {
		DailyRegenerated = 0,
		WeeklyRegenerated = 0,
	},
}

return {
	Quests = Quests,
	QuestsOnly = {
		DailyQuests = Quests.DailyQuests,
		WeeklyQuests = Quests.WeeklyQuests,
		EventQuests = Quests.EventQuests,
	} :: { [string]: { DefaultQuestData } },
}
