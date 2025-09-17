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
		Health = 12,
		Speed = 1.8,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Archer"] = {
		ModelName = "Egyptian Archer",
		Health = 15,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Spearman"] = {
		ModelName = "Egyptian Spearman",
		Health = 25,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Charioteer"] = {
		ModelName = "Charioteer",
		Health = 100,
		Speed = 2.8,
		IsBoss = false,
		Ally = false,
	},
	["War Priest"] = {
		ModelName = "War Priest",
		Health = 200,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Commander"] = {
		ModelName = "Egyptian Commander",
		Health = 250,
		Speed = 0.7,
		IsBoss = false,
		Ally = false,
	},
	["Royal Guard"] = {
		ModelName = "Royal Guard",
		Health = 350,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Ramesses II"] = {
		ModelName = "Ramesses II",
		Health = 650,
		Speed = 0.8,
		IsBoss = true,
		Ally = false,
	},

	-- Greece --
	["Peltast"] = {
		ModelName = "Peltast",
		Health = 16,
		Speed = 1.9,
		IsBoss = false,
		Ally = false,
	},
	["Hoplite"] = {
		ModelName = "Hoplite",
		Health = 25,
		Speed = 1.7,
		IsBoss = false,
		Ally = false,
	},
	["Greek Calvaryman"] = {
		ModelName = "Greek Cavalryman",
		Health = 33,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Greek Slinger"] = {
		ModelName = "Greek Slinger",
		Health = 20,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Strategos"] = {
		ModelName = "Strategos",
		Health = 125,
		Speed = 1.3,
		IsBoss = false,
		Ally = false,
	},
	["Polemarch"] = {
		ModelName = "Polemarch",
		Health = 300,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
	},
	["Palace Guard"] = {
		ModelName = "Palace Guard",
		Health = 400,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Pyrrhus"] = {
		ModelName = "Pyrrhus",
		Health = 800,
		Speed = 0.7,
		IsBoss = true,
		Ally = false,
	},

	-- Rome --
	["Roman Slinger"] = {
		ModelName = "Roman Slinger",
		Health = 20,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Legionary"] = {
		ModelName = "Legionary",
		Health = 35,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Standard Bearer"] = {
		ModelName = "Standard Bearer",
		Health = 43,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
		AdornmentName = "StandardArmor",
	},
	["Roman Archer"] = {
		ModelName = "Roman Archer",
		Health = 30,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Centurion"] = {
		ModelName = "Centurion",
		Health = 125,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Tribune"] = {
		ModelName = "Tribune",
		Health = 200,
		Speed = 0.9,
		IsBoss = false,
		Ally = false,
	},
	["Praetorian Guard"] = {
		ModelName = "Praetorian Guard",
		Health = 300,
		Speed = 0.5,
		IsBoss = false,
		Ally = false,
	},
	["Trajan"] = {
		ModelName = "Trajan",
		Health = 1000,
		Speed = 0.5,
		IsBoss = true,
		Ally = false,
	},

	-- Chinese --
	["Foot Soldier"] = {
		ModelName = "Foot Soldier",
		Health = 25,
		Speed = 1.4,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Spearman"] = {
		ModelName = "Chinese Spearman",
		Health = 50,
		Speed = 1.3,
		IsBoss = false,
		Ally = false,
	},
	["Shield Bearer"] = {
		ModelName = "Shield Bearer",
		Health = 100,
		Speed = 1.3,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Archer"] = {
		ModelName = "Chinese Archer",
		Health = 40,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Commander"] = {
		ModelName = "Chinese Commander",
		Health = 150,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
	},
	["Chinese General"] = {
		ModelName = "Chinese General",
		Health = 230,
		Speed = 1.2,
		IsBoss = false,
		Ally = false,
	},
	["Imperial Guard"] = {
		ModelName = "Imperial Guard",
		Health = 500,
		Speed = 0.5,
		IsBoss = false,
		Ally = false,
	},
	["Qin Shi Huang"] = {
		ModelName = "Qin Shi Huang",
		Health = 1250,
		Speed = 0.4,
		IsBoss = true,
		Ally = false,
	},

	-- Medieval --
	["Medieval Footman"] = {
		ModelName = "Medieval Footman",
		Health = 30,
		Speed = 1.4,
		IsBoss = false,
		Ally = false,
	},
	["Medieval Spearman"] = {
		ModelName = "Medieval Spearman",
		Health = 55,
		Speed = 1.6,
		IsBoss = false,
		Ally = false,
	},
	["Axeman"] = {
		ModelName = "Axeman",
		Health = 140,
		Speed = 1.4,
		IsBoss = false,
		Ally = false,
	},
	["Knight"] = {
		ModelName = "Knight",
		Health = 95,
		Speed = 1.3,
		IsBoss = false,
		Ally = false,
	},
	["Medieval Captain"] = {
		ModelName = "Medieval Captain",
		Health = 300,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Banneret"] = {
		ModelName = "Banneret",
		Health = 250,
		Speed = 0.6,
		IsBoss = false,
		Ally = false,
	},
	["Bodyguard"] = {
		ModelName = "Bodyguard",
		Health = 750,
		Speed = 0.5,
		IsBoss = false,
		Ally = false,
	},
	["Charlemagne"] = {
		ModelName = "Charlemagne",
		Health = 1500,
		Speed = 0.4,
		IsBoss = true,
		Ally = false,
	},

	-- Allies --

	["Viking 1"] = {
		ModelName = "Viking 1",
		Health = 100,
		Speed = 1.5,
		IsBoss = false,
		Ally = true,
	},
	["Viking 2"] = {
		ModelName = "Viking 2",
		Health = 120,
		Speed = 1.4,
		IsBoss = false,
		Ally = true,
	},

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
