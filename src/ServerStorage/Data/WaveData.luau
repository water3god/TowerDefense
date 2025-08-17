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
			[1] = { Enemies = { Zombie = { 1 } }, Length = 45, CoinBonus = 1 },
			[2] = { Enemies = { Zombie = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } }, Length = 50, CoinBonus = 1 },
			[3] = { Enemies = { Zombie = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } }, Length = 55, CoinBonus = 1 },
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 1: Desert Reconnaissance
	["AncientEgypt_DesertReconnaissance"] = {
		Data = {
			[1] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14 },
					["Egyptian Spearman"] = { 17, 18 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 19 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 19, 20, 21 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 19, 20, 21 },
					["Charioteer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26 },
					["Charioteer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29 },
					["Charioteer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32 },
					["Charioteer"] = { 44, 48 },
					["War Priest"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Charioteer"] = { 47, 51, 55 },
					["War Priest"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
					["Charioteer"] = { 50, 54, 58, 62 },
					["War Priest"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 },
					["Charioteer"] = { 53, 57, 61, 65, 69 },
					["War Priest"] = { 77, 81 },
					["Egyptian Commander"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44 },
					["Charioteer"] = { 56, 60, 64, 68, 72, 76 },
					["War Priest"] = { 84, 88, 92 },
					["Egyptian Commander"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 },
					["Charioteer"] = { 52, 54, 56, 58, 60, 62, 64 },
					["War Priest"] = { 69, 71, 73, 75 },
					["Egyptian Commander"] = { 80 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Spearman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50 },
					["Charioteer"] = { 55, 57, 59, 61, 63, 65, 67, 69 },
					["War Priest"] = { 74, 76, 78, 80, 82 },
					["Egyptian Commander"] = { 87, 90 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Egyptian Spearman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53 },
					["Charioteer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["War Priest"] = { 79, 81, 83, 85, 87, 89 },
					["Egyptian Commander"] = { 94, 97, 100 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 2: Arrow Barrage
	["AncientEgypt_ArrowBarrage"] = {
		Data = {
			[1] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3 },
					["Egyptian Archer"] = { 7, 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 15, 16 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 8, 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 17, 18, 19 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 19, 20, 21, 22 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28 },
					["Charioteer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31 },
					["Charioteer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Charioteer"] = { 44, 48 },
					["War Priest"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 47, 51, 55 },
					["War Priest"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 50, 54, 58 },
					["War Priest"] = { 62 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Charioteer"] = { 53, 57, 61, 65 },
					["War Priest"] = { 77, 81 },
					["Egyptian Commander"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Egyptian Spearman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Charioteer"] = { 56, 60, 64, 68, 72 },
					["War Priest"] = { 84, 88, 92 },
					["Egyptian Commander"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Egyptian Spearman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Charioteer"] = { 59, 63, 67, 71, 75, 79 },
					["War Priest"] = { 91, 95, 99, 103 },
					["Egyptian Commander"] = { 115 },
					["Royal Guard"] = { 125 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Egyptian Spearman"] = { 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Charioteer"] = { 62, 66, 70, 74, 78, 82, 86 },
					["War Priest"] = { 98, 102, 106, 110, 114 },
					["Egyptian Commander"] = { 119, 122 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Archer"] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Egyptian Spearman"] = { 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58 },
					["Charioteer"] = { 63, 65, 67, 69, 71, 73, 75, 77 },
					["War Priest"] = { 82, 84, 86, 88, 90, 92 },
					["Egyptian Commander"] = { 97, 100, 103 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 3: Shielded Formation
	["AncientEgypt_ShieldedFormation"] = {
		Data = {
			[1] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2 },
					["Egyptian Archer"] = { 5, 6 },
					["Egyptian Spearman"] = { 9, 10 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3 },
					["Egyptian Archer"] = { 6, 7, 8 },
					["Egyptian Spearman"] = { 11, 12, 13 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 7, 8, 9, 10 },
					["Egyptian Spearman"] = { 13, 14, 15, 16 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11, 12 },
					["Egyptian Spearman"] = { 15, 16, 17, 18, 19 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Egyptian Spearman"] = { 17, 18, 19, 20, 21, 22 },
					["Charioteer"] = { 30 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 19, 20, 21, 22, 23, 24, 25 },
					["Charioteer"] = { 33 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26, 27, 28 },
					["Charioteer"] = { 36, 40 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Charioteer"] = { 39, 43 },
					["War Priest"] = { 47 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 42, 46, 50 },
					["War Priest"] = { 57 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Charioteer"] = { 45, 49, 53, 57 },
					["War Priest"] = { 65, 69 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 48, 52, 56, 60, 64 },
					["War Priest"] = { 72, 76 },
					["Egyptian Commander"] = { 85 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 51, 55, 59, 63, 67, 71 },
					["War Priest"] = { 79, 83, 87 },
					["Egyptian Commander"] = { 95 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Charioteer"] = { 54, 58, 62, 66, 70, 74, 78 },
					["War Priest"] = { 86, 90, 94, 98 },
					["Egyptian Commander"] = { 108 },
					["Royal Guard"] = { 118 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Charioteer"] = { 57, 61, 65, 69, 73, 77, 81, 85 },
					["War Priest"] = { 93, 97, 101, 105, 109 },
					["Egyptian Commander"] = { 119, 123 },
					["Royal Guard"] = { 135 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Spearman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Charioteer"] = { 57, 59, 61, 63, 65, 67, 69, 71, 73 },
					["War Priest"] = { 78, 80, 82, 84, 86, 88 },
					["Egyptian Commander"] = { 93, 96, 99 },
					["Royal Guard"] = { 104, 107 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 4: Chariot Assault
	["AncientEgypt_ChariotAssault"] = {
		Data = {
			[1] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2 },
					["Egyptian Archer"] = { 5, 6 },
					["Egyptian Spearman"] = { 9, 10 },
					["Charioteer"] = { 13, 14 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3 },
					["Egyptian Archer"] = { 6, 7, 8 },
					["Egyptian Spearman"] = { 11, 12, 13 },
					["Charioteer"] = { 16, 17, 18 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 7, 8, 9, 10 },
					["Egyptian Spearman"] = { 13, 14, 15, 16 },
					["Charioteer"] = { 19, 20, 21, 22 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5 },
					["Egyptian Scout"] = { 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 26, 27, 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Scout"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 29, 30, 31, 32 },
					["War Priest"] = { 40 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Scout"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Archer"] = { 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 32, 33, 34, 35, 36 },
					["War Priest"] = { 43 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Scout"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Archer"] = { 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40 },
					["War Priest"] = { 47, 51 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Scout"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Archer"] = { 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Spearman"] = { 38, 39, 40, 41, 42, 43, 44 },
					["War Priest"] = { 51, 55 },
					["Egyptian Commander"] = { 65 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Scout"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Archer"] = { 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Egyptian Spearman"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
					["War Priest"] = { 55, 59, 63 },
					["Egyptian Commander"] = { 73 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Scout"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Archer"] = { 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Egyptian Spearman"] = { 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["War Priest"] = { 59, 63, 67, 71 },
					["Egyptian Commander"] = { 81, 85 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Scout"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Archer"] = { 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Egyptian Spearman"] = { 47, 48, 49, 50, 51, 52, 53, 54, 55, 56 },
					["War Priest"] = { 63, 67, 71, 75, 79 },
					["Egyptian Commander"] = { 89, 93 },
					["Royal Guard"] = { 105 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Scout"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Archer"] = { 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Egyptian Spearman"] = { 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60 },
					["War Priest"] = { 67, 71, 75, 79, 83, 87 },
					["Egyptian Commander"] = { 97, 101 },
					["Royal Guard"] = { 113 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Scout"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Archer"] = { 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Egyptian Spearman"] = { 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 },
					["War Priest"] = { 71, 75, 79, 83, 87, 91, 95 },
					["Egyptian Commander"] = { 100, 103, 106 },
					["Royal Guard"] = { 111, 115 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Scout"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Archer"] = { 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Egyptian Spearman"] = { 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68 },
					["War Priest"] = { 75, 79, 83, 87, 91, 95, 99, 103 },
					["Egyptian Commander"] = { 108, 111, 114, 117 },
					["Royal Guard"] = { 122, 125 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Scout"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Egyptian Archer"] = { 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Egyptian Spearman"] = { 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72 },
					["War Priest"] = { 77, 79, 81, 83, 85, 87, 89, 91, 93 },
					["Egyptian Commander"] = { 98, 101, 104, 107, 110 },
					["Royal Guard"] = { 115, 118, 121 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 5: Sacred Ritual
	["AncientEgypt_SacredRitual"] = {
		Data = {
			[1] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3 },
					["Egyptian Archer"] = { 6, 7, 8 },
					["Egyptian Spearman"] = { 11, 12 },
					["War Priest"] = { 15 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["War Priest"] = { 1, 2 },
					["Egyptian Scout"] = { 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 20 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3 },
					["Egyptian Scout"] = { 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 23, 24 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4 },
					["Egyptian Scout"] = { 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 26, 27, 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5 },
					["Egyptian Scout"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 29, 30, 31, 32 },
					["Charioteer"] = { 40 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Scout"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Archer"] = { 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 32, 33, 34, 35, 36 },
					["Charioteer"] = { 43 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Scout"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 47, 51 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Scout"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Spearman"] = { 38, 39, 40, 41, 42, 43, 44 },
					["Charioteer"] = { 51, 55 },
					["Egyptian Commander"] = { 65 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Scout"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Egyptian Spearman"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
					["Charioteer"] = { 55, 59, 63 },
					["Egyptian Commander"] = { 73 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Scout"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Egyptian Spearman"] = { 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Charioteer"] = { 59, 63, 67, 71 },
					["Egyptian Commander"] = { 81, 85 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Scout"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Egyptian Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Egyptian Spearman"] = { 47, 48, 49, 50, 51, 52, 53, 54, 55, 56 },
					["Charioteer"] = { 63, 67, 71, 75, 79 },
					["Egyptian Commander"] = { 89, 93 },
					["Royal Guard"] = { 105 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Scout"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Egyptian Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Egyptian Spearman"] = { 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60 },
					["Charioteer"] = { 67, 71, 75, 79, 83, 87 },
					["Egyptian Commander"] = { 97, 101 },
					["Royal Guard"] = { 113 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Scout"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Egyptian Spearman"] = { 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 },
					["Charioteer"] = { 71, 75, 79, 83, 87, 91, 95 },
					["Egyptian Commander"] = { 100, 103, 106 },
					["Royal Guard"] = { 111, 115 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Scout"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Egyptian Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Egyptian Spearman"] = { 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68 },
					["Charioteer"] = { 75, 79, 83, 87, 91, 95, 99, 103 },
					["Egyptian Commander"] = { 108, 111, 114, 117 },
					["Royal Guard"] = { 122, 125 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Scout"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Egyptian Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Egyptian Spearman"] = { 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73 },
					["Charioteer"] = { 78, 80, 82, 84, 86, 88, 90, 92, 94 },
					["Egyptian Commander"] = { 99, 102, 105, 108, 111 },
					["Royal Guard"] = { 116, 119, 122, 125 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 6: Final Defense
	["AncientEgypt_FinalDefense"] = {
		Data = {
			[1] = {
				Enemies = {
					["Royal Guard"] = { 1 },
					["Egyptian Scout"] = { 5, 6, 7, 8 },
					["Egyptian Archer"] = { 12, 13, 14 },
					["Egyptian Spearman"] = { 18, 19 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Royal Guard"] = { 1, 2 },
					["Egyptian Scout"] = { 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 21, 22, 23 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3 },
					["Egyptian Scout"] = { 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 24, 25, 26, 27 },
					["Charioteer"] = { 35 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4 },
					["Egyptian Scout"] = { 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31 },
					["Charioteer"] = { 38 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5 },
					["Egyptian Scout"] = { 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 30, 31, 32, 33, 34, 35 },
					["Charioteer"] = { 42, 46 },
					["War Priest"] = { 55 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Scout"] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Archer"] = { 22, 23, 24, 25, 26, 27, 28, 29 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39 },
					["Charioteer"] = { 46, 50, 54 },
					["War Priest"] = { 61 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Scout"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Archer"] = { 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Spearman"] = { 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 50, 54, 58, 62 },
					["War Priest"] = { 69, 73 },
					["Egyptian Commander"] = { 85 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Scout"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Archer"] = { 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Egyptian Spearman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47 },
					["Charioteer"] = { 54, 58, 62, 66, 70 },
					["War Priest"] = { 77, 81, 85 },
					["Egyptian Commander"] = { 95 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Scout"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Archer"] = { 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
					["Egyptian Spearman"] = { 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Charioteer"] = { 58, 62, 66, 70, 74, 78 },
					["War Priest"] = { 85, 89, 93, 97 },
					["Egyptian Commander"] = { 107, 111 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Scout"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Archer"] = { 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 },
					["Egyptian Spearman"] = { 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Charioteer"] = { 62, 66, 70, 74, 78, 82, 86 },
					["War Priest"] = { 93, 97, 101, 105, 109 },
					["Egyptian Commander"] = { 119, 123 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Scout"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Archer"] = { 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44 },
					["Egyptian Spearman"] = { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 },
					["Charioteer"] = { 66, 70, 74, 78, 82, 86, 90, 94 },
					["War Priest"] = { 101, 105, 109, 113, 117, 121 },
					["Egyptian Commander"] = { 126, 129, 132 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Scout"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Archer"] = { 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 },
					["Egyptian Spearman"] = { 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63 },
					["Charioteer"] = { 70, 74, 78, 82, 86, 90, 94, 98, 102 },
					["War Priest"] = { 109, 113, 117, 121, 125, 129, 133 },
					["Egyptian Commander"] = { 138, 141, 144 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Scout"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Archer"] = { 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50 },
					["Egyptian Spearman"] = { 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
					["Charioteer"] = { 74, 78, 82, 86, 90, 94, 98, 102, 106, 110 },
					["War Priest"] = { 117, 121, 125, 129, 133, 137, 141, 145 },
					["Egyptian Commander"] = { 155, 161, 167, 173 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Scout"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Archer"] = { 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53 },
					["Egyptian Spearman"] = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71 },
					["Charioteer"] = { 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118 },
					["War Priest"] = { 125, 129, 133, 137, 141, 145, 149, 153, 157 },
					["Egyptian Commander"] = { 167, 173, 179, 185, 191 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Scout"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Egyptian Archer"] = { 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56 },
					["Egyptian Spearman"] = { 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75 },
					["Charioteer"] = { 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102 },
					["War Priest"] = { 107, 109, 111, 113, 115, 117, 119, 121, 123, 125 },
					["Egyptian Commander"] = { 130, 133, 136, 139, 142, 145 },
					["Ramesses II"] = { 150 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 1: Spartan Defense
	["Greece_SpartanDefense"] = {
		Data = {
			[1] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3 },
					["Greek Slinger"] = { 6, 7, 8 },
					["Hoplite"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 44, 48 },
					["Strategos"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 47, 51, 55 },
					["Strategos"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 50, 54, 58, 62 },
					["Strategos"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 53, 57, 61, 65, 69 },
					["Strategos"] = { 77, 81 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 56, 60, 64, 68, 72, 76 },
					["Strategos"] = { 84, 88, 92 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Strategos"] = { 91, 95, 99, 103 },
					["Polemarch"] = { 115 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Strategos"] = { 98, 102, 106, 110, 114 },
					["Polemarch"] = { 122, 126 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Strategos"] = { 79, 81, 83, 85, 87, 89 },
					["Polemarch"] = { 94, 97, 100 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 2: Olympian Challenge
	["Greece_OlympianChallenge"] = {
		Data = {
			[1] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3 },
					["Greek Slinger"] = { 6, 7, 8 },
					["Hoplite"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 31, 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 34, 38, 42 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 37, 41, 45, 49 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 40, 44, 48, 52 },
					["Strategos"] = { 60 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 47, 51, 55, 59 },
					["Strategos"] = { 67, 71 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 50, 54, 58, 62, 66 },
					["Strategos"] = { 74, 78, 82 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 53, 57, 61, 65, 69, 73 },
					["Strategos"] = { 81, 85, 89 },
					["Polemarch"] = { 95 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 52, 56, 60, 64, 68, 72, 76, 80 },
					["Strategos"] = { 88, 92, 96, 100 },
					["Polemarch"] = { 110 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 55, 59, 63, 67, 71, 75, 79, 83, 87 },
					["Strategos"] = { 95, 99, 103, 107, 111 },
					["Polemarch"] = { 121, 125 },
					["Palace Guard"] = { 140 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 58, 62, 66, 70, 74, 78, 82, 86, 90, 94 },
					["Strategos"] = { 102, 106, 110, 114, 118, 122 },
					["Polemarch"] = { 132, 138, 144 },
					["Palace Guard"] = { 155 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78 },
					["Strategos"] = { 83, 85, 87, 89, 91, 93, 95 },
					["Polemarch"] = { 100, 103, 106, 109 },
					["Palace Guard"] = { 114, 117, 120 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 3: Athenian Walls
	["Greece_AthenianWalls"] = {
		Data = {
			[1] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3 },
					["Greek Slinger"] = { 6, 7, 8 },
					["Hoplite"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 31, 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 34, 38, 42 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 37, 41, 45, 49 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 40, 44, 48, 52 },
					["Strategos"] = { 60 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 47, 51, 55, 59 },
					["Strategos"] = { 67, 71 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 50, 54, 58, 62, 66 },
					["Strategos"] = { 74, 78, 82 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 53, 57, 61, 65, 69, 73 },
					["Strategos"] = { 81, 85, 89 },
					["Polemarch"] = { 95 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 52, 56, 60, 64, 68, 72, 76, 80 },
					["Strategos"] = { 88, 92, 96, 100 },
					["Polemarch"] = { 110 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 55, 59, 63, 67, 71, 75, 79, 83, 87 },
					["Strategos"] = { 95, 99, 103, 107, 111 },
					["Polemarch"] = { 121, 125 },
					["Palace Guard"] = { 140 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 58, 62, 66, 70, 74, 78, 82, 86, 90, 94 },
					["Strategos"] = { 102, 106, 110, 114, 118, 122 },
					["Polemarch"] = { 132, 138, 144 },
					["Palace Guard"] = { 155 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78 },
					["Strategos"] = { 83, 85, 87, 89, 91, 93, 95 },
					["Polemarch"] = { 100, 103, 106, 109 },
					["Palace Guard"] = { 114, 117, 120 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 4: Phalanx Advance
	["Greece_PhalanxAdvance"] = {
		Data = {
			[1] = {
				Enemies = {
					["Peltast"] = { 1, 2 },
					["Greek Slinger"] = { 5, 6 },
					["Hoplite"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3 },
					["Greek Slinger"] = { 6, 7, 8 },
					["Hoplite"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18 },
					["Greek Calvaryman"] = { 25 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 28, 32 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 31, 35, 39 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 34, 38, 42, 46 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 37, 41, 45, 49 },
					["Strategos"] = { 56 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 40, 44, 48, 52, 56 },
					["Strategos"] = { 63, 67 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 47, 51, 55, 59, 63 },
					["Strategos"] = { 70, 74, 78 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 50, 54, 58, 62, 66, 70 },
					["Strategos"] = { 77, 81, 85 },
					["Polemarch"] = { 92 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 53, 57, 61, 65, 69, 73, 77 },
					["Strategos"] = { 84, 88, 92, 96 },
					["Polemarch"] = { 105 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 52, 56, 60, 64, 68, 72, 76, 80, 84 },
					["Strategos"] = { 91, 95, 99, 103, 107 },
					["Polemarch"] = { 116, 120 },
					["Palace Guard"] = { 135 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 55, 59, 63, 67, 71, 75, 79, 83, 87, 91 },
					["Strategos"] = { 98, 102, 106, 110, 114, 118 },
					["Polemarch"] = { 127, 133, 139 },
					["Palace Guard"] = { 150 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Greek Calvaryman"] = { 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76 },
					["Strategos"] = { 81, 83, 85, 87, 89, 91, 93 },
					["Polemarch"] = { 98, 101, 104, 107 },
					["Palace Guard"] = { 112, 115, 118 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 5: Oracle's Prophecy
	["Greece_OraclesProphecy"] = {
		Data = {
			[1] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3 },
					["Greek Slinger"] = { 6, 7, 8 },
					["Hoplite"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21 },
					["Strategos"] = { 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Strategos"] = { 31, 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Strategos"] = { 34, 38, 42 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Strategos"] = { 37, 41, 45, 49 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Strategos"] = { 40, 44, 48, 52 },
					["Greek Calvaryman"] = { 58 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Strategos"] = { 43, 47, 51, 55, 59 },
					["Greek Calvaryman"] = { 65, 69 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Strategos"] = { 46, 50, 54, 58, 62, 66 },
					["Greek Calvaryman"] = { 72, 76, 80 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Strategos"] = { 49, 53, 57, 61, 65, 69, 73 },
					["Greek Calvaryman"] = { 79, 83, 87 },
					["Polemarch"] = { 95 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Strategos"] = { 52, 56, 60, 64, 68, 72, 76, 80 },
					["Greek Calvaryman"] = { 86, 90, 94, 98 },
					["Polemarch"] = { 106, 110 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Strategos"] = { 55, 59, 63, 67, 71, 75, 79, 83, 87 },
					["Greek Calvaryman"] = { 93, 97, 101, 105, 109 },
					["Polemarch"] = { 117, 123, 129 },
					["Palace Guard"] = { 140 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Strategos"] = { 58, 62, 66, 70, 74, 78, 82, 86, 90, 94 },
					["Greek Calvaryman"] = { 100, 104, 108, 112, 116, 120 },
					["Polemarch"] = { 128, 134, 140, 146 },
					["Palace Guard"] = { 155, 159 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Strategos"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78 },
					["Greek Calvaryman"] = { 83, 85, 87, 89, 91, 93, 95 },
					["Polemarch"] = { 100, 103, 106, 109, 112 },
					["Palace Guard"] = { 117, 120, 123, 126 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 6: Final Stand
	["Greece_FinalStand"] = {
		Data = {
			[1] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3 },
					["Greek Slinger"] = { 6, 7, 8 },
					["Hoplite"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 480,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 28 },
				},
				Length = 60,
				CoinBonus = 520,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 31, 35 },
				},
				Length = 65,
				CoinBonus = 560,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 34, 38, 42 },
					["Strategos"] = { 48 },
				},
				Length = 70,
				CoinBonus = 600,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 37, 41, 45, 49 },
					["Strategos"] = { 55, 59 },
				},
				Length = 75,
				CoinBonus = 640,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 40, 44, 48, 52, 56 },
					["Strategos"] = { 62, 66, 70 },
					["Polemarch"] = { 78 },
				},
				Length = 80,
				CoinBonus = 680,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 47, 51, 55, 59, 63 },
					["Strategos"] = { 69, 73, 77, 81 },
					["Polemarch"] = { 87, 91 },
				},
				Length = 85,
				CoinBonus = 720,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 50, 54, 58, 62, 66, 70 },
					["Strategos"] = { 76, 80, 84, 88, 92 },
					["Polemarch"] = { 98, 104, 110 },
					["Palace Guard"] = { 120 },
				},
				Length = 90,
				CoinBonus = 760,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 53, 57, 61, 65, 69, 73, 77 },
					["Strategos"] = { 83, 87, 91, 95, 99, 103 },
					["Polemarch"] = { 109, 115, 121, 127 },
					["Palace Guard"] = { 137, 141 },
				},
				Length = 95,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 52, 56, 60, 64, 68, 72, 76, 80, 84 },
					["Strategos"] = { 90, 94, 98, 102, 106, 110, 114 },
					["Polemarch"] = { 120, 126, 132, 138, 144 },
					["Palace Guard"] = { 154, 164, 174 },
				},
				Length = 100,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 55, 59, 63, 67, 71, 75, 79, 83, 87, 91 },
					["Strategos"] = { 97, 101, 105, 109, 113, 117, 121, 125 },
					["Polemarch"] = { 131, 137, 143, 149, 155, 161 },
					["Palace Guard"] = { 171, 181, 191, 201 },
				},
				Length = 105,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98 },
					["Strategos"] = { 104, 108, 112, 116, 120, 124, 128, 132, 136 },
					["Polemarch"] = { 142, 148, 154, 160, 166, 172, 178 },
					["Palace Guard"] = { 188, 198, 208, 218, 228 },
				},
				Length = 110,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80 },
					["Strategos"] = { 85, 87, 89, 91, 93, 95, 97, 99, 101, 103 },
					["Polemarch"] = { 108, 111, 114, 117, 120, 123, 126, 129 },
					["Palace Guard"] = { 134, 137, 140, 143, 146, 149 },
					["Pyrrhus"] = { 155 },
				},
				Length = 2000,
				CoinBonus = 1000,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 1: Legion's March
	["Rome_LegionsMarch"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3 },
					["Roman Archer"] = { 6, 7, 8 },
					["Legionary"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 28 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 31 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 44, 48 },
					["Centurion"] = { 52 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 47, 51, 55 },
					["Centurion"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 50, 54, 58, 62 },
					["Centurion"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 53, 57, 61, 65, 69 },
					["Centurion"] = { 77, 81 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Centurion"] = { 84, 88, 92 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Centurion"] = { 91, 95, 99, 103 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Centurion"] = { 98, 102, 106, 110, 114 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Roman Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Legionary"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Standard Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Centurion"] = { 79, 81, 83, 85, 87, 89 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 2: Centurion's Charge
	["Rome_CenturionsCharge"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3 },
					["Roman Archer"] = { 6, 7, 8 },
					["Legionary"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 28 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 31 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 44, 48 },
					["Centurion"] = { 52 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 47, 51, 55 },
					["Centurion"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 50, 54, 58, 62 },
					["Centurion"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 53, 57, 61, 65, 69 },
					["Centurion"] = { 77, 81 },
					["Tribune"] = { 85 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Centurion"] = { 84, 88, 92 },
					["Tribune"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Centurion"] = { 91, 95, 99, 103 },
					["Tribune"] = { 115 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Centurion"] = { 98, 102, 106, 110, 114 },
					["Tribune"] = { 122, 126 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Roman Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Legionary"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Standard Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Centurion"] = { 79, 81, 83, 85, 87, 89, 91 },
					["Tribune"] = { 96, 99, 102 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 3: Imperial Walls
	["Rome_ImperialWalls"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2 },
					["Roman Archer"] = { 5, 6 },
					["Legionary"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3 },
					["Roman Archer"] = { 6, 7, 8 },
					["Legionary"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 44, 48 },
					["Centurion"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 47, 51, 55 },
					["Centurion"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 50, 54, 58, 62 },
					["Centurion"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 53, 57, 61, 65, 69 },
					["Centurion"] = { 77, 81 },
					["Tribune"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Centurion"] = { 84, 88, 92 },
					["Tribune"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Centurion"] = { 91, 95, 99, 103 },
					["Tribune"] = { 115 },
					["Praetorian Guard"] = { 125 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Centurion"] = { 98, 102, 106, 110, 114 },
					["Tribune"] = { 122, 126 },
					["Praetorian Guard"] = { 140 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 55, 57, 59, 61, 63, 65, 67, 69, 71 },
					["Centurion"] = { 76, 78, 80, 82, 84, 86 },
					["Tribune"] = { 91, 94, 97 },
					["Praetorian Guard"] = { 102, 105, 108 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 4: Chariot Onslaught
	["Rome_ChariotOnslaught"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3 },
					["Roman Archer"] = { 6, 7, 8 },
					["Legionary"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 44, 48 },
					["Centurion"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 47, 51, 55 },
					["Centurion"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 50, 54, 58, 62 },
					["Centurion"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 53, 57, 61, 65, 69 },
					["Centurion"] = { 77, 81 },
					["Tribune"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Centurion"] = { 84, 88, 92 },
					["Tribune"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Centurion"] = { 91, 95, 99, 103 },
					["Tribune"] = { 115 },
					["Praetorian Guard"] = { 125 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Centurion"] = { 98, 102, 106, 110, 114 },
					["Tribune"] = { 122, 126 },
					["Praetorian Guard"] = { 140 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Roman Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Legionary"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Standard Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Centurion"] = { 79, 81, 83, 85, 87, 89, 91 },
					["Tribune"] = { 96, 99, 102 },
					["Praetorian Guard"] = { 107, 110, 113 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 5: Sacred Arena
	["Rome_SacredArena"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3 },
					["Roman Archer"] = { 6, 7, 8 },
					["Legionary"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 44, 48 },
					["Centurion"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 47, 51, 55 },
					["Centurion"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 50, 54, 58, 62 },
					["Centurion"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 53, 57, 61, 65, 69 },
					["Centurion"] = { 77, 81 },
					["Tribune"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Centurion"] = { 84, 88, 92 },
					["Tribune"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Centurion"] = { 91, 95, 99, 103 },
					["Tribune"] = { 115 },
					["Praetorian Guard"] = { 125 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Centurion"] = { 98, 102, 106, 110, 114 },
					["Tribune"] = { 122, 126 },
					["Praetorian Guard"] = { 140 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Roman Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Legionary"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Standard Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Centurion"] = { 79, 81, 83, 85, 87, 89, 91 },
					["Tribune"] = { 96, 99, 102, 105 },
					["Praetorian Guard"] = { 110, 113, 116 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 6: Final Triumph
	["Rome_FinalTriumph"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3 },
					["Roman Archer"] = { 6, 7, 8 },
					["Legionary"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 44, 48 },
					["Centurion"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 47, 51, 55 },
					["Centurion"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 43, 47, 51, 55 },
					["Centurion"] = { 62, 66 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 53, 57, 61, 65, 69 },
					["Centurion"] = { 77, 81 },
					["Tribune"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Centurion"] = { 84, 88, 92 },
					["Tribune"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 59, 63, 67, 71, 75, 79, 83 },
					["Centurion"] = { 91, 95, 99, 103 },
					["Tribune"] = { 115 },
					["Praetorian Guard"] = { 125 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 62, 66, 70, 74, 78, 82, 86, 90 },
					["Centurion"] = { 98, 102, 106, 110, 114 },
					["Tribune"] = { 122, 126 },
					["Praetorian Guard"] = { 140 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Roman Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Legionary"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Standard Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Centurion"] = { 79, 81, 83, 85, 87, 89, 91 },
					["Tribune"] = { 96, 99, 102, 105, 108 },
					["Praetorian Guard"] = { 113, 116, 119, 122 },
					["Trajan"] = { 127 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- China Level 1: Yellow River Defense
	["China_YellowRiverDefense"] = {
		Data = {
			[1] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 6, 7, 8 },
					["Chinese Archer"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Shield Bearer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Shield Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Shield Bearer"] = { 44, 48 },
					["Chinese Commander"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Shield Bearer"] = { 47, 51, 55 },
					["Chinese Commander"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Shield Bearer"] = { 50, 54, 58, 62 },
					["Chinese Commander"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Shield Bearer"] = { 53, 57, 61, 65, 69 },
					["Chinese Commander"] = { 77, 81 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Chinese Commander"] = { 84, 88, 92 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Shield Bearer"] = { 52, 54, 56, 58, 60, 62, 64 },
					["Chinese Commander"] = { 69, 72, 75, 78 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Shield Bearer"] = { 55, 57, 59, 61, 63, 65, 67, 69 },
					["Chinese Commander"] = { 74, 77, 80, 83, 86 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Shield Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Chinese Commander"] = { 79, 81, 83, 85, 87, 89 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- China Level 2: Terracotta Barrage
	["China_TerracottaBarrage"] = {
		Data = {
			[1] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 6, 7, 8 },
					["Chinese Archer"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 35 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Shield Bearer"] = { 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Shield Bearer"] = { 41, 45 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Shield Bearer"] = { 44, 48 },
					["Chinese Commander"] = { 55 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Shield Bearer"] = { 47, 51, 55 },
					["Chinese Commander"] = { 62 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Shield Bearer"] = { 50, 54, 58, 62 },
					["Chinese Commander"] = { 70, 74 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Shield Bearer"] = { 53, 57, 61, 65, 69 },
					["Chinese Commander"] = { 77, 81 },
					["Imperial Guard"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 56, 60, 64, 68, 72, 76 },
					["Chinese Commander"] = { 84, 88, 92 },
					["Imperial Guard"] = { 100 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Shield Bearer"] = { 52, 54, 56, 58, 60, 62, 64 },
					["Chinese Commander"] = { 69, 72, 75, 78 },
					["Imperial Guard"] = { 83, 86 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Shield Bearer"] = { 55, 57, 59, 61, 63, 65, 67, 69 },
					["Chinese Commander"] = { 74, 77, 80, 83, 86 },
					["Imperial Guard"] = { 91, 94, 97 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Shield Bearer"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74 },
					["Chinese Commander"] = { 79, 81, 83, 85, 87, 89, 91 },
					["Imperial Guard"] = { 96, 99, 102, 105 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- China Level 3: Great Wall Stand
	["China_GreatWallStand"] = {
		Data = {
			[1] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2 },
					["Chinese Spearman"] = { 5, 6 },
					["Chinese Archer"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 6, 7, 8 },
					["Chinese Archer"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Shield Bearer"] = { 43 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Shield Bearer"] = { 53, 57 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 56, 60, 64 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Shield Bearer"] = { 59, 63, 67, 71 },
					["Chinese Commander"] = { 75 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Shield Bearer"] = { 55, 57, 59, 61, 63 },
					["Chinese Commander"] = { 68, 71 },
					["Imperial Guard"] = { 76, 79 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- China Level 4: Imperial Cavalry
	["China_ImperialCavalry"] = {
		Data = {
			[1] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2 },
					["Chinese Spearman"] = { 5, 6 },
					["Chinese Archer"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 6, 7, 8 },
					["Chinese Archer"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 30 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 33 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Shield Bearer"] = { 36, 40 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Shield Bearer"] = { 39, 43 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Shield Bearer"] = { 42, 46, 50 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Shield Bearer"] = { 45, 49, 53, 57 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Shield Bearer"] = { 48, 52, 56, 60, 64 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Shield Bearer"] = { 51, 55, 59, 63, 67, 71 },
					["Chinese Commander"] = { 75 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 54, 58, 62, 66, 70, 74, 78 },
					["Chinese Commander"] = { 87, 91 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Shield Bearer"] = { 57, 61, 65, 69, 73, 77, 81, 85 },
					["Chinese Commander"] = { 94, 98, 102 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Shield Bearer"] = { 60, 64, 68, 72, 76, 80, 84, 88, 92 },
					["Chinese Commander"] = { 101, 105, 109, 113 },
					["Imperial Guard"] = { 125 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- China Level 5: Sacred Scrolls
	["China_SacredScrolls"] = {
		Data = {
			[1] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 6, 7, 8 },
					["Chinese Archer"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21 },
				},
				Length = 70,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
					["Chinese Commander"] = { 35 },
				},
				Length = 80,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Chinese Commander"] = { 38, 42 },
				},
				Length = 90,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Commander"] = { 41, 45, 49 },
				},
				Length = 100,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Chinese Commander"] = { 44, 48, 52, 56 },
				},
				Length = 110,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Commander"] = { 47, 51, 55, 59, 63 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Chinese Commander"] = { 50, 54, 58, 62, 66, 70 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Chinese Commander"] = { 53, 57, 61, 65, 69, 73, 77 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Chinese Commander"] = { 56, 60, 64, 68, 72, 76, 80, 84 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Chinese Commander"] = { 59, 63, 67, 71, 75, 79, 83, 87, 91 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Chinese Commander"] = { 62, 66, 70, 74, 78, 82, 86, 90, 94, 98 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Chinese Commander"] = { 65, 69, 73, 77, 81, 85, 89, 93, 97, 101, 105 },
					["Imperial Guard"] = { 120 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- China Level 6: Final Dynasty
	["China_FinalDynasty"] = {
		Data = {
			[1] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 6, 7, 8 },
					["Chinese Archer"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
					["Imperial Guard"] = { 35 },
				},
				Length = 80,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Imperial Guard"] = { 38, 42 },
				},
				Length = 90,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Imperial Guard"] = { 41, 45, 49 },
				},
				Length = 100,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Imperial Guard"] = { 44, 48, 52, 56 },
				},
				Length = 110,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Imperial Guard"] = { 47, 51, 55, 59, 63 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Imperial Guard"] = { 50, 54, 58, 62, 66, 70 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Imperial Guard"] = { 53, 57, 61, 65, 69, 73, 77 },
					["Chinese Commander"] = { 90 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Imperial Guard"] = { 56, 60, 64, 68, 72, 76, 80, 84 },
					["Chinese Commander"] = { 97 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Imperial Guard"] = { 59, 63, 67, 71, 75, 79, 83, 87, 91 },
					["Chinese Commander"] = { 104, 108 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Imperial Guard"] = { 62, 66, 70, 74, 78, 82, 86, 90, 94, 98 },
					["Chinese Commander"] = { 111, 115, 119 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Chinese Commander"] = { 83, 86, 89, 92 },
					["Imperial Guard"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78 },
					["Qin Shi Huang"] = { 85 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 1: Knights Stand
	["Medieval_KnightsStand"] = {
		Data = {
			[1] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3 },
					["Medieval Spearman"] = { 6, 7, 8 },
					["Axeman"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18 },
				},
				Length = 50,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21 },
				},
				Length = 55,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 60,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Axeman"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 65,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 70,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 75,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 80,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Axeman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 85,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Axeman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Knight"] = { 55 },
				},
				Length = 90,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 58, 62 },
				},
				Length = 95,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 61, 65, 69 },
				},
				Length = 100,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 64, 68, 72, 76 },
				},
				Length = 105,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Axeman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Knight"] = { 67, 71, 75, 79, 83 },
					["Medieval Captain"] = { 92, 96 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 2: Archers Volley
	["Medieval_ArchersVolley"] = {
		Data = {
			[1] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3 },
					["Medieval Spearman"] = { 6, 7, 8 },
					["Axeman"] = { 11, 12 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Axeman"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Axeman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Axeman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Knight"] = { 55 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 58, 62 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 61, 65, 69 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 64, 68, 72, 76 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Axeman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Knight"] = { 67, 71, 75, 79 },
					["Medieval Captain"] = { 88 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 3: Shield Wall
	["Medieval_ShieldWall"] = {
		Data = {
			[1] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2 },
					["Medieval Spearman"] = { 5, 6 },
					["Axeman"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3 },
					["Medieval Spearman"] = { 6, 7, 8 },
					["Axeman"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Axeman"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Axeman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Knight"] = { 43 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Axeman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Knight"] = { 53, 57 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 56, 60, 64 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 59, 63, 67, 71 },
					["Medieval Captain"] = { 75 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 62, 66, 70, 74, 78 },
					["Medieval Captain"] = { 87, 91 },
					["Bodyguard"] = { 105, 109 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 4: Cavalry Charge
	["Medieval_CavalryCharge"] = {
		Data = {
			[1] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2 },
					["Medieval Spearman"] = { 5, 6 },
					["Axeman"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3 },
					["Medieval Spearman"] = { 6, 7, 8 },
					["Axeman"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Axeman"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Axeman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Knight"] = { 43 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Axeman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Knight"] = { 53, 57 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 56, 60, 64 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 59, 63, 67, 71 },
					["Medieval Captain"] = { 75 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 62, 66, 70, 74, 78 },
					["Medieval Captain"] = { 87, 91 },
					["Banneret"] = { 105 },
					["Bodyguard"] = { 115 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 5: Sacred Relics
	["Medieval_SacredRelics"] = {
		Data = {
			[1] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2 },
					["Medieval Spearman"] = { 5, 6 },
					["Axeman"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3 },
					["Medieval Spearman"] = { 6, 7, 8 },
					["Axeman"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Axeman"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Axeman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Knight"] = { 43 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Axeman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Knight"] = { 53, 57 },
					["Medieval Captain"] = { 61 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 56, 60, 64 },
					["Medieval Captain"] = { 75, 80 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 59, 63, 67, 71 },
					["Medieval Captain"] = { 82, 87, 92 },
					["Banneret"] = { 105 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 62, 66, 70, 74, 78 },
					["Medieval Captain"] = { 89, 94, 99, 104 },
					["Banneret"] = { 115, 119 },
					["Bodyguard"] = { 140, 144 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 6: Final Crusade
	["Medieval_FinalCrusade"] = {
		Data = {
			[1] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2 },
					["Medieval Spearman"] = { 5, 6 },
					["Axeman"] = { 9 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3 },
					["Medieval Spearman"] = { 6, 7, 8 },
					["Axeman"] = { 11, 12 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Axeman"] = { 21, 22, 23, 24, 25, 26, 27 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Axeman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Knight"] = { 43 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Axeman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Knight"] = { 53, 57 },
					["Medieval Captain"] = { 61 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 56, 60, 64 },
					["Medieval Captain"] = { 75, 80 },
					["Banneret"] = { 95 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 59, 63, 67, 71 },
					["Medieval Captain"] = { 82, 87, 92 },
					["Banneret"] = { 105, 109 },
					["Bodyguard"] = { 130 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 55, 57, 59, 61, 63 },
					["Medieval Captain"] = { 68, 71, 74, 77 },
					["Banneret"] = { 82, 85, 88 },
					["Bodyguard"] = { 92, 94 },
					["Charlemagne"] = { 97 },
				},
				Length = 2000,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
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

return Data
