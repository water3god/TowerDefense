--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local Unit = require(GlobalModules.Unit)

local Data: { [string]: Unit.UnitInput } = {
	["Julius Caesar"] = {
		UnitName = "Julius Caesar",

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
	["Pompey"] = {
		UnitName = "Pompey",

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
	["Spartacus"] = {
		UnitName = "Spartacus",

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
	["Cicero"] = {
		UnitName = "Cicero",

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
	["Trajan"] = {
		UnitName = "Trajan",

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
	["Augustus"] = {
		UnitName = "Augustus",

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
