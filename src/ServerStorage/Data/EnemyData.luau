--!strict

-- By Wa1er_God --

local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local Enemy = require(GlobalModules.Enemy)

local Data: { [string]: Enemy.EnemyInfo } = {
	["Zombie"] = {
		ModelName = "Zombie",
		Health = 10,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},

	-- Egypt --
	["Egyptian Scout"] = {
		ModelName = "Egyptian Scout",
		Health = 5,
		Speed = 4,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Archer"] = {
		ModelName = "Egyptian Archer",
		Health = 8,
		Speed = 3,
		IsBoss = false,
		Ally = false,
	},
	["Egyptian Spearman"] = {
		ModelName = "Egyptian Spearman",
		Health = 12,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Charioteer"] = {
		ModelName = "Charioteer",
		Health = 50,
		Speed = 5,
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
		Health = 150,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Royal Guard"] = {
		ModelName = "Royal Guard",
		Health = 200,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Ramesses II"] = {
		ModelName = "Ramesses II",
		Health = 1000,
		Speed = 1,
		IsBoss = true,
		Ally = false,
	},

	-- Greece --
	["Peltast"] = {
		ModelName = "Peltast",
		Health = 15,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Hoplite"] = {
		ModelName = "Hoplite",
		Health = 25,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Greek Calvaryman"] = {
		ModelName = "Greek Cavalryman",
		Health = 40,
		Speed = 3,
		IsBoss = false,
		Ally = false,
	},
	["Greek Slinger"] = {
		ModelName = "Greek Slinger",
		Health = 20,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Strategos"] = {
		ModelName = "Strategos",
		Health = 300,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Polemarch"] = {
		ModelName = "Polemarch",
		Health = 500,
		Speed = 1,
		IsBoss = false,
		Ally = false,
	},
	["Palace Guard"] = {
		ModelName = "Palace Guard",
		Health = 400,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Pyrrhus"] = {
		ModelName = "Pyrrhus",
		Health = 2000,
		Speed = 1,
		IsBoss = true,
		Ally = false,
	},

	-- Rome --
	["Roman Slinger"] = {
		ModelName = "Roman Slinger",
		Health = 20,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Legionary"] = {
		ModelName = "Legionary",
		Health = 30,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Standard Bearer"] = {
		ModelName = "Standard Bearer",
		Health = 60,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
		AdornmentName = "StandardArmor",
	},
	["Roman Archer"] = {
		ModelName = "Roman Archer",
		Health = 25,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Centurion"] = {
		ModelName = "Centurion",
		Health = 150,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Tribune"] = {
		ModelName = "Tribune",
		Health = 300,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Praetorian Guard"] = {
		ModelName = "Praetorian Guard",
		Health = 300,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Trajan"] = {
		ModelName = "Trajan",
		Health = 2500,
		Speed = 1,
		IsBoss = true,
		Ally = false,
	},

	-- Medieval --
	["Medieval Footman"] = {
		ModelName = "Medieval Footman",
		Health = 40,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Medieval Spearman"] = {
		ModelName = "Medieval Spearman",
		Health = 50,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Axeman"] = {
		ModelName = "Axeman",
		Health = 60,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Knight"] = {
		ModelName = "Knight",
		Health = 150,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Medieval Captain"] = {
		ModelName = "Medieval Captain",
		Health = 300,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Banneret"] = {
		ModelName = "Banneret",
		Health = 500,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Bodyguard"] = {
		ModelName = "Bodyguard",
		Health = 400,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Charlemagne"] = {
		ModelName = "Charlemagne",
		Health = 3000,
		Speed = 1,
		IsBoss = true,
		Ally = false,
	},

	-- Chinese --
	["Foot Soldier"] = {
		ModelName = "Foot Soldier",
		Health = 30,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Spearman"] = {
		ModelName = "Chinese Spearman",
		Health = 25,
		Speed = 2.5,
		IsBoss = false,
		Ally = false,
	},
	["Shield Bearer"] = {
		ModelName = "Shield Bearer",
		Health = 50,
		Speed = 2,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Archer"] = {
		ModelName = "Chinese Archer",
		Health = 20,
		Speed = 3,
		IsBoss = false,
		Ally = false,
	},
	["Chinese Commander"] = {
		ModelName = "Chinese Commander",
		Health = 200,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Imperial Guard"] = {
		ModelName = "Imperial Guard",
		Health = 400,
		Speed = 1.5,
		IsBoss = false,
		Ally = false,
	},
	["Qin Shi Huang"] = {
		ModelName = "Qin Shi Huang",
		Health = 3500,
		Speed = 1,
		IsBoss = true,
		Ally = false,
	},

	-- Allies --

	["Trajan's Legionary"] = {
		ModelName = "Trajan's Legionary",
		AdornmentName = "LegionaryArmor",
		Health = 20,
		Speed = 2,
		IsBoss = false,
		Ally = true,
	},
}

return Data
