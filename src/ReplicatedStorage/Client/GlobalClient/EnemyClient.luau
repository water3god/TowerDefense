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
local Timer = require(ReplicatedStorage.Packages.Timer)
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
local Arrow = Extra.Arrow

local Emitters = ModelStorage.Emitters
local DestroyParticle = Emitters.poof
local OtherDestroyParticle = Emitters.Pops

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

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
local Misc = GlobalWorkspace.Misc

local function WeldParts(Character: typeof(ModelStorage.Extra.Rig), Adornment: Model, SizeRatio: number)
	for _, Limb in ipairs(Adornment:GetChildren()) do
		if not Limb:IsA("Model") then
			continue
		end
		local CharLimb: BasePart? = Character:FindFirstChild(Limb.Name) :: BasePart
		local Middle: BasePart = Limb:FindFirstChild("Middle") :: BasePart

		if not Middle then
			warn("No BasePart Called Middle For: " .. Limb.Name)
		end

		if not CharLimb then
			continue
		end

		for _, BasePart in ipairs(Limb:GetDescendants()) do
			if BasePart:IsA("BasePart") and BasePart.Name ~= "Middle" then
				BasePart.CanCollide = false
				BasePart.Anchored = false

				local Offset = Middle.CFrame:ToObjectSpace(BasePart.CFrame)
				local ScaledOffset = CFrame.new(Offset.X * SizeRatio, Offset.Y * SizeRatio, Offset.Z * SizeRatio)
					* Offset.Rotation

				local WorldCFrame = ScaledOffset:ToWorldSpace(CharLimb.CFrame)

				local Weld = Instance.new("WeldConstraint")
				BasePart.CFrame = WorldCFrame
				Weld.Name = BasePart.Name
				Weld.Part0 = BasePart
				Weld.Part1 = Middle
				Weld.Parent = Middle
			end
		end

		Middle.CFrame = CharLimb.CFrame
		local Weld = Instance.new("WeldConstraint")
		Weld.Name = "MainMiddleWeld"
		Weld.Part0 = Middle
		Weld.Part1 = CharLimb
		Weld.Parent = Middle
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

local EnemyModule: Types.EnemyModule = {} :: Types.EnemyModule
EnemyModule.__index = EnemyModule

EnemyModule.NewEnemy = Signal.new()

local function NewEnemy(Input: Types.EnemyInput, SpectateFire: boolean)
	local self = setmetatable({}, EnemyModule) :: Types.EnemyClient

	self.UniqueId = Input.UniqueId
	GenerateId.AddId(self.UniqueId)
	self.Trove = Trove.new()

	self.SpeedChanged = self.Trove:Add(Signal.new(), "DisconnectAll")
	self.HealthChanged = self.Trove:Add(Signal.new(), "DisconnectAll")
	self.MaxHealthChanged = self.Trove:Add(Signal.new(), "DisconnectAll")
	self.ReachedEnd = self.Trove:Add(Signal.new(), "DisconnectAll")
	self.Destroying = self.Trove:Add(Signal.new(), "DisconnectAll")

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
			local Particle = HelperFunctions.EmitParticle({ DestroyParticle }, self.Root.CFrame, 1, SetColor)
			local OtherParticle = HelperFunctions.EmitParticle({ OtherDestroyParticle }, self.Root.CFrame, 16, SetColor)
			Particle.Parent = ParticlesFolder
			OtherParticle.Parent = ParticlesFolder
		end
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
	for _, EnemyInput in pairs(Data) do
		if not Enemies[EnemyInput.UniqueId] then
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

RunService.PostSimulation:Connect(function()
	for _, self in pairs(Enemies) do
		local TimePosition = CalculateTimePosition(self)

		self.TimePosition = TimePosition
		local NewCFrame = self.Bezier:CalculateUniformCFrame(TimePosition) + self.VectorOffset
		self.CFrame = NewCFrame
		self.Root.CFrame = self.CFrame + Vector3.new(0, self.YOffset, 0)
	end
end)

-- Arrow Info --
export type ArrowData = { StartTime: number, Arrow: typeof(Arrow), Bezier: string }

local Arrows: { ArrowData } = {}
local VectorOffset = Vector3.new(0, 0.5, 0)
local ArrowSpeed = 50

local function CalculateArrowTimePosition(ArrowData: ArrowData)
	local Bezier = Beziers[ArrowData.Bezier]

	if not Bezier then
		return 0
	end

	local Difference = workspace:GetServerTimeNow() - ArrowData.StartTime
	local Length = Bezier.PathLength

	return math.clamp((ArrowSpeed / Length) * Difference, 0, 1)
end

local StartTrove = Trove.new()

local function OnStart()
	local ArrowTimer = StartTrove:Construct(Timer, 1)

	ArrowTimer.Tick:Connect(function()
		for Id, Bezier in pairs(Beziers) do
			local ArrowClone = Arrow:Clone()
			table.insert(Arrows, { StartTime = workspace:GetServerTimeNow(), Arrow = ArrowClone, Bezier = Id })
			ArrowClone.CFrame = Bezier:CalculateUniformCFrame(0)
			ArrowClone.Parent = Misc
			StartTrove:Add(ArrowClone)
		end
	end)

	StartTrove:Add(function()
		table.clear(Arrows)
	end)

	ArrowTimer:Start()
end

do
	local Data = WaveService.GetWaveData()
	if Data and Data.Wave == 0 then
		OnStart()
	end
end

WaveService.Added:Connect(function(Data)
	if Data.Wave == 0 then
		OnStart()
	end
end)

WaveService.Passed:Connect(StartTrove:WrapClean())
WaveService.Ended:Connect(StartTrove:WrapClean())

RunService.PostSimulation:Connect(function()
	for _, ArrowData in ipairs(Arrows) do
		local Bezier = Beziers[ArrowData.Bezier]
		local Time = CalculateArrowTimePosition(ArrowData)
		if Time == 0 or not Bezier then
			continue
		end
		if Time == 1 then
			ArrowData.Arrow:Destroy()
			local Index = table.find(Arrows, ArrowData)
			if Index then
				table.remove(ArrowData, Index)
			end
		end
		ArrowData.Arrow.CFrame = Bezier:CalculateUniformCFrame(Time) + VectorOffset
	end
end)

-- End of Arrow stuff --

return EnemyModule
