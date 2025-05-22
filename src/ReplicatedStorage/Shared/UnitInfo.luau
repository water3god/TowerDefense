--!strict

-- By Wa1er_God --

local RarityInfo = require(script.Parent.RarityInfo)

export type TotalUnitData = {
	[number]: UnitData,
}

export type UnitData = {
	Damage: { number },
	FireRate: number,
	Range: number,
	Armor: string?,
	Cost: number,
}

export type UnitInfo = {
	Rarity: RarityInfo.Rarity,
	Description: string,
	Image: string?,

	UnitData: TotalUnitData,
	Vector3Offset: Vector3?,
	ViewportOffset: CFrame?,
	CollisionRadius: number,
	Abilties: { { Name: string, Length: number, Cooldown: number } },
}

local Data = {}

local UnitInfo: { [string]: UnitInfo } = {
	["BLANK"] = {
		Rarity = "BLANK",
		Description = "NIL",
		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "Armor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilties = {},
	},
	["Scout"] = {
		Rarity = "Common",
		Description = "A Scout",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "Armor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilties = {},
	},
	["Shocker"] = {
		Rarity = "Common",
		Description = "A Shocker",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "Armor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilties = {},
	},
	["Sniper"] = {
		Rarity = "Rare",
		Description = "A Damage dealer Sniper",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "Armor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilties = {},
	},
	["Shotgunner"] = {
		Rarity = "Epic",
		Description = "A DamageDealer",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "Armor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilties = {},
	},
	["Minigunner"] = {
		Rarity = "Legendary",
		Description = "A Minigunner from the depths",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "Armor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilties = {},
	},
}

export type SortType = "First" | "Last" | "Strongest" | "Weakest"
Data.SortTypes = { "First", "Last", "Strongest", "Weakest" }

function Data.GetNextSortType(SortType: SortType | string)
	local Index = table.find(Data.SortTypes, SortType)

	if Index then
		if Index >= #Data.SortTypes then
			return Data.SortTypes[1]
		else
			return Data.SortTypes[Index + 1]
		end
	else
		return Data.SortTypes[1]
	end
end

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

local function CalculateTotalCost(UpgradeData: TotalUnitData, GivenLevel: number)
	local TotalCost = 0

	for Level, Info in pairs(UpgradeData) do
		if Level >= GivenLevel then
			TotalCost += Info.Cost
		end
	end

	return TotalCost
end

local Stats = {}

export type StatProperty = "Damage" | "Range" | "FireRate" | "Specials"
local StatProperties = { "Damage", "Range", "FireRate", "Specials" }

local Icons: { [StatProperty]: string } = {
	Damage = "rbxassetid://116153831042938",
	FireRate = "rbxassetid://117289508099114",
	Range = "rbxassetid://95171919754669",
	Specials = "rbxassetid://134876951462162",
}

local Colors: { [StatProperty]: Color3 } = {
	Damage = Color3.new(0.772549, 0.109804, 0.109804),
	FireRate = Color3.new(0.113725, 0.247059, 0.784314),
	Range = Color3.new(0.749020, 0.843137, 0.133333),
	Specials = Color3.new(0.921569, 0.600000, 0.149020),
}

local Layout: { [StatProperty]: number } = {
	Damage = 1,
	FireRate = 2,
	Range = 3,
	Specials = 4,
}

Stats.StatProperties = StatProperties
Stats.Icons = Icons
Stats.Colors = Colors
Stats.Layout = Layout

Data.Stats = Stats

Data.UnitInfo = UnitInfo
Data.LevelInfo = LevelInfo
Data.CalculateTotalCost = CalculateTotalCost

return Data
