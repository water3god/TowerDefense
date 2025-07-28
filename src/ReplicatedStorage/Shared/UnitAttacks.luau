--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions)
local Promise = require(Packages.Promise)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local SFXService = require(GlobalClient.SFXService)

local ModelStorage = ReplicatedStorage.ModelStorage
local Adornments = ModelStorage.Adornments
local PompeyArrow = Adornments.PompeyArrow

local Extra = ModelStorage.Extra
local ParticleEmitter = Extra.ParticleEmitter

local Emitters = ModelStorage.Emitters
local AttackParticle = Emitters["Blood-01"]
local Slash = Emitters.Alpha

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

local SoundEffects = SoundService.SoundEffects
local Sounds = SoundEffects.Sounds

local GlobalWorkspace = workspace.GlobalWorkspace
local ParticlesFolder = GlobalWorkspace.Particles

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
	Times: number?,
	Func: ((Particle: ParticleEmitter) -> ())?
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
			if Func then
				Func(ParticleClone)
			end
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
	Times: number?,
	Func: ((Particle: ParticleEmitter) -> ())?
): Promise.Promise
	local Emitter = ParticleEmitter:Clone()
	Emitter.CFrame = CFrame

	local ParticlePromise = EmitOnPart(Unit, ParticlesInput, { Emitter }, Once, Attack, Times, Func):finally(function()
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

	Emitter.Parent = ParticlesFolder

	return ParticlePromise
end

local function PlayAttackHit(Enemy: Types.EnemyClient?)
	if not Enemy or not Enemy.Root then
		return
	end

	local Emitter = ParticleEmitter:Clone()
	Emitter.Name = "AttackEmitter"
	Emitter.CFrame = Enemy.Root.CFrame + RandomVector() / 2

	local Particle = AttackParticle:Clone()
	Particle.Parent = Emitter.___EmitAttachment

	Emitter.Parent = ParticlesFolder
	Particle:Emit(10)

	task.delay(Particle.Lifetime.Max, function()
		Emitter:Destroy()
	end)
end

local function DelayedAttackHit(
	Unit: Types.Unit,
	AttackInput: Types.UnitAttackInput,
	Enemy: Types.EnemyClient?,
	Time: number,
	Delay: number,
	Name: string?
)
	if not Enemy or not Enemy.Root then
		return
	end

	local CalculatedDelay = CalculateDelay(Time, AttackInput.SpeedRatio, Delay)

	local Attack = Promise.delay(CalculatedDelay):andThen(function()
		PlayAttackHit(Enemy)
	end)

	Unit:AddAttackPromise(Attack, "DelayedAttackHit" .. (Name or ""))
end

local function DelayedSound(
	Unit: Types.Unit,
	SoundsList: { Sound },
	AttackInput: Types.UnitAttackInput,
	Enemy: Types.EnemyClient?,
	Time: number,
	Delay: number,
	Name: string?
)
	if not Enemy or not Enemy.Root then
		return
	end

	local CalculatedDelay = CalculateDelay(Time, AttackInput.SpeedRatio, Delay)

	local Attack = Promise.delay(CalculatedDelay):andThen(function()
		PlayAttackHit(Enemy)
		SFXService.PlaySoundAtRandom(SoundsList, Unit.Root.CFrame)
	end)

	Unit:AddAttackPromise(Attack, "DelayedAttackHitWithSound" .. (Name or ""))
end

local function EasyWeld(Part0: BasePart, Part1: BasePart)
	local Weld = Instance.new("Weld")
	Weld.Name = Part0.Name
	Weld.Part0 = Part0
	Weld.Part1 = Part1
	Weld.Parent = Part0
	return Weld
end

local function FireArrow(
	Unit: Types.Unit,
	AttackInput: Types.UnitAttackInput,
	Enemy: Types.EnemyClient?,
	Delay: number,
	Data: {
		DelayTime: number,
		Realigned: CFrame,
		Speed: number,
	}
)
	if not Enemy then
		return
	end
	local SpeedRatio = AttackInput.SpeedRatio
	PlayAnimation(Unit, AttackInput, Delay)
	SFXService.PlaySoundAt(Sounds.bow_pull, Unit.Root.CFrame)

	local Arrow = Unit:WeldAdornment(PompeyArrow)
	Arrow.Parent = ParticlesFolder

	local DelayTime = CalculateDelay(Data.DelayTime, SpeedRatio, Delay)
	DestroyBeforeTime(Unit, Arrow, DelayTime)

	local LastPosition: Vector3? = nil

	if Enemy then
		Enemy.Destroying:Once(function()
			LastPosition = Enemy.CFrame.Position + Vector3.new(0, Enemy.YOffset, 0)
			Enemy = nil
		end)
	end

	Unit:AddAttackPromise(
		Promise.delay(DelayTime)
			:andThen(function()
				if Enemy then
					Unit:RotateToEnemy(Enemy)
				end
				SFXService.PlaySoundAt(Sounds.bow_release, Unit.Root.CFrame)
				ClearWelds(Arrow)
				local Middle = FindFirstMiddle(Arrow)
				if Middle then
					Middle.Anchored = true
					if Enemy then
						LastPosition = Enemy.CFrame.Position + Vector3.new(0, Enemy.YOffset, 0)
					end
					Realign(Arrow, Data.Realigned)
					if Enemy and LastPosition then
						TweenBetweenPositions(
							Middle,
							Middle.CFrame.Position,
							LastPosition + RandomVector() / 2,
							Data.Speed,
							Unit.CFrame.Position
						):await()
						if Enemy then
							PlayAttackHit(Enemy)
							SFXService.PlaySoundAt(Sounds.arrow_hit, Middle.CFrame)
						else
							SFXService.PlaySoundAt(Sounds.arrow_miss, Middle.CFrame)
						end
					end
				end
			end)
			:finally(function()
				Arrow:Destroy()
			end),
		"AttackArrow"
	)
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
					FireArrow(Unit, AttackInput, Enemy, Delay, {
						DelayTime = 0.4,
						Realigned = CFrame.Angles(0, math.rad(90), 0),
						Speed = 50,
					})
				end,
			},
		},
		["Augustus"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.35, Delay)
					DelayedSound(Unit, { Sounds.SwordSwing }, AttackInput, Enemy, 0.2, Delay)
				end,
			},
		},
		["Alexander The Great"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					local DelayTime = CalculateDelay(0.38, AttackInput.SpeedRatio, Delay)

					local DelProm = Promise.delay(DelayTime):andThen(function()
						if not Enemy or not Enemy.Root then
							return
						end
						local EmitPromise =
							Emit(Unit, { Emitters.AlexanderSpark }, Enemy.Root.CFrame + RandomVector() / 2, true, true)
						Unit:AddAttackPromise(EmitPromise, "AlexanderAttackEmitReal")
					end)

					DelayedAttackHit(Unit, AttackInput, Enemy, 0.38, Delay)
					DelayedSound(Unit, { Sounds.SwordSwing }, AttackInput, Enemy, 0.32, Delay)
					Unit:AddAttackPromise(DelProm, "AlexanderAttackEmit")
				end,
			},
		},
		["Julius Caesar"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					SFXService.PlaySoundAt(Sounds.LightSwing, Unit.Root.CFrame)

					local DelayTime = CalculateDelay(0.15, AttackInput.SpeedRatio, Delay)

					local DelProm = Promise.delay(DelayTime):andThen(function()
						Emit(
							Unit,
							{ Emitters.GreySlash },
							Unit.Root.CFrame + Unit.CFrame.LookVector * 1.5,
							true,
							true,
							2
						)
					end)

					DelayedAttackHit(Unit, AttackInput, Enemy, 0.15, Delay)

					Unit:AddAttackPromise(DelProm, "JuliusAttackEmit")
				end,
			},
		},
		["Pyrrhus"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)

					local DelayTime = CalculateDelay(0.3, AttackInput.SpeedRatio, Delay)

					local DelProm = Promise.delay(DelayTime):andThen(function()
						Emit(
							Unit,
							{ Emitters.BlackSlash },
							Unit.Root.CFrame + Unit.CFrame.RightVector / 1.2 + Unit.CFrame.LookVector * 1.5,
							true,
							true,
							2
						)
					end)

					DelayedAttackHit(Unit, AttackInput, Enemy, 0.3, Delay)
					DelayedSound(Unit, { Sounds.SwordSwing }, AttackInput, Enemy, 0.2, Delay)

					Unit:AddAttackPromise(DelProm, "PyrrhusAttackEmit")
				end,
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

					DelayedSound(Unit, { Sounds.SwordSwing }, AttackInput, Enemy, 0.34, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.42, Delay)

					Unit:AddAttackPromise(DelProm, "SpartacusAttackEmit")
				end,
			},
		},
		["Leonidas"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)

					local DelayTime = CalculateDelay(0.3, AttackInput.SpeedRatio, Delay)

					local DelProm = Promise.delay(DelayTime):andThen(function()
						EmitOnPart(
							Unit,
							{ Emitters.pierce },
							{ Unit.Character.LeonidasArmor.RightHand.Spear.MainPole.Pole },
							true,
							true,
							30
						)
					end)

					DelayedAttackHit(Unit, AttackInput, Enemy, 0.3, Delay)
					DelayedSound(Unit, { Sounds.LightSwing }, AttackInput, Enemy, 0.2, Delay)

					Unit:AddAttackPromise(DelProm, "LeonidasAttackEmit")
				end,
			},
		},
		["William the Conqueror"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.3, Delay, "1")
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.5, Delay, "2")
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.8, Delay, "3")
					DelayedSound(Unit, { Sounds.SwordSwing, Sounds.LightSwing }, AttackInput, Enemy, 0.2, Delay, "1")
					DelayedSound(Unit, { Sounds.SwordSwing, Sounds.LightSwing }, AttackInput, Enemy, 0.4, Delay, "2")
					DelayedSound(Unit, { Sounds.SwordSwing, Sounds.LightSwing }, AttackInput, Enemy, 0.7, Delay, "3")
				end,
			},
		},
		["Charlemagne"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.6, Delay)
					DelayedSound(Unit, { Sounds.HeavySwordSwing, Sounds.HeavySwing2 }, AttackInput, Enemy, 0.3, Delay)
				end,
			},
		},
		["Richard the Lionheart"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.6, Delay)
					DelayedSound(Unit, { Sounds.HeavySwordSwing, Sounds.HeavySwing2 }, AttackInput, Enemy, 0.3, Delay)

					for i = 1, 3, 1 do
						local NewDelay = CalculateDelay(0.2, AttackInput.SpeedRatio, Delay)
						local SmashPromise = Promise.delay(NewDelay + i / 10):andThen(function()
							local Part = Instance.new("Part")
							Part.Size = Vector3.new(3, 3, 3)
							Part.Anchored = true
							Part.CanCollide = false
							Part.CanQuery = false
							Part.Transparency = 1
							Part.CFrame = (Unit.CFrame + Unit.CFrame.LookVector * i * 5)
									* CFrame.Angles(
										math.rad(Random:NextNumber(0, 360)),
										math.rad(Random:NextNumber(0, 360)),
										math.rad(Random:NextNumber(0, 360))
									)
								- Vector3.new(0, 5, 0)

							local Raycast =
								workspace:Raycast(Part.CFrame.Position + Vector3.yAxis * 6, -Vector3.yAxis * 2)

							if Raycast and Raycast.Instance then
								Part.Material = Raycast.Instance.Material
								Part.Color = Raycast.Instance.Color
							else
								Part.Material = Enum.Material.Concrete
							end

							Promise.resolve()
								:andThen(function()
									TweenService
										:Create(
											Part,
											TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{
												CFrame = Part.CFrame + Vector3.new(0, 5, 0),
												Transparency = 0,
											}
										)
										:Play()
									Part.Parent = ParticlesFolder

									Emit(
										Unit,
										{ Emitters["Smoke-Debris"] },
										Part.CFrame + Vector3.new(0, 5, 0),
										true,
										true,
										10
									)
									Emit(
										Unit,
										{ Emitters["Smoke-Debris-2"] },
										Part.CFrame + Vector3.new(0, 5, 0),
										true,
										true,
										5,
										function(Emitter: ParticleEmitter)
											Emitter.Color = ColorSequence.new(Part.Color)
										end
									)
									wait(3)
								end)
								:andThen(function()
									local Tween = TweenService:Create(
										Part,
										TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{
											CFrame = Part.CFrame - Vector3.new(0, 5, 0),
											Transparency = 1,
										}
									)

									Tween:Play()
									Tween.Completed:Wait()
								end)
								:andThen(function()
									Part:Destroy()
								end)

							return Part
						end)

						Unit:AddAttackPromise(SmashPromise, "RichardGroundHit" .. i)
					end
				end,
			},
		},
		["Robert the Bruce"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.5, Delay)

					local DelayTime = CalculateDelay(0.3, AttackInput.SpeedRatio, Delay)

					local DelProm = Promise.delay(DelayTime):andThen(function()
						Emit(
							Unit,
							{ Emitters["Grey-alpha"] },
							Unit.Root.CFrame + Unit.CFrame.RightVector / 1.2 + Unit.CFrame.LookVector * 2,
							true,
							true,
							2
						)
					end)

					SFXService.PlaySoundAt(Sounds.SwordSwing, Unit.Root.CFrame)
					Unit:AddAttackPromise(DelProm, "RobertAttackEmit")
				end,
			},
		},
		["Ptolemy"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					FireArrow(Unit, AttackInput, Enemy, Delay, {
						DelayTime = 0.4,
						Realigned = CFrame.Angles(0, math.rad(90), 0),
						Speed = 70,
					})
				end,
			},
		},
		["Cleopatra"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					FireArrow(Unit, AttackInput, Enemy, Delay, {
						DelayTime = 0.4,
						Realigned = CFrame.Angles(0, math.rad(90), 0),
						Speed = 100,
					})
				end,
			},
		},
		["Narmer"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
				end,
			},
		},
		["Ramesses II"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					DefaultAttack(Unit, AttackInput, Enemy, Delay)
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.4, Delay, "1")
					DelayedAttackHit(Unit, AttackInput, Enemy, 0.65, Delay, "2")
					DelayedSound(Unit, { Sounds.LightSwing }, AttackInput, Enemy, 0.35, Delay, "1")
					DelayedSound(Unit, { Sounds.LightSwing }, AttackInput, Enemy, 0.6, Delay, "2")

					local FirstDelay = CalculateDelay(0.3, AttackInput.SpeedRatio, Delay)
					local SecondDelay = CalculateDelay(0.55, AttackInput.SpeedRatio, Delay)

					local FirstAttackParticle = Promise.delay(FirstDelay):andThen(function()
						Emit(
							Unit,
							{ Emitters.GreenAttack },
							Unit.Root.CFrame
								+ Unit.CFrame.RightVector
								+ Unit.CFrame.LookVector * 2
								+ Unit.CFrame.UpVector * 0.5,
							true,
							true,
							2,
							function(Particle: ParticleEmitter)
								Particle.Rotation = NumberRange.new(130)
							end
						)
					end)

					local SecondAttackParticle = Promise.delay(SecondDelay):andThen(function()
						Emit(
							Unit,
							{ Emitters.GreenAttack },
							Unit.Root.CFrame - Unit.CFrame.RightVector * 0.7 + Unit.CFrame.LookVector * 1.5,
							true,
							true,
							2,
							function(Particle: ParticleEmitter)
								Particle.EmissionDirection = Enum.NormalId.Top
								Particle.RotSpeed = NumberRange.new(-20)
								Particle.Size = NumberSequence.new(2)
								Particle.Rotation = NumberRange.new(100)
							end
						)
					end)

					Unit:AddAttackPromise(FirstAttackParticle, "RamessesFirstAttackParticle")
					Unit:AddAttackPromise(SecondAttackParticle, "RamessesSecondAttackParticle")
				end,
			},
		},
	}

local DefaultRuns: { [string]: { [number]: (Unit: Types.Unit) -> () } } = {
	["Trajan"] = {},
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
