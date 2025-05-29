--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
}

return Data
