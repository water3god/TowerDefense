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
			[1] = { Enemies = { Zombie = { 1 } }, Length = 10, CoinBonus = 1 },
			[2] = { Enemies = { Zombie = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } }, Length = 20, CoinBonus = 1 },
			[3] = { Enemies = { Zombie = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } }, Length = 100, CoinBonus = 1 },
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 1: Desert Reconnaissance
	["AncientEgypt_DesertReconnaissance"] = {
		Data = {
			[1] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3 },
					["Egyptian Archer"] = { 6, 7 },
					["Egyptian Spearman"] = { 10 },
				},
				Length = 15,
				CoinBonus = 200,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 8, 9, 10 },
					["Egyptian Spearman"] = { 13, 14 },
				},
				Length = 21,
				CoinBonus = 220,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 9, 10, 11, 12 },
					["Egyptian Spearman"] = { 15, 16, 17 },
				},
				Length = 25,
				CoinBonus = 240,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14 },
					["Egyptian Spearman"] = { 17, 18, 19, 20 },
				},
				Length = 30,
				CoinBonus = 260,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16 },
					["Egyptian Spearman"] = { 19, 20, 21, 22, 23 },
				},
				Length = 34,
				CoinBonus = 280,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18 },
					["Egyptian Spearman"] = { 21, 22, 23, 24, 25, 26 },
				},
				Length = 39,
				CoinBonus = 300,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 24, 25, 26, 27, 28, 29 },
				},
				Length = 44,
				CoinBonus = 320,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 49,
				CoinBonus = 340,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 28, 29, 30, 31, 32, 33, 34, 35 },
				},
				Length = 54,
				CoinBonus = 360,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Spearman"] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
				},
				Length = 59,
				CoinBonus = 380,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					["Egyptian Spearman"] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 },
				},
				Length = 64,
				CoinBonus = 400,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					["Egyptian Spearman"] = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44 },
				},
				Length = 69,
				CoinBonus = 420,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					["Egyptian Spearman"] = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 74,
				CoinBonus = 440,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					["Egyptian Spearman"] = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50 },
				},
				Length = 79,
				CoinBonus = 460,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Archer"] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					["Egyptian Spearman"] = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53 },
				},
				Length = 84,
				CoinBonus = 480,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 2: Arrow Barrage
	["AncientEgypt_ArrowBarrage"] = {
		Data = {
			[1] = {
				Enemies = { ["Egyptian Scout"] = { 1, 2, 3 }, ["Egyptian Archer"] = { 6, 7, 8, 9, 10 } },
				Length = 15,
				CoinBonus = 220,
			},
			[2] = {
				Enemies = { ["Egyptian Scout"] = { 1, 2, 3, 4 }, ["Egyptian Archer"] = { 7, 8, 9, 10, 11, 12 } },
				Length = 21,
				CoinBonus = 242,
			},
			[3] = {
				Enemies = { ["Egyptian Scout"] = { 1, 2, 3, 4, 5 }, ["Egyptian Archer"] = { 8, 9, 10, 11, 12, 13, 14 } },
				Length = 27,
				CoinBonus = 264,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 33,
				CoinBonus = 286,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 308,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 45,
				CoinBonus = 330,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 51,
				CoinBonus = 352,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 57,
				CoinBonus = 374,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 63,
				CoinBonus = 396,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 69,
				CoinBonus = 418,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 440,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 81,
				CoinBonus = 462,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 87,
				CoinBonus = 484,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 93,
				CoinBonus = 506,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["War Priest"] = { 39 },
				},
				Length = 59,
				CoinBonus = 528,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 3: Shielded Formation
	["AncientEgypt_ShieldedFormation"] = {
		Data = {
			[1] = {
				Enemies = { ["Egyptian Spearman"] = { 1 } },
				Length = 2,
				CoinBonus = 250,
			},
			[2] = {
				Enemies = { ["Egyptian Spearman"] = { 1, 2 }, ["Egyptian Archer"] = { 5 } },
				Length = 7,
				CoinBonus = 275,
			},
			[3] = {
				Enemies = { ["Egyptian Spearman"] = { 1, 2, 3 }, ["Egyptian Archer"] = { 6, 7 } },
				Length = 10,
				CoinBonus = 300,
			},
			[4] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4 },
					["Egyptian Archer"] = { 7, 8, 9 },
					["Egyptian Scout"] = { 12 },
				},
				Length = 18,
				CoinBonus = 325,
			},
			[5] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Scout"] = { 14, 15 },
				},
				Length = 23,
				CoinBonus = 350,
			},
			[6] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Scout"] = { 16, 17, 18 },
				},
				Length = 27,
				CoinBonus = 375,
			},
			[7] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Scout"] = { 19, 20, 21, 22 },
				},
				Length = 33,
				CoinBonus = 400,
			},
			[8] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Scout"] = { 23, 24, 25, 26, 27 },
				},
				Length = 41,
				CoinBonus = 425,
			},
			[9] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Scout"] = { 28, 29, 30, 31, 32, 33 },
				},
				Length = 50,
				CoinBonus = 450,
			},
			[10] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Scout"] = { 34, 35, 36, 37, 38, 39, 40 },
				},
				Length = 61,
				CoinBonus = 475,
			},
			[11] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Scout"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
				},
				Length = 73,
				CoinBonus = 500,
			},
			[12] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Scout"] = { 49, 50, 51, 52, 53, 54, 55, 56, 57 },
				},
				Length = 88,
				CoinBonus = 525,
			},
			[13] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Egyptian Scout"] = { 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
				},
				Length = 105,
				CoinBonus = 550,
			},
			[14] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Egyptian Scout"] = { 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78 },
				},
				Length = 124,
				CoinBonus = 575,
			},
			[15] = {
				Enemies = {
					["Egyptian Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Egyptian Scout"] = { 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 },
					["Royal Guard"] = { 92, 93 },
					["War Priest"] = { 95 },
				},
				Length = 143,
				CoinBonus = 600,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 4: Chariot Assault
	["AncientEgypt_ChariotAssault"] = {
		Data = {
			[1] = {
				Enemies = { ["Charioteer"] = { 1, 2 }, ["Egyptian Scout"] = { 5, 6 } },
				Length = 9,
				CoinBonus = 300,
			},
			[2] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3 },
					["Egyptian Scout"] = { 5, 6, 7 },
					["Egyptian Archer"] = { 11 },
				},
				Length = 14,
				CoinBonus = 330,
			},
			[3] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4 },
					["Egyptian Scout"] = { 5, 6, 7, 8 },
					["Egyptian Archer"] = { 13, 14 },
				},
				Length = 19,
				CoinBonus = 360,
			},
			[4] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5 },
					["Egyptian Scout"] = { 6, 7, 8, 9 },
					["Egyptian Archer"] = { 15, 16, 17 },
				},
				Length = 24,
				CoinBonus = 390,
			},
			[5] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Scout"] = { 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 18, 19, 20, 21 },
				},
				Length = 29,
				CoinBonus = 420,
			},
			[6] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Scout"] = { 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 22, 23, 24, 25, 26 },
				},
				Length = 34,
				CoinBonus = 450,
			},
			[7] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Scout"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 27, 28, 29, 30, 31, 32 },
				},
				Length = 39,
				CoinBonus = 480,
			},
			[8] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Scout"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Archer"] = { 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 44,
				CoinBonus = 510,
			},
			[9] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Scout"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Archer"] = { 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 49,
				CoinBonus = 540,
			},
			[10] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Scout"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Archer"] = { 48, 49, 50, 51, 52, 53, 54, 55, 56 },
				},
				Length = 54,
				CoinBonus = 570,
			},
			[11] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Scout"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Archer"] = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66 },
				},
				Length = 59,
				CoinBonus = 600,
			},
			[12] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Scout"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Archer"] = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
				},
				Length = 64,
				CoinBonus = 630,
			},
			[13] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Scout"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Archer"] = { 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 },
				},
				Length = 69,
				CoinBonus = 660,
			},
			[14] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Scout"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Egyptian Archer"] = { 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 },
				},
				Length = 74,
				CoinBonus = 690,
			},
			[15] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Egyptian Scout"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Egyptian Archer"] = { 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 },
					["Royal Guard"] = { 120 },
				},
				Length = 81,
				CoinBonus = 720,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 5: Sacred Ritual
	["AncientEgypt_SacredRitual"] = {
		Data = {
			[1] = {
				Enemies = { ["War Priest"] = { 1 }, ["Egyptian Archer"] = { 1, 2, 3 } },
				Length = 50,
				CoinBonus = 350,
			},
			[2] = {
				Enemies = { ["War Priest"] = { 1, 2 }, ["Egyptian Archer"] = { 1, 2, 3, 4 } },
				Length = 75,
				CoinBonus = 385,
			},
			[3] = {
				Enemies = { ["War Priest"] = { 1, 2, 3 }, ["Egyptian Archer"] = { 1, 2, 3, 4, 5 } },
				Length = 100,
				CoinBonus = 420,
			},
			[4] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4 }, ["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 125,
				CoinBonus = 455,
			},
			[5] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4, 5 }, ["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 150,
				CoinBonus = 490,
			},
			[6] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4, 5, 6 }, ["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 175,
				CoinBonus = 525,
			},
			[7] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
				},
				Length = 200,
				CoinBonus = 560,
			},
			[8] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
				},
				Length = 225,
				CoinBonus = 595,
			},
			[9] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
				},
				Length = 250,
				CoinBonus = 630,
			},
			[10] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
				},
				Length = 275,
				CoinBonus = 665,
			},
			[11] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
				},
				Length = 300,
				CoinBonus = 700,
			},
			[12] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 325,
				CoinBonus = 735,
			},
			[13] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
				},
				Length = 350,
				CoinBonus = 770,
			},
			[14] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 375,
				CoinBonus = 805,
			},
			[15] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Archer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Commander"] = { 1 },
				},
				Length = 400,
				CoinBonus = 840,
			},
		},
		EnemyData = {},
	},

	-- Ancient Egypt Level 6: Final Defense
	["AncientEgypt_FinalDefense"] = {
		Data = {
			[1] = {
				Enemies = { ["Royal Guard"] = { 1 } },
				Length = 60,
				CoinBonus = 400,
			},
			[2] = {
				Enemies = { ["Royal Guard"] = { 1, 2 } },
				Length = 90,
				CoinBonus = 440,
			},
			[3] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3 } },
				Length = 120,
				CoinBonus = 480,
			},
			[4] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4 } },
				Length = 150,
				CoinBonus = 520,
			},
			[5] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4, 5 } },
				Length = 180,
				CoinBonus = 560,
			},
			[6] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 210,
				CoinBonus = 600,
			},
			[7] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 240,
				CoinBonus = 640,
			},
			[8] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 270,
				CoinBonus = 680,
			},
			[9] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 300,
				CoinBonus = 720,
			},
			[10] = {
				Enemies = { ["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
				Length = 330,
				CoinBonus = 760,
			},
			[11] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Commander"] = { 1 },
				},
				Length = 360,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Commander"] = { 1 },
				},
				Length = 390,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Commander"] = { 1, 2 },
				},
				Length = 420,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Commander"] = { 1, 2 },
				},
				Length = 450,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Egyptian Commander"] = { 1, 2, 3 },
					["Ramesses II"] = { 1 },
				},
				Length = 480,
				CoinBonus = 1000,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 1: Spartan Defense
	["Greece_SpartanDefense"] = {
		Data = {
			[1] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3 },
					["Hoplite"] = { 6, 7 },
				},
				Length = 15,
				CoinBonus = 200,
			},
			[2] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4 },
					["Hoplite"] = { 8, 9, 10 },
				},
				Length = 21,
				CoinBonus = 220,
			},
			[3] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 9, 10, 11, 12 },
				},
				Length = 25,
				CoinBonus = 240,
			},
			[4] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 10, 11, 12, 13, 14 },
				},
				Length = 30,
				CoinBonus = 260,
			},
			[5] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16 },
				},
				Length = 34,
				CoinBonus = 280,
			},
			[6] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 300,
			},
			[7] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 44,
				CoinBonus = 320,
			},
			[8] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 49,
				CoinBonus = 340,
			},
			[9] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 54,
				CoinBonus = 360,
			},
			[10] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 59,
				CoinBonus = 380,
			},
			[11] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 64,
				CoinBonus = 400,
			},
			[12] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 69,
				CoinBonus = 420,
			},
			[13] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Hoplite"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 74,
				CoinBonus = 440,
			},
			[14] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Hoplite"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 79,
				CoinBonus = 460,
			},
			[15] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Hoplite"] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 84,
				CoinBonus = 480,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 2: Olympian Challenge
	["Greece_OlympianChallenge"] = {
		Data = {
			[1] = {
				Enemies = { ["Greek Slinger"] = { 1, 2, 3 }, ["Greek Calvaryman"] = { 6, 7, 8, 9, 10 } },
				Length = 15,
				CoinBonus = 220,
			},
			[2] = {
				Enemies = { ["Greek Slinger"] = { 1, 2, 3, 4 }, ["Greek Calvaryman"] = { 7, 8, 9, 10, 11, 12 } },
				Length = 21,
				CoinBonus = 242,
			},
			[3] = {
				Enemies = { ["Greek Slinger"] = { 1, 2, 3, 4, 5 }, ["Greek Calvaryman"] = { 8, 9, 10, 11, 12, 13, 14 } },
				Length = 27,
				CoinBonus = 264,
			},
			[4] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Calvaryman"] = { 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 33,
				CoinBonus = 286,
			},
			[5] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Calvaryman"] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 308,
			},
			[6] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Calvaryman"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 45,
				CoinBonus = 330,
			},
			[7] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Calvaryman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 51,
				CoinBonus = 352,
			},
			[8] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Calvaryman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 57,
				CoinBonus = 374,
			},
			[9] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 63,
				CoinBonus = 396,
			},
			[10] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Calvaryman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 69,
				CoinBonus = 418,
			},
			[11] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 440,
			},
			[12] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Calvaryman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 81,
				CoinBonus = 462,
			},
			[13] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 87,
				CoinBonus = 484,
			},
			[14] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Calvaryman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 93,
				CoinBonus = 506,
			},
			[15] = {
				Enemies = {
					["Greek Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Strategos"] = { 39 },
				},
				Length = 59,
				CoinBonus = 528,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 3: Athenian Walls
	["Greece_AthenianWalls"] = {
		Data = {
			[1] = {
				Enemies = { ["Hoplite"] = { 1 } },
				Length = 2,
				CoinBonus = 250,
			},
			[2] = {
				Enemies = { ["Hoplite"] = { 1, 2 }, ["Greek Calvaryman"] = { 5 } },
				Length = 7,
				CoinBonus = 275,
			},
			[3] = {
				Enemies = { ["Hoplite"] = { 1, 2, 3 }, ["Greek Calvaryman"] = { 6, 7 } },
				Length = 10,
				CoinBonus = 300,
			},
			[4] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4 },
					["Greek Calvaryman"] = { 7, 8, 9 },
					["Greek Slinger"] = { 12 },
				},
				Length = 18,
				CoinBonus = 325,
			},
			[5] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5 },
					["Greek Calvaryman"] = { 8, 9, 10, 11 },
					["Greek Slinger"] = { 14, 15 },
				},
				Length = 23,
				CoinBonus = 350,
			},
			[6] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Calvaryman"] = { 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 16, 17, 18 },
				},
				Length = 27,
				CoinBonus = 375,
			},
			[7] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Calvaryman"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 19, 20, 21, 22 },
				},
				Length = 33,
				CoinBonus = 400,
			},
			[8] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Calvaryman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Slinger"] = { 23, 24, 25, 26, 27 },
				},
				Length = 41,
				CoinBonus = 425,
			},
			[9] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Calvaryman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Slinger"] = { 28, 29, 30, 31, 32, 33 },
				},
				Length = 50,
				CoinBonus = 450,
			},
			[10] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Calvaryman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Slinger"] = { 34, 35, 36, 37, 38, 39, 40 },
				},
				Length = 61,
				CoinBonus = 475,
			},
			[11] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Slinger"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
				},
				Length = 73,
				CoinBonus = 500,
			},
			[12] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Calvaryman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Greek Slinger"] = { 49, 50, 51, 52, 53, 54, 55, 56, 57 },
				},
				Length = 88,
				CoinBonus = 525,
			},
			[13] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Greek Slinger"] = { 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
				},
				Length = 105,
				CoinBonus = 550,
			},
			[14] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Calvaryman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Greek Slinger"] = { 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78 },
				},
				Length = 124,
				CoinBonus = 575,
			},
			[15] = {
				Enemies = {
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Greek Slinger"] = { 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 },
					["Palace Guard"] = { 92, 93 },
					["Strategos"] = { 95 },
				},
				Length = 143,
				CoinBonus = 600,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 4: Phalanx Advance
	["Greece_PhalanxAdvance"] = {
		Data = {
			[1] = {
				Enemies = { ["Greek Calvaryman"] = { 1, 2 }, ["Greek Slinger"] = { 5, 6 } },
				Length = 9,
				CoinBonus = 300,
			},
			[2] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3 },
					["Greek Slinger"] = { 5, 6, 7 },
					["Hoplite"] = { 11 },
				},
				Length = 14,
				CoinBonus = 330,
			},
			[3] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4 },
					["Greek Slinger"] = { 5, 6, 7, 8 },
					["Hoplite"] = { 13, 14 },
				},
				Length = 19,
				CoinBonus = 360,
			},
			[4] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5 },
					["Greek Slinger"] = { 6, 7, 8, 9 },
					["Hoplite"] = { 15, 16, 17 },
				},
				Length = 24,
				CoinBonus = 390,
			},
			[5] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6 },
					["Greek Slinger"] = { 7, 8, 9, 10, 11 },
					["Hoplite"] = { 18, 19, 20, 21 },
				},
				Length = 29,
				CoinBonus = 420,
			},
			[6] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Greek Slinger"] = { 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 22, 23, 24, 25, 26 },
				},
				Length = 34,
				CoinBonus = 450,
			},
			[7] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Greek Slinger"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Hoplite"] = { 27, 28, 29, 30, 31, 32 },
				},
				Length = 39,
				CoinBonus = 480,
			},
			[8] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Greek Slinger"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Hoplite"] = { 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 44,
				CoinBonus = 510,
			},
			[9] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Greek Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Hoplite"] = { 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 49,
				CoinBonus = 540,
			},
			[10] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Greek Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Hoplite"] = { 48, 49, 50, 51, 52, 53, 54, 55, 56 },
				},
				Length = 54,
				CoinBonus = 570,
			},
			[11] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Greek Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Hoplite"] = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66 },
				},
				Length = 59,
				CoinBonus = 600,
			},
			[12] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Greek Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Hoplite"] = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
				},
				Length = 64,
				CoinBonus = 630,
			},
			[13] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Greek Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Hoplite"] = { 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 },
				},
				Length = 69,
				CoinBonus = 660,
			},
			[14] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Greek Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Hoplite"] = { 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 },
				},
				Length = 74,
				CoinBonus = 690,
			},
			[15] = {
				Enemies = {
					["Greek Calvaryman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Greek Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Hoplite"] = { 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 },
					["Palace Guard"] = { 120 },
				},
				Length = 81,
				CoinBonus = 720,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 5: Oracle's Prophecy
	["Greece_OraclesProphecy"] = {
		Data = {
			[1] = {
				Enemies = { ["Strategos"] = { 1 }, ["Hoplite"] = { 1, 2, 3 } },
				Length = 50,
				CoinBonus = 350,
			},
			[2] = {
				Enemies = { ["Strategos"] = { 1, 2 }, ["Hoplite"] = { 1, 2, 3, 4 } },
				Length = 75,
				CoinBonus = 385,
			},
			[3] = {
				Enemies = { ["Strategos"] = { 1, 2, 3 }, ["Hoplite"] = { 1, 2, 3, 4, 5 } },
				Length = 100,
				CoinBonus = 420,
			},
			[4] = {
				Enemies = { ["Strategos"] = { 1, 2, 3, 4 }, ["Hoplite"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 125,
				CoinBonus = 455,
			},
			[5] = {
				Enemies = { ["Strategos"] = { 1, 2, 3, 4, 5 }, ["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 150,
				CoinBonus = 490,
			},
			[6] = {
				Enemies = { ["Strategos"] = { 1, 2, 3, 4, 5, 6 }, ["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 175,
				CoinBonus = 525,
			},
			[7] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
				},
				Length = 200,
				CoinBonus = 560,
			},
			[8] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
				},
				Length = 225,
				CoinBonus = 595,
			},
			[9] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
				},
				Length = 250,
				CoinBonus = 630,
			},
			[10] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
				},
				Length = 275,
				CoinBonus = 665,
			},
			[11] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
				},
				Length = 300,
				CoinBonus = 700,
			},
			[12] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 325,
				CoinBonus = 735,
			},
			[13] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
				},
				Length = 350,
				CoinBonus = 770,
			},
			[14] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 375,
				CoinBonus = 805,
			},
			[15] = {
				Enemies = {
					["Strategos"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Hoplite"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Polemarch"] = { 1 },
				},
				Length = 400,
				CoinBonus = 840,
			},
		},
		EnemyData = {},
	},

	-- Greece Level 6: Final Stand
	["Greece_FinalStand"] = {
		Data = {
			[1] = {
				Enemies = { ["Palace Guard"] = { 1 } },
				Length = 60,
				CoinBonus = 400,
			},
			[2] = {
				Enemies = { ["Palace Guard"] = { 1, 2 } },
				Length = 90,
				CoinBonus = 440,
			},
			[3] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3 } },
				Length = 120,
				CoinBonus = 480,
			},
			[4] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4 } },
				Length = 150,
				CoinBonus = 520,
			},
			[5] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4, 5 } },
				Length = 180,
				CoinBonus = 560,
			},
			[6] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 210,
				CoinBonus = 600,
			},
			[7] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 240,
				CoinBonus = 640,
			},
			[8] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 270,
				CoinBonus = 680,
			},
			[9] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 300,
				CoinBonus = 720,
			},
			[10] = {
				Enemies = { ["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
				Length = 330,
				CoinBonus = 760,
			},
			[11] = {
				Enemies = {
					["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Polemarch"] = { 1 },
				},
				Length = 360,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Polemarch"] = { 1 },
				},
				Length = 390,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Polemarch"] = { 1, 2 },
				},
				Length = 420,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Polemarch"] = { 1, 2 },
				},
				Length = 450,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Palace Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Polemarch"] = { 1, 2, 3 },
					["Pyrrhus"] = { 1 },
				},
				Length = 480,
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
					["Legionary"] = { 6, 7 },
				},
				Length = 15,
				CoinBonus = 200,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4 },
					["Legionary"] = { 8, 9, 10 },
				},
				Length = 21,
				CoinBonus = 220,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 9, 10, 11, 12 },
				},
				Length = 25,
				CoinBonus = 240,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 10, 11, 12, 13, 14 },
				},
				Length = 30,
				CoinBonus = 260,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16 },
				},
				Length = 34,
				CoinBonus = 280,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 300,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 44,
				CoinBonus = 320,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 49,
				CoinBonus = 340,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 54,
				CoinBonus = 360,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 59,
				CoinBonus = 380,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 64,
				CoinBonus = 400,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 69,
				CoinBonus = 420,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Legionary"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 74,
				CoinBonus = 440,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Legionary"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 79,
				CoinBonus = 460,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Legionary"] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 84,
				CoinBonus = 480,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 2: Centurion's Charge
	["Rome_CenturionsCharge"] = {
		Data = {
			[1] = {
				Enemies = { ["Roman Slinger"] = { 1, 2, 3 }, ["Roman Archer"] = { 6, 7, 8, 9, 10 } },
				Length = 15,
				CoinBonus = 220,
			},
			[2] = {
				Enemies = { ["Roman Slinger"] = { 1, 2, 3, 4 }, ["Roman Archer"] = { 7, 8, 9, 10, 11, 12 } },
				Length = 21,
				CoinBonus = 242,
			},
			[3] = {
				Enemies = { ["Roman Slinger"] = { 1, 2, 3, 4, 5 }, ["Roman Archer"] = { 8, 9, 10, 11, 12, 13, 14 } },
				Length = 27,
				CoinBonus = 264,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 33,
				CoinBonus = 286,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 308,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 45,
				CoinBonus = 330,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 51,
				CoinBonus = 352,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 57,
				CoinBonus = 374,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 63,
				CoinBonus = 396,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 69,
				CoinBonus = 418,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 440,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 81,
				CoinBonus = 462,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 87,
				CoinBonus = 484,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 93,
				CoinBonus = 506,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Roman Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Centurion"] = { 39 },
				},
				Length = 59,
				CoinBonus = 528,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 3: Imperial Walls
	["Rome_ImperialWalls"] = {
		Data = {
			[1] = {
				Enemies = { ["Legionary"] = { 1 } },
				Length = 2,
				CoinBonus = 250,
			},
			[2] = {
				Enemies = { ["Legionary"] = { 1, 2 }, ["Roman Archer"] = { 5 } },
				Length = 7,
				CoinBonus = 275,
			},
			[3] = {
				Enemies = { ["Legionary"] = { 1, 2, 3 }, ["Roman Archer"] = { 6, 7 } },
				Length = 10,
				CoinBonus = 300,
			},
			[4] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4 },
					["Roman Archer"] = { 7, 8, 9 },
					["Roman Slinger"] = { 12 },
				},
				Length = 18,
				CoinBonus = 325,
			},
			[5] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5 },
					["Roman Archer"] = { 8, 9, 10, 11 },
					["Roman Slinger"] = { 14, 15 },
				},
				Length = 23,
				CoinBonus = 350,
			},
			[6] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Archer"] = { 9, 10, 11, 12, 13 },
					["Roman Slinger"] = { 16, 17, 18 },
				},
				Length = 27,
				CoinBonus = 375,
			},
			[7] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Roman Slinger"] = { 19, 20, 21, 22 },
				},
				Length = 33,
				CoinBonus = 400,
			},
			[8] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Roman Slinger"] = { 23, 24, 25, 26, 27 },
				},
				Length = 41,
				CoinBonus = 425,
			},
			[9] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Roman Slinger"] = { 28, 29, 30, 31, 32, 33 },
				},
				Length = 50,
				CoinBonus = 450,
			},
			[10] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Roman Slinger"] = { 34, 35, 36, 37, 38, 39, 40 },
				},
				Length = 61,
				CoinBonus = 475,
			},
			[11] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Roman Slinger"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
				},
				Length = 73,
				CoinBonus = 500,
			},
			[12] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Roman Slinger"] = { 49, 50, 51, 52, 53, 54, 55, 56, 57 },
				},
				Length = 88,
				CoinBonus = 525,
			},
			[13] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Roman Slinger"] = { 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
				},
				Length = 105,
				CoinBonus = 550,
			},
			[14] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Roman Slinger"] = { 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78 },
				},
				Length = 124,
				CoinBonus = 575,
			},
			[15] = {
				Enemies = {
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Roman Slinger"] = { 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 },
					["Praetorian Guard"] = { 92, 93 },
					["Centurion"] = { 95 },
				},
				Length = 143,
				CoinBonus = 600,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 4: Chariot Onslaught
	["Rome_ChariotOnslaught"] = {
		Data = {
			[1] = {
				Enemies = { ["Standard Bearer"] = { 1, 2 }, ["Roman Slinger"] = { 5, 6 } },
				Length = 9,
				CoinBonus = 300,
			},
			[2] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3 },
					["Roman Slinger"] = { 5, 6, 7 },
					["Legionary"] = { 11 },
				},
				Length = 14,
				CoinBonus = 330,
			},
			[3] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4 },
					["Roman Slinger"] = { 5, 6, 7, 8 },
					["Legionary"] = { 13, 14 },
				},
				Length = 19,
				CoinBonus = 360,
			},
			[4] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5 },
					["Roman Slinger"] = { 6, 7, 8, 9 },
					["Legionary"] = { 15, 16, 17 },
				},
				Length = 24,
				CoinBonus = 390,
			},
			[5] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6 },
					["Roman Slinger"] = { 7, 8, 9, 10, 11 },
					["Legionary"] = { 18, 19, 20, 21 },
				},
				Length = 29,
				CoinBonus = 420,
			},
			[6] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Roman Slinger"] = { 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 22, 23, 24, 25, 26 },
				},
				Length = 34,
				CoinBonus = 450,
			},
			[7] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Roman Slinger"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Legionary"] = { 27, 28, 29, 30, 31, 32 },
				},
				Length = 39,
				CoinBonus = 480,
			},
			[8] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Roman Slinger"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Legionary"] = { 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 44,
				CoinBonus = 510,
			},
			[9] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Roman Slinger"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Legionary"] = { 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 49,
				CoinBonus = 540,
			},
			[10] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Roman Slinger"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Legionary"] = { 48, 49, 50, 51, 52, 53, 54, 55, 56 },
				},
				Length = 54,
				CoinBonus = 570,
			},
			[11] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Roman Slinger"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Legionary"] = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66 },
				},
				Length = 59,
				CoinBonus = 600,
			},
			[12] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Roman Slinger"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Legionary"] = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
				},
				Length = 64,
				CoinBonus = 630,
			},
			[13] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Roman Slinger"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Legionary"] = { 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 },
				},
				Length = 69,
				CoinBonus = 660,
			},
			[14] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Roman Slinger"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Legionary"] = { 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 },
				},
				Length = 74,
				CoinBonus = 690,
			},
			[15] = {
				Enemies = {
					["Standard Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Roman Slinger"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Legionary"] = { 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 },
					["Praetorian Guard"] = { 120 },
				},
				Length = 81,
				CoinBonus = 720,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 5: Sacred Arena
	["Rome_SacredArena"] = {
		Data = {
			[1] = {
				Enemies = { ["Centurion"] = { 1 }, ["Legionary"] = { 1, 2, 3 } },
				Length = 50,
				CoinBonus = 350,
			},
			[2] = {
				Enemies = { ["Centurion"] = { 1, 2 }, ["Legionary"] = { 1, 2, 3, 4 } },
				Length = 75,
				CoinBonus = 385,
			},
			[3] = {
				Enemies = { ["Centurion"] = { 1, 2, 3 }, ["Legionary"] = { 1, 2, 3, 4, 5 } },
				Length = 100,
				CoinBonus = 420,
			},
			[4] = {
				Enemies = { ["Centurion"] = { 1, 2, 3, 4 }, ["Legionary"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 125,
				CoinBonus = 455,
			},
			[5] = {
				Enemies = { ["Centurion"] = { 1, 2, 3, 4, 5 }, ["Legionary"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 150,
				CoinBonus = 490,
			},
			[6] = {
				Enemies = { ["Centurion"] = { 1, 2, 3, 4, 5, 6 }, ["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 175,
				CoinBonus = 525,
			},
			[7] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
				},
				Length = 200,
				CoinBonus = 560,
			},
			[8] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
				},
				Length = 225,
				CoinBonus = 595,
			},
			[9] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
				},
				Length = 250,
				CoinBonus = 630,
			},
			[10] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
				},
				Length = 275,
				CoinBonus = 665,
			},
			[11] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
				},
				Length = 300,
				CoinBonus = 700,
			},
			[12] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 325,
				CoinBonus = 735,
			},
			[13] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
				},
				Length = 350,
				CoinBonus = 770,
			},
			[14] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 375,
				CoinBonus = 805,
			},
			[15] = {
				Enemies = {
					["Centurion"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Legionary"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Tribune"] = { 1 },
				},
				Length = 400,
				CoinBonus = 840,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 6: Final Triumph
	["Rome_FinalTriumph"] = {
		Data = {
			[1] = {
				Enemies = { ["Praetorian Guard"] = { 1 } },
				Length = 60,
				CoinBonus = 400,
			},
			[2] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2 } },
				Length = 90,
				CoinBonus = 440,
			},
			[3] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3 } },
				Length = 120,
				CoinBonus = 480,
			},
			[4] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4 } },
				Length = 150,
				CoinBonus = 520,
			},
			[5] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4, 5 } },
				Length = 180,
				CoinBonus = 560,
			},
			[6] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 210,
				CoinBonus = 600,
			},
			[7] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 240,
				CoinBonus = 640,
			},
			[8] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 270,
				CoinBonus = 680,
			},
			[9] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 300,
				CoinBonus = 720,
			},
			[10] = {
				Enemies = { ["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
				Length = 330,
				CoinBonus = 760,
			},
			[11] = {
				Enemies = {
					["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Tribune"] = { 1 },
				},
				Length = 360,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Tribune"] = { 1 },
				},
				Length = 390,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Tribune"] = { 1, 2 },
				},
				Length = 420,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Tribune"] = { 1, 2 },
				},
				Length = 450,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Praetorian Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Tribune"] = { 1, 2, 3 },
					["Trajan"] = { 1 },
				},
				Length = 480,
				CoinBonus = 1000,
			},
		},
		EnemyData = {},
	},

	-- China Level 1: Yellow River Defense
	["China_YellowRiverDefense"] = {
		Data = {
			[1] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3 },
					["Foot Soldier"] = { 6, 7 },
				},
				Length = 15,
				CoinBonus = 200,
			},
			[2] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4 },
					["Foot Soldier"] = { 8, 9, 10 },
				},
				Length = 21,
				CoinBonus = 220,
			},
			[3] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5 },
					["Foot Soldier"] = { 9, 10, 11, 12 },
				},
				Length = 25,
				CoinBonus = 240,
			},
			[4] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6 },
					["Foot Soldier"] = { 10, 11, 12, 13, 14 },
				},
				Length = 30,
				CoinBonus = 260,
			},
			[5] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Foot Soldier"] = { 11, 12, 13, 14, 15, 16 },
				},
				Length = 34,
				CoinBonus = 280,
			},
			[6] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Foot Soldier"] = { 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 300,
			},
			[7] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Foot Soldier"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 44,
				CoinBonus = 320,
			},
			[8] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Foot Soldier"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 49,
				CoinBonus = 340,
			},
			[9] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Foot Soldier"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 54,
				CoinBonus = 360,
			},
			[10] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Foot Soldier"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 59,
				CoinBonus = 380,
			},
			[11] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Foot Soldier"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 64,
				CoinBonus = 400,
			},
			[12] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Foot Soldier"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 69,
				CoinBonus = 420,
			},
			[13] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Foot Soldier"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 74,
				CoinBonus = 440,
			},
			[14] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Foot Soldier"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 79,
				CoinBonus = 460,
			},
			[15] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Foot Soldier"] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 84,
				CoinBonus = 480,
			},
		},
		EnemyData = {},
	},

	-- China Level 2: Terracotta Barrage
	["China_TerracottaBarrage"] = {
		Data = {
			[1] = {
				Enemies = { ["Chinese Spearman"] = { 1, 2, 3 }, ["Chinese Archer"] = { 6, 7, 8, 9, 10 } },
				Length = 15,
				CoinBonus = 220,
			},
			[2] = {
				Enemies = { ["Chinese Spearman"] = { 1, 2, 3, 4 }, ["Chinese Archer"] = { 7, 8, 9, 10, 11, 12 } },
				Length = 21,
				CoinBonus = 242,
			},
			[3] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5 },
					["Chinese Archer"] = { 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 27,
				CoinBonus = 264,
			},
			[4] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Archer"] = { 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 33,
				CoinBonus = 286,
			},
			[5] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Archer"] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 308,
			},
			[6] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Archer"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 45,
				CoinBonus = 330,
			},
			[7] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 51,
				CoinBonus = 352,
			},
			[8] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 57,
				CoinBonus = 374,
			},
			[9] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 63,
				CoinBonus = 396,
			},
			[10] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 69,
				CoinBonus = 418,
			},
			[11] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 440,
			},
			[12] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 81,
				CoinBonus = 462,
			},
			[13] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 87,
				CoinBonus = 484,
			},
			[14] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Archer"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 93,
				CoinBonus = 506,
			},
			[15] = {
				Enemies = {
					["Chinese Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Archer"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Chinese Commander"] = { 39 },
				},
				Length = 59,
				CoinBonus = 528,
			},
		},
		EnemyData = {},
	},

	-- China Level 3: Great Wall Stand
	["China_GreatWallStand"] = {
		Data = {
			[1] = {
				Enemies = { ["Foot Soldier"] = { 1 } },
				Length = 2,
				CoinBonus = 250,
			},
			[2] = {
				Enemies = { ["Foot Soldier"] = { 1, 2 }, ["Chinese Archer"] = { 5 } },
				Length = 7,
				CoinBonus = 275,
			},
			[3] = {
				Enemies = { ["Foot Soldier"] = { 1, 2, 3 }, ["Chinese Archer"] = { 6, 7 } },
				Length = 10,
				CoinBonus = 300,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4 },
					["Chinese Archer"] = { 7, 8, 9 },
					["Chinese Spearman"] = { 12 },
				},
				Length = 18,
				CoinBonus = 325,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Archer"] = { 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15 },
				},
				Length = 23,
				CoinBonus = 350,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Archer"] = { 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18 },
				},
				Length = 27,
				CoinBonus = 375,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 19, 20, 21, 22 },
				},
				Length = 33,
				CoinBonus = 400,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Chinese Spearman"] = { 23, 24, 25, 26, 27 },
				},
				Length = 41,
				CoinBonus = 425,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Chinese Spearman"] = { 28, 29, 30, 31, 32, 33 },
				},
				Length = 50,
				CoinBonus = 450,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Chinese Spearman"] = { 34, 35, 36, 37, 38, 39, 40 },
				},
				Length = 61,
				CoinBonus = 475,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Chinese Spearman"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
				},
				Length = 73,
				CoinBonus = 500,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Chinese Spearman"] = { 49, 50, 51, 52, 53, 54, 55, 56, 57 },
				},
				Length = 88,
				CoinBonus = 525,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Chinese Spearman"] = { 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
				},
				Length = 105,
				CoinBonus = 550,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Chinese Spearman"] = { 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78 },
				},
				Length = 124,
				CoinBonus = 575,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Archer"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Chinese Spearman"] = { 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 },
					["Imperial Guard"] = { 92, 93 },
					["Chinese Commander"] = { 95 },
				},
				Length = 143,
				CoinBonus = 600,
			},
		},
		EnemyData = {},
	},

	-- China Level 4: Imperial Cavalry
	["China_ImperialCavalry"] = {
		Data = {
			[1] = {
				Enemies = { ["Shield Bearer"] = { 1, 2 }, ["Chinese Spearman"] = { 5, 6 } },
				Length = 9,
				CoinBonus = 300,
			},
			[2] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3 },
					["Chinese Spearman"] = { 5, 6, 7 },
					["Foot Soldier"] = { 11 },
				},
				Length = 14,
				CoinBonus = 330,
			},
			[3] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4 },
					["Chinese Spearman"] = { 5, 6, 7, 8 },
					["Foot Soldier"] = { 13, 14 },
				},
				Length = 19,
				CoinBonus = 360,
			},
			[4] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 6, 7, 8, 9 },
					["Foot Soldier"] = { 15, 16, 17 },
				},
				Length = 24,
				CoinBonus = 390,
			},
			[5] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 7, 8, 9, 10, 11 },
					["Foot Soldier"] = { 18, 19, 20, 21 },
				},
				Length = 29,
				CoinBonus = 420,
			},
			[6] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 8, 9, 10, 11, 12, 13 },
					["Foot Soldier"] = { 22, 23, 24, 25, 26 },
				},
				Length = 34,
				CoinBonus = 450,
			},
			[7] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Foot Soldier"] = { 27, 28, 29, 30, 31, 32 },
				},
				Length = 39,
				CoinBonus = 480,
			},
			[8] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Foot Soldier"] = { 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 44,
				CoinBonus = 510,
			},
			[9] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Foot Soldier"] = { 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 49,
				CoinBonus = 540,
			},
			[10] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Foot Soldier"] = { 48, 49, 50, 51, 52, 53, 54, 55, 56 },
				},
				Length = 54,
				CoinBonus = 570,
			},
			[11] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Foot Soldier"] = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66 },
				},
				Length = 59,
				CoinBonus = 600,
			},
			[12] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Foot Soldier"] = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
				},
				Length = 64,
				CoinBonus = 630,
			},
			[13] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Foot Soldier"] = { 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 },
				},
				Length = 69,
				CoinBonus = 660,
			},
			[14] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Foot Soldier"] = { 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 },
				},
				Length = 74,
				CoinBonus = 690,
			},
			[15] = {
				Enemies = {
					["Shield Bearer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Foot Soldier"] = { 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 },
					["Imperial Guard"] = { 120 },
				},
				Length = 81,
				CoinBonus = 720,
			},
		},
		EnemyData = {},
	},

	-- China Level 5: Sacred Scrolls
	["China_SacredScrolls"] = {
		Data = {
			[1] = {
				Enemies = { ["Chinese Commander"] = { 1 }, ["Foot Soldier"] = { 1, 2, 3 } },
				Length = 50,
				CoinBonus = 350,
			},
			[2] = {
				Enemies = { ["Chinese Commander"] = { 1, 2 }, ["Foot Soldier"] = { 1, 2, 3, 4 } },
				Length = 75,
				CoinBonus = 385,
			},
			[3] = {
				Enemies = { ["Chinese Commander"] = { 1, 2, 3 }, ["Foot Soldier"] = { 1, 2, 3, 4, 5 } },
				Length = 100,
				CoinBonus = 420,
			},
			[4] = {
				Enemies = { ["Chinese Commander"] = { 1, 2, 3, 4 }, ["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 125,
				CoinBonus = 455,
			},
			[5] = {
				Enemies = { ["Chinese Commander"] = { 1, 2, 3, 4, 5 }, ["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 150,
				CoinBonus = 490,
			},
			[6] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
				},
				Length = 175,
				CoinBonus = 525,
			},
			[7] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
				},
				Length = 200,
				CoinBonus = 560,
			},
			[8] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
				},
				Length = 225,
				CoinBonus = 595,
			},
			[9] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
				},
				Length = 250,
				CoinBonus = 630,
			},
			[10] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
				},
				Length = 275,
				CoinBonus = 665,
			},
			[11] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
				},
				Length = 300,
				CoinBonus = 700,
			},
			[12] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 325,
				CoinBonus = 735,
			},
			[13] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
				},
				Length = 350,
				CoinBonus = 770,
			},
			[14] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 375,
				CoinBonus = 805,
			},
			[15] = {
				Enemies = {
					["Chinese Commander"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Imperial Guard"] = { 1 },
				},
				Length = 400,
				CoinBonus = 840,
			},
		},
		EnemyData = {},
	},

	-- China Level 6: Final Dynasty
	["China_FinalDynasty"] = {
		Data = {
			[1] = {
				Enemies = { ["Imperial Guard"] = { 1 } },
				Length = 60,
				CoinBonus = 400,
			},
			[2] = {
				Enemies = { ["Imperial Guard"] = { 1, 2 } },
				Length = 90,
				CoinBonus = 440,
			},
			[3] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3 } },
				Length = 120,
				CoinBonus = 480,
			},
			[4] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4 } },
				Length = 150,
				CoinBonus = 520,
			},
			[5] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4, 5 } },
				Length = 180,
				CoinBonus = 560,
			},
			[6] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 210,
				CoinBonus = 600,
			},
			[7] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 240,
				CoinBonus = 640,
			},
			[8] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 270,
				CoinBonus = 680,
			},
			[9] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 300,
				CoinBonus = 720,
			},
			[10] = {
				Enemies = { ["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
				Length = 330,
				CoinBonus = 760,
			},
			[11] = {
				Enemies = {
					["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Commander"] = { 1 },
				},
				Length = 360,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Commander"] = { 1 },
				},
				Length = 390,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Commander"] = { 1, 2 },
				},
				Length = 420,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Commander"] = { 1, 2 },
				},
				Length = 450,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Imperial Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Chinese Commander"] = { 1, 2, 3 },
					["Qin Shi Huang"] = { 1 },
				},
				Length = 480,
				CoinBonus = 1000,
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
					["Medieval Spearman"] = { 6, 7 },
				},
				Length = 15,
				CoinBonus = 250,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4 },
					["Medieval Spearman"] = { 8, 9, 10 },
				},
				Length = 21,
				CoinBonus = 275,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 9, 10, 11, 12 },
				},
				Length = 25,
				CoinBonus = 300,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14 },
				},
				Length = 30,
				CoinBonus = 325,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16 },
				},
				Length = 34,
				CoinBonus = 350,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 375,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 44,
				CoinBonus = 400,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 49,
				CoinBonus = 425,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 54,
				CoinBonus = 450,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 59,
				CoinBonus = 475,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 64,
				CoinBonus = 500,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 69,
				CoinBonus = 525,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 74,
				CoinBonus = 550,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Spearman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 79,
				CoinBonus = 575,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Spearman"] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
				},
				Length = 84,
				CoinBonus = 600,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 2: Archers Volley
	["Medieval_ArchersVolley"] = {
		Data = {
			[1] = {
				Enemies = { ["Medieval Footman"] = { 1, 2, 3 }, ["Axeman"] = { 6, 7, 8, 9, 10 } },
				Length = 15,
				CoinBonus = 275,
			},
			[2] = {
				Enemies = { ["Medieval Footman"] = { 1, 2, 3, 4 }, ["Axeman"] = { 7, 8, 9, 10, 11, 12 } },
				Length = 21,
				CoinBonus = 303,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Axeman"] = { 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 27,
				CoinBonus = 330,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Axeman"] = { 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 33,
				CoinBonus = 358,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Axeman"] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 },
				},
				Length = 39,
				CoinBonus = 385,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Axeman"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
				},
				Length = 45,
				CoinBonus = 413,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Axeman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 51,
				CoinBonus = 440,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 57,
				CoinBonus = 468,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Axeman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 63,
				CoinBonus = 495,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 69,
				CoinBonus = 523,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 550,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 81,
				CoinBonus = 578,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 87,
				CoinBonus = 605,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Axeman"] = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 93,
				CoinBonus = 633,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
					["Medieval Captain"] = { 39 },
				},
				Length = 59,
				CoinBonus = 660,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 3: Shield Wall
	["Medieval_ShieldWall"] = {
		Data = {
			[1] = {
				Enemies = { ["Medieval Spearman"] = { 1 } },
				Length = 2,
				CoinBonus = 300,
			},
			[2] = {
				Enemies = { ["Medieval Spearman"] = { 1, 2 }, ["Axeman"] = { 5 } },
				Length = 7,
				CoinBonus = 330,
			},
			[3] = {
				Enemies = { ["Medieval Spearman"] = { 1, 2, 3 }, ["Axeman"] = { 6, 7 } },
				Length = 10,
				CoinBonus = 360,
			},
			[4] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4 },
					["Axeman"] = { 7, 8, 9 },
					["Medieval Footman"] = { 12 },
				},
				Length = 18,
				CoinBonus = 390,
			},
			[5] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5 },
					["Axeman"] = { 8, 9, 10, 11 },
					["Medieval Footman"] = { 14, 15 },
				},
				Length = 23,
				CoinBonus = 420,
			},
			[6] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6 },
					["Axeman"] = { 9, 10, 11, 12, 13 },
					["Medieval Footman"] = { 16, 17, 18 },
				},
				Length = 27,
				CoinBonus = 450,
			},
			[7] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Axeman"] = { 10, 11, 12, 13, 14, 15 },
					["Medieval Footman"] = { 19, 20, 21, 22 },
				},
				Length = 33,
				CoinBonus = 480,
			},
			[8] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Axeman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Footman"] = { 23, 24, 25, 26, 27 },
				},
				Length = 41,
				CoinBonus = 510,
			},
			[9] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Axeman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Medieval Footman"] = { 28, 29, 30, 31, 32, 33 },
				},
				Length = 50,
				CoinBonus = 540,
			},
			[10] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Axeman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Medieval Footman"] = { 34, 35, 36, 37, 38, 39, 40 },
				},
				Length = 61,
				CoinBonus = 570,
			},
			[11] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Axeman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Medieval Footman"] = { 41, 42, 43, 44, 45, 46, 47, 48 },
				},
				Length = 73,
				CoinBonus = 600,
			},
			[12] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Axeman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Medieval Footman"] = { 49, 50, 51, 52, 53, 54, 55, 56, 57 },
				},
				Length = 88,
				CoinBonus = 630,
			},
			[13] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					["Medieval Footman"] = { 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
				},
				Length = 105,
				CoinBonus = 660,
			},
			[14] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Axeman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					["Medieval Footman"] = { 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78 },
				},
				Length = 124,
				CoinBonus = 690,
			},
			[15] = {
				Enemies = {
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					["Medieval Footman"] = { 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 },
					["Bodyguard"] = { 92, 93 },
					["Medieval Captain"] = { 95 },
				},
				Length = 143,
				CoinBonus = 720,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 4: Cavalry Charge
	["Medieval_CavalryCharge"] = {
		Data = {
			[1] = {
				Enemies = { ["Axeman"] = { 1, 2 }, ["Medieval Footman"] = { 5, 6 } },
				Length = 9,
				CoinBonus = 375,
			},
			[2] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3 },
					["Medieval Footman"] = { 5, 6, 7 },
					["Medieval Spearman"] = { 11 },
				},
				Length = 14,
				CoinBonus = 413,
			},
			[3] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4 },
					["Medieval Footman"] = { 5, 6, 7, 8 },
					["Medieval Spearman"] = { 13, 14 },
				},
				Length = 19,
				CoinBonus = 450,
			},
			[4] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5 },
					["Medieval Footman"] = { 6, 7, 8, 9 },
					["Medieval Spearman"] = { 15, 16, 17 },
				},
				Length = 24,
				CoinBonus = 488,
			},
			[5] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Footman"] = { 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 18, 19, 20, 21 },
				},
				Length = 29,
				CoinBonus = 525,
			},
			[6] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Footman"] = { 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 22, 23, 24, 25, 26 },
				},
				Length = 34,
				CoinBonus = 563,
			},
			[7] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Footman"] = { 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 27, 28, 29, 30, 31, 32 },
				},
				Length = 39,
				CoinBonus = 600,
			},
			[8] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Footman"] = { 10, 11, 12, 13, 14, 15, 16, 17 },
					["Medieval Spearman"] = { 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 44,
				CoinBonus = 638,
			},
			[9] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Footman"] = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					["Medieval Spearman"] = { 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 49,
				CoinBonus = 675,
			},
			[10] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Footman"] = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					["Medieval Spearman"] = { 48, 49, 50, 51, 52, 53, 54, 55, 56 },
				},
				Length = 54,
				CoinBonus = 713,
			},
			[11] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Footman"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					["Medieval Spearman"] = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66 },
				},
				Length = 59,
				CoinBonus = 750,
			},
			[12] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Footman"] = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					["Medieval Spearman"] = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
				},
				Length = 64,
				CoinBonus = 788,
			},
			[13] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Footman"] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					["Medieval Spearman"] = { 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 },
				},
				Length = 69,
				CoinBonus = 825,
			},
			[14] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Footman"] = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					["Medieval Spearman"] = { 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 },
				},
				Length = 74,
				CoinBonus = 863,
			},
			[15] = {
				Enemies = {
					["Axeman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					["Medieval Footman"] = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					["Medieval Spearman"] = { 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 },
					["Bodyguard"] = { 120 },
				},
				Length = 81,
				CoinBonus = 900,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 5: Sacred Relics
	["Medieval_SacredRelics"] = {
		Data = {
			[1] = {
				Enemies = { ["Medieval Captain"] = { 1 }, ["Medieval Spearman"] = { 1, 2, 3 } },
				Length = 50,
				CoinBonus = 438,
			},
			[2] = {
				Enemies = { ["Medieval Captain"] = { 1, 2 }, ["Medieval Spearman"] = { 1, 2, 3, 4 } },
				Length = 75,
				CoinBonus = 481,
			},
			[3] = {
				Enemies = { ["Medieval Captain"] = { 1, 2, 3 }, ["Medieval Spearman"] = { 1, 2, 3, 4, 5 } },
				Length = 100,
				CoinBonus = 525,
			},
			[4] = {
				Enemies = { ["Medieval Captain"] = { 1, 2, 3, 4 }, ["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 125,
				CoinBonus = 569,
			},
			[5] = {
				Enemies = { ["Medieval Captain"] = { 1, 2, 3, 4, 5 }, ["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 150,
				CoinBonus = 613,
			},
			[6] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
				},
				Length = 175,
				CoinBonus = 656,
			},
			[7] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
				},
				Length = 200,
				CoinBonus = 700,
			},
			[8] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
				},
				Length = 225,
				CoinBonus = 744,
			},
			[9] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
				},
				Length = 250,
				CoinBonus = 788,
			},
			[10] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
				},
				Length = 275,
				CoinBonus = 831,
			},
			[11] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
				},
				Length = 300,
				CoinBonus = 875,
			},
			[12] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 325,
				CoinBonus = 919,
			},
			[13] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
				},
				Length = 350,
				CoinBonus = 963,
			},
			[14] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 375,
				CoinBonus = 1006,
			},
			[15] = {
				Enemies = {
					["Medieval Captain"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Medieval Spearman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Bodyguard"] = { 1 },
				},
				Length = 400,
				CoinBonus = 1050,
			},
		},
		EnemyData = {},
	},

	-- Medieval Level 6: Final Crusade
	["Medieval_FinalCrusade"] = {
		Data = {
			[1] = {
				Enemies = { ["Bodyguard"] = { 1 } },
				Length = 60,
				CoinBonus = 500,
			},
			[2] = {
				Enemies = { ["Bodyguard"] = { 1, 2 } },
				Length = 90,
				CoinBonus = 550,
			},
			[3] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3 } },
				Length = 120,
				CoinBonus = 600,
			},
			[4] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4 } },
				Length = 150,
				CoinBonus = 650,
			},
			[5] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4, 5 } },
				Length = 180,
				CoinBonus = 700,
			},
			[6] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4, 5, 6 } },
				Length = 210,
				CoinBonus = 750,
			},
			[7] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 240,
				CoinBonus = 800,
			},
			[8] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 270,
				CoinBonus = 850,
			},
			[9] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 300,
				CoinBonus = 900,
			},
			[10] = {
				Enemies = { ["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
				Length = 330,
				CoinBonus = 950,
			},
			[11] = {
				Enemies = {
					["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Banneret"] = { 1 },
				},
				Length = 360,
				CoinBonus = 1000,
			},
			[12] = {
				Enemies = {
					["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Banneret"] = { 1 },
				},
				Length = 390,
				CoinBonus = 1050,
			},
			[13] = {
				Enemies = {
					["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Banneret"] = { 1, 2 },
				},
				Length = 420,
				CoinBonus = 1100,
			},
			[14] = {
				Enemies = {
					["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Banneret"] = { 1, 2 },
				},
				Length = 450,
				CoinBonus = 1150,
			},
			[15] = {
				Enemies = {
					["Bodyguard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					["Banneret"] = { 1, 2, 3 },
					["Charlemagne"] = { 1 },
				},
				Length = 480,
				CoinBonus = 1250,
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
