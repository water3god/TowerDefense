--!strict

-- By Wa1er_God --

local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local Enemy = require(GlobalModules.Enemy)

local Data: { [string]: Enemy.EnemyInfo } = {
	["PCE3R"] = {
		ModelName = "PCE3R",
		Health = 10,
		Speed = 1.4,
		IsBoss = false,
		Ally = false,
	},
	["Wa1er_God"] = {
		ModelName = "Wa1er_God",
		Health = 16,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
	},
	["CheneyC9999"] = {
		ModelName = "CheneyC9999",
		Health = 19,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["ULTIMATEFORM"] = {
		ModelName = "ULTIMATEFORM",
		Health = 50,
		Speed = 1,
		IsBoss = true,
		Ally = false,
	},

	-- Egypt --
	["Egyptian Scout"] = {
		ModelName = "Egyptian Scout",
		Health = 21,
		Speed = 1.8,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Archer"] = {
		ModelName = "Egyptian Archer",
		Health = 25,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Spearman"] = {
		ModelName = "Egyptian Spearman",
		Health = 30,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Charioteer"] = {
		ModelName = "Charioteer",
		Health = 42,
		Speed = 2.3,
		IsBoss = false,
		Ally = false,
	},
	["War Priest"] = {
		ModelName = "War Priest",
		Health = 100,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Commander"] = {
		ModelName = "Egyptian Commander",
		Health = 120,
		Speed = 0.7,
		IsBoss = false,
		Ally = false,
	},
	["Royal Guard"] = {
		ModelName = "Royal Guard",
		Health = 260,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Ramesses II"] = {
		ModelName = "Ramesses II",
		Health = 730,
		Speed = 0.6,
		IsBoss = true,
		Ally = false,
	},

	-- Greece --
	["Peltast"] = {
		ModelName = "Peltast",
		Health = 27,
		Speed = 1.9,
		IsBoss = false,
		Ally = false,
	},
	["Hoplite"] = {
		ModelName = "Hoplite",
		Health = 36,
		Speed = 1.7,
		IsBoss = false,
		Ally = false,
	},
	["Greek Calvaryman"] = {
		ModelName = "Greek Cavalryman",
		Health = 53,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Greek Slinger"] = {
		ModelName = "Greek Slinger",
		Health = 25,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Strategos"] = {
		ModelName = "Strategos",
		Health = 145,
		Speed = 1.3,
		IsBoss = false,
		Ally = false,
	},
	["Polemarch"] = {
		ModelName = "Polemarch",
		Health = 262,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
	},
	["Palace Guard"] = {
		ModelName = "Palace Guard",
		Health = 345,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Pyrrhus"] = {
		ModelName = "Pyrrhus",
		Health = 1000,
		Speed = 0.7,
		IsBoss = true,
		Ally = false,
	},

	-- Rome --
	["Roman Slinger"] = {
		ModelName = "Roman Slinger",
		Health = 38,
		Speed = 1.8,
		IsBoss = false,
		Ally = false,
	},
	["Legionary"] = {
		ModelName = "Legionary",
		Health = 43,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Standard Bearer"] = {
		ModelName = "Standard Bearer",
		Health = 60,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
		AdornmentName = "StandardArmor",
	},
	["Roman Archer"] = {
		ModelName = "Roman Archer",
		Health = 40,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Centurion"] = {
		ModelName = "Centurion",
		Health = 200,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Tribune"] = {
		ModelName = "Tribune",
		Health = 300,
		Speed = 0.9,
		IsBoss = false,
		Ally = false,
	},
	["Praetorian Guard"] = {
		ModelName = "Praetorian Guard",
		Health = 400,
		Speed = 0.5,
		IsBoss = false,
		Ally = false,
	},
	["Trajan"] = {
		ModelName = "Trajan",
		Health = 1550,
		Speed = 0.4,
		IsBoss = true,
		Ally = false,
	},

	-- Chinese --
	["Foot Soldier"] = {
		ModelName = "Foot Soldier",
		Health = 60,
		Speed = 1.7,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Spearman"] = {
		ModelName = "Chinese Spearman",
		Health = 90,
		Speed = 1.7,
		IsBoss = false,
		Ally = false,
	},
	["Shield Bearer"] = {
		ModelName = "Shield Bearer",
		Health = 90,
		Speed = 1.8,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Archer"] = {
		ModelName = "Chinese Archer",
		Health = 50,
		Speed = 1.8,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Commander"] = {
		ModelName = "Chinese Commander",
		Health = 220,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Chinese General"] = {
		ModelName = "Chinese General",
		Health = 400,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
	},
	["Imperial Guard"] = {
		ModelName = "Imperial Guard",
		Health = 640,
		Speed = 0.6,
		IsBoss = false,
		Ally = false,
	},
	["Qin Shi Huang"] = {
		ModelName = "Qin Shi Huang",
		Health = 2000,
		Speed = 0.4,
		IsBoss = true,
		Ally = false,
	},

	-- Medieval --
	["Medieval Footman"] = {
		ModelName = "Medieval Footman",
		Health = 70,
		Speed = 1.7,
		IsBoss = false,
		Ally = false,
	},
	["Medieval Spearman"] = {
		ModelName = "Medieval Spearman",
		Health = 120,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Axeman"] = {
		ModelName = "Axeman",
		Health = 140,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Knight"] = {
		ModelName = "Knight",
		Health = 190,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Medieval Captain"] = {
		ModelName = "Medieval Captain",
		Health = 250,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Banneret"] = {
		ModelName = "Banneret",
		Health = 300,
		Speed = 0.6,
		IsBoss = false,
		Ally = false,
	},
	["Bodyguard"] = {
		ModelName = "Bodyguard",
		Health = 600,
		Speed = 0.5,
		IsBoss = false,
		Ally = false,
	},
	["Charlemagne"] = {
		ModelName = "Charlemagne",
		Health = 3000,
		Speed = 0.3,
		IsBoss = true,
		Ally = false,
	},

	-- Allies --

	["Trajan's Legionary"] = {
		ModelName = "Trajan's Legionary",
		AdornmentName = "LegionaryArmor",
		Health = 25,
		Speed = 2,
		IsBoss = false,
		Ally = true,
	},
}

return Data
