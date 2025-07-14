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
	["Scout"] = {
		ModelName = "Scout",
		Health = 5,
		Speed = 4,
		IsBoss = false,
		Ally = false,
	},
	["Archer"] = {
		ModelName = "Archer",
		Health = 8,
		Speed = 3,
		IsBoss = false,
		Ally = false,
	},
	["Spearman"] = {
		ModelName = "Spearman",
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
	["Commander"] = {
		ModelName = "Commander",
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
}

return Data
