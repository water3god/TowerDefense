--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local GlobalModules = ServerScriptService.GlobalModules
local UnitModule = require(GlobalModules.Unit)
local GlobalWave = require(GlobalModules.GlobalWave)

local function AddAlly(Ally: string, Data: {}?)
	local Wave = GlobalWave.GetWave()
	if Wave then
		Wave:AddAlly(Ally, Data)
	end
end

local function DelayAttack(Unit: UnitModule.Unit, Damage: number, Delay: number)
	local CurrentEnemy = Unit.CurrentEnemy

	if CurrentEnemy then
		Unit:AddAttackPromise(
			Promise.delay(Delay * Unit.SpeedRatio):andThen(function()
				if CurrentEnemy and CurrentEnemy.Damage then
					CurrentEnemy:Damage(Damage)
				end
			end),
			"DelayAttack"
		)
	end
end

local UnitData: { [string]: UnitModule.UnitInput } = {
	["Alexander The Great"] = {
		UnitName = "Alexander The Great",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.42)
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
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.28)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Pericles"] = {
		UnitName = "Pericles",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Pyrrhus"] = {
		UnitName = "Pyrrhus",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.35)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Socrates"] = {
		UnitName = "Socrates",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Themistocles"] = {
		UnitName = "Themistocles",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Julius Caesar"] = {
		UnitName = "Julius Caesar",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.23)
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
				function(Unit: UnitModule.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy
					Unit:AddAttackPromise(
						Promise.delay(0.4 * Unit.SpeedRatio):andThen(function()
							if CurrentEnemy and CurrentEnemy.Damage then
								local Speed = 50
								local Distance = (Unit.CFrame.Position - CurrentEnemy.CFrame.Position).Magnitude
								Unit:AddPromise(
									Promise.delay(Distance / Speed):andThen(function()
										if CurrentEnemy and CurrentEnemy.Damage then
											CurrentEnemy:Damage(Damage)
										end
									end),
									"PompeyAttackArrow"
								)
							end
						end),
						"PompeyAttackPromise"
					)
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
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.52)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {
			function(Unit, Data)
				Unit:DisableAttack(1.8)
				Unit:PlayAnimation("Rage")

				Unit:AddPromise(
					Promise.delay(1.6):andThen(function()
						Unit:EnableAttack()
					end),
					"SpartacusRage"
				)

				Unit:ChangeSpeedRatio("SpartacusRage", 0.7, Data.Length)
			end,
		},
	},
	["Cicero"] = {
		UnitName = "Cicero",

		AttackFuncs = {
			[0] = {
				function() end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Trajan"] = {
		UnitName = "Trajan",

		AttackFuncs = {},
		DefaultRuns = {
			--[[[0] = function(Unit, Damage: number)
				AddAlly("Ally", {
					Health = Damage,
				})
			end,]]
		},
		Abilities = {},
	},
	["Augustus"] = {
		UnitName = "Augustus",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Robert the Bruce"] = {
		UnitName = "Robert the Bruce",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.5)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Leif Erikson"] = {
		UnitName = "Leif Erikson",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Charlemagne"] = {
		UnitName = "Charlemagne",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.6)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Joan of Arc"] = {
		UnitName = "Joan of Arc",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["William the Conqueror"] = {
		UnitName = "William the Conqueror",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.3)
					DelayAttack(Unit, Damage, 0.5)
					DelayAttack(Unit, Damage, 0.8)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Richard the Lionheart"] = {
		UnitName = "Richard the Lionheart",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.6)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Rammeses II"] = {
		UnitName = "Rammeses II",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.35)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Akhenaten"] = {
		UnitName = "Akhenaten",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Tutankhamun"] = {
		UnitName = "Tutankhamun",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
	["Narmer"] = {
		UnitName = "Narmer",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.35)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Cleopatra"] = {
		UnitName = "Cleopatra",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.35)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Ptolemy"] = {
		UnitName = "Ptolemy",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage, 0.35)
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
}

local Ultimate = {}

Ultimate.UnitData = UnitData

function Ultimate.LevelFunc(Level: number): number
	return 1 + (Level / 100)
end

return Ultimate
