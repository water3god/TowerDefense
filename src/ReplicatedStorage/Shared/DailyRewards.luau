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
		{ Type = "Resource", Name = "Gold", Count = 160 },
		{ Type = "Resource", Name = "Gold", Count = 246 },
		{ Type = "Resource", Name = "Omen Coins", Count = 3 },
		{ Type = "Unit", Name = "Spartacus", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 420 },
		{ Type = "Resource", Name = "Omen Coins", Count = 2 },
		{ Type = "Unit", Name = "Cleopatra", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 168 },
		{ Type = "Unit", Name = "Socrates", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 231 },
		{ Type = "Resource", Name = "Gold", Count = 317 },
		{ Type = "Resource", Name = "Omen Coins", Count = 3 },
		{ Type = "Resource", Name = "Gold", Count = 175 },
		{ Type = "Product", Name = "2x Luck Boost (1 Hour)", Count = 1 },
		{ Type = "Unit", Name = "Charlemagne", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 243 },
		{ Type = "Unit", Name = "Julius Caesar", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 214 },
		{ Type = "Resource", Name = "Gold", Count = 191 },
		{ Type = "Resource", Name = "Omen Coins", Count = 6 },
		{ Type = "Resource", Name = "Gold", Count = 120 },
		{ Type = "Unit", Name = "Narmer", Count = 1 },
		{ Type = "Product", Name = "3x Luck Boost (1 Hour)", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 328 },
		{ Type = "Resource", Name = "Gold", Count = 546 },
		{ Type = "Resource", Name = "Gold", Count = 421 },
		{ Type = "Resource", Name = "Omen Coins", Count = 4 },
		{ Type = "Unit", Name = "Alexander The Great", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 237 },
		{ Type = "Resource", Name = "Gold", Count = 396 },
		{ Type = "Product", Name = "2x Luck Boost (1 Hour)", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 315 },
		{ Type = "Resource", Name = "Gold", Count = 67 },
		{ Type = "Resource", Name = "Omen Coins", Count = 5 },
		{ Type = "Resource", Name = "Gold", Count = 177 },
		{ Type = "Unit", Name = "Cicero", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 238 },
		{ Type = "Resource", Name = "Gold", Count = 194 },
		{ Type = "Resource", Name = "Gold", Count = 220 },
		{ Type = "Resource", Name = "Omen Coins", Count = 10 },
		{ Type = "Resource", Name = "Gold", Count = 175 },
		{ Type = "Product", Name = "2x Luck Boost (1 Hour)", Count = 1 },
		{ Type = "Product", Name = "3x Luck Boost (1 Hour)", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 500 },
		{ Type = "Resource", Name = "Gold", Count = 432 },
		{ Type = "Resource", Name = "Omen Coins", Count = 5 },
		{ Type = "Resource", Name = "Gold", Count = 149 },
		{ Type = "Resource", Name = "Gold", Count = 134 },
		{ Type = "Unit", Name = "Augustus", Count = 1 },
		{ Type = "Resource", Name = "Gold", Count = 653 },
		{ Type = "Product", Name = "3x Luck Boost (1 Hour)", Count = 1 },
		{ Type = "Unit", Name = "William the Conqueror", Count = 1 },
	},
}

return table.freeze(DailyRewards)
