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

export type ResourceData = {
	Resource: string,
	Count: number,
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
	Resources: {
		[string]: ResourceData,
	},
	AutoRoll: boolean,
	CompletedMaps: { [string]: { [number]: { [string]: StageData } } },
	Level: number,
	XP: number,
	RollCount: number,
	Settings: { [Settings.Setting]: any },
	Gold: number,
}

local Data: Data = {
	EquippedUnits = {},
	Units = {},
	Gamepasses = {},
	Resources = {},
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
	AutoRoll = false,
	CompletedMaps = {},
	Level = 1,
	XP = 0,
	RollCount = 0,
	Gold = 0,
}

return Data
