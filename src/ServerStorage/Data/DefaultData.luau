--!strict

local Settings = require(game:GetService("ReplicatedStorage").Shared.Settings)

export type UnitData = {
	Unit: string,
	Level: number,
	UniqueId: string,
	XP: number,
	NeededXP: number,
}

export type ProductData = {
	ProductId: number,
	Name: string,
	IsGamepass: boolean,
	Count: number,
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
	Gamepasses: { number },
	Products: {
		[string]: ProductData,
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
	RobuxSpent: number,
	Gold: number,
	TotalGoldGained: number,
}

local Data: Data = {
	EquippedUnits = {},
	Units = {},
	Gamepasses = {},
	Products = {},
	Resources = {},
	Settings = Settings.Default,
	AutoRoll = false,
	CompletedMaps = {},
	Level = 1,
	XP = 0,
	RollCount = 0,
	RobuxSpent = 0,
	Gold = 80,
	TotalGoldGained = 80,
}

return Data
