--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local Unit = require(GlobalModules.Unit)

local Data: { [string]: Unit.UnitInput } = {
	["Alexander The Great"] = {
		UnitName = "Alexander The Great",

		AttackFuncs = {
			[0] = {
				function(Unit: Unit.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy

					task.delay(0.65 * Unit.SpeedRatio, function()
						if CurrentEnemy and CurrentEnemy.Damage then
							CurrentEnemy:Damage(Damage)
						end
					end)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Leonidas"] = {
		UnitName = "Leonidas",

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
		DefaultRuns = {},
		Abilities = {},
	},
	["Pericles"] = {
		UnitName = "Pericles",

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
		DefaultRuns = {},
		Abilities = {},
	},
	["Pyrrhus"] = {
		UnitName = "Pyrrhus",

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
		DefaultRuns = {},
		Abilities = {},
	},
	["Socrates"] = {
		UnitName = "Socrates",

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
		DefaultRuns = {},
		Abilities = {},
	},
	["Themistocles"] = {
		UnitName = "Themistocles",

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
		DefaultRuns = {},
		Abilities = {},
	},
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
		DefaultRuns = {},
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
		DefaultRuns = {},
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
		DefaultRuns = {},
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
		DefaultRuns = {},
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
		DefaultRuns = {},
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
		DefaultRuns = {},
		Abilities = {},
	},
}

local Ultimate = {}

Ultimate.UnitData = Data

function Ultimate.LevelFunc(Level: number): number
	return 1 + (Level / 100)
end

return Ultimate
