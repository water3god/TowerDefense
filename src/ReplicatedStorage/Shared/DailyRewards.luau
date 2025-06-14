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
