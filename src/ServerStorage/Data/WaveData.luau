--!strict

-- By Wa1er_God --

local Data = {}

export type WaveData = {
	Data: { [number]: {
		Enemies: { [string]: { number } },
		Length: number,
		CoinBonus: number,
	} },
	EnemyData: {
		[string]: {
			ExtraData: {}?, -- Overriden Data
		},
	},
}

local WaveData: { [string]: WaveData } = {
	["Hastingsv1"] = {
		Data = {
			[1] = {
				Enemies = { Zombie = { 1 } },
				Length = 10,
				CoinBonus = 1,
			},
			[2] = {
				Enemies = { Zombie = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 20,
				CoinBonus = 1,
			},
			[3] = {
				Enemies = { Zombie = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 100,
				CoinBonus = 1,
			},
		},
		EnemyData = { -- TBD --
			Zombie = {},
		},
	},
}

export type InfiniteData = {
	Data: {
		[string]: {
			FirstSpawnWave: number,
			SpawnCount: number?, --Default 1 --
			OrderPriority: number, -- closer the number is from 0, the earlier it spawns realtive to the other enemies
			WaveDelay: number?, -- Delay of waves from first spawn wave to spawn again. (default 1)--
		},
	},
	EnemyData: { -- TBD --
		[string]: {
			ExtraData: {}?, -- Overriden Data
		},
	},
}

local InfiniteData: { [string]: InfiniteData } = {}

Data.WaveData = WaveData
Data.InfiniteData = InfiniteData

table.freeze(Data)

return WaveData
