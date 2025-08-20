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

local function HealBase(Health: number)
	local Wave = GlobalWave.GetWave()
	if Wave then
		Wave:Heal(Health)
	end
end

local function HealBasePerWave(Health: number)
	local Wave = GlobalWave.GetWave()
	if Wave then
		local Connection = Wave.Passed:Connect(function()
			Wave:Heal(Health)
		end)

		return function()
			Connection:Disconnect()
		end
	end

	return function() end
end

local function AddAlly(Unit: UnitModule.Unit, Ally: string, Data: {}?)
	local Wave = GlobalWave.GetWave()
	if Wave then
		task.defer(function()
			Unit:AddAlly(Wave:AddAlly(Ally, Data))
		end)
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

local function ApplyBuff(Unit: UnitModule.Unit, BuffType: string, Ratio: number, Duration: number): () -> ()
	local BuffTrove = Unit._Trove:Extend()

	if BuffType == "FireRate" then
		Ratio = 1 / Ratio
	end

	local HandlingUnits = {}

	local function Handle(OtherUnit: UnitModule.Unit)
		if OtherUnit == Unit then
			return
		end

		local Name = string.format("Buff_%s_%s", Unit.UnitName, BuffType)

		OtherUnit:ChangeRatio(Name, Unit.UniqueId, BuffType, Ratio, Duration)
		table.insert(HandlingUnits, OtherUnit)

		BuffTrove:Connect(OtherUnit.Destroying, function()
			local Index = table.find(HandlingUnits, OtherUnit)
			if Index then
				table.remove(HandlingUnits, Index)
			end
		end)
	end

	BuffTrove:Connect(Unit.Destroying, function()
		for _, OtherUnit in pairs(HandlingUnits) do
			local Name = string.format("Buff_%s_%s", Unit.UnitName, BuffType)
			OtherUnit:CancelRatio(Name, Unit.UniqueId)
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

	return function()
		task.defer(BuffTrove.Destroy, BuffTrove)
	end
end

local function DelayAttack(Unit: UnitModule.Unit, Damage: number, Delay: number, Name: string?)
	local CurrentEnemy = Unit.CurrentEnemy

	if CurrentEnemy then
		Unit:AddAttackPromise(
			Promise.delay(Delay * Unit.Ratios.FireRate):andThen(function()
				Unit:DamageEnemy(CurrentEnemy, Damage)
			end),
			"DelayAttack" .. (Name or "")
		)
	end
end

local function DelayAOE(
	Unit: UnitModule.Unit,
	Damage: number,
	Delay: number,
	ShapeData: {
		Type: string,
		Size: number,
	},
	Name: string?
)
	Unit:AddAttackPromise(
		Promise.delay(Delay * Unit.Ratios.FireRate):andThen(function()
			if Unit.CurrentEnemy then
				if ShapeData.Type == "Cone" then
					-- Ignore Y axis for cone calculations
					local UnitPos = Vector3.new(Unit.CFrame.Position.X, 0, Unit.CFrame.Position.Z)
					local TargetPos =
						Vector3.new(Unit.CurrentEnemy.CFrame.Position.X, 0, Unit.CurrentEnemy.CFrame.Position.Z)
					local UnitToTarget = (TargetPos - UnitPos).Unit
					local ConeThreshold = math.cos(math.rad(ShapeData.Size / 2))

					for _, Enemy in pairs(Unit:GetEnemiesInRange()) do
						local EnemyPos = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z)
						local UnitToEnemy = (EnemyPos - UnitPos).Unit
						local DotProduct = UnitToTarget:Dot(UnitToEnemy)

						if DotProduct >= ConeThreshold then
							Unit:DamageEnemy(Enemy, Damage)
						end
					end
				elseif ShapeData.Type == "Line" then
					-- Ignore Y axis for line calculations
					local UnitPos = Vector3.new(Unit.CFrame.Position.X, 0, Unit.CFrame.Position.Z)
					local TargetPos =
						Vector3.new(Unit.CurrentEnemy.CFrame.Position.X, 0, Unit.CurrentEnemy.CFrame.Position.Z)
					local UnitToTarget = (TargetPos - UnitPos).Unit

					for _, Enemy in pairs(Unit:GetEnemiesInRange()) do
						local EnemyPos = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z)
						local UnitToEnemy = EnemyPos - UnitPos
						local ProjectionLength = UnitToTarget:Dot(UnitToEnemy)
						local RejectionMagnitude = math.sqrt(UnitToEnemy.Magnitude ^ 2 - ProjectionLength ^ 2)

						if ProjectionLength >= 0 and ProjectionLength <= ShapeData.Size and RejectionMagnitude <= 5 then
							Unit:DamageEnemy(Enemy, Damage)
						end
					end
				elseif ShapeData.Type == "Circle" then
					for _, Enemy in pairs(Unit:GetEnemiesInRange()) do
						Unit:DamageEnemy(Enemy, Damage)
					end
				else
					warn("Unknown ShapeData Type", ShapeData.Type)
				end
			end
		end),
		"DelayAOE" .. (Name or "")
	)
end

local function FireArrow(Unit: UnitModule.Unit, Damage: number, Speed: number, Delay: number)
	local CurrentEnemy = Unit.CurrentEnemy
	if CurrentEnemy then
		Unit:AddAttackPromise(
			Promise.delay(Delay * Unit.Ratios.FireRate):andThen(function()
				if CurrentEnemy and CurrentEnemy.Damage then
					local Distance = (Unit.CFrame.Position - CurrentEnemy.CFrame.Position).Magnitude
					Unit:AddPromise(
						Promise.delay(Distance / Speed):andThen(function()
							Unit:DamageEnemy(CurrentEnemy, Damage)
						end),
						"FireArrowTravel"
					)
				end
			end),
			"FireArrow"
		)
	end
end

local UnitData: { [string]: UnitModule.UnitInput } = {
	["Pompey"] = {
		UnitName = "Pompey",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					FireArrow(Unit, Damage, 50, 0.4)
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

				Unit:ChangeRatio("SpartacusRage", "Global", "FireRate", 0.7, Data.Length)
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
					return "Trajan's Legionary", { Health = Unit:GetProperty("Damage") }
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
				local Damage = Unit:GetPropertyRaw("Damage")
				return ApplyBuff(Unit, "Damage", Damage, math.huge)
			end,
		},
		Abilities = {},
	},
	["Themistocles"] = {
		UnitName = "Themistocles",

		AttackFuncs = {},
		DefaultRuns = {
			[0] = function(Unit)
				local Range = Unit:GetPropertyRaw("Damage")
				return ApplyBuff(Unit, "Range", Range, math.huge)
			end,
		},
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
		DefaultRuns = {
			[0] = function(Unit)
				local Ratio = Unit:GetPropertyRaw("Damage")
				return ApplyBuff(Unit, "FireRate", Ratio, math.huge)
			end,
		},
		Abilities = {},
	},
	["William the Conqueror"] = {
		UnitName = "William the Conqueror",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage / 3, 0.3, "1")
					DelayAttack(Unit, Damage / 3, 0.5, "2")
					DelayAttack(Unit, Damage / 3, 0.8, "3")
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
					DelayAOE(Unit, Damage, 0.6, {
						Type = "Line",
						Size = 50,
					})
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
					FireArrow(Unit, Damage, 70, 0.4)
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
					FireArrow(Unit, Damage, 100, 0.4)
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
		DefaultRuns = {
			[0] = function(Unit: UnitModule.Unit)
				local Damage = Unit:GetProperty("Damage")
				return HealBasePerWave(Damage)
			end,
		},
		Abilities = {},
	},
	["Ramesses II"] = {
		UnitName = "Ramesses II",

		AttackFuncs = {
			[0] = {
				function(Unit: UnitModule.Unit, Damage: number)
					DelayAttack(Unit, Damage * 0.5, 0.4, "1")
					DelayAttack(Unit, Damage * 0.5, 0.65, "2")
				end,
			},
		},
		DefaultRuns = {},
		Abilities = {},
	},
	["Tutankhamun"] = {
		UnitName = "Tutankhamun",

		AttackFuncs = {},
		DefaultRuns = {
			[0] = function(Unit: UnitModule.Unit)
				local Ratio = Unit:GetPropertyRaw("Damage")
				local Damage = ApplyBuff(Unit, "Damage", Ratio, math.huge)
				local FireRate = ApplyBuff(Unit, "FireRate", Ratio, math.huge)
				local Range = ApplyBuff(Unit, "Range", Ratio, math.huge)
				return function()
					Damage()
					FireRate()
					Range()
				end
			end,
		},
		Abilities = {},
	},
	["Cao Cao"] = {
		UnitName = "Cao Cao",

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
	["Qin Shi Huang"] = {
		UnitName = "Qin Shi Huang",

		AttackFuncs = {},
		DefaultRuns = {
			function(Unit: UnitModule.Unit)
				local Ratio = Unit:GetPropertyRaw("Damage")
				local Damage = ApplyBuff(Unit, "Damage", Ratio, math.huge)
				local FireRate = ApplyBuff(Unit, "FireRate", Ratio, math.huge)
				local Range = ApplyBuff(Unit, "Range", Ratio, math.huge)
				return function()
					Damage()
					FireRate()
					Range()
				end
			end,
		},
		Abilities = {},
	},
}

local Ultimate = {}

Ultimate.UnitData = UnitData

function Ultimate.LevelFunc(Level: number): number
	return 1 + (Level / 100)
end

return Ultimate
