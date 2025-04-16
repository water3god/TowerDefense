--!strict

-- By Wa1er_God --

local RarityInfo = require(script.Parent.RarityInfo)

export type UnitInfo = {
	Rarity: RarityInfo.Rarity,
	Description: string,
	PlacementCost: number,
}

local Data = {}

local UnitInfo: { [string]: UnitInfo } = {
	["BLANK"] = {
		Rarity = "BLANK",
		Description = "NIL",
		PlacementCost = 0,
	},
	["Scout"] = {
		Rarity = "Common",
		Description = "A Scout",
		PlacementCost = 10,
	},
	["Shocker"] = {
		Rarity = "Common",
		Description = "A Shocker",
		PlacementCost = 10,
	},
	["Sniper"] = {
		Rarity = "Rare",
		Description = "A Damage dealer Sniper",
		PlacementCost = 10,
	},
	["Shotgunner"] = {
		Rarity = "Epic",
		Description = "A DamageDealer",
		PlacementCost = 10,
	},
	["Minigunner"] = {
		Rarity = "Legendary",
		Description = "A Minigunner from the depths",
		PlacementCost = 10,
	},
}

export type LevelInfo = {
	MainColor: ColorSequence,
	StrokeColor: ColorSequence,
}

local LevelInfo: { [number]: LevelInfo } = {
	[1] = {
		MainColor = ColorSequence.new(Color3.new(1, 1, 1)),
		StrokeColor = ColorSequence.new(Color3.new()),
	},
}

Data.UnitInfo = UnitInfo
Data.LevelInfo = LevelInfo

return Data
