--!strict

-- By Wa1er_God --

export type Data = {
	Health: number,
	HealthRatio: number,
	HealthIncrRatio: number,
	SpeedAdditive: number,
}

local DifficultyData: { [string]: Data } = {
	Normal = {
		Health = 200,
		HealthRatio = 1,
		HealthIncrRatio = 1.04,
		SpeedAdditive = 0.01,
	},
	Hard = {
		Health = 100,
		HealthRatio = 1.25,
		HealthIncrRatio = 1.041,
		SpeedAdditive = 0.011,
	},
	Insane = {
		Health = 50,
		HealthRatio = 1.5,
		HealthIncrRatio = 1.042,
		SpeedAdditive = 0.012,
	},
}

return table.freeze(DifficultyData)
