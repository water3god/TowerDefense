--!strict

-- By Wa1er_God --

--[[

player joins in, can select who he he wants to play with in story mode. Also, in the new infinite mode,
it rotates between maps, they should have health depending on the stage in infinite mode. ALL of these gives boosts,
which are temporary boosts that give you a higher chance of getting somthing rare for a certain amount of time. There
are some boosts that grant certain units a higher chance of obtaining it. Infinite Mode is locked until player is level
5. Levels give you a higher chance of obtaining units.

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)
local RarityInfo = require(Shared.RarityInfo)

export type Difficulty = "Normal" | "Hard" | "Insane"
local Difficulty = { "Normal", "Hard", "Insane" }

export type RewardInfo = { Units: { string }, Resources: { Types.RewardData } }

export type LevelInfo = {
	Name: string,
	GameId: string,
	Index: number, --7 is infinite
	XPMultiplier: number, -- normal XP is multiplied and given to player
	RewardInfo: { [Difficulty | string]: RewardInfo },
}

export type ResourceData = {
	Units: { string },
	Resources: { { Resource: string, Count: number } },
	ExistingUnits: { { Name: string, Trait: string?, OldLevel: number, NewLevel: number, OldXP: number, NewXP: number } },
}

export type MapInfo = {
	Name: string,
	MapId: string,
	Image: string,
	Prerequisite: string?,
	LevelInfo: { LevelInfo },
}

local Data = {}

local GameInfo: { MapInfo } = {
	{
		MapId = "Egypt",
		Name = "Egypt",
		Image = "rbxassetid://81730317336118",
		LevelInfo = {
			[0] = {
				Name = "Infinite",
				GameId = "AncientEgypt_Infinite",
				Index = 0,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 240 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 280 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[1] = {
				Name = "Desert Reconnaissance",
				GameId = "AncientEgypt_DesertReconnaissance",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 200 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 240 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 280 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[2] = {
				Name = "Arrow Barrage",
				GameId = "AncientEgypt_ArrowBarrage",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 220 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 260 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 300 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[3] = {
				Name = "Shielded Formation",
				GameId = "AncientEgypt_ShieldedFormation",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 240 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 280 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 320 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[4] = {
				Name = "Chariot Assault",
				GameId = "AncientEgypt_ChariotAssault",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 260 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 300 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 340 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[5] = {
				Name = "Sacred Ritual",
				GameId = "AncientEgypt_SacredRitual",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 280 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 320 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 360 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[6] = {
				Name = "Final Defense",
				GameId = "AncientEgypt_FinalDefense",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 300 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 340 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 380 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
		},
	},
	{
		MapId = "Greece",
		Name = "Greece",
		Image = "rbxassetid://120734686321148",
		LevelInfo = {
			[0] = {
				Name = "Infinite",
				GameId = "Greece_Infinite",
				Index = 0,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 260 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 300 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 340 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[1] = {
				Name = "Spartan Defense",
				GameId = "Greece_SpartanDefense",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 280 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 320 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 360 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[2] = {
				Name = "Olympian Challenge",
				GameId = "Greece_OlympianChallenge",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 300 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 340 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 380 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[3] = {
				Name = "Athenian Walls",
				GameId = "Greece_AthenianWalls",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 320 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 360 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 400 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[4] = {
				Name = "Phalanx Advance",
				GameId = "Greece_PhalanxAdvance",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 340 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 380 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 420 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[5] = {
				Name = "Oracle's Prophecy",
				GameId = "Greece_OraclesProphecy",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 360 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 400 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 440 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[6] = {
				Name = "Final Stand",
				GameId = "Greece_FinalStand",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 380 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 420 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 460 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
		},
		Prerequisite = "Egypt",
	},
	{
		MapId = "Rome",
		Name = "Rome",
		Image = "rbxassetid://74963095419523",
		LevelInfo = {
			[0] = {
				Name = "Infinite",
				GameId = "Rome_Infinite",
				Index = 0,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 340 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 380 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 420 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[1] = {
				Name = "Legion's March",
				GameId = "Rome_LegionsMarch",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 360 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 400 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 440 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[2] = {
				Name = "Centurion's Charge",
				GameId = "Rome_CenturionsCharge",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 380 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 420 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 460 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[3] = {
				Name = "Imperial Walls",
				GameId = "Rome_ImperialWalls",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 400 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 440 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 480 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[4] = {
				Name = "Chariot Onslaught",
				GameId = "Rome_ChariotOnslaught",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 420 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 460 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 500 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[5] = {
				Name = "Sacred Arena",
				GameId = "Rome_SacredArena",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 440 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 480 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 520 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[6] = {
				Name = "Final Triumph",
				GameId = "Rome_FinalTriumph",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 460 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 500 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 540 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
		},
		Prerequisite = "Greece",
	},
	{
		MapId = "China",
		Name = "China",
		Image = "rbxassetid://136523529237600",
		LevelInfo = {
			[0] = {
				Name = "Infinite",
				GameId = "China_Infinite",
				Index = 0,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 420 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 460 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 500 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[1] = {
				Name = "Yellow River Defense",
				GameId = "China_YellowRiverDefense",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 440 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 480 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 520 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[2] = {
				Name = "Terracotta Barrage",
				GameId = "China_TerracottaBarrage",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 460 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 500 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 540 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[3] = {
				Name = "Great Wall Stand",
				GameId = "China_GreatWallStand",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 480 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 520 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 560 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[4] = {
				Name = "Imperial Cavalry",
				GameId = "China_ImperialCavalry",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 500 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 540 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 580 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[5] = {
				Name = "Sacred Scrolls",
				GameId = "China_SacredScrolls",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 520 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 560 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 600 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[6] = {
				Name = "Final Dynasty",
				GameId = "China_FinalDynasty",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 540 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 580 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 620 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
		},
		Prerequisite = "Rome",
	},
	{
		MapId = "Medieval",
		Name = "Medieval",
		Image = "rbxassetid://80598570223220", -- image5.png
		LevelInfo = {
			[0] = {
				Name = "Infinite",
				GameId = "Medieval_Infinite",
				Index = 0,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 500 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 540 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 580 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[1] = {
				Name = "Knight's Stand",
				GameId = "Medieval_KnightsStand",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 520 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 560 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 600 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[2] = {
				Name = "Archer's Volley",
				GameId = "Medieval_ArchersVolley",
				Index = 2,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 540 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 580 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 620 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[3] = {
				Name = "Shield Wall",
				GameId = "Medieval_ShieldWall",
				Index = 3,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 560 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 600 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 640 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[4] = {
				Name = "Cavalry Charge",
				GameId = "Medieval_CavalryCharge",
				Index = 4,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 580 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 620 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 660 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[5] = {
				Name = "Sacred Relics",
				GameId = "Medieval_SacredRelics",
				Index = 5,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 600 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 640 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 680 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
			[6] = {
				Name = "Final Crusade",
				GameId = "Medieval_FinalCrusade",
				Index = 6,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 620 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Hard = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 660 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
					Insane = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 700 },
							{ Resource = "Omen Coins", Count = 1 },
						},
					},
				},
			},
		},
		Prerequisite = "China",
	},
	{
		Name = "Tutorial",
		MapId = "Tutorial",
		Index = 1,
		XPMultiplier = 1,
		Image = "rbxassetid://101287981134771",
		LevelInfo = {
			{
				Name = "Tutorial",
				GameId = "Tutorial",
				Index = 1,
				XPMultiplier = 1,
				RewardInfo = {
					Normal = {
						Units = {},
						Resources = {
							{ Resource = "Gold", Count = 600 },
							{ Resource = "Omen Coins", Count = 5 },
						},
					},
					Hard = {
						Units = {},
						Resources = {},
					},
					Insane = {
						Units = {},
						Resources = {},
					},
				},
			},
		},
	},
}

export type RewardData = {
	Image: string,
	Rarity: RarityInfo.Rarity,
	Description: string,
}

local RewardInfo: { [string]: RewardData } = {
	["Omen Coins"] = {
		Image = "rbxassetid://72575091810623",
		Rarity = "Mythic",
		Description = "A rare currency used to purchase powerful items and units.",
	},
	["Gold"] = {
		Image = "rbxassetid://87241276261105",
		Rarity = "Common",
		Description = "A basic currency used for various transactions.",
	},
	["XP"] = {
		Image = "rbxassetid://87241276261105", -- Change later (placeholder)
		Rarity = "Common",
		Description = "Experience points used to level up your units and player profile.",
	},
}

local Colors: { [string]: Color3 } = {
	Normal = Color3.fromRGB(88, 226, 65),
	Hard = Color3.fromRGB(224, 47, 57),
	Insane = Color3.fromRGB(187, 85, 211),
}

Data.Difficulty = Difficulty
Data.GameInfo = GameInfo
Data.RewardInfo = RewardInfo

local XPData = {}

XPData.UnitMaxLevel = 100

local UnitXPCache = {}
local PlayerXPCache = {}

function XPData.CalculateUnitXP(Level: number)
	local Multiplier = 1.04
	local BaseXP = 100

	if UnitXPCache[Level] then
		return UnitXPCache[Level]
	end

	local Value = math.round(BaseXP * math.pow(Multiplier, Level))
	UnitXPCache[Level] = Value
	return Value
end

function XPData.CalculatePlayerXP(Level: number)
	local Multiplier = 1.03
	local BaseXP = 100

	if PlayerXPCache[Level] then
		return PlayerXPCache[Level]
	end

	local Value = math.round(BaseXP * math.pow(Multiplier, Level))
	PlayerXPCache[Level] = Value

	return Value
end

function XPData.GetDamageMultiplierFromLevel(Level: number)
	return 1 + math.max(Level * 0.01, 0)
end

Data.XPData = XPData

function Data.GetMapFromId(MapId: string): MapInfo?
	for _, Item in ipairs(GameInfo) do
		if Item.MapId == MapId then
			return Item
		end
	end

	return
end

function Data.GetDataFromInfo(MapId: string, LevelId: string): (MapInfo?, LevelInfo?)
	local MapInfo = Data.GetMapFromId(MapId)

	if MapInfo then
		for _, Info in pairs(MapInfo.LevelInfo) do
			if Info.GameId == LevelId then
				return MapInfo, Info
			end
		end
	end

	return
end

function Data.GetFullName(MapName: string, Index: number, LevelName: string)
	return string.format("%s: %u - %s", MapName, Index, LevelName)
end

function Data.GetDifficultyString(DifficultyInput: string)
	local Color = Colors[DifficultyInput]
	return string.format('Difficulty: <font color = "#%s">%s</font>', Color:ToHex(), DifficultyInput)
end

return table.freeze(Data)
