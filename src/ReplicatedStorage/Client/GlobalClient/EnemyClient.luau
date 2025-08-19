--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Network = require(ReplicatedStorage.Network.Client)
local SpawnEvent = Network.EnemySpawnEvent
local SpeedEvent = Network.EnemySpeedEvent
local HealthEvent = Network.EnemyHealthEvent
local LocationEvent = Network.EnemyLocationEvent
local DestroyEvent = Network.EnemyDestroyEvent

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local BezierPath = require(Modules.BezierPath)
local HelperFunctions = require(Modules.HelperFunctions)
local GenerateId = require(Modules.GenerateId)

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)
local Constants = require(Shared.Constants)

local AnimationFolder = ReplicatedStorage.Animations
local EnemiesAnimations = AnimationFolder.Enemies
local Default = EnemiesAnimations.Default

local ModelStorage = ReplicatedStorage.ModelStorage
local Extra = ModelStorage.Extra
local _Rig = Extra.Rig

local Emitters = ModelStorage.Emitters
local DestroyParticle = Emitters.poof
local OtherDestroyParticle = Emitters.Pops

local EnemyFolder = {}
for _, Enemy in ipairs(ModelStorage.Enemies:GetChildren()) do
	EnemyFolder[Enemy.Name] = Enemy
end
local AdornmentFolder = {}
for _, Adornment in ipairs(ModelStorage.Adornments:GetChildren()) do
	AdornmentFolder[Adornment.Name] = Adornment
end

local GlobalWorkspace = workspace.GlobalWorkspace
local EnemiesFolder = GlobalWorkspace.Enemies
local ParticlesFolder = GlobalWorkspace.Particles

local function WeldParts(Character: typeof(ModelStorage.Extra.Rig), Adornment: Model, SizeRatio: number)
	for _, Limb in ipairs(Adornment:GetChildren()) do
		if not Limb:IsA("Model") then
			continue
		end
		local CharLimb: BasePart? = Character:FindFirstChild(Limb.Name) :: BasePart
		local Handle: BasePart = Limb:FindFirstChild("Handle") :: BasePart

		if not Handle then
			warn("No BasePart Called Handle For: " .. Limb.Name)
		end

		if not CharLimb then
			continue
		end
		Limb:ScaleTo(SizeRatio)

		local Bases: { [BasePart]: CFrame } = {}

		for _, BasePart in ipairs(Limb:GetDescendants()) do
			if BasePart:IsA("BasePart") then
				if BasePart.Name == "Handle" and BasePart.Parent == Limb then
					continue
				end
				BasePart.CanCollide = false
				BasePart.Anchored = false

				local Motor = Instance.new("Motor6D")
				Motor.C0 = BasePart.CFrame:Inverse()
				Motor.C1 = Handle.CFrame:Inverse()
				Motor.Name = BasePart.Name
				Motor.Part0 = BasePart
				Motor.Part1 = Handle
				Bases[BasePart] = Handle.CFrame:ToObjectSpace(BasePart.CFrame)
				Motor.Parent = Handle
			end
		end

		Handle.CFrame = CharLimb.CFrame
		for Base, CFrame in pairs(Bases) do
			Base.CFrame = Handle.CFrame:ToWorldSpace(CFrame)
		end

		local Weld = Instance.new("Motor6D")
		Weld.C0 = CFrame.new()
		Weld.C1 = CFrame.new()
		Weld.Name = "__MainHandleWeld"
		Weld.Part0 = Handle
		Weld.Part1 = CharLimb

		Weld.Parent = Handle
	end
end

local function GetYOffset(Model: Model)
	local Position, Size = Model:GetBoundingBox()
	local PrimaryPart: BasePart = Model.PrimaryPart :: BasePart

	local HeightDifference = (PrimaryPart.Position - Position.Position).Y

	return Size.Y / 2 + HeightDifference
end

local function AddEnemyTag(RigClone: typeof(_Rig))
	for _, BasePart in ipairs(RigClone:GetDescendants()) do
		if BasePart:IsA("BasePart") then
			BasePart.CollisionGroup = "PlacedCharacters"
		end
	end
end

local Enemies: { [string]: Types.EnemyClient } = {}
local Beziers: { [string]: BezierPath.Path } = {}

export type Enemy = Types.EnemyClient

local EnemyModule: Types.EnemyModule = {} :: Types.EnemyModule
EnemyModule.__index = EnemyModule

EnemyModule.NewEnemy = Signal.new()

local function NewEnemy(Input: Types.EnemyInput, SpectateFire: boolean)
	local self = setmetatable({}, EnemyModule) :: Types.EnemyClient

	self.UniqueId = Input.UniqueId
	GenerateId.AddId(self.UniqueId)
	self.Trove = Trove.new()

	self.Damaged = self.Trove:Construct(Signal)
	self.Healed = self.Trove:Construct(Signal)

	self.SpeedChanged = self.Trove:Construct(Signal)
	self.HealthChanged = self.Trove:Construct(Signal)
	self.MaxHealthChanged = self.Trove:Construct(Signal)
	self.ReachedEnd = self.Trove:Construct(Signal)
	self.Destroying = self.Trove:Construct(Signal)

	self.ModelName = Input.ModelName
	self.Health = Input.Health
	self.MaxHealth = Input.MaxHealth
	self.Speed = Input.Speed
	self.IsBoss = Input.IsBoss
	self.Ally = Input.Ally
	self.TimePosition = Input.TimePosition
	self.SpeedChanges = Input.SpeedChanges

	self.OriginalSpeed = Input.OriginalSpeed
	self.VectorOffset = Input.VectorOffset

	self.Bezier = Beziers[Input.BezierId]
	self.PathLength = self.Bezier:GetPathLength()

	self.CFrame = self.Bezier:CalculateUniformCFrame(self.TimePosition)

	self.Character = self.Trove:Clone(EnemyFolder[self.ModelName])
	self.Root = self.Character.HumanoidRootPart
	self.Humanoid = self.Character.Humanoid
	self.Animator = self.Humanoid.Animator
	self.SizeRatio = self.Humanoid.BodyHeightScale.Value

	self.YOffset = GetYOffset(self.Character)
	self.Root.Anchored = true
	self.Root.CFrame = self.CFrame + Vector3.new(0, self.YOffset, 0)

	HelperFunctions.DisableHumanoid(self.Humanoid)
	AddEnemyTag(self.Character)

	self.Animations = {}

	self.Character.Parent = EnemiesFolder

	if Input.AdornmentName then
		local NewAdornment = AdornmentFolder[Input.AdornmentName]:Clone()
		WeldParts(self.Character, NewAdornment, self.SizeRatio)
		NewAdornment.Parent = self.Character
		self.Adornment = NewAdornment
	end

	local CoreInfo = EnemiesAnimations:FindFirstChild(self.ModelName)
	if CoreInfo then
		for _, Animation in pairs(CoreInfo:GetChildren()) do
			self.Animations[Animation.Name] = self.Animator:LoadAnimation(Animation)
		end
	end

	if not self.Animations["Walk"] then
		self.Animations["Walk"] = self.Animator:LoadAnimation(Default)
	end

	local WalkAnim = self.Animations["Walk"]
	if WalkAnim then
		WalkAnim:Play()
		WalkAnim:AdjustSpeed(self:GetAnimationRatio())
	end

	local function SetColor(Particle: ParticleEmitter)
		Particle.Color = ColorSequence.new(self.Character["Body Colors"].TorsoColor3)
	end

	self.Destroying:Connect(function(Animate: boolean)
		if Animate then
			local Particle = HelperFunctions.EmitParticle({ DestroyParticle }, self.Root.CFrame, 1, SetColor, true)
			local OtherParticle =
				HelperFunctions.EmitParticle({ OtherDestroyParticle }, self.Root.CFrame, 16, SetColor, true)
			Particle.Parent = ParticlesFolder
			OtherParticle.Parent = ParticlesFolder
		end
	end)

	local OldHealth = self.Health

	self.HealthChanged:Connect(function(Health: number)
		if Health < OldHealth then
			self.Damaged:Fire(OldHealth - Health)
		elseif Health > OldHealth then
			self.Healed:Fire(Health - OldHealth)
		end
		OldHealth = Health
	end)

	Enemies[self.UniqueId] = self

	self.NewEnemy:Fire(self, SpectateFire)
end

local function EnemyDestroy(self: Types.EnemyClient, Animate: boolean)
	self.Destroying:Fire(Animate)
	Enemies[self.UniqueId] = nil
	GenerateId.RemoveId(self.UniqueId)
	self.Trove:Destroy()
	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function EnemyModule:GetAnimationRatio()
	return self.Speed / self.OriginalSpeed
end

function EnemyModule:PartIsDescendantOf(Part: BasePart)
	return Part:IsDescendantOf(self.Character)
end

function EnemyModule.GetEnemy(UniqueId: string)
	return Enemies[UniqueId]
end

function EnemyModule.GetEnemies()
	return Enemies
end

function EnemyModule.GetBeziers()
	return Beziers
end

LocationEvent.SetCallback(function(UniqueId: string, Waypoints: { Vector3 }?)
	if Waypoints then
		if not Beziers[UniqueId] then
			Beziers[UniqueId] = BezierPath.new(Waypoints, Constants.BEZIERCURVE)
		end
	else
		if Beziers[UniqueId] then
			Beziers[UniqueId] = nil
		end
	end
end)

SpawnEvent.SetCallback(function(Data: { [string]: Types.EnemyInput }, SpectateFire: boolean)
	for UniqueId, EnemyInput in pairs(Data) do
		if not Enemies[UniqueId] then
			NewEnemy(EnemyInput, SpectateFire)
		else
			task.spawn(function()
				error("Duplicate Enemy! " .. EnemyInput.ModelName)
			end)
		end
	end
end)

SpeedEvent.SetCallback(function(Data: { UniqueId: string, Speed: number, Time: number })
	local Enemy = Enemies[Data.UniqueId]

	if Enemy then
		Enemy.Speed = Data.Speed
		Enemy.SpeedChanges[#Enemy.SpeedChanges].TimeEnd = Data.Time
		table.insert(Enemy.SpeedChanges, { TimeStart = Data.Time, Speed = Data.Speed })
		local WalkAnim = Enemy.Animations["Walk"]
		if WalkAnim then
			WalkAnim:AdjustSpeed(Enemy:GetAnimationRatio())
		end
	end
end)

HealthEvent.SetCallback(function(UniqueId: string, Health: number, MaxHealth: number)
	local Enemy = Enemies[UniqueId]

	if Enemy then
		if Enemy.Health ~= Health then
			Enemy.Health = Health
			Enemy.HealthChanged:Fire(Health)
		end

		if Enemy.MaxHealth ~= MaxHealth then
			Enemy.MaxHealth = MaxHealth
			Enemy.MaxHealthChanged:Fire(MaxHealth)
		end
	end
end)

DestroyEvent.SetCallback(function(UniqueIds: { string }, Animate: boolean)
	for _, Id in ipairs(UniqueIds) do
		local Enemy = Enemies[Id]
		if Enemy then
			EnemyDestroy(Enemy, Animate)
			Enemies[Id] = nil
		end
	end
end)

local function CalculateTimePosition(Enemy: Types.EnemyClient)
	local NewTime = 0
	local CurrentTime = workspace:GetServerTimeNow()

	for _, Data in ipairs(Enemy.SpeedChanges) do
		local EndTime = Data.TimeEnd or CurrentTime
		local Difference = EndTime - Data.TimeStart

		NewTime += (Data.Speed / Enemy.PathLength) * Difference
	end

	NewTime = math.clamp(NewTime, 0, 1)
	if Enemy.Ally then
		NewTime = math.abs(NewTime - 1)
	end

	return NewTime
end

RunService.Heartbeat:Connect(function()
	for _, self in pairs(Enemies) do
		local TimePosition = CalculateTimePosition(self)

		self.TimePosition = TimePosition
		local NewCFrame = self.Bezier:CalculateUniformCFrame(TimePosition) + self.VectorOffset
		if self.Ally then
			NewCFrame = NewCFrame * CFrame.fromEulerAnglesXYZ(0, math.rad(180), 0)
		end
		self.CFrame = NewCFrame
		self.Root.CFrame = self.CFrame + Vector3.new(0, self.YOffset, 0)
	end
end)

-- Arrow Info --

-- End of Arrow stuff --

return EnemyModule
