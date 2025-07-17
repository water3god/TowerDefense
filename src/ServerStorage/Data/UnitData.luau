--!strict
--!native
--#selene: allow(unused_variable, global_usage)

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Timer = require(Packages.Timer)

local GlobalModules = ServerScriptService.GlobalModules
local UnitModule = require(GlobalModules.Unit)
local GlobalWave = require(GlobalModules.GlobalWave)

local function AddAlly(Unit: UnitModule.Unit, Ally: string, Data: {}?)
	local Wave = GlobalWave.GetWave()
	if Wave then
		Unit:AddAlly(Wave:AddAlly(Ally, Data))
	end
end

local function AddAllyToWave(Unit: UnitModule.Unit, Callback: () -> (string, {}?))
	local AllyTrove = Unit._Trove:Extend()
	local Wave = GlobalWave.GetWave()
	local AllyTimer = AllyTrove:Construct(Timer, Unit:GetProperty("FireRate"))
	local function HandleWave(Input: GlobalWave.GlobalWave)
		if Input.Wave == 0 then
			AllyTrove:Connect(Input.Passed, function()
				AllyTimer:Start()
			end)
		else
			AllyTimer:Start()
		end
	end

	if Wave then
		HandleWave(Wave)
	else
		AllyTrove:Connect(GlobalWave.Added, HandleWave)
	end

	AllyTrove:Connect(Unit.PropertyChanged, function(Property: string, Value: number)
		if Property == "FireRate" then
			AllyTimer.Interval = Value
		end
	end)

	AllyTimer.Tick:Connect(function()
		local Ally, Data = Callback()
		AddAlly(Unit, Ally, Data)
	end)

	return AllyTrove:WrapClean()
end

local function AddCoinsPerWave(Unit: UnitModule.Unit, Callback: (Wave: number) -> number)
	local Wave = GlobalWave.GetWave()

	if Wave then
		local Connection = Wave.Passed:Connect(function()
			Unit:AddCoins(Callback(Wave.Wave))
		end)

		return function()
			Connection:Disconnect()
		end
	end

	return function() end
end

local function ApplyBuff(Unit: UnitModule.Unit, BuffType: string, Ratio: number, Duration: number)
	local BuffTrove = Unit._Trove:Extend()

	local HandlingUnits = {}

	local function Handle(OtherUnit: UnitModule.Unit)
		local Name = string.format("Buff_%s_%s", OtherUnit.UniqueId, BuffType)
		OtherUnit:ChangeRatio(Name, "Damage", Ratio, Duration)
		table.insert(HandlingUnits, OtherUnit)

		BuffTrove:Connect(OtherUnit.Destroying, function()
			local Index = table.find(HandlingUnits, OtherUnit)
			if Index then
				table.remove(HandlingUnits, Index)
			end
		end)
	end

	BuffTrove:Add(function()
		for _, OtherUnit in pairs(HandlingUnits) do
			local Name = string.format("Buff_%s_%s", OtherUnit.UniqueId, BuffType)
			OtherUnit:CancelRatio(Name)
		end
		HandlingUnits = {}
	end)

	for _, OtherUnit in pairs(Unit:GetUnitsInRange()) do
		Handle(OtherUnit)
	end

	BuffTrove:Connect(Unit.Added, function(OtherUnit: UnitModule.Unit)
		if Unit:UnitIsInRange(OtherUnit) then
			Handle(OtherUnit)
		end
	end)

	BuffTrove:Connect(Unit.Upgraded, BuffTrove:WrapClean())

	return BuffTrove:WrapClean()
end

local function DelayAttack(Unit: UnitModule.Unit, Damage: number, Delay: number)
	local CurrentEnemy = Unit.CurrentEnemy

	if CurrentEnemy then
		Unit:AddAttackPromise(
			Promise.delay(Delay * Unit.Ratios.FireRate):andThen(function()
				Unit:DamageEnemy(CurrentEnemy, Damage)
			end),
			"DelayAttack"
		)
	end
end

local UnitData: { [string]: UnitModule.UnitInput } = {
	["Pompey"] = {
		UnitName = "Pompey",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					local CurrentEnemy = Unit.CurrentEnemy
					Unit:AddAttackPromise(
						Promise.delay(0.4 * Unit.Ratios.FireRate):andThen(function()
							if CurrentEnemy and CurrentEnemy.Damage then
								local Speed = 50
								local Distance = (Unit.CFrame.Position - CurrentEnemy.CFrame.Position).Magnitude
								Unit:AddPromise(
									Promise.delay(Distance / Speed):andThen(function()
										Unit:DamageEnemy(CurrentEnemy, Damage)
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

				Unit:ChangeRatio("SpartacusRage", "FireRate", 0.7, Data.Length)
			end,
		},
	},
	["Cicero"] = {
		UnitName = "Cicero",

		AttackFuncs = {},
		DefaultRuns = {
			[0] = function(Unit)
				return AddCoinsPerWave(Unit, function(Wave: number)
					return Unit:GetProperty("Coins")
				end)
			end,
		},
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
	["Augustus"] = {
		UnitName = "Augustus",

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
	["Trajan"] = {
		UnitName = "Trajan",

		AttackFuncs = {},
		DefaultRuns = {
			[0] = function(Unit, Damage: number)
				return AddAllyToWave(Unit, function()
					Unit:PlayAnimation("Ability")
					return "Legionary", { Health = Damage }
				end)
			end,
		},
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
		DefaultRuns = {
			[0] = function(Unit)
				return AddCoinsPerWave(Unit, function(Wave: number)
					return Unit:GetProperty("Coins")
				end)
			end,
		},
		Abilities = {},
	},
	["Pericles"] = {
		UnitName = "Pericles",

		AttackFuncs = {},
		DefaultRuns = {
			[0] = function(Unit)
				return ApplyBuff(Unit, "Damage", 1.5, math.huge)
			end,
		},
		Abilities = {},
	},
	["Themistocles"] = {
		UnitName = "Themistocles",

		AttackFuncs = {},
		DefaultRuns = {},
		Abilities = {},
	},
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
	["Akhenaten"] = {
		UnitName = "Akhenaten",

		AttackFuncs = {},
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
	["Tutankhamun"] = {
		UnitName = "Tutankhamun",

		AttackFuncs = {},
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
