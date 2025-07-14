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
				Enemies = { Scout = { 1, 2, 3 }, Archer = { 6, 7 }, Spearman = { 10 } },
				Length = 15,
				CoinBonus = 200,
			},
			[2] = {
				Enemies = { Scout = { 1, 2, 3, 4 }, Archer = { 8, 9, 10 }, Spearman = { 13, 14 } },
				Length = 21,
				CoinBonus = 220,
			},
			[3] = {
				Enemies = { Scout = { 1, 2, 3, 4, 5 }, Archer = { 9, 10, 11, 12 }, Spearman = { 15, 16, 17 } },
				Length = 25,
				CoinBonus = 240,
			},
			[4] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6 },
					Archer = { 10, 11, 12, 13, 14 },
					Spearman = { 17, 18, 19, 20 },
				},
				Length = 30,
				CoinBonus = 260,
			},
			[5] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7 },
					Archer = { 11, 12, 13, 14, 15, 16 },
					Spearman = { 19, 20, 21, 22, 23 },
				},
				Length = 34,
				CoinBonus = 280,
			},
			[6] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8 },
					Archer = { 12, 13, 14, 15, 16, 17, 18 },
					Spearman = { 21, 22, 23, 24, 25, 26 },
				},
				Length = 39,
				CoinBonus = 300,
			},
			[7] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					Archer = { 13, 14, 15, 16, 17, 18, 19, 20 },
					Spearman = { 23, 24, 25, 26, 27, 28, 29 },
				},
				Length = 44,
				CoinBonus = 320,
			},
			[8] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					Archer = { 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					Spearman = { 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 49,
				CoinBonus = 340,
			},
			[9] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					Archer = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					Spearman = { 27, 28, 29, 30, 31, 32, 33, 34, 35 },
				},
				Length = 54,
				CoinBonus = 360,
			},
			[10] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					Archer = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					Spearman = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
				},
				Length = 59,
				CoinBonus = 380,
			},
			[11] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					Archer = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
					Spearman = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 },
				},
				Length = 64,
				CoinBonus = 400,
			},
			[12] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					Archer = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
					Spearman = { 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44 },
				},
				Length = 69,
				CoinBonus = 420,
			},
			[13] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					Archer = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
					Spearman = { 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 74,
				CoinBonus = 440,
			},
			[14] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					Archer = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
					Spearman = { 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50 },
				},
				Length = 79,
				CoinBonus = 460,
			},
			[15] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					Archer = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 },
					Spearman = { 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53 },
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
				Enemies = { Scout = { 1, 2, 3 }, Archer = { 6, 7, 8, 9, 10 } },
				Length = 15,
				CoinBonus = 220,
			},
			[2] = {
				Enemies = { Scout = { 1, 2, 3, 4 }, Archer = { 7, 8, 9, 10, 11, 12 } },
				Length = 21,
				CoinBonus = 242,
			},
			[3] = {
				Enemies = { Scout = { 1, 2, 3, 4, 5 }, Archer = { 8, 9, 10, 11, 12, 13, 14 } },
				Length = 27,
				CoinBonus = 264,
			},
			[4] = {
				Enemies = { Scout = { 1, 2, 3, 4, 5, 6 }, Archer = { 9, 10, 11, 12, 13, 14, 15, 16 } },
				Length = 33,
				CoinBonus = 286,
			},
			[5] = {
				Enemies = { Scout = { 1, 2, 3, 4, 5, 6, 7 }, Archer = { 10, 11, 12, 13, 14, 15, 16, 17, 18 } },
				Length = 39,
				CoinBonus = 308,
			},
			[6] = {
				Enemies = { Scout = { 1, 2, 3, 4, 5, 6, 7, 8 }, Archer = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 } },
				Length = 45,
				CoinBonus = 330,
			},
			[7] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					Archer = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
				},
				Length = 51,
				CoinBonus = 352,
			},
			[8] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					Archer = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
				},
				Length = 57,
				CoinBonus = 374,
			},
			[9] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					Archer = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
				},
				Length = 63,
				CoinBonus = 396,
			},
			[10] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					Archer = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 },
				},
				Length = 69,
				CoinBonus = 418,
			},
			[11] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					Archer = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
				},
				Length = 75,
				CoinBonus = 440,
			},
			[12] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					Archer = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 81,
				CoinBonus = 462,
			},
			[13] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					Archer = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 },
				},
				Length = 87,
				CoinBonus = 484,
			},
			[14] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					Archer = { 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 },
				},
				Length = 93,
				CoinBonus = 506,
			},
			[15] = {
				Enemies = {
					Scout = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					Archer = { 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 },
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
				Enemies = { Spearman = { 1 } },
				Length = 2,
				CoinBonus = 250,
			},
			[2] = {
				Enemies = { Spearman = { 1, 2 }, Archer = { 5 } },
				Length = 7,
				CoinBonus = 275,
			},
			[3] = {
				Enemies = { Spearman = { 1, 2, 3 }, Archer = { 6, 7 } },
				Length = 10,
				CoinBonus = 300,
			},
			[4] = {
				Enemies = { Spearman = { 1, 2, 3, 4 }, Archer = { 7, 8, 9 }, Scout = { 12 } },
				Length = 18,
				CoinBonus = 325,
			},
			[5] = {
				Enemies = { Spearman = { 1, 2, 3, 4, 5 }, Archer = { 8, 9, 10, 11 }, Scout = { 14, 15 } },
				Length = 23,
				CoinBonus = 350,
			},
			[6] = {
				Enemies = { Spearman = { 1, 2, 3, 4, 5, 6 }, Archer = { 9, 10, 11, 12, 13 }, Scout = { 16, 17, 18 } },
				Length = 27,
				CoinBonus = 375,
			},
			[7] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7 },
					Archer = { 10, 11, 12, 13, 14, 15 },
					Scout = { 19, 20, 21, 22 },
				},
				Length = 33,
				CoinBonus = 400,
			},
			[8] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8 },
					Archer = { 11, 12, 13, 14, 15, 16, 17 },
					Scout = { 23, 24, 25, 26, 27 },
				},
				Length = 41,
				CoinBonus = 425,
			},
			[9] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					Archer = { 12, 13, 14, 15, 16, 17, 18, 19 },
					Scout = { 28, 29, 30, 31, 32, 33 },
				},
				Length = 50,
				CoinBonus = 450,
			},
			[10] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					Archer = { 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					Scout = { 34, 35, 36, 37, 38, 39, 40 },
				},
				Length = 61,
				CoinBonus = 475,
			},
			[11] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					Archer = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					Scout = { 41, 42, 43, 44, 45, 46, 47, 48 },
				},
				Length = 73,
				CoinBonus = 500,
			},
			[12] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					Archer = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					Scout = { 49, 50, 51, 52, 53, 54, 55, 56, 57 },
				},
				Length = 88,
				CoinBonus = 525,
			},
			[13] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					Archer = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 },
					Scout = { 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
				},
				Length = 105,
				CoinBonus = 550,
			},
			[14] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					Archer = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
					Scout = { 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78 },
				},
				Length = 124,
				CoinBonus = 575,
			},
			[15] = {
				Enemies = {
					Spearman = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					Archer = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 },
					Scout = { 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 },
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
				Enemies = { ["Charioteer"] = { 1, 2 }, Scout = { 5, 6 } },
				Length = 9,
				CoinBonus = 300,
			},
			[2] = {
				Enemies = { ["Charioteer"] = { 1, 2, 3 }, Scout = { 5, 6, 7 }, Archer = { 11 } },
				Length = 14,
				CoinBonus = 330,
			},
			[3] = {
				Enemies = { ["Charioteer"] = { 1, 2, 3, 4 }, Scout = { 5, 6, 7, 8 }, Archer = { 13, 14 } },
				Length = 19,
				CoinBonus = 360,
			},
			[4] = {
				Enemies = { ["Charioteer"] = { 1, 2, 3, 4, 5 }, Scout = { 6, 7, 8, 9 }, Archer = { 15, 16, 17 } },
				Length = 24,
				CoinBonus = 390,
			},
			[5] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6 },
					Scout = { 7, 8, 9, 10, 11 },
					Archer = { 18, 19, 20, 21 },
				},
				Length = 29,
				CoinBonus = 420,
			},
			[6] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7 },
					Scout = { 8, 9, 10, 11, 12, 13 },
					Archer = { 22, 23, 24, 25, 26 },
				},
				Length = 34,
				CoinBonus = 450,
			},
			[7] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					Scout = { 9, 10, 11, 12, 13, 14, 15 },
					Archer = { 27, 28, 29, 30, 31, 32 },
				},
				Length = 39,
				CoinBonus = 480,
			},
			[8] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					Scout = { 10, 11, 12, 13, 14, 15, 16, 17 },
					Archer = { 33, 34, 35, 36, 37, 38, 39 },
				},
				Length = 44,
				CoinBonus = 510,
			},
			[9] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					Scout = { 11, 12, 13, 14, 15, 16, 17, 18, 19 },
					Archer = { 40, 41, 42, 43, 44, 45, 46, 47 },
				},
				Length = 49,
				CoinBonus = 540,
			},
			[10] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					Scout = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
					Archer = { 48, 49, 50, 51, 52, 53, 54, 55, 56 },
				},
				Length = 54,
				CoinBonus = 570,
			},
			[11] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					Scout = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 },
					Archer = { 57, 58, 59, 60, 61, 62, 63, 64, 65, 66 },
				},
				Length = 59,
				CoinBonus = 600,
			},
			[12] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					Scout = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 },
					Archer = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
				},
				Length = 64,
				CoinBonus = 630,
			},
			[13] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					Scout = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 },
					Archer = { 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 },
				},
				Length = 69,
				CoinBonus = 660,
			},
			[14] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					Scout = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
					Archer = { 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 },
				},
				Length = 74,
				CoinBonus = 690,
			},
			[15] = {
				Enemies = {
					["Charioteer"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
					Scout = { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
					Archer = { 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 },
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
				Enemies = { ["War Priest"] = { 1 }, Archer = { 1, 2, 3 } },
				Length = 50,
				CoinBonus = 350,
			},
			[2] = {
				Enemies = { ["War Priest"] = { 1, 2 }, Archer = { 1, 2, 3, 4 } },
				Length = 75,
				CoinBonus = 385,
			},
			[3] = {
				Enemies = { ["War Priest"] = { 1, 2, 3 }, Archer = { 1, 2, 3, 4, 5 } },
				Length = 100,
				CoinBonus = 420,
			},
			[4] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4 }, Archer = { 1, 2, 3, 4, 5, 6 } },
				Length = 125,
				CoinBonus = 455,
			},
			[5] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4, 5 }, Archer = { 1, 2, 3, 4, 5, 6, 7 } },
				Length = 150,
				CoinBonus = 490,
			},
			[6] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4, 5, 6 }, Archer = { 1, 2, 3, 4, 5, 6, 7, 8 } },
				Length = 175,
				CoinBonus = 525,
			},
			[7] = {
				Enemies = { ["War Priest"] = { 1, 2, 3, 4, 5, 6, 7 }, Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
				Length = 200,
				CoinBonus = 560,
			},
			[8] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
				},
				Length = 225,
				CoinBonus = 595,
			},
			[9] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
				},
				Length = 250,
				CoinBonus = 630,
			},
			[10] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
				},
				Length = 275,
				CoinBonus = 665,
			},
			[11] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
				},
				Length = 300,
				CoinBonus = 700,
			},
			[12] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
				},
				Length = 325,
				CoinBonus = 735,
			},
			[13] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
				},
				Length = 350,
				CoinBonus = 770,
			},
			[14] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
				},
				Length = 375,
				CoinBonus = 805,
			},
			[15] = {
				Enemies = {
					["War Priest"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					Archer = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 },
					["Commander"] = { 1 },
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
					Commander = { 1 },
				},
				Length = 360,
				CoinBonus = 800,
			},
			[12] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					Commander = { 1 },
				},
				Length = 390,
				CoinBonus = 840,
			},
			[13] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					Commander = { 1, 2 },
				},
				Length = 420,
				CoinBonus = 880,
			},
			[14] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					Commander = { 1, 2 },
				},
				Length = 450,
				CoinBonus = 920,
			},
			[15] = {
				Enemies = {
					["Royal Guard"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
					Commander = { 1, 2, 3 },
					["Ramesses II"] = { 1 },
				},
				Length = 480,
				CoinBonus = 1000,
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

return WaveData
