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
	Cost: number,
	Special: string?,
}

export type UnitInfo = {
	Rarity: RarityInfo.Rarity,
	Description: string,
	Image: string?,

	UnitData: TotalUnitData,
	Vector3Offset: Vector3?,
	ViewportOffset: CFrame?,
	CollisionRadius: number,
	Static: boolean?,
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
		Description = "Powerful single-target fighter; delivers timed strikes to priority enemies.",
		Image = "rbxassetid://88336644068695",

		UnitData = {
			[0] = {
				Damage = { 75 },
				FireRate = 2,
				Range = 15,
				Cost = 200,
			},
			[1] = {
				Damage = { 125 },
				FireRate = 1.7,
				Range = 17,
				Cost = 265,
			},
			[2] = {
				Damage = { 280 },
				FireRate = 1.5,
				Range = 17,
				Cost = 700,
			},
			[3] = {
				Damage = { 500 },
				FireRate = 1.4,
				Range = 18,
				Cost = 1500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Leonidas"] = {
		Rarity = "Godly",
		Description = "Frontline melee; consistent single-target hits with solid stats.",
		Image = "rbxassetid://90542218956315",

		UnitData = {
			[0] = {
				Damage = { 300 },
				FireRate = 2,
				Range = 15,
				Cost = 540,
			},
			[1] = {
				Damage = { 700 },
				FireRate = 1.9,
				Range = 18,
				Cost = 750,
			},
			[2] = {
				Damage = { 1200 },
				FireRate = 1.7,
				Range = 20,
				Cost = 1000,
			},
			[3] = {
				Damage = { 2000 },
				FireRate = 1.5,
				Range = 23,
				Cost = 1700,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pericles"] = {
		Rarity = "Epic",
		Description = "Support aura (Damage): passively increases nearby allies' damage.",
		Image = "rbxassetid://106430561053468",

		UnitData = {
			[0] = {
				Damage = { 1.05 },
				FireRate = 0,
				Range = 12,
				Cost = 200,
			},
			[1] = {
				Damage = { 1.1 },
				FireRate = 0,
				Range = 13,
				Cost = 375,
			},
			[2] = {
				Damage = { 1.2 },
				FireRate = 0,
				Range = 15,
				Cost = 600,
			},
			[3] = {
				Damage = { 1.3 },
				FireRate = 0,
				Range = 18,
				Cost = 1000,
			},
		},
		CollisionRadius = 3,
		Static = true,
		Abilities = {},
	},
	["Pyrrhus"] = {
		Rarity = "Common",
		Description = "Reliable single-target melee; straightforward damage dealer.",
		Image = "rbxassetid://112207752049885",

		UnitData = {
			[0] = {
				Damage = { 4 },
				FireRate = 1,
				Range = 14,
				Cost = 125,
			},
			[1] = {
				Damage = { 8 },
				FireRate = 1,
				Range = 16,
				Cost = 200,
			},
			[2] = {
				Damage = { 14 },
				FireRate = 0.8,
				Range = 18,
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Socrates"] = {
		Rarity = "Rare",
		Description = "Economy unit: generates coins every wave (does not attack).",
		Image = "rbxassetid://92733001424959",

		UnitData = {
			[0] = {
				Damage = { 0 },
				Coins = 30,
				FireRate = 0,
				Range = 5,
				Cost = 130,
			},
			[1] = {
				Damage = { 0 },
				Coins = 60,
				FireRate = 0,
				Range = 5,
				Cost = 130,
			},
			[2] = {
				Damage = { 0 },
				Coins = 120,
				FireRate = 0,
				Range = 5,
				Cost = 250,
			},
			[3] = {
				Damage = { 0 },
				Coins = 250,
				FireRate = 0,
				Range = 5,
				Cost = 600,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Themistocles"] = {
		Rarity = "Legendary",
		Description = "Support aura (Range): passively increases nearby allies' range.",
		Image = "rbxassetid://101001750083065",

		UnitData = {
			[0] = {
				Damage = { 1.1 },
				FireRate = 0,
				Range = 5,
				Cost = 300,
			},
			[1] = {
				Damage = { 1.15 },
				FireRate = 0,
				Range = 5,
				Cost = 400,
			},
			[2] = {
				Damage = { 1.2 },
				FireRate = 0,
				Range = 5,
				Cost = 800,
			},
			[3] = {
				Damage = { 1.3 },
				FireRate = 0,
				Range = 5,
				Cost = 1200,
			},
		},
		CollisionRadius = 3,
		Static = true,
		Abilities = {},
	},
	["Julius Caesar"] = {
		Rarity = "Legendary",
		Description = "Fast single-target melee; quick, precise strikes.",
		Image = "rbxassetid://96743852473893",

		UnitData = {
			[0] = {
				Damage = { 30 },
				FireRate = 0.6,
				Range = 13,
				Cost = 115,
			},
			[1] = {
				Damage = { 80 },
				FireRate = 0.5,
				Range = 13,
				Cost = 250,
			},
			[2] = {
				Damage = { 120 },
				FireRate = 0.4,
				Range = 15,
				Cost = 300,
			},
			[3] = {
				Damage = { 200 },
				FireRate = 0.4,
				Range = 15,
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pompey"] = {
		Rarity = "Common",
		Description = "Ranged archer: fires traveling arrows at distant targets.",
		Image = "rbxassetid://99439817623832",

		UnitData = {
			[0] = {
				Damage = { 1 },
				FireRate = 1.5,
				Range = 40,
				Cost = 75,
			},
			[1] = {
				Damage = { 3 },
				FireRate = 1.5,
				Range = 40,
				Cost = 150,
			},
			[2] = {
				Damage = { 7 },
				FireRate = 1.25,
				Range = 45,
				Cost = 300,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Trajan"] = {
		Rarity = "Godly",
		Description = "Summoner: periodically summons Legionaries to fight alongside him.",
		Image = "rbxassetid://97945746294799",
		UnitData = {
			[0] = {
				Damage = { 800 },
				FireRate = 10,
				Range = 5,
				Cost = 600,
			},
			[1] = {
				Damage = { 1600 },
				FireRate = 9,
				Range = 5,
				Cost = 600,
			},
			[2] = {
				Damage = { 2400 },
				FireRate = 7.5,
				Range = 5,
				Cost = 800,
			},
			[3] = {
				Damage = { 3800 },
				FireRate = 7,
				Range = 5,
				Cost = 1500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Spartacus"] = {
		Rarity = "Rare",
		Description = "Melee attacker with activatable Rage: after a brief windup, greatly increases his attack speed.",
		Image = "rbxassetid://121520471894961",

		UnitData = {
			[0] = {
				Damage = { 15 },
				FireRate = 1.3,
				Range = 12,
				Cost = 300,
			},
			[1] = {
				Damage = { 30 },
				FireRate = 1.2,
				Range = 13,
				Cost = 400,
			},
			[2] = {
				Damage = { 50 },
				FireRate = 1,
				Range = 15,
				Cost = 600,
			},
			[3] = {
				Damage = { 80 },
				FireRate = 0.8,
				Range = 15,
				Cost = 1000,
			},
		},
		CollisionRadius = 3,
		Abilities = {
			{
				MinimumLevel = 0,
				BackgroundColor = ColorSequence.new(Color3.new(0.803922, 0.133333, 0.133333)),
				Cooldown = 30,
				Icon = "rbxassetid://77775640392808",
				Length = 10,
				Name = "Rage",
			},
		},
	},
	["Cicero"] = {
		Rarity = "Epic",
		Description = "Economy unit: generates coins every wave (does not attack).",
		Image = "rbxassetid://80438308188618",

		UnitData = {
			[0] = {
				Damage = { 0 },
				Coins = 60,
				FireRate = 0,
				Range = 5,
				Cost = 300,
			},
			[1] = {
				Damage = { 0 },
				Coins = 140,
				FireRate = 0,
				Range = 5,
				Cost = 500,
			},
			[2] = {
				Damage = { 0 },
				Coins = 300,
				FireRate = 0,
				Range = 5,
				Cost = 1200,
			},
			[3] = {
				Damage = { 0 },
				Coins = 500,
				FireRate = 0,
				Range = 5,
				Cost = 1500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Augustus"] = {
		Rarity = "Mythic",
		Description = "Solid single-target melee with improving speed and damage.",
		Image = "rbxassetid://125386565080263",

		UnitData = {
			[0] = {
				Damage = { 100 },
				FireRate = 1.8,
				Range = 13,
				Cost = 425,
			},
			[1] = {
				Damage = { 150 },
				FireRate = 1.7,
				Range = 14,
				Cost = 600,
			},
			[2] = {
				Damage = { 225 },
				FireRate = 1.55,
				Range = 16,
				Cost = 850,
			},
			[3] = {
				Damage = { 400 },
				FireRate = 1.4,
				Range = 16,
				Cost = 1300,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["William the Conqueror"] = {
		Rarity = "Mythic",
		Description = "Multi-strike attacker: lands 3 consecutive hits per attack cycle.",
		Image = "rbxassetid://127237964660825",

		UnitData = {
			[0] = {
				Damage = { 120 },
				FireRate = 1.4,
				Range = 14,
				Cost = 400,
			},
			[1] = {
				Damage = { 250 },
				FireRate = 1.4,
				Range = 14,
				Cost = 400,
			},
			[2] = {
				Damage = { 350 },
				FireRate = 1.2,
				Range = 16,
				Cost = 700,
			},
			[3] = {
				Damage = { 600 },
				FireRate = 1.2,
				Range = 18,
				Cost = 1500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Robert the Bruce"] = {
		Rarity = "Common",
		Description = "Single-target melee; dependable early-game damage.",
		Image = "rbxassetid://72392021367991",

		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1.3,
				Range = 15,
				Cost = 125,
			},
			[1] = {
				Damage = { 10 },
				FireRate = 1.3,
				Range = 15,
				Cost = 230,
			},
			[2] = {
				Damage = { 25 },
				FireRate = 1,
				Range = 15,
				Cost = 345,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Robert the Bruce (Bannockburn)"] = {
		Rarity = "Common",
		Description = "Single-target melee; dependable early-game damage.",
		Image = "rbxassetid://72392021367991",

		UnitData = {
			[0] = {
				Damage = { 20 },
				FireRate = 1.3,
				Range = 15,
				Cost = 125,
			},
			[1] = {
				Damage = { 50 },
				FireRate = 1.3,
				Range = 15,
				Cost = 230,
			},
			[2] = {
				Damage = { 120 },
				FireRate = 1,
				Range = 15,
				Cost = 345,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Richard the Lionheart"] = {
		Rarity = "Godly",
		Description = "Line AOE: slashes in a line, damaging multiple enemies along the path.",
		Image = "rbxassetid://131934169872463",

		UnitData = {
			[0] = {
				Damage = { 600 },
				FireRate = 5,
				Range = 25,
				Cost = 1000,
			},
			[1] = {
				Damage = { 1100 },
				FireRate = 4.5,
				Range = 26,
				Cost = 1250,
			},
			[2] = {
				Damage = { 2000 },
				FireRate = 4.25,
				Range = 30,
				Cost = 2750,
			},
			[3] = {
				Damage = { 3500 },
				FireRate = 4,
				Range = 35,
				Cost = 5000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Charlemagne"] = {
		Rarity = "Epic",
		Description = "Single-target melee; balanced stats through upgrades.",
		Image = "rbxassetid://135616277878704",

		UnitData = {
			[0] = {
				Damage = { 20 },
				FireRate = 1.6,
				Range = 12,
				Cost = 245,
			},
			[1] = {
				Damage = { 40 },
				FireRate = 1.6,
				Range = 12,
				Cost = 300,
			},
			[2] = {
				Damage = { 70 },
				FireRate = 1.5,
				Range = 15,
				Cost = 400,
			},
			[3] = {
				Damage = { 120 },
				FireRate = 1.4,
				Range = 17,
				Cost = 1000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Joan of Arc"] = {
		Rarity = "Legendary",
		Description = "Support aura (Attack Speed): passively increases nearby allies' fire rate.",
		Image = "rbxassetid://75620746945992",

		UnitData = {
			[0] = {
				Damage = { 1.05 },
				FireRate = 0,
				Range = 15,
				Cost = 200,
			},
			[1] = {
				Damage = { 1.08 },
				FireRate = 0,
				Range = 16,
				Cost = 300,
			},
			[2] = {
				Damage = { 1.1 },
				FireRate = 0,
				Range = 18,
				Cost = 600,
			},
			[3] = {
				Damage = { 1.2 },
				FireRate = 0,
				Range = 20,
				Cost = 2000,
			},
		},
		CollisionRadius = 3,
		Static = true,
		Abilities = {},
	},
	["Leif Erikson"] = {
		Rarity = "Rare",
		Description = "Summoner: periodically calls Viking allies to fight; stronger allies at higher levels.",
		Image = "rbxassetid://111147011911639",

		UnitData = {
			[0] = {
				Damage = { 7 },
				FireRate = 8,
				Range = 5,
				Cost = 200,
			},
			[1] = {
				Damage = { 16 },
				FireRate = 7,
				Range = 5,
				Cost = 260,
			},
			[2] = {
				Damage = { 25 },
				FireRate = 6.5,
				Range = 5,
				Cost = 300,
			},
			[3] = {
				Damage = { 40 },
				FireRate = 6,
				Range = 5,
				Cost = 350,
			},
			[4] = {
				Damage = { 60 },
				FireRate = 6,
				Range = 25,
				Cost = 600,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Ptolemy"] = {
		Rarity = "Common",
		Description = "Ranged archer: fires swift projectiles at long range.",
		Image = "rbxassetid://84772192162069",

		UnitData = {
			[0] = {
				Damage = { 2 },
				FireRate = 1.75,
				Range = 35,
				Cost = 75,
			},
			[1] = {
				Damage = { 5 },
				FireRate = 1.5,
				Range = 40,
				Cost = 200,
			},
			[2] = {
				Damage = { 9 },
				FireRate = 1.2,
				Range = 50,
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Cleopatra"] = {
		Rarity = "Rare",
		Description = "Ranged archer: very fast arrows with excellent range.",
		Image = "rbxassetid://128569882185944",

		UnitData = {
			[0] = {
				Damage = { 4 },
				FireRate = 2,
				Range = 50,
				Cost = 200,
			},
			[1] = {
				Damage = { 8 },
				FireRate = 1.75,
				Range = 60,
				Cost = 400,
			},
			[2] = {
				Damage = { 14 },
				FireRate = 1.75,
				Range = 60,
				Cost = 650,
			},
			[3] = {
				Damage = { 22 },
				FireRate = 1.2,
				Range = 60,
				Cost = 1000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Narmer"] = {
		Rarity = "Epic",
		Description = "Single-target melee; steady damage output.",
		Image = "rbxassetid://123302243147194",

		UnitData = {
			[0] = {
				Damage = { 15 },
				FireRate = 1.4,
				Range = 12,
				Cost = 175,
			},
			[1] = {
				Damage = { 30 },
				FireRate = 1.4,
				Range = 12,
				Cost = 250,
			},
			[2] = {
				Damage = { 50 },
				FireRate = 1.4,
				Range = 15,
				Cost = 350,
			},
			[3] = {
				Damage = { 80 },
				FireRate = 1.3,
				Range = 15,
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Akhenaten"] = {
		Rarity = "Legendary",
		Description = "Support (Base Heal): heals the base after each wave based on his Damage stat.",
		Image = "rbxassetid://140319991588251",

		UnitData = {
			[0] = {
				Damage = { 10 },
				FireRate = 0,
				Range = 25,
				Cost = 150,
			},
			[1] = {
				Damage = { 20 },
				FireRate = 0,
				Range = 25,
				Cost = 250,
			},
			[2] = {
				Damage = { 40 },
				FireRate = 0,
				Range = 25,
				Cost = 400,
			},
			[3] = {
				Damage = { 60 },
				FireRate = 0,
				Range = 30,
				Cost = 700,
			},
		},
		CollisionRadius = 3,
		Static = true,
		Abilities = {},
	},
	["Ramesses II"] = {
		Rarity = "Mythic",
		Description = "Double-strike attacker: hits twice per attack for burst damage.",
		Image = "rbxassetid://84378323969306",

		UnitData = {
			[0] = {
				Damage = { 100 },
				FireRate = 1.5,
				Range = 15,
				Cost = 325,
			},
			[1] = {
				Damage = { 150 },
				FireRate = 1.4,
				Range = 15,
				Cost = 450,
			},
			[2] = {
				Damage = { 250 },
				FireRate = 1.2,
				Range = 18,
				Cost = 500,
			},
			[3] = {
				Damage = { 350 },
				FireRate = 1,
				Range = 18,
				Cost = 750,
			},
			[4] = {
				Damage = { 500 },
				FireRate = 0.8,
				Range = 25,
				Cost = 1200,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Tutankhamun"] = {
		Rarity = "Godly",
		Description = "Support auras (Triple): boosts allies' Damage, Attack Speed, and Range.",
		Image = "rbxassetid://127377869922808",

		UnitData = {
			[0] = {
				Damage = { 1.1 },
				FireRate = 0,
				Range = 40,
				Cost = 500,
			},
			[1] = {
				Damage = { 1.2 },
				FireRate = 0,
				Range = 45,
				Cost = 1200,
			},
			[2] = {
				Damage = { 1.3 },
				FireRate = 0,
				Range = 50,
				Cost = 2000,
			},
			[3] = {
				Damage = { 1.4 },
				FireRate = 0,
				Range = 60,
				Cost = 3000,
			},
		},
		CollisionRadius = 3,
		Static = true,
		Abilities = {},
	},
	["Cao Cao"] = {
		Rarity = "Mythic",
		Description = "Single-target melee; solid stats and scaling.",
		Image = "rbxassetid://73915227461302",

		UnitData = {
			[0] = {
				Damage = { 120 },
				FireRate = 1.4,
				Range = 15,
				Cost = 345,
			},
			[1] = {
				Damage = { 180 },
				FireRate = 1.2,
				Range = 17,
				Cost = 500,
			},
			[2] = {
				Damage = { 400 },
				FireRate = 1.1,
				Range = 18,
				Cost = 800,
			},
			[3] = {
				Damage = { 700 },
				FireRate = 0.9,
				Range = 20,
				Cost = 1300,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Qin Shi Huang"] = {
		Rarity = "Godly",
		Description = "Support auras (Triple): boosts allies' Damage, Attack Speed, and Range.",
		Image = "rbxassetid://72049353436342",

		UnitData = {
			[0] = {
				Damage = { 1.25 },
				FireRate = 0,
				Range = 40,
				Cost = 2000,
			},
			[1] = {
				Damage = { 1.5 },
				FireRate = 0,
				Range = 45,
				Cost = 4000,
			},
			[2] = {
				Damage = { 1.75 },
				FireRate = 0,
				Range = 50,
				Cost = 10000,
			},
			[3] = {
				Damage = { 2 },
				FireRate = 0,
				Range = 60,
				Cost = 20000,
			},
		},
		CollisionRadius = 4,
		Static = true,
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
		if Level <= GivenLevel then
			TotalCost += Info.Cost
		end
	end

	return TotalCost
end

local Stats = {}

export type StatProperty = "Damage" | "Range" | "FireRate" | "Coins" | "Special"
local StatProperties = { "Damage", "Range", "FireRate", "Coins", "Special" }

local Icons: { [StatProperty]: string } = {
	Damage = "rbxassetid://116153831042938",
	FireRate = "rbxassetid://117289508099114",
	Range = "rbxassetid://95171919754669",
	Coins = "rbxassetid://72304165589077",
	Special = "rbxassetid://134876951462162",
}

local Colors: { [StatProperty]: Color3 } = {
	Damage = Color3.new(0.772549, 0.109804, 0.109804),
	FireRate = Color3.new(0.113725, 0.247059, 0.784314),
	Range = Color3.new(0.749020, 0.843137, 0.133333),
	Coins = Color3.new(0.105882, 0.47451, 0.231373),
	Special = Color3.new(0.921569, 0.600000, 0.149020),
}

local Layout: { [StatProperty]: number } = {
	Damage = 1,
	FireRate = 2,
	Range = 3,
	Special = 4,
}

Stats.StatProperties = StatProperties
Stats.Icons = Icons
Stats.Colors = Colors
Stats.Layout = Layout

Data.Stats = Stats

Data.UnitInfo = UnitInfo
Data.LevelInfo = LevelInfo
Data.CalculateTotalCost = CalculateTotalCost

return table.freeze(Data)
