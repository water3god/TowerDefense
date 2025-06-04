--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Packages = ReplicatedStorage.Packages
local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions)
local Promise = require(Packages.Promise)

local ModelStorage = ReplicatedStorage.ModelStorage
local Adornments = ModelStorage.Adornments
local PompeyArrow = Adornments.PompeyArrow

local Extra = ModelStorage.Extra
local ParticleEmitter = Extra.ParticleEmitter

local Emitters = ModelStorage.Emitters
local Slash = Emitters.Alpha

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

local Random = Random.new()

local function RandomVector(): Vector3
	return Vector3.new(Random:NextNumber(-1, 1), Random:NextNumber(-1, 1), Random:NextNumber(-1, 1))
end

local function FindFirstMiddle(Adornment: Model): BasePart?
	for _, Descendant in ipairs(Adornment:GetDescendants()) do
		if Descendant:IsA("BasePart") and Descendant.Name == "Middle" then
			return Descendant
		end
	end

	return
end

local function Realign(Adornment: Model, NewOrientation: CFrame)
	local Middle = FindFirstMiddle(Adornment)

	if Middle then
		for _, Weld in ipairs(Middle:GetChildren()) do
			if Weld:IsA("Motor6D") then
				local OtherPart = Weld.Part0
				if OtherPart then
					Weld.Enabled = false
					Middle.CFrame *= NewOrientation

					Weld.C0 = OtherPart.CFrame:Inverse()
					Weld.C1 = Middle.CFrame:Inverse()

					Weld.Enabled = true
				end
			end
		end
	end
end

local function ClearWelds(Adornment: Model)
	for _, Limb in ipairs(Adornment:GetChildren()) do
		local Middle = Limb:FindFirstChild("Middle") :: BasePart?

		if Middle then
			local Weld = Middle:FindFirstChild("MainMiddleWeld")
			if Weld then
				Weld:Destroy()
			end
		end
	end
end

local function PlayAnimation(Unit, AttackInput, Delay: number)
	local SpeedRatio = AttackInput.SpeedRatio
	Unit:PlayAnimation("Attack", Delay / SpeedRatio, 1 / SpeedRatio, nil)
end

local function DefaultAttack(Unit, AttackInput, Enemy, Delay: number)
	if Enemy then
		Unit:RotateToEnemy(Enemy)
	end
	PlayAnimation(Unit, AttackInput, Delay)
end

local function CalculateDelay(Normal: number, SpeedRatio: number, Delay: number)
	return math.clamp(Normal * SpeedRatio - Delay, 0, math.huge)
end

local function DestroyBeforeTime(Unit: Types.Unit, Model: Model, Delay: number)
	Unit:AddAttackPromise(
		Promise.delay(Delay):finally(function(Status)
			if Status == "Cancelled" then
				Model:Destroy()
			end
		end),
		"DelayPromiseTime"
	)
end

local function TweenBetweenPositions(
	Part: BasePart,
	Start: Vector3,
	End: Vector3,
	Speed: number,
	DistanceCalc: Vector3?
)
	return Promise.new(function(resolve, reject)
		local Distance = (Start - End).Magnitude
		if DistanceCalc then
			Distance = (DistanceCalc - End).Magnitude
		end
		local Inital = CFrame.lookAt(Start, End)
		Part.CFrame = Inital
		local Tween = TweenService:Create(Part, TweenInfo.new(Distance / Speed), {
			CFrame = CFrame.new(End) * Inital.Rotation,
		})

		Tween:Play()

		Tween.Completed:Once(function(PlaybackState)
			if PlaybackState == Enum.PlaybackState.Cancelled then
				reject()
			else
				resolve()
			end
		end)
	end)
end

local function EmitOnPart(
	Unit: Types.Unit,
	ParticlesInput: { ParticleEmitter },
	Emitters: { Part },

	Once: boolean,
	Attack: boolean,
	Times: number?
)
	local Particles = {}

	for _, Emitter in ipairs(Emitters) do
		local Attachment = Emitter:FindFirstChild("___EmitAttachment")
		if not Attachment then
			Attachment = Instance.new("Attachment")
			if Attachment then
				Attachment.Name = "___EmitAttachment"
				Attachment.Parent = Emitter
			end
		end
		for _, Particle in ipairs(ParticlesInput) do
			local ParticleClone = Particle:Clone()
			table.insert(Particles, ParticleClone)
			ParticleClone.Parent = Attachment
		end
	end

	local ParticlePromise = Promise.new(function(resolve, reject, oncancel)
		oncancel(function()
			for _, Particle in ipairs(Particles) do
				Particle:Clear()
			end
		end)
		if Once then
			for _, Particle in ipairs(Particles) do
				Particle:Emit(Times or 1)
			end
			resolve()
		else
			for _, Particle in ipairs(Particles) do
				Particle.Enabled = true
			end
		end
	end):finally(function()
		for _, Particle in ipairs(Particles) do
			Particle.Enabled = false
			task.delay(Particle.Lifetime.Max, function()
				Particle:Destroy()
			end)
		end
	end)

	if Attack then
		Unit:AddAttackPromise(ParticlePromise, "___AttackEmitterv0.01")
	else
		Unit:AddPromise(ParticlePromise, "___Emitterv0.01")
	end

	return ParticlePromise
end

local function Emit(
	Unit: Types.Unit,
	ParticlesInput: { ParticleEmitter },
	CFrame: CFrame,
	Once: boolean,
	Attack: boolean,
	Times: number?
): Promise.Promise
	local Emitter = ParticleEmitter:Clone()
	Emitter.CFrame = CFrame

	local ParticlePromise = EmitOnPart(Unit, ParticlesInput, { Emitter }, Once, Attack, Times):finally(function()
		local LongestTime = 0
		for _, Particle in ipairs(ParticlesInput) do
			if LongestTime < Particle.Lifetime.Max then
				LongestTime = Particle.Lifetime.Max
			end
		end
		task.delay(LongestTime, function()
			Emitter:Destroy()
		end)
	end)

	Emitter.Parent = workspace

	return ParticlePromise
end

local function EasyWeld(Part0: BasePart, Part1: BasePart)
	local Weld = Instance.new("Weld")
	Weld.Name = Part0.Name
	Weld.Part0 = Part0
	Weld.Part1 = Part1
	Weld.Parent = Part0
	return Weld
end

local UnitAttacks: {
	[string]: {
		[number --[[Level]]]: {
			--[[Index]]
			(
				Unit: Types.Unit,
				AttackInput: Types.UnitAttackInput,
				Enemy: Types.EnemyClient?,
				Delay: number
			) -> ()
		},
	},
} =
	{
		["Pompey"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					if not Enemy then
						return
					end
					local SpeedRatio = AttackInput.SpeedRatio
					PlayAnimation(Unit, AttackInput, Delay)

					local Arrow = Unit:WeldAdornment(PompeyArrow)
					Arrow.Parent = workspace

					local DelayTime = CalculateDelay(0.4, SpeedRatio, Delay)
					DestroyBeforeTime(Unit, Arrow, DelayTime)

					local LastPosition: Vector3? = nil

					Enemy.Destroying:Once(function()
						LastPosition = Enemy.CFrame.Position + Vector3.new(0, Enemy.YOffset, 0)
						Enemy = nil
					end)

					Unit:AddAttackPromise(
						Promise.delay(DelayTime)
							:andThen(function()
								if Enemy then
									Unit:RotateToEnemy(Enemy)
								end
								ClearWelds(Arrow)
								local Middle = FindFirstMiddle(Arrow)
								if Middle then
									Middle.Anchored = true
									if Enemy then
										LastPosition = Enemy.CFrame.Position + Vector3.new(0, Enemy.YOffset, 0)
									end
									Realign(Arrow, CFrame.Angles(0, math.rad(90), 0))
									if LastPosition then
										TweenBetweenPositions(
											Middle,
											Middle.CFrame.Position,
											LastPosition + RandomVector() / 2,
											50,
											Unit.CFrame.Position
										):await()
									end
								end
							end)
							:finally(function()
								Arrow:Destroy()
							end),
						"AttackPompeyArrow"
					)
				end,
			},
		},
		["Alexander The Great"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					local DelayTime = CalculateDelay(0.35, AttackInput.SpeedRatio, Delay)

					local DelProm = Promise.delay(DelayTime)
						:andThen(function()
							if not Enemy then
								return
							end
							local EmitPromise = Emit(
								Unit,
								{ Emitters.AlexanderSpark },
								Enemy.Root.CFrame + RandomVector() / 2,
								true,
								true
							)
							Unit:AddAttackPromise(EmitPromise, "AlexanderAttackEmitReal")
							Promise.delay(CalculateDelay(0.3, AttackInput.SpeedRatio, Delay - DelayTime)):await()
						end)
						:andThen(function()
							Unit:CancelPromise("AlexanderAttackEmitReal")
						end)
					Unit:AddAttackPromise(DelProm, "AlexanderAttackEmit")
				end,
			},
		},
		["Julius Caesar"] = {
			[0] = {
				DefaultAttack,
			},
		},
		["Spartacus"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)

					local DelayTime = CalculateDelay(0.42, AttackInput.SpeedRatio, Delay)
					local DelProm = Promise.delay(DelayTime):andThen(function()
						Emit(
							Unit,
							{ Slash },
							Unit.Root.CFrame + Unit.CFrame.RightVector / 1.2 + Unit.CFrame.LookVector * 2,
							true,
							true,
							2
						)
					end)

					Unit:AddAttackPromise(DelProm, "SpartacusAttackEmit")
				end,
			},
		},
	}

local DefaultRuns: { [string]: { [number]: (Unit: Types.Unit) -> () } } = {
	["Trajan"] = {
		[0] = function(Unit)
			Unit:PlayAnimation("Ability")
		end,
	},
}

local Abilities: {
	[string]: {
		(Unit: Types.Unit, Data: {
			LastUsed: number,
			Length: number,
			Cooldown: number,
		}) -> ()
	},
} =
	{
		["Spartacus"] = {
			function(Unit, Data)
				local EmitPromise = Emit(
					Unit,
					{ Emitters.AwakeningD, Emitters.AwakeningL, Emitters.aura, Emitters.aura2 },
					Unit.Root.CFrame,
					false,
					false
				)
				local Delay = workspace:GetServerTimeNow() - Data.LastUsed

				local DelayProm = Promise.delay(Data.Length - Delay):andThen(function()
					EmitPromise:cancel()
				end)

				EmitPromise:finally(function(Status)
					if Status == "Cancelled" then
						DelayProm:cancel()
					end
				end)

				Unit:AddPromise(DelayProm, "SpartacusAbilityPromise")
			end,
		},
	}

return {
	UnitAttacks = UnitAttacks,
	DefaultRuns = DefaultRuns,
	Abilities = Abilities,
}
