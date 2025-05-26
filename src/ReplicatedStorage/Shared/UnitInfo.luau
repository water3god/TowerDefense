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
	Abilities: { { Name: string, Length: number, Cooldown: number } },
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
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Alexander The Great"] = {
		Rarity = "Mythic",
		Description = "A Scout",
		Image = "rbxassetid://76818408729348",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "AlexanderArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Leonidas"] = {
		Rarity = "Godly",
		Description = "A Scout",
		Image = "rbxassetid://128751657366626",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "LeonidasArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pericles"] = {
		Rarity = "Epic",
		Description = "A Scout",
		Image = "rbxassetid://111308279380468",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "PericlesArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pyrrhus"] = {
		Rarity = "Common",
		Description = "A Scout",
		Image = "rbxassetid://100404690417654",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "PyrrhusArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Socrates"] = {
		Rarity = "Rare",
		Description = "A Scout",
		Image = "rbxassetid://131020680622418",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Themistocles"] = {
		Rarity = "Legendary",
		Description = "A Scout",
		Image = "rbxassetid://110018750391246",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "ThemistoclesArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Julius Caesar"] = {
		Rarity = "Legendary",
		Description = "A Scout",
		Image = "rbxassetid://121449132209175",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "JuliusCaesarArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pompey"] = {
		Rarity = "Common",
		Description = "A Scout",
		Image = "rbxassetid://135071065213924",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "PompeyArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Trajan"] = {
		Rarity = "Godly",
		Description = "A Scout",
		Image = "rbxassetid://71882576147189",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "TrajanArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Spartacus"] = {
		Rarity = "Rare",
		Description = "A Scout",
		Image = "rbxassetid://98986641918249",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Armor = "SpartacusArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Cicero"] = {
		Rarity = "Epic",
		Description = "A Scout",
		Image = "rbxassetid://117293946766765",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Augustus"] = {
		Rarity = "Mythic",
		Description = "A Scout",
		Image = "rbxassetid://73951067640481",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Animations = {},
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
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
