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
	["Tutorial"] = {
		Data = {
			[1] = {
				Enemies = {
					["PCER"] = { 1, 2, 3 },
					["Water"] = { 5, 6, 7 },
					["Cheney"] = { 9, 10, 11 },
				},
				Length = 20,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["PCER"] = { 1, 2, 3, 4 },
					["Water"] = { 6, 7, 8, 9 },
					["Cheney"] = { 11, 12, 13, 14 },
				},
				Length = 45,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["PCER"] = { 1, 2, 3, 4, 5 },
					["Water"] = { 7, 8, 9, 10, 11 },
					["Cheney"] = { 13, 14, 15, 16, 17 },
				},
				Length = 45,
				CoinBonus = 140,
			},
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
					["Charioteer"] = { 25 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26 },
					["Charioteer"] = { 31 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 24, 25, 26, 27, 28, 29, 30 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 43 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Charioteer"] = { 40, 42, 44 },
					["War Priest"] = { 48 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
					["Charioteer"] = { 44, 46, 48, 50 },
					["War Priest"] = { 53, 55 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 },
					["Charioteer"] = { 45, 47, 49, 51, 53 },
					["War Priest"] = { 57, 59 },
					["Egyptian Commander"] = { 63 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44 },
					["Charioteer"] = { 48, 50, 52, 54, 56, 58 },
					["War Priest"] = { 63, 65, 67 },
					["Egyptian Commander"] = { 71 },
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
					["Egyptian Commander"] = { 79 },
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
					["Egyptian Commander"] = { 85, 87 },
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
					["Egyptian Commander"] = { 94, 96, 98 },
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
					["Charioteer"] = { 35 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 37, 39 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Charioteer"] = { 40, 42 },
					["War Priest"] = { 46 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 43, 45, 47 },
					["War Priest"] = { 51 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 46, 48, 50 },
					["War Priest"] = { 54 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Charioteer"] = { 49, 51, 53, 55 },
					["War Priest"] = { 59, 61 },
					["Egyptian Commander"] = { 65 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Egyptian Spearman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Charioteer"] = { 52, 54, 56, 58 },
					["War Priest"] = { 62, 64, 66 },
					["Egyptian Commander"] = { 72 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Egyptian Spearman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Charioteer"] = { 55, 57, 59, 63, 67 },
					["War Priest"] = { 70, 72, 74, 76 },
					["Egyptian Commander"] = { 80 },
					["Royal Guard"] = { 84 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Egyptian Spearman"] = { 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Charioteer"] = { 58, 60, 62, 64, 66, 68 },
					["War Priest"] = { 72, 74, 76, 78, 80 },
					["Egyptian Commander"] = { 84, 86 },
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
					["Charioteer"] = { 26 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 19, 20, 21, 22, 23, 24, 25 },
					["Charioteer"] = { 29 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26, 27, 28 },
					["Charioteer"] = { 32, 34 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Charioteer"] = { 35, 37 },
					["War Priest"] = { 41 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 38, 40, 42 },
					["War Priest"] = { 46 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Charioteer"] = { 41, 43, 45, 47, 49 },
					["War Priest"] = { 53, 55 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 44, 46, 48, 50, 52, 56 },
					["War Priest"] = { 61, 63 },
					["Egyptian Commander"] = { 66 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 47, 49, 51, 53, 55, 59 },
					["War Priest"] = { 63, 65, 67 },
					["Egyptian Commander"] = { 71 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Charioteer"] = { 50, 52, 54, 58, 62, 66 },
					["War Priest"] = { 71, 73, 75, 77 },
					["Egyptian Commander"] = { 80 },
					["Royal Guard"] = { 84 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Charioteer"] = { 51, 53, 55, 57, 61, 65, 69, 73 },
					["War Priest"] = { 77, 79, 81, 83, 85 },
					["Egyptian Commander"] = { 89, 91 },
					["Royal Guard"] = { 95 },
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
					["Royal Guard"] = { 103, 105 },
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13, 14 },
					["Egyptian Spearman"] = { 18, 19, 20, 21, 22 },
					["Charioteer"] = { 26, 27, 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 20, 21, 22, 23, 24, 25 },
					["Charioteer"] = { 29, 30, 31, 32 },
					["War Priest"] = { 36 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 22, 23, 24, 25, 26, 27, 28 },
					["Charioteer"] = { 32, 33, 34, 35, 36 },
					["War Priest"] = { 40 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 24, 25, 26, 27, 28, 29, 30, 31 },
					["Charioteer"] = { 35, 36, 37, 38, 39, 40 },
					["War Priest"] = { 44, 46 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 38, 39, 40, 41, 42, 43, 44 },
					["War Priest"] = { 48, 50 },
					["Egyptian Commander"] = { 54 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Charioteer"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
					["War Priest"] = { 50, 52, 53 },
					["Egyptian Commander"] = { 56 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["War Priest"] = { 55, 57, 59, 61 },
					["Egyptian Commander"] = { 64, 66 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 47, 48, 49, 50, 51, 52, 53, 54, 55, 56 },
					["War Priest"] = { 61, 63, 65, 67, 69 },
					["Egyptian Commander"] = { 72, 74 },
					["Royal Guard"] = { 78 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Spearman"] = { 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Charioteer"] = { 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60 },
					["War Priest"] = { 63, 65, 67, 69, 71, 73 },
					["Egyptian Commander"] = { 76, 78 },
					["Royal Guard"] = { 82 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Spearman"] = { 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Charioteer"] = { 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 },
					["War Priest"] = { 67, 69, 71, 73, 75 },
					["Egyptian Commander"] = { 78, 80, 82 },
					["Royal Guard"] = { 85, 87 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Spearman"] = { 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["Charioteer"] = { 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
					["War Priest"] = { 71, 73, 75, 77, 79, 81 },
					["Egyptian Commander"] = { 84, 86, 88, 90 },
					["Royal Guard"] = { 93, 95 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Egyptian Spearman"] = { 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Charioteer"] = { 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72 },
					["War Priest"] = { 75, 77, 79, 81, 83, 85, 87, 89, 91 },
					["Egyptian Commander"] = { 94, 96, 98, 100, 102 },
					["Royal Guard"] = { 105, 107, 109 },
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
					["Charioteer"] = { 15 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2 },
					["Egyptian Archer"] = { 6, 7, 8, 9 },
					["Egyptian Spearman"] = { 13, 14, 15, 16 },
					["Charioteer"] = { 20 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3 },
					["Egyptian Archer"] = { 7, 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 15, 16, 17, 18, 19 },
					["Charioteer"] = { 23, 24 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 8, 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 17, 18, 19, 20, 21, 22 },
					["Charioteer"] = { 26, 27, 28 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 19, 20, 21, 22, 23, 24, 25 },
					["Charioteer"] = { 29, 30, 31, 32 },
					["War Priest"] = { 36 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26, 27, 28 },
					["Charioteer"] = { 32, 33, 34, 35, 36 },
					["War Priest"] = { 40 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Charioteer"] = { 35, 36, 37, 38, 39, 40 },
					["War Priest"] = { 44, 46 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 38, 39, 40, 41, 42, 43, 44 },
					["War Priest"] = { 48, 50 },
					["Egyptian Commander"] = { 53 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 },
					["Charioteer"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
					["War Priest"] = { 51, 53, 55 },
					["Egyptian Commander"] = { 59 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 },
					["Charioteer"] = { 44, 45, 46, 47, 48, 49, 50, 51, 52 },
					["War Priest"] = { 55, 57, 59, 63 },
					["Egyptian Commander"] = { 66, 68 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 },
					["Charioteer"] = { 47, 48, 49, 50, 51, 52, 53, 54, 55, 56 },
					["War Priest"] = { 60, 62, 64, 66, 68 },
					["Egyptian Commander"] = { 71, 73 },
					["Royal Guard"] = { 77 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
					["Charioteer"] = { 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60 },
					["War Priest"] = { 63, 65, 67, 69, 71, 75 },
					["Egyptian Commander"] = { 79, 81 },
					["Royal Guard"] = { 85 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 },
					["Charioteer"] = { 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63 },
					["War Priest"] = { 67, 69, 71, 73, 75, 77, 79 },
					["Egyptian Commander"] = { 82, 84, 86 },
					["Royal Guard"] = { 90, 92 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Egyptian Spearman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Charioteer"] = { 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65 },
					["War Priest"] = { 69, 71, 73, 75, 77, 79, 81 },
					["Egyptian Commander"] = { 85, 87, 89, 91 },
					["Royal Guard"] = { 94, 96 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Egyptian Spearman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 },
					["Charioteer"] = { 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73 },
					["War Priest"] = { 78, 80, 82, 84, 86, 88, 90, 92, 94 },
					["Egyptian Commander"] = { 99, 102, 105, 108, 111 },
					["Royal Guard"] = { 115, 117, 119, 121 },
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
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 7, 8, 9 },
					["Egyptian Spearman"] = { 13, 14 },
				},
				Length = 45,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 16, 17, 18 },
				},
				Length = 50,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14 },
					["Egyptian Spearman"] = { 17, 18, 19, 20 },
					["Charioteer"] = { 24 },
				},
				Length = 55,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26 },
					["Charioteer"] = { 30 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29 },
					["Charioteer"] = { 32, 34 },
					["War Priest"] = { 38 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 44 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 44 },
					["Egyptian Commander"] = { 48 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32 },
					["Charioteer"] = { 35, 37, 39, 41, 43 },
					["War Priest"] = { 47, 49, 51 },
					["Egyptian Commander"] = { 54 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Charioteer"] = { 38, 40, 42 },
					["War Priest"] = { 46, 48, 50, 52 },
					["Egyptian Commander"] = { 56, 58 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 46, 48, 50, 52 },
					["Egyptian Commander"] = { 56, 58 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Charioteer"] = { 37, 39, 41, 43, 45 },
					["War Priest"] = { 49, 51, 53, 55 },
					["Egyptian Commander"] = { 58, 60 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
					["Charioteer"] = { 40, 42, 44, 46, 48, 50, 52 },
					["War Priest"] = { 56, 58, 60, 62 },
					["Egyptian Commander"] = { 66, 68 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Charioteer"] = { 40, 42, 44, 46, 48, 50, 52, 54 },
					["War Priest"] = { 58, 60, 62, 64, 66 },
					["Egyptian Commander"] = { 70, 72, 74 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 30, 31, 32, 33, 34, 35 },
					["Charioteer"] = { 39, 41, 43, 45 },
					["War Priest"] = { 48, 50, 52, 54, 56, 58 },
					["Egyptian Commander"] = { 62, 64, 66, 68 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Spearman"] = { 28, 29, 30, 31, 32, 33, 34, 35 },
					["Charioteer"] = { 39, 41, 43, 45, 47, 49, 51, 53, 55, 57 },
					["War Priest"] = { 60, 62, 64, 66, 68, 70, 72, 74 },
					["Egyptian Commander"] = { 78, 80, 82, 84, 86, 88 },
					["Ramesses II"] = { 93 },
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
					["Greek Calvaryman"] = { 27 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 32 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 34, 36 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 37 }, -- trimmed to end before Strategos 55
					["Strategos"] = { 41 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 40, 42 }, -- trimmed to end before Strategos 62
					["Strategos"] = { 46 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 43, 45, 47 }, -- trimmed to end before Strategos 70
					["Strategos"] = { 51, 53 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 47, 49, 51, 53 },
					["Strategos"] = { 57, 59, 61 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 48, 50, 52, 54, 56 },
					["Strategos"] = { 60, 62, 64 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 51, 53, 55, 57 },
					["Strategos"] = { 60, 62, 64, 68 },
					["Polemarch"] = { 71 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 54, 56, 58, 60, 62, 64 },
					["Strategos"] = { 68, 70, 72, 74, 76 },
					["Polemarch"] = { 80, 82 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70 },
					["Strategos"] = { 75, 77, 79, 81 },
					["Polemarch"] = { 84, 86, 88 },
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
					["Greek Calvaryman"] = { 25 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 34, 36, 38 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 35, 37, 39, 41 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 36, 38, 40, 42, 44 },
					["Strategos"] = { 48 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 39, 41, 43, 45, 47 },
					["Strategos"] = { 50, 52 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 42, 44, 46, 48, 50, 52 },
					["Strategos"] = { 56, 58 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 45, 47, 49, 51, 53, 55 },
					["Strategos"] = { 58, 60, 62 },
					["Polemarch"] = { 65 },
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
					["Strategos"] = { 60, 62, 64, 66 },
					["Polemarch"] = { 69 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 55, 59 },
					["Strategos"] = { 62, 64, 66 },
					["Polemarch"] = { 70, 72 },
					["Palace Guard"] = { 75 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 56, 58, 60 },
					["Strategos"] = { 64, 66, 68 },
					["Polemarch"] = { 73, 75, 77 },
					["Palace Guard"] = { 80 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76 },
					["Strategos"] = { 82, 84, 86, 88, 90, 92, 94 },
					["Polemarch"] = { 98, 100, 102, 104 },
					["Palace Guard"] = { 107, 109, 111 },
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
					["Greek Calvaryman"] = { 26 },
				},
				Length = 60,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 28, 30 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 32, 34, 36 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 35, 37, 39, 41 },
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
					["Strategos"] = { 56 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 47, 51, 55 },
					["Strategos"] = { 58, 60 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 50, 54 },
					["Strategos"] = { 55, 57, 59 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 53, 57 },
					["Strategos"] = { 58, 60 },
					["Polemarch"] = { 65 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 52, 54, 56 },
					["Strategos"] = { 60, 62 },
					["Polemarch"] = { 71 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 52, 54 },
					["Strategos"] = { 58, 60 },
					["Polemarch"] = { 65, 67 },
					["Palace Guard"] = { 70 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 58, 60, 62, 64 },
					["Strategos"] = { 68, 70 },
					["Polemarch"] = { 73, 75, 77 }, -- 70->73 gap 3
					["Palace Guard"] = { 80 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66 },
					["Strategos"] = { 68, 70, 72, 74, 76, 78, 80 },
					["Polemarch"] = { 83, 85, 87, 89 },
					["Palace Guard"] = { 92, 94, 96 },
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
					["Greek Calvaryman"] = { 28, 30 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 29, 31, 33 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 32, 34, 36, 38 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 35, 37, 39, 41 },
					["Strategos"] = { 45 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 38, 40, 42, 44, 46 },
					["Strategos"] = { 49, 51 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 45, 47, 49, 51, 53 },
					["Strategos"] = { 56, 58, 60 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 44, 46, 48, 50, 52, 54, 56 },
					["Strategos"] = { 60, 64 },
					["Polemarch"] = { 67 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 51, 53, 55, 57, 59, 63, 67 },
					["Strategos"] = { 70, 72 },
					["Polemarch"] = { 76 },
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
					["Strategos"] = { 62, 64, 66, 68, 70 },
					["Polemarch"] = { 73, 75 },
					["Palace Guard"] = { 78 },
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
					["Strategos"] = { 62, 64, 66, 68, 70, 72 },
					["Polemarch"] = { 75, 77, 79 },
					["Palace Guard"] = { 82 },
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
					["Strategos"] = { 79, 81, 83, 85, 87, 89, 91 },
					["Polemarch"] = { 94, 96, 98, 100 },
					["Palace Guard"] = { 103, 105, 107 },
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
					["Strategos"] = { 38, 40, 42, 44 },
					["Greek Calvaryman"] = { 49 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 43, 45, 47, 49, 51 },
					["Strategos"] = { 55, 57 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 48, 50, 52, 54, 56 },
					["Strategos"] = { 60, 62 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 49, 51, 53, 55 },
					["Strategos"] = { 60, 62 },
					["Polemarch"] = { 58 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 52, 54, 56, 58 },
					["Strategos"] = { 60, 62, 64, 66 },
					["Polemarch"] = { 70, 72 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 49, 51, 53 },
					["Strategos"] = { 55, 57, 59, 61, 63, 65, 67 },
					["Polemarch"] = { 70, 72, 74 },
					["Palace Guard"] = { 78 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Greek Calvaryman"] = { 52, 54, 56 },
					["Strategos"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76 },
					["Polemarch"] = { 75, 77, 79 },
					["Palace Guard"] = { 82 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 52, 54, 56, 58 },
					["Strategos"] = { 64, 66, 68, 70, 72, 74, 76, 78 },
					["Polemarch"] = { 83, 85, 87, 89, 91 },
					["Palace Guard"] = { 97, 99, 101 },
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
					["Greek Calvaryman"] = { 25 },
				},
				Length = 60,
				CoinBonus = 520,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 29, 31 },
				},
				Length = 65,
				CoinBonus = 560,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Greek Calvaryman"] = { 32, 34, 36 },
					["Strategos"] = { 40 },
				},
				Length = 70,
				CoinBonus = 600,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Hoplite"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Greek Calvaryman"] = { 37, 39, 41, 43 },
					["Strategos"] = { 46, 48 },
				},
				Length = 75,
				CoinBonus = 640,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Greek Calvaryman"] = { 40, 42, 44, 46 },
					["Strategos"] = { 50, 52, 54 },
					["Polemarch"] = { 58 },
				},
				Length = 80,
				CoinBonus = 680,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Greek Calvaryman"] = { 39, 41, 43, 45, 47 },
					["Strategos"] = { 51, 53, 55, 57 },
					["Polemarch"] = { 61, 63 },
				},
				Length = 85,
				CoinBonus = 720,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Greek Calvaryman"] = { 46, 48, 50, 52, 54, 56, 58 },
					["Strategos"] = { 61, 63, 65, 67, 69 },
					["Polemarch"] = { 74, 76, 78 },
					["Palace Guard"] = { 81 },
				},
				Length = 90,
				CoinBonus = 760,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Hoplite"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Greek Calvaryman"] = { 45, 47, 49, 53, 57, 59 },
					["Strategos"] = { 61, 63, 65, 67, 69 },
					["Polemarch"] = { 73, 75, 77, 79, 81 },
					["Palace Guard"] = { 84, 86, 88 },
				},
				Length = 95,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Greek Calvaryman"] = { 48, 50, 52, 54, 56, 58, 60 },
					["Strategos"] = { 63, 65, 67, 69 },
					["Polemarch"] = { 74, 75, 77, 79, 81 },
					["Palace Guard"] = { 84, 86, 88 },
				},
				Length = 100,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Hoplite"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 51, 52, 53, 54, 55, 56, 57, 58, 59 },
					["Strategos"] = { 63, 65, 67 },
					["Polemarch"] = { 70, 72, 74, 76 },
					["Palace Guard"] = { 79, 81, 83, 85 },
				},
				Length = 105,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Hoplite"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Greek Calvaryman"] = { 51, 52, 53, 54, 55, 56, 57 },
					["Strategos"] = { 60, 62, 64, 66, 68, 70, 72, 74 },
					["Polemarch"] = { 77, 79, 81, 83, 85, 87 },
					["Palace Guard"] = { 90 },
				},
				Length = 110,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Hoplite"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Greek Calvaryman"] = { 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78 }, -- trimmed to end before Strategos 81
					["Strategos"] = { 81, 83, 85, 87, 89, 91, 93, 95, 97, 99 }, -- shifted earlier to preserve gaps
					["Polemarch"] = { 103, 105, 107, 109, 111, 113, 115, 117 }, -- earlier for 3s gap to Palace Guard
					["Palace Guard"] = { 120, 122, 124, 126, 128, 130 }, -- earlier for 3s gap to Pyrrhus
					["Pyrrhus"] = { 133 },
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
					["Standard Bearer"] = { 34, 36 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 37, 39 },
					["Centurion"] = { 43 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 40, 42, 44 },
					["Centurion"] = { 48 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 43, 45, 47, 49 },
					["Centurion"] = { 52, 54 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 45, 47, 49, 51, 53 },
					["Centurion"] = { 56, 58 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 50, 52, 54, 56, 58, 60 },
					["Centurion"] = { 64, 66, 68 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 51, 53, 55, 57, 59, 61, 63 },
					["Centurion"] = { 67, 69, 71, 73 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 56, 58, 60, 62, 64, 66, 68, 70 },
					["Centurion"] = { 74, 76, 78, 80, 82 },
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
					["Standard Bearer"] = { 27 },
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
					["Standard Bearer"] = { 34, 36 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 39, 41, 43 },
					["Centurion"] = { 48 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 44, 46, 48, 50 },
					["Centurion"] = { 55, 57 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 45, 47, 49, 51, 53, 55, 57 },
					["Centurion"] = { 62, 64 },
					["Tribune"] = { 68 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 49, 51, 53, 55, 57, 59 },
					["Centurion"] = { 62, 64, 66 },
					["Tribune"] = { 70 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 53, 55, 57, 59, 61, 63, 65 },
					["Centurion"] = { 69, 71, 73, 75 },
					["Tribune"] = { 79 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 54, 56, 58, 60, 62, 64, 66, 68 },
					["Centurion"] = { 72, 74, 76, 78 },
					["Tribune"] = { 82, 84 },
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
					["Standard Bearer"] = { 24 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Standard Bearer"] = { 31, 33 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Legionary"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Standard Bearer"] = { 34, 36 },
					["Centurion"] = { 40 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 37, 39, 41 },
					["Centurion"] = { 45 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 40, 42, 44, 46 },
					["Centurion"] = { 52, 54 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 43, 45, 47, 49, 51 },
					["Centurion"] = { 55, 57 },
					["Tribune"] = { 62 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 46, 48, 50, 52, 54, 56 },
					["Centurion"] = { 60, 62, 64, 66 },
					["Tribune"] = { 70 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 49, 53, 55, 57, 59, 61, 63 },
					["Centurion"] = { 67, 69, 71, 73 },
					["Tribune"] = { 77 },
					["Praetorian Guard"] = { 81 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 52, 54, 56, 58, 60, 62, 66, 70 },
					["Centurion"] = { 74, 76, 78, 80, 82 },
					["Tribune"] = { 86, 88 },
					["Praetorian Guard"] = { 92 },
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
					["Standard Bearer"] = { 34, 36 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 37, 39 },
					["Centurion"] = { 44 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 41, 43, 45 },
					["Centurion"] = { 49 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 43, 45, 47, 49 },
					["Centurion"] = { 52, 54 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 46, 48, 50, 52, 54 },
					["Centurion"] = { 59, 61 },
					["Tribune"] = { 65 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 49, 51, 53, 55, 57, 59 },
					["Centurion"] = { 63, 65, 67 },
					["Tribune"] = { 71 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 51, 53, 55, 57, 59, 61, 63 },
					["Centurion"] = { 67, 69, 71, 73 },
					["Tribune"] = { 76 },
					["Praetorian Guard"] = { 80 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 54, 56, 58, 60, 62, 64, 66, 68 },
					["Centurion"] = { 71, 73, 75, 77, 79 },
					["Tribune"] = { 83, 85 },
					["Praetorian Guard"] = { 88 },
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
					["Standard Bearer"] = { 29 },
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
					["Standard Bearer"] = { 34, 36 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Standard Bearer"] = { 37, 39 },
					["Centurion"] = { 43 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 41, 43, 45 },
					["Centurion"] = { 50 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Standard Bearer"] = { 43, 45, 47, 49 },
					["Centurion"] = { 53, 55 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 47, 49, 51, 53, 55 },
					["Centurion"] = { 59, 61 },
					["Tribune"] = { 66 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 50, 52, 54, 56, 58, 60 },
					["Centurion"] = { 65, 67, 69 },
					["Tribune"] = { 75 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 53, 55, 57, 59, 61, 63, 65 },
					["Centurion"] = { 70, 72, 74, 76 },
					["Tribune"] = { 79 },
					["Praetorian Guard"] = { 83 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 54, 56, 58, 60, 62, 64, 66, 68, 70 },
					["Centurion"] = { 74, 76, 78, 80, 82 },
					["Tribune"] = { 85, 87 },
					["Praetorian Guard"] = { 90 },
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
					["Praetorian Guard"] = { 109, 111, 113 },
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
					["Standard Bearer"] = { 36, 38 },
					["Centurion"] = { 42 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Standard Bearer"] = { 41, 43, 45 },
					["Centurion"] = { 49 },
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
					["Centurion"] = { 59, 61 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Legionary"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Standard Bearer"] = { 47, 49, 51, 53, 55 },
					["Centurion"] = { 59, 61 },
					["Tribune"] = { 65 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Standard Bearer"] = { 49, 51, 53, 55, 57, 61, 65 },
					["Centurion"] = { 69, 71, 73 },
					["Tribune"] = { 77 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Legionary"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Standard Bearer"] = { 51, 53, 55, 57, 59, 61, 63 },
					["Centurion"] = { 67, 69, 71, 73 },
					["Tribune"] = { 76 },
					["Praetorian Guard"] = { 80 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Legionary"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Standard Bearer"] = { 57, 59, 61, 63, 65, 67, 69, 71 },
					["Centurion"] = { 75, 77, 79, 81, 83 },
					["Tribune"] = { 87, 89 },
					["Praetorian Guard"] = { 93 },
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
					["Shield Bearer"] = { 30 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Shield Bearer"] = { 31 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Shield Bearer"] = { 34, 36 },
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
					["Chinese General"] = { 57 },
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
					["Chinese General"] = { 64 },
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
					["Chinese General"] = { 76 },
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
					["Shield Bearer"] = { 29 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Shield Bearer"] = { 31 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Shield Bearer"] = { 35, 37 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Shield Bearer"] = { 37, 39 },
					["Chinese Commander"] = { 43 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Shield Bearer"] = { 40, 42, 44 },
					["Chinese Commander"] = { 49 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Shield Bearer"] = { 44, 46, 48, 50 },
					["Chinese Commander"] = { 55, 57 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Shield Bearer"] = { 46, 48, 50, 52, 54 },
					["Chinese Commander"] = { 60, 62 },
					["Chinese General"] = { 65 },
					["Imperial Guard"] = { 68 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 50, 52, 54, 56, 58, 60 },
					["Chinese Commander"] = { 65, 67, 69 },
					["Chinese General"] = { 73 },
					["Imperial Guard"] = { 78 },
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
				["Chinese General"] = { 96 },
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
					["Shield Bearer"] = { 45, 47 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 48, 50, 52 },
					["Chinese General"] = { 55 },
				},

				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Shield Bearer"] = { 53, 55, 57, 59 },
					["Chinese Commander"] = { 63 },
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
				["Chinese General"] = { 88 },
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
					["Shield Bearer"] = { 25 },
				},
				Length = 65,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27 },
				},
				Length = 70,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Shield Bearer"] = { 31, 32 },
				},
				Length = 75,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Shield Bearer"] = { 34, 36 },
				},
				Length = 80,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Shield Bearer"] = { 36, 38, 40 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Shield Bearer"] = { 41, 43, 45, 47 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Shield Bearer"] = { 43, 45, 47, 49, 51 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Shield Bearer"] = { 47, 49, 51, 53, 55 },
					["Chinese Commander"] = { 59 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Shield Bearer"] = { 50, 52, 54, 56, 58 },
					["Chinese Commander"] = { 62, 64 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Shield Bearer"] = { 52, 54, 56, 58, 60, 62, 64 },
					["Chinese Commander"] = { 69, 71, 73 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Shield Bearer"] = { 56, 58, 60, 62, 64, 66, 68, 70 },
					["Chinese Commander"] = { 75, 77, 79 },
					["Imperial Guard"] = { 82 },
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
					["Chinese Commander"] = { 30 },
				},
				Length = 80,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Chinese Commander"] = { 32, 34 },
				},
				Length = 90,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Commander"] = { 35, 37, 39 },
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
					["Chinese Commander"] = { 62, 64, 66, 68, 70, 72 },
					["Chinese General"] = { 77, 79 },
				},

				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Chinese Commander"] = { 65, 67, 69, 71, 73, 75, 77 },
					["Chinese General"] = { 79, 81, 83 },
					["Imperial Guard"] = { 88 },
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
					["Imperial Guard"] = { 30 },
				},
				Length = 80,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18 },
					["Chinese Archer"] = { 21, 22, 23, 24, 25, 26, 27 },
					["Imperial Guard"] = { 33, 35 },
				},
				Length = 90,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20 },
					["Chinese Archer"] = { 23, 24, 25, 26, 27, 28, 29, 30 },
					["Imperial Guard"] = { 36, 38, 40 },
				},
				Length = 100,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Chinese Archer"] = { 25, 26, 27, 28, 29, 30, 31, 32, 33 },
					["Imperial Guard"] = { 37, 39, 41, 43 },
				},
				Length = 110,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Chinese Archer"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Imperial Guard"] = { 39, 41, 43, 45, 47 },
				},
				Length = 85,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Chinese Archer"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 },
					["Imperial Guard"] = { 43, 45, 48, 51, 53, 55 },
				},
				Length = 90,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Chinese Archer"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 },
					["Imperial Guard"] = { 53, 55, 57, 59, 61, 63, 65 },
					["Chinese Commander"] = { 70 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Chinese Archer"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Imperial Guard"] = { 49, 51, 53, 55, 57, 59, 61 },
					["Chinese Commander"] = { 65 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Chinese Archer"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Imperial Guard"] = { 59, 61, 63, 65, 67, 69, 71, 73 },
					["Chinese Commander"] = { 75, 79 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Chinese Archer"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Imperial Guard"] = { 62, 64, 66, 68, 70, 72, 74 },
					["Chinese Commander"] = { 79, 81, 83 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Chinese Archer"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Chinese Commander"] = { 57, 59, 61, 63 },
					["Imperial Guard"] = { 66, 68, 70, 72, 74, 76, 78 },
					["Qin Shi Huang"] = { 81 },
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
					["Knight"] = { 46 },
				},
				Length = 90,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 49, 51 },
				},
				Length = 95,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 51, 53, 55 },
				},
				Length = 100,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 55, 57, 59, 61 },
				},
				Length = 105,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Axeman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Knight"] = { 57, 59, 61, 63, 65 },
					["Medieval Captain"] = { 69, 71 },
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
					["Knight"] = { 46 },
				},
				Length = 95,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 48, 50 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 51, 53, 55 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 56, 58, 60 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Axeman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54 },
					["Knight"] = { 67, 69, 71, 73 },
					["Medieval Captain"] = { 76 },
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
					["Knight"] = { 45, 47 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 56, 58, 60 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 52, 54, 56, 58 },
					["Medieval Captain"] = { 62 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 54, 56, 58, 60, 62 },
					["Medieval Captain"] = { 66, 68 },
					["Bodyguard"] = { 72, 74 },
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
					["Knight"] = { 45, 47 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 50, 52, 54 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 51, 53, 55, 57 },
					["Medieval Captain"] = { 60 },
				},
				Length = 110,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Axeman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51 },
					["Knight"] = { 62, 64, 66, 68, 70 },
					["Medieval Captain"] = { 74, 76 },
					["Banneret"] = { 80 },
					["Bodyguard"] = { 84 },
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
					["Knight"] = { 47, 49 },
					["Medieval Captain"] = { 53 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 50, 52, 54 },
					["Medieval Captain"] = { 58, 60 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 52, 54, 56, 58 },
					["Medieval Captain"] = { 62, 64, 66 },
					["Banneret"] = { 70 },
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
					["Medieval Captain"] = { 66, 68, 70, 72 },
					["Banneret"] = { 75, 77 },
					["Bodyguard"] = { 81 },
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
					["Knight"] = { 46, 48 },
					["Medieval Captain"] = { 52 },
				},
				Length = 100,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Axeman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 },
					["Knight"] = { 49, 51, 53 },
					["Medieval Captain"] = { 56, 58, 60 },
					["Banneret"] = { 64, 66, 68 },
				},
				Length = 105,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Axeman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 },
					["Knight"] = { 51, 53, 55, 57 },
					["Medieval Captain"] = { 60, 62, 64 },
					["Banneret"] = { 68, 70 },
					["Bodyguard"] = { 74 },
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
					["Medieval Captain"] = { 67, 69, 71, 73 },
					["Banneret"] = { 76, 78, 80 },
					["Bodyguard"] = { 84, 86 },
					["Charlemagne"] = { 90 },
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

local InfiniteData: { [string]: InfiniteData } = {
	["AncientEgypt_Infinite"] = {
		Data = {
			["Egyptian Scout"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 1,
			},
			["Egyptian Archer"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 2,
			},
			["Egyptian Spearman"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 3,
			},
			["Charioteer"] = {
				FirstSpawnWave = 2,
				SpawnCount = 8,
				OrderPriority = 4,
			},
			["War Priest"] = {
				FirstSpawnWave = 3,
				SpawnCount = 3,
				OrderPriority = 5,
			},
			["Egyptian Commander"] = {
				FirstSpawnWave = 5,
				SpawnCount = 2,
				OrderPriority = 6,
			},
			["Royal Guard"] = {
				FirstSpawnWave = 9,
				SpawnCount = 4,
				OrderPriority = 7,
				WaveDelay = 3,
			},
			["Ramesses II"] = {
				FirstSpawnWave = 15,
				SpawnCount = 1,
				OrderPriority = 8,
				WaveDelay = 15,
			},
		},
		EnemyData = {},
	},
	["Greece_Infinite"] = {
		Data = {
			["Peltast"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 1,
			},
			["Hoplite"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 2,
			},
			["Greek Slinger"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 3,
			},
			["Greek Calvaryman"] = {
				FirstSpawnWave = 2,
				SpawnCount = 8,
				OrderPriority = 4,
			},
			["Strategos"] = {
				FirstSpawnWave = 3,
				SpawnCount = 3,
				OrderPriority = 5,
			},
			["Polemarch"] = {
				FirstSpawnWave = 5,
				SpawnCount = 2,
				OrderPriority = 6,
			},
			["Palace Guard"] = {
				FirstSpawnWave = 9,
				SpawnCount = 4,
				OrderPriority = 7,
				WaveDelay = 3,
			},
			["Pyrrhus"] = {
				FirstSpawnWave = 15,
				SpawnCount = 1,
				OrderPriority = 8,
				WaveDelay = 15,
			},
		},
		EnemyData = {},
	},
	["Rome_Infinite"] = {
		Data = {
			["Roman Slinger"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 1,
			},
			["Legionary"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 2,
			},
			["Roman Archer"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 3,
			},
			["Standard Bearer"] = {
				FirstSpawnWave = 2,
				SpawnCount = 8,
				OrderPriority = 4,
			},
			["Centurion"] = {
				FirstSpawnWave = 3,
				SpawnCount = 3,
				OrderPriority = 5,
			},
			["Tribune"] = {
				FirstSpawnWave = 5,
				SpawnCount = 2,
				OrderPriority = 6,
			},
			["Praetorian Guard"] = {
				FirstSpawnWave = 9,
				SpawnCount = 4,
				OrderPriority = 7,
				WaveDelay = 3,
			},
			["Trajan"] = {
				FirstSpawnWave = 15,
				SpawnCount = 1,
				OrderPriority = 8,
				WaveDelay = 15,
			},
		},
		EnemyData = {},
	},
	["China_Infinite"] = {
		Data = {
			["Foot Soldier"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 1,
			},
			["Chinese Spearman"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 2,
			},
			["Chinese Archer"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 3,
			},
			["Shield Bearer"] = {
				FirstSpawnWave = 2,
				SpawnCount = 8,
				OrderPriority = 4,
			},
			["Chinese Commander"] = {
				FirstSpawnWave = 3,
				SpawnCount = 3,
				OrderPriority = 5,
			},
			["Imperial Guard"] = {
				FirstSpawnWave = 5,
				SpawnCount = 2,
				OrderPriority = 6,
			},
			["Qin Shi Huang"] = {
				FirstSpawnWave = 15,
				SpawnCount = 1,
				OrderPriority = 7,
				WaveDelay = 15,
			},
		},
		EnemyData = {},
	},
	["Medieval_Infinite"] = {
		Data = {
			["Medieval Footman"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 1,
			},
			["Medieval Spearman"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 2,
			},
			["Axeman"] = {
				FirstSpawnWave = 1,
				SpawnCount = 10,
				OrderPriority = 3,
			},
			["Knight"] = {
				FirstSpawnWave = 2,
				SpawnCount = 8,
				OrderPriority = 4,
			},
			["Medieval Captain"] = {
				FirstSpawnWave = 3,
				SpawnCount = 3,
				OrderPriority = 5,
			},
			["Banneret"] = {
				FirstSpawnWave = 5,
				SpawnCount = 2,
				OrderPriority = 6,
			},
			["Bodyguard"] = {
				FirstSpawnWave = 9,
				SpawnCount = 4,
				OrderPriority = 7,
				WaveDelay = 3,
			},
			["Charlemagne"] = {
				FirstSpawnWave = 15,
				SpawnCount = 1,
				OrderPriority = 8,
				WaveDelay = 15,
			},
		},
		EnemyData = {},
	},
}

Data.WaveData = WaveData
Data.InfiniteData = InfiniteData

table.freeze(Data)

return Data
