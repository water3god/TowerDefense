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
					["PCE3R"] = { 1, 2, 3 },
					["Wa1er_God"] = { 5, 6, 7 },
					["CheneyC9999"] = { 9, 10, 11 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["PCE3R"] = { 1, 2, 3, 4 },
					["Wa1er_God"] = { 6, 7, 8, 9 },
					["CheneyC9999"] = { 11, 12, 13, 14 },
				},
				Length = 35,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["PCE3R"] = { 1, 2, 3, 4, 5 },
					["Wa1er_God"] = { 7, 8, 9, 10, 11 },
					["CheneyC9999"] = { 13, 14, 15, 16, 17 },
					["ULTIMATEFORM"] = { 20 },
				},
				Length = 200,
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 25, 27 },
					["Charioteer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 24, 26, 28, 30 },
					["Charioteer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 27, 29, 31 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 26, 28, 30, 32 },
					["Charioteer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41, 43 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 43, 45 },
					["Egyptian Commander"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
				},
				Length = 1200,
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 25, 27 },
					["Charioteer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 24, 26, 28, 30 },
					["Charioteer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 27, 29, 31 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 26, 28, 30, 32 },
					["Charioteer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41, 43 },
					["Egyptian Commander"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 43, 45 },
					["Egyptian Commander"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52, 54 },
				},
				Length = 1200,
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 25, 27 },
					["Charioteer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 24, 26, 28, 30 },
					["Charioteer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 27, 29, 31 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 26, 28, 30, 32 },
					["Charioteer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41, 43 },
					["Egyptian Commander"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 43, 45 },
					["Egyptian Commander"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33, 35 },
					["Charioteer"] = { 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55 },
				},
				Length = 1200,
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 25, 27 },
					["Charioteer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 24, 26, 28, 30 },
					["Charioteer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 27, 29, 31 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 26, 28, 30, 32 },
					["Charioteer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41, 43 },
					["Egyptian Commander"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 43, 45 },
					["Egyptian Commander"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33, 35 },
					["Charioteer"] = { 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55, 57 },
				},
				Length = 1200,
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 25, 27 },
					["Charioteer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 24, 26, 28, 30 },
					["Charioteer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 27, 29, 31 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 26, 28, 30, 32 },
					["Charioteer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41, 43 },
					["Egyptian Commander"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 43, 45 },
					["Egyptian Commander"] = { 48 },
					["Royal Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33, 35 },
					["Charioteer"] = { 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55, 57, 59 },
				},
				Length = 1200,
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
					["Egyptian Scout"] = { 1, 2, 3, 4, 5 },
					["Egyptian Archer"] = { 8, 9, 10, 11 },
					["Egyptian Spearman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6 },
					["Egyptian Archer"] = { 9, 10, 11, 12, 13 },
					["Egyptian Spearman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Egyptian Archer"] = { 10, 11, 12, 13, 14, 15 },
					["Egyptian Spearman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Egyptian Archer"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Egyptian Spearman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Egyptian Archer"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Egyptian Spearman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Egyptian Archer"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Egyptian Spearman"] = { 23, 25, 27 },
					["Charioteer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Egyptian Archer"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Egyptian Spearman"] = { 24, 26, 28, 30 },
					["Charioteer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Egyptian Archer"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Egyptian Spearman"] = { 25, 27, 29, 31 },
					["Charioteer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Egyptian Archer"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Egyptian Spearman"] = { 26, 28, 30, 32 },
					["Charioteer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38 },
					["War Priest"] = { 41, 43 },
					["Egyptian Commander"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40 },
					["War Priest"] = { 43, 45 },
					["Egyptian Commander"] = { 48 },
					["Royal Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33, 35 },
					["Charioteer"] = { 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Egyptian Scout"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Egyptian Archer"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Egyptian Spearman"] = { 27, 29, 31, 33 },
					["Charioteer"] = { 36, 38, 40, 42 },
					["War Priest"] = { 45, 47 },
					["Egyptian Commander"] = { 50, 52 },
					["Royal Guard"] = { 55, 57, 59 },
					["Ramesses II"] = { 61 },
				},
				Length = 1200,
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
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Calvaryman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Greek Calvaryman"] = { 23, 25, 27 },
					["Greek Slinger"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 24, 26, 28, 30 },
					["Greek Slinger"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Greek Calvaryman"] = { 25, 27, 29, 31 },
					["Greek Slinger"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Calvaryman"] = { 26, 28, 30, 32 },
					["Greek Slinger"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41, 43 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40 },
					["Strategos"] = { 43, 45 },
					["Polemarch"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
				},
				Length = 1200,
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
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Calvaryman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Greek Calvaryman"] = { 23, 25, 27 },
					["Greek Slinger"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 24, 26, 28, 30 },
					["Greek Slinger"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Greek Calvaryman"] = { 25, 27, 29, 31 },
					["Greek Slinger"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Calvaryman"] = { 26, 28, 30, 32 },
					["Greek Slinger"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41, 43 },
					["Polemarch"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40 },
					["Strategos"] = { 43, 45 },
					["Polemarch"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52, 54 },
				},
				Length = 1200,
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
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Calvaryman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Greek Calvaryman"] = { 23, 25, 27 },
					["Greek Slinger"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 24, 26, 28, 30 },
					["Greek Slinger"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Greek Calvaryman"] = { 25, 27, 29, 31 },
					["Greek Slinger"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Calvaryman"] = { 26, 28, 30, 32 },
					["Greek Slinger"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41, 43 },
					["Polemarch"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40 },
					["Strategos"] = { 43, 45 },
					["Polemarch"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33, 35 },
					["Greek Slinger"] = { 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55 },
				},
				Length = 1200,
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
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Calvaryman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Greek Calvaryman"] = { 23, 25, 27 },
					["Greek Slinger"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 24, 26, 28, 30 },
					["Greek Slinger"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Greek Calvaryman"] = { 25, 27, 29, 31 },
					["Greek Slinger"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Calvaryman"] = { 26, 28, 30, 32 },
					["Greek Slinger"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41, 43 },
					["Polemarch"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40 },
					["Strategos"] = { 43, 45 },
					["Polemarch"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33, 35 },
					["Greek Slinger"] = { 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55, 57 },
				},
				Length = 1200,
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
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Calvaryman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Greek Calvaryman"] = { 23, 25, 27 },
					["Greek Slinger"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 24, 26, 28, 30 },
					["Greek Slinger"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Greek Calvaryman"] = { 25, 27, 29, 31 },
					["Greek Slinger"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Calvaryman"] = { 26, 28, 30, 32 },
					["Greek Slinger"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41, 43 },
					["Polemarch"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40 },
					["Strategos"] = { 43, 45 },
					["Polemarch"] = { 48 },
					["Palace Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33, 35 },
					["Greek Slinger"] = { 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55, 57, 59 },
				},
				Length = 1200,
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
					["Peltast"] = { 1, 2, 3, 4, 5 },
					["Hoplite"] = { 8, 9, 10, 11 },
					["Greek Calvaryman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6 },
					["Hoplite"] = { 9, 10, 11, 12, 13 },
					["Greek Calvaryman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Hoplite"] = { 10, 11, 12, 13, 14, 15 },
					["Greek Calvaryman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Hoplite"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Greek Calvaryman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Hoplite"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Greek Calvaryman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Hoplite"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Greek Calvaryman"] = { 23, 25, 27 },
					["Greek Slinger"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Hoplite"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Greek Calvaryman"] = { 24, 26, 28, 30 },
					["Greek Slinger"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Hoplite"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Greek Calvaryman"] = { 25, 27, 29, 31 },
					["Greek Slinger"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Hoplite"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Greek Calvaryman"] = { 26, 28, 30, 32 },
					["Greek Slinger"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38 },
					["Strategos"] = { 41, 43 },
					["Polemarch"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40 },
					["Strategos"] = { 43, 45 },
					["Polemarch"] = { 48 },
					["Palace Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33, 35 },
					["Greek Slinger"] = { 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Peltast"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Hoplite"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Greek Calvaryman"] = { 27, 29, 31, 33 },
					["Greek Slinger"] = { 36, 38, 40, 42 },
					["Strategos"] = { 45, 47 },
					["Polemarch"] = { 50, 52 },
					["Palace Guard"] = { 55, 57, 59 },
					["Pyrrhus"] = { 61 },
				},
				Length = 1200,
				CoinBonus = 380,
			},
		},
		EnemyData = {},
	},

	-- Rome Level 1: Legion's March
	["Rome_LegionsMarch"] = {
		Data = {
			[1] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 8, 9, 10, 11 },
					["Standard Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 9, 10, 11, 12, 13 },
					["Standard Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 10, 11, 12, 13, 14, 15 },
					["Standard Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Standard Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Standard Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Standard Bearer"] = { 23, 25, 27 },
					["Roman Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 24, 26, 28, 30 },
					["Roman Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Standard Bearer"] = { 25, 27, 29, 31 },
					["Roman Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Standard Bearer"] = { 26, 28, 30, 32 },
					["Roman Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41, 43 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40 },
					["Centurion"] = { 43, 45 },
					["Tribune"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
				},
				Length = 1200,
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
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 8, 9, 10, 11 },
					["Standard Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 9, 10, 11, 12, 13 },
					["Standard Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 10, 11, 12, 13, 14, 15 },
					["Standard Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Standard Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Standard Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Standard Bearer"] = { 23, 25, 27 },
					["Roman Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 24, 26, 28, 30 },
					["Roman Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Standard Bearer"] = { 25, 27, 29, 31 },
					["Roman Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Standard Bearer"] = { 26, 28, 30, 32 },
					["Roman Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41, 43 },
					["Tribune"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40 },
					["Centurion"] = { 43, 45 },
					["Tribune"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52, 54 },
				},
				Length = 1200,
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
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 8, 9, 10, 11 },
					["Standard Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 9, 10, 11, 12, 13 },
					["Standard Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 10, 11, 12, 13, 14, 15 },
					["Standard Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Standard Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Standard Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Standard Bearer"] = { 23, 25, 27 },
					["Roman Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 24, 26, 28, 30 },
					["Roman Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Standard Bearer"] = { 25, 27, 29, 31 },
					["Roman Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Standard Bearer"] = { 26, 28, 30, 32 },
					["Roman Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41, 43 },
					["Tribune"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40 },
					["Centurion"] = { 43, 45 },
					["Tribune"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33, 35 },
					["Roman Archer"] = { 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55 },
				},
				Length = 1200,
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
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 8, 9, 10, 11 },
					["Standard Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 9, 10, 11, 12, 13 },
					["Standard Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 10, 11, 12, 13, 14, 15 },
					["Standard Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Standard Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Standard Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Standard Bearer"] = { 23, 25, 27 },
					["Roman Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 24, 26, 28, 30 },
					["Roman Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Standard Bearer"] = { 25, 27, 29, 31 },
					["Roman Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Standard Bearer"] = { 26, 28, 30, 32 },
					["Roman Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41, 43 },
					["Tribune"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40 },
					["Centurion"] = { 43, 45 },
					["Tribune"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33, 35 },
					["Roman Archer"] = { 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55, 57 },
				},
				Length = 1200,
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
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 8, 9, 10, 11 },
					["Standard Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 9, 10, 11, 12, 13 },
					["Standard Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 10, 11, 12, 13, 14, 15 },
					["Standard Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Standard Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Standard Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Standard Bearer"] = { 23, 25, 27 },
					["Roman Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 24, 26, 28, 30 },
					["Roman Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Standard Bearer"] = { 25, 27, 29, 31 },
					["Roman Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Standard Bearer"] = { 26, 28, 30, 32 },
					["Roman Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41, 43 },
					["Tribune"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40 },
					["Centurion"] = { 43, 45 },
					["Tribune"] = { 48 },
					["Praetorian Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33, 35 },
					["Roman Archer"] = { 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55, 57, 59 },
				},
				Length = 1200,
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
					["Roman Slinger"] = { 1, 2, 3, 4, 5 },
					["Legionary"] = { 8, 9, 10, 11 },
					["Standard Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6 },
					["Legionary"] = { 9, 10, 11, 12, 13 },
					["Standard Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Legionary"] = { 10, 11, 12, 13, 14, 15 },
					["Standard Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Legionary"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Standard Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Legionary"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Standard Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Legionary"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Standard Bearer"] = { 23, 25, 27 },
					["Roman Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Legionary"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Standard Bearer"] = { 24, 26, 28, 30 },
					["Roman Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Legionary"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Standard Bearer"] = { 25, 27, 29, 31 },
					["Roman Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Legionary"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Standard Bearer"] = { 26, 28, 30, 32 },
					["Roman Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38 },
					["Centurion"] = { 41, 43 },
					["Tribune"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40 },
					["Centurion"] = { 43, 45 },
					["Tribune"] = { 48 },
					["Praetorian Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33, 35 },
					["Roman Archer"] = { 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Roman Slinger"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Legionary"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Standard Bearer"] = { 27, 29, 31, 33 },
					["Roman Archer"] = { 36, 38, 40, 42 },
					["Centurion"] = { 45, 47 },
					["Tribune"] = { 50, 52 },
					["Praetorian Guard"] = { 55, 57, 59 },
					["Trajan"] = { 61 },
				},
				Length = 1200,
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
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11 },
					["Shield Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13 },
					["Shield Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Shield Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Shield Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Shield Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Shield Bearer"] = { 23, 25, 27 },
					["Chinese Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 24, 26, 28, 30 },
					["Chinese Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Shield Bearer"] = { 25, 27, 29, 31 },
					["Chinese Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Shield Bearer"] = { 26, 28, 30, 32 },
					["Chinese Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41, 43 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40 },
					["Chinese Commander"] = { 43, 45 },
					["Chinese General"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
				},
				Length = 1200,
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
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11 },
					["Shield Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13 },
					["Shield Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Shield Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Shield Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Shield Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Shield Bearer"] = { 23, 25, 27 },
					["Chinese Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 24, 26, 28, 30 },
					["Chinese Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Shield Bearer"] = { 25, 27, 29, 31 },
					["Chinese Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Shield Bearer"] = { 26, 28, 30, 32 },
					["Chinese Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41, 43 },
					["Chinese General"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40 },
					["Chinese Commander"] = { 43, 45 },
					["Chinese General"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52, 54 },
				},
				Length = 1200,
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
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11 },
					["Shield Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13 },
					["Shield Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Shield Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Shield Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Shield Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Shield Bearer"] = { 23, 25, 27 },
					["Chinese Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 24, 26, 28, 30 },
					["Chinese Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Shield Bearer"] = { 25, 27, 29, 31 },
					["Chinese Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Shield Bearer"] = { 26, 28, 30, 32 },
					["Chinese Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41, 43 },
					["Chinese General"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40 },
					["Chinese Commander"] = { 43, 45 },
					["Chinese General"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33, 35 },
					["Chinese Archer"] = { 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55 },
				},
				Length = 1200,
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
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11 },
					["Shield Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13 },
					["Shield Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Shield Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Shield Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Shield Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Shield Bearer"] = { 23, 25, 27 },
					["Chinese Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 24, 26, 28, 30 },
					["Chinese Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Shield Bearer"] = { 25, 27, 29, 31 },
					["Chinese Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Shield Bearer"] = { 26, 28, 30, 32 },
					["Chinese Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41, 43 },
					["Chinese General"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40 },
					["Chinese Commander"] = { 43, 45 },
					["Chinese General"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33, 35 },
					["Chinese Archer"] = { 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55, 57 },
				},
				Length = 1200,
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
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11 },
					["Shield Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13 },
					["Shield Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Shield Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Shield Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Shield Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Shield Bearer"] = { 23, 25, 27 },
					["Chinese Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 24, 26, 28, 30 },
					["Chinese Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Shield Bearer"] = { 25, 27, 29, 31 },
					["Chinese Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Shield Bearer"] = { 26, 28, 30, 32 },
					["Chinese Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41, 43 },
					["Chinese General"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40 },
					["Chinese Commander"] = { 43, 45 },
					["Chinese General"] = { 48 },
					["Imperial Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33, 35 },
					["Chinese Archer"] = { 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55, 57, 59 },
				},
				Length = 1200,
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
					["Foot Soldier"] = { 1, 2, 3, 4, 5 },
					["Chinese Spearman"] = { 8, 9, 10, 11 },
					["Shield Bearer"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6 },
					["Chinese Spearman"] = { 9, 10, 11, 12, 13 },
					["Shield Bearer"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Chinese Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Shield Bearer"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Chinese Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Shield Bearer"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Chinese Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Shield Bearer"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Chinese Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Shield Bearer"] = { 23, 25, 27 },
					["Chinese Archer"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Chinese Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Shield Bearer"] = { 24, 26, 28, 30 },
					["Chinese Archer"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Chinese Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Shield Bearer"] = { 25, 27, 29, 31 },
					["Chinese Archer"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Chinese Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Shield Bearer"] = { 26, 28, 30, 32 },
					["Chinese Archer"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38 },
					["Chinese Commander"] = { 41, 43 },
					["Chinese General"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40 },
					["Chinese Commander"] = { 43, 45 },
					["Chinese General"] = { 48 },
					["Imperial Guard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33, 35 },
					["Chinese Archer"] = { 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Foot Soldier"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Chinese Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Shield Bearer"] = { 27, 29, 31, 33 },
					["Chinese Archer"] = { 36, 38, 40, 42 },
					["Chinese Commander"] = { 45, 47 },
					["Chinese General"] = { 50, 52 },
					["Imperial Guard"] = { 55, 57, 59 },
					["Qin Shi Huang"] = { 61 },
				},
				Length = 1200,
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
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11 },
					["Axeman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Axeman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 25, 27 },
					["Knight"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Axeman"] = { 24, 26, 28, 30 },
					["Knight"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 27, 29, 31 },
					["Knight"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Axeman"] = { 26, 28, 30, 32 },
					["Knight"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41, 43 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40 },
					["Medieval Captain"] = { 43, 45 },
					["Banneret"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
				},
				Length = 1200,
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
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11 },
					["Axeman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Axeman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 25, 27 },
					["Knight"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Axeman"] = { 24, 26, 28, 30 },
					["Knight"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 27, 29, 31 },
					["Knight"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Axeman"] = { 26, 28, 30, 32 },
					["Knight"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41, 43 },
					["Banneret"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40 },
					["Medieval Captain"] = { 43, 45 },
					["Banneret"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52, 54 },
				},
				Length = 1200,
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
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11 },
					["Axeman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Axeman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 25, 27 },
					["Knight"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Axeman"] = { 24, 26, 28, 30 },
					["Knight"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 27, 29, 31 },
					["Knight"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Axeman"] = { 26, 28, 30, 32 },
					["Knight"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41, 43 },
					["Banneret"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40 },
					["Medieval Captain"] = { 43, 45 },
					["Banneret"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33, 35 },
					["Knight"] = { 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55 },
				},
				Length = 1200,
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
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11 },
					["Axeman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Axeman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 25, 27 },
					["Knight"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Axeman"] = { 24, 26, 28, 30 },
					["Knight"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 27, 29, 31 },
					["Knight"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Axeman"] = { 26, 28, 30, 32 },
					["Knight"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41, 43 },
					["Banneret"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40 },
					["Medieval Captain"] = { 43, 45 },
					["Banneret"] = { 48 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33, 35 },
					["Knight"] = { 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55, 57 },
				},
				Length = 1200,
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
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11 },
					["Axeman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Axeman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 25, 27 },
					["Knight"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Axeman"] = { 24, 26, 28, 30 },
					["Knight"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 27, 29, 31 },
					["Knight"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Axeman"] = { 26, 28, 30, 32 },
					["Knight"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41, 43 },
					["Banneret"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40 },
					["Medieval Captain"] = { 43, 45 },
					["Banneret"] = { 48 },
					["Bodyguard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33, 35 },
					["Knight"] = { 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55, 57, 59 },
				},
				Length = 1200,
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
					["Medieval Footman"] = { 1, 2, 3, 4, 5 },
					["Medieval Spearman"] = { 8, 9, 10, 11 },
					["Axeman"] = { 14 },
				},
				Length = 30,
				CoinBonus = 100,
			},
			[2] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6 },
					["Medieval Spearman"] = { 9, 10, 11, 12, 13 },
					["Axeman"] = { 16, 18 },
				},
				Length = 30,
				CoinBonus = 120,
			},
			[3] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7 },
					["Medieval Spearman"] = { 10, 11, 12, 13, 14, 15 },
					["Axeman"] = { 18, 20, 22 },
				},
				Length = 35,
				CoinBonus = 140,
			},
			[4] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8 },
					["Medieval Spearman"] = { 11, 12, 13, 14, 15, 16, 17 },
					["Axeman"] = { 20, 22, 24 },
				},
				Length = 35,
				CoinBonus = 160,
			},
			[5] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
					["Medieval Spearman"] = { 12, 13, 14, 15, 16, 17, 18, 19 },
					["Axeman"] = { 22, 24, 26 },
				},
				Length = 40,
				CoinBonus = 180,
			},
			[6] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					["Medieval Spearman"] = { 13, 14, 15, 16, 17, 18, 19, 20 },
					["Axeman"] = { 23, 25, 27 },
					["Knight"] = { 31 },
				},
				Length = 40,
				CoinBonus = 200,
			},
			[7] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
					["Medieval Spearman"] = { 14, 15, 16, 17, 18, 19, 20, 21 },
					["Axeman"] = { 24, 26, 28, 30 },
					["Knight"] = { 33 },
				},
				Length = 45,
				CoinBonus = 220,
			},
			[8] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
					["Medieval Spearman"] = { 15, 16, 17, 18, 19, 20, 21, 22 },
					["Axeman"] = { 25, 27, 29, 31 },
					["Knight"] = { 34, 36 },
				},
				Length = 45,
				CoinBonus = 240,
			},
			[9] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
					["Medieval Spearman"] = { 16, 17, 18, 19, 20, 21, 22, 23 },
					["Axeman"] = { 26, 28, 30, 32 },
					["Knight"] = { 35, 37 },
				},
				Length = 50,
				CoinBonus = 260,
			},
			[10] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
				},
				Length = 50,
				CoinBonus = 280,
			},
			[11] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41 },
				},
				Length = 55,
				CoinBonus = 300,
			},
			[12] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38 },
					["Medieval Captain"] = { 41, 43 },
					["Banneret"] = { 46 },
				},
				Length = 55,
				CoinBonus = 320,
			},
			[13] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40 },
					["Medieval Captain"] = { 43, 45 },
					["Banneret"] = { 48 },
					["Bodyguard"] = { 51 },
				},
				Length = 60,
				CoinBonus = 340,
			},
			[14] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33, 35 },
					["Knight"] = { 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55, 57 },
				},
				Length = 65,
				CoinBonus = 360,
			},
			[15] = {
				Enemies = {
					["Medieval Footman"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
					["Medieval Spearman"] = { 17, 18, 19, 20, 21, 22, 23, 24 },
					["Axeman"] = { 27, 29, 31, 33 },
					["Knight"] = { 36, 38, 40, 42 },
					["Medieval Captain"] = { 45, 47 },
					["Banneret"] = { 50, 52 },
					["Bodyguard"] = { 55, 57, 59 },
					["Charlemagne"] = { 61 },
				},
				Length = 1200,
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
