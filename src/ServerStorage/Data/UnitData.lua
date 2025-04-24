--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local Unit = require(GlobalModules.Unit)

local Data: { [string]: Unit.UnitInput } = {
	["Scout"] = {
		UnitName = "Scout",

		AttackFuncs = {
			[0] = {
				function(Unit: Unit.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy

					if CurrentEnemy then
						CurrentEnemy:Damage(Damage)
					end
				end,
			},
		},
		Abilities = {},
	},
	["Shocker"] = {
		UnitName = "Scout",

		AttackFuncs = {
			[0] = {
				function(Unit: Unit.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy

					if CurrentEnemy then
						CurrentEnemy:Damage(Damage)
					end
				end,
			},
		},
		Abilities = {},
	},
	["Sniper"] = {
		UnitName = "Scout",

		AttackFuncs = {
			[0] = {
				function(Unit: Unit.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy

					if CurrentEnemy then
						CurrentEnemy:Damage(Damage)
					end
				end,
			},
		},
		Abilities = {},
	},
	["Shotgunner"] = {
		UnitName = "Scout",

		AttackFuncs = {
			[0] = {
				function(Unit: Unit.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy

					if CurrentEnemy then
						CurrentEnemy:Damage(Damage)
					end
				end,
			},
		},
		Abilities = {},
	},
	["Minigunner"] = {
		UnitName = "Scout",
		AttackFuncs = {
			[0] = {
				function(Unit: Unit.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy

					if CurrentEnemy then
						CurrentEnemy:Damage(Damage)
					end
				end,
			},
		},
		Abilities = {},
	},
}

local Ultimate = {}

Ultimate.UnitData = Data

function Ultimate.LevelFunc(Level: number): number
	return 1 + (Level / 100)
end

return Ultimate
