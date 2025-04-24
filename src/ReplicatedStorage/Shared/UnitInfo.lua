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

Data.UnitInfo = UnitInfo
Data.LevelInfo = LevelInfo
Data.CalculateTotalCost = CalculateTotalCost

return Data
