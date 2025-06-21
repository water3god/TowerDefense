--!strict

-- By Wa1er_God --

local RarityInfo = require(script.Parent.RarityInfo)

export type TotalUnitData = {
	[number]: UnitData,
}

export type UnitData = {
	Damage: { number },
	Coins: number?,
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
	Abilities: { { MinimumLevel: number, Name: string, Icon: string, Length: number, Cooldown: number } },
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
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Alexander The Great"] = {
		Rarity = "Mythic",
		Description = "A Scout",
		Image = "rbxassetid://123087615935684",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 2,
				Range = 10,
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
		Image = "rbxassetid://121547000533197",

		UnitData = {
			[0] = {
				Damage = { 100 },
				FireRate = 0.6,
				Range = 20,
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
		Image = "rbxassetid://106430561053468",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
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
		Image = "rbxassetid://122873675701138",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 10,
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
		Image = "rbxassetid://92733001424959",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Themistocles"] = {
		Rarity = "Legendary",
		Description = "A Scout",
		Image = "rbxassetid://101001750083065",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
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
		Image = "rbxassetid://123255834687209",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
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
		Image = "rbxassetid://117170171575136",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
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
		Image = "rbxassetid://129329108626021",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 0,
				Range = 0,
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
		Image = "rbxassetid://121520471894961",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 8,
				Armor = "SpartacusArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {
			{
				MinimumLevel = 0,
				BackgroundColor = ColorSequence.new(Color3.new(0.803922, 0.133333, 0.133333)),
				Cooldown = 30,
				Icon = "",
				Length = 10,
				Name = "Rage",
			},
		},
	},
	["Cicero"] = {
		Rarity = "Epic",
		Description = "A Scout",
		Image = "rbxassetid://73965035363559",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Augustus"] = {
		Rarity = "Mythic",
		Description = "A Scout",
		Image = "rbxassetid://117008785997390",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
				Armor = "AugustusArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["William the Conqueror"] = {
		Rarity = "Mythic",
		Description = "A Scout",
		Image = "rbxassetid://127237964660825",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1.5,
				Range = 5,
				Armor = "WilliamArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Robert the Bruce"] = {
		Rarity = "Common",
		Description = "A Scout",
		Image = "rbxassetid://118958489112206",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 5,
				Armor = "RobertArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Richard the Lionheart"] = {
		Rarity = "Godly",
		Description = "A Scout",
		Image = "rbxassetid://131934169872463",

		UnitData = {
			[0] = {
				Damage = { 10 },
				FireRate = 1.5,
				Range = 5,
				Armor = "RichardArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Charlemagne"] = {
		Rarity = "Epic",
		Description = "A Scout",
		Image = "rbxassetid://135616277878704",

		UnitData = {
			[0] = {
				Damage = { 10 },
				FireRate = 2,
				Range = 5,
				Armor = "CharlemagneArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Joan of Arc"] = {
		Rarity = "Legendary",
		Description = "A Scout",
		Image = "rbxassetid://108269486400086",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
				Armor = "JoanArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Leif Erikson"] = {
		Rarity = "Rare",
		Description = "A Scout",
		Image = "rbxassetid://111147011911639",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
				Armor = "LeifArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Ptolemy"] = {
		Rarity = "Common",
		Description = "A Scout",
		Image = "rbxassetid://84772192162069",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 3,
				Range = 5,
				Armor = "PtolemyArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Cleopatra"] = {
		Rarity = "Rare",
		Description = "A Scout",
		Image = "rbxassetid://137545520172915",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 2,
				Range = 5,
				Armor = "CleopatraArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Narmer"] = {
		Rarity = "Epic",
		Description = "A Scout",
		Image = "rbxassetid://123302243147194",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 2,
				Range = 5,
				Armor = "NarmerArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Akhenaten"] = {
		Rarity = "Legendary",
		Description = "A Scout",
		Image = "rbxassetid://140319991588251",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Ramesses II"] = {
		Rarity = "Mythic",
		Description = "A Scout",
		Image = "rbxassetid://115676624628103",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 2,
				Range = 5,
				Armor = "RamessesArmor",
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Tutankhamun"] = {
		Rarity = "Godly",
		Description = "A Scout",
		Image = "rbxassetid://127377869922808",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 5,
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
local StatProperties = { "Damage", "Range", "FireRate", "Coins", "Specials" }

local Icons: { [StatProperty]: string } = {
	Damage = "rbxassetid://116153831042938",
	FireRate = "rbxassetid://117289508099114",
	Range = "rbxassetid://95171919754669",
	Coins = "rbxassetid://72304165589077",
	Specials = "rbxassetid://134876951462162",
}

local Colors: { [StatProperty]: Color3 } = {
	Damage = Color3.new(0.772549, 0.109804, 0.109804),
	FireRate = Color3.new(0.113725, 0.247059, 0.784314),
	Range = Color3.new(0.749020, 0.843137, 0.133333),
	Coins = Color3.new(0.105882, 0.47451, 0.231373),
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
