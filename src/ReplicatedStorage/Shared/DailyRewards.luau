--!strict

-- By Wa1er_God --

-- Services --

export type InfoType = "Unit" | "Product" | "Resource"

export type DailyData = {
	Type: InfoType | string,
	Name: string,
	Count: number,
	ExtraData: any,
}

local DailyRewards: {
	Rewards: { DailyData },
} = {
	Rewards = {
		{ Type = "Resource", Name = "Gold", Count = 260 },
		{ Type = "Resource", Name = "Gold", Count = 346 },
		{ Type = "Resource", Name = "Omen Coins", Count = 3 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 420 },
		{ Type = "Resource", Name = "Omen Coins", Count = 5 },
		{ Type = "Unit", Name = "Cleopatra", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 168 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Trajan", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
	},
}

return DailyRewards
