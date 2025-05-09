--!strict

local Settings = require(game:GetService("ReplicatedStorage").Shared.Settings)

export type UnitData = {
	Unit: string,
	Level: number,
	UniqueId: string,
	XP: number,
	NeededXP: number,
}

export type GamepassData = {
	Gamepass: string,
	UniqueId: string,
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
	Gamepasses: {
		[string]: GamepassData,
	},
	CompletedMaps: { [string]: { [number]: { [string]: StageData } } },
	Level: number,
	XP: number,
	RollCount: number,
	Settings: { [Settings.Setting]: any },
	Coins: number,
}

local Data: Data = {
	EquippedUnits = {},
	Units = {},
	Settings = {
		Music = true,
		MusicVolume = 1,
		AutoRoll = false,
		RollFrameLeft = true,
		CommonSkip = false,
		RareSkip = false,
		EpicSkip = false,
		LegendarySkip = false,
		MythicSkip = false,
		CanTrade = true,
	},
	CompletedMaps = {},
	Level = 1,
	XP = 0,
	RollCount = 0,
	Gamepasses = {},
	Coins = 0,
}

return Data
