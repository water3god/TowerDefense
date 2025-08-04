--!strict

-- By Wa1er_God --

local UnableToPlaceColor = Color3.new(1, 0.140795, 0)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer

local ModelStorage = ReplicatedStorage.ModelStorage
local UnitsAnimations = ReplicatedStorage.Animations.Units
local Default = UnitsAnimations.Default
local DefaultWalk = UnitsAnimations.Walk
local _Global = UnitsAnimations.Global

local GlobalWorkspace = workspace.GlobalWorkspace
local ParticlesFolder = GlobalWorkspace.Particles
local UnitsFolder = GlobalWorkspace.Units
local PlacementClient = GlobalWorkspace.PlacementClient

local UnitModels: { [string]: { [number]: { Model: Model, Adornment: Model? } } } = {}
for _, UnitFolder in ipairs(ModelStorage.Units:GetChildren()) do
	local Table = {}
	for _, LevelFolder in pairs(UnitFolder:GetChildren()) do
		Table[tonumber(LevelFolder.Name) :: number] =
			{ Model = LevelFolder:FindFirstChild(UnitFolder.Name), Adornment = LevelFolder:FindFirstChild("Adornment") }
	end
	UnitModels[UnitFolder.Name] = Table
end

local Camera = workspace.CurrentCamera

local Emitters = ModelStorage.Emitters
local SmokeEmitter = Emitters.Smoke
local DestroyParticle = Emitters.poof
local OtherDestroyParticle = Emitters.Pops
local UpgradeArrowParticle = Emitters.Arrows
local UpgradeCircleParticle = Emitters.Circle

local Extra = ModelStorage.Extra
local RadiusReference = Extra.CollisionRadius
local _Rig = Extra.Rig
local RangeDisplay = Extra.RangeDisplay
local CenterPartRef = Extra.CenterPart
local CylinderCast = Extra.CylinderCast

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local EnemyClient = require(GlobalClient.EnemyClient)
local SFXService = require(GlobalClient.SFXService)

local Shared = ReplicatedStorage.Shared
local UnitAttacks = require(Shared.UnitAttacks)
local UnitInfo = require(Shared.UnitInfo)
local Types = require(Shared.Types)
local Variables = require(Shared.Variables)

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Promise = require(Packages.Promise)
local InputLib = require(Packages.Input)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local GameFrames = Gui.GameFrames
local MobilePlacementFrame = require(GameFrames.MobilePlacementFrame)
local CoinsAdded = require(GameFrames.CoinsAdded)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Lerps = require(Modules.Lerps)
local GenerateId = require(Modules.GenerateId)

local Network = require(ReplicatedStorage.Network.Client)

local Attack = Network.UnitAttack
local OnPlacement = Network.UnitPlacementEvent
local OnUpgrade = Network.UnitUpgradeEvent
local PriorityChanged = Network.UnitPriorityChanged
local AbilityEvent = Network.UnitAbilityEvent
local AnimationEvent = Network.UnitAnimationEvent
local RatioEvent = Network.RatioEvent
local Destroy = Network.UnitDestroyEvent
local UnitCoinsEvent = Network.UnitCoinsEvent

local PlaceUnit = Network.PlaceUnit
local SellUnit = Network.SellUnit
local Upgrade = Network.UpgradeUnit
local ChangePriority = Network.ChangeUnitPriority
local UseAbility = Network.UseUnitAbility

local WarningEvents = require(ReplicatedStorage.Network.ClientOnly)
local SendWarning = WarningEvents.Warning

local Sounds = SoundService.SoundEffects.Sounds
local PlacementSound = Sounds.Placement
local UpgradeSound = Sounds.Upgrade

export type Unit = Types.Unit
export type UnitModule = Types.UnitModule
export type UnitInput = Types.UnitInput
export type UnitData = UnitInfo.UnitData
export type TotalUnitData = UnitInfo.TotalUnitData
export type AbilityData = Types.AbilityData

local Units: { [string]: Types.Unit } = {}

local UnitModule: Types.UnitModule = {} :: Types.UnitModule
UnitModule.__index = UnitModule

UnitModule.NewUnit = Signal.new()

local function WeldParts(Character: typeof(ModelStorage.Extra.Rig), Adornment: Model)
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
		Limb:ScaleTo(0.6)

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

		local MainMotor = Instance.new("Motor6D")
		MainMotor.C0 = CFrame.new()
		MainMotor.C1 = CFrame.new()
		MainMotor.Name = "__MainHandleWeld"
		MainMotor.Part0 = Handle
		MainMotor.Part1 = CharLimb

		MainMotor.Parent = Handle
	end
end

local function GetRotatingRange()
	local NewTrove = Trove.new()
	local RangePart: BasePart = NewTrove:Clone(RangeDisplay)
	RangePart.CollisionGroup = "PlacementClient"

	local CurrentPromise: Promise.Promise? = nil

	local Connection: RBXScriptConnection? = nil
	local function Animate(Range: number, Enabled: boolean)
		if CurrentPromise then
			CurrentPromise:cancel()
			CurrentPromise = nil
		end

		local ShrunkRange = Range * 0.5
		local NumberLerp = Enabled and Lerps.number(ShrunkRange, Range) or Lerps.number(Range, ShrunkRange)

		local NewPromise = NewTrove:AddPromise(HelperFunctions.TweenPromise(0.3, function(alpha: number)
			local Direction = if Enabled then Enum.EasingDirection.Out else Enum.EasingDirection.In
			local NewAlpha = TweenService:GetValue(alpha, Enum.EasingStyle.Cubic, Direction)
			local LerpedRange = NumberLerp(NewAlpha)
			RangePart.Size = Vector3.new(LerpedRange, RangePart.Size.Y, LerpedRange)
		end) :: any) :: Promise.Promise

		NewPromise:andThen(function()
			CurrentPromise = nil
		end)

		CurrentPromise = NewPromise

		return NewPromise
	end

	NewTrove:Connect(RangePart:GetPropertyChangedSignal("Parent"), function()
		if Connection then
			Connection:Disconnect()
			Connection = nil
		end
		if RangePart.Parent then
			Connection = NewTrove:Connect(RunService.PreSimulation, function()
				RangePart.CFrame *= CFrame.Angles(0, math.rad(0.5), 0)
			end) :: any
		end
	end)

	return RangePart, Animate, NewTrove
end

local function GetUnitModelFromLevel(UnitName: string, Level: number): (Model, number)
	local HighestLevel = 0
	for i = 0, Level, 1 do
		local UnitData = UnitModels[UnitName][i]
		if UnitData and UnitData.Model then
			HighestLevel = i
		end
	end

	return UnitModels[UnitName][HighestLevel].Model, HighestLevel
end

local function GetAdornmentFromLevel(UnitName: string, Level: number): (Model?, number?)
	local HighestLevel = nil
	for i = 0, Level, 1 do
		local UnitData = UnitModels[UnitName][i]
		if UnitData and UnitData.Adornment then
			HighestLevel = i
		end
	end
	if HighestLevel then
		return UnitModels[UnitName][HighestLevel].Adornment, HighestLevel
	end
	return
end

--[[Part0 is the part being attached, Part1 is the Root (Usually Middle or PrimaryPart) part. ]]
local function Weld(Part0: BasePart, Part1: BasePart)
	local Motor = Instance.new("Motor6D")
	Motor.C0 = Part0.CFrame:Inverse()
	Motor.C1 = Part1.CFrame:Inverse()
	Motor.Name = Part1.Name
	Motor.Part0 = Part0
	Motor.Part1 = Part1
	Motor.Parent = Part1

	return Motor
end

local function SetAdornment(Character: typeof(_Rig), UnitName: string, Level: number): Model?
	local Adornment = GetAdornmentFromLevel(UnitName, Level)
	if Adornment then
		local AdornmentClone = Adornment:Clone()
		WeldParts(Character, AdornmentClone)
		AdornmentClone.Parent = Character
		return AdornmentClone
	end

	return
end

local function CastCylinder(Position: Vector3, Params: OverlapParams?, RatioRadius: number)
	local Cast = CylinderCast:Clone()
	Cast.Size = Vector3.new(RatioRadius, Cast.Size.Y, RatioRadius)
	Cast.CFrame = CFrame.new(Position) * Cast.CFrame.Rotation
	return workspace:GetPartsInPart(Cast, Params)
end

local function SyncFuncs(Table: { [number]: any }, HighestLevel: number)
	local Closest = 0
	local NewTable = {}

	for i = 0, HighestLevel, 1 do
		if Table[i] then
			Closest = i
		end
		NewTable[i] = Table[Closest]
	end

	return NewTable
end

local function TweenTransparency(BasePart: BasePart, Transparency: number)
	if BasePart.Transparency ~= Transparency then
		local Tween = TweenService:Create(
			BasePart,
			TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ Transparency = Transparency }
		)

		Tween:Play()

		return Tween
	end

	return
end

local function NewUnit(Input: Types.UnitInput, New: boolean)
	local self = setmetatable({}, UnitModule) :: Types.Unit

	self.UniqueId = Input.UniqueId
	GenerateId.AddId(self.UniqueId)
	self.Trove = Trove.new()

	self.CharacterTrove = self.Trove:Extend()
	self.AttackTrove = self.Trove:Extend()

	self.Attacked = self.Trove:Construct(Signal)
	self.Upgraded = self.Trove:Construct(Signal)
	self.AbilityUsed = self.Trove:Construct(Signal)
	self.CharacterClicked = self.Trove:Construct(Signal)
	self.PriorityChanged = self.Trove:Construct(Signal)
	self.PropertyChanged = self.Trove:Construct(Signal)
	self.AnimationPlayed = self.Trove:Construct(Signal)
	self.CoinsAdded = self.Trove:Construct(Signal)

	self.Destroying = self.Trove:Construct(Signal)

	self.UnitName = Input.UnitName
	self.CFrame = Input.CFrame
	self.OwnerId = Input.OwnerId
	self.AttackPriority = Input.AttackPriority
	self.Level = Input.Level

	self.Promises = {}

	self.RatioData = Input.RatioData
	self.Ratios = {
		Damage = 1,
		FireRate = 1,
		Range = 1,
		Coins = 1,
	}
	self.Trait = Input.Trait

	for Name, Data in pairs(self.RatioData) do
		for SubName, SubData in pairs(Data) do
			local PromiseName = "Ratio" .. Name .. SubName
			local Difference = SubData.EndTime - workspace:GetServerTimeNow()

			if SubData.EndTime ~= math.huge then
				if Difference > 0 then
					self:AddPromise(
						Promise.delay(SubData.EndTime - workspace:GetServerTimeNow()):andThen(function()
							self.RatioData[Name][SubName] = nil
							if not next(self.RatioData[Name]) then
								self.RatioData[Name] = nil
							end
							self:_CalculateRatio()
						end),
						PromiseName
					)
				else
					self.RatioData[Name] = nil
				end
			end
		end
	end

	self:_CalculateRatio()

	self.UnitData = UnitInfo.UnitInfo[self.UnitName]
	self.CollisionRadius = self.UnitData.CollisionRadius
	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)

	self:ApplyDetail()

	local HighestLevel = #self.UnitData.UnitData

	local Runs = UnitAttacks.DefaultRuns[self.UnitName]
	local Attacks = UnitAttacks.UnitAttacks[self.UnitName]

	self.DefaultRuns = Runs and SyncFuncs(Runs, HighestLevel) or {}
	self.UnitAttacks = Attacks and SyncFuncs(Attacks, HighestLevel) or {}

	self.CoinsAdded:Connect(function(Coins: number)
		local BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Name = "CoinsAddedTempGui"
		BillboardGui.Size = UDim2.fromScale(6, 4)
		BillboardGui.StudsOffset = Vector3.new(0, 3 * self.SizeRatio, 0)
		BillboardGui.Adornee = self.Character.Head
		BillboardGui.Parent = self.Character.Head

		local Root = ReactRoblox.createRoot(BillboardGui)
		Root:render(e(CoinsAdded, {
			Coins = Coins,
		}))
		task.delay(5, function()
			Root:unmount()
			BillboardGui:Destroy()
		end)
	end)

	self.Upgraded:Connect(function()
		SFXService.PlaySoundGlobal(UpgradeSound)
		local Arrow = HelperFunctions.EmitParticle({ UpgradeArrowParticle }, self.CFrame, 10)
		local Circle = HelperFunctions.EmitParticle({ UpgradeCircleParticle }, self.CFrame + Vector3.yAxis, 1)
		Arrow.Parent = ParticlesFolder
		Circle.Parent = ParticlesFolder
	end)

	do
		local Table = {}
		for i = 1, #self.UnitData.Abilities, 1 do
			local OtherData = self.UnitData.Abilities[i]
			local Funcs = UnitAttacks.Abilities[self.UnitName]
			local Func = if Funcs then Funcs[i] else nil
			Table[i] = HelperFunctions.joinDicts(OtherData, { LastUsed = Input.Abilities[i], Func = Func })
		end
		self.Abilities = Table :: any
	end

	for _, AbilityData in ipairs(self.Abilities) do
		if workspace:GetServerTimeNow() - AbilityData.LastUsed < AbilityData.Length then
			AbilityData.Func(self, {
				LastUsed = AbilityData.LastUsed,
				Cooldown = AbilityData.Cooldown,
				Length = AbilityData.Length,
			})
		end
	end

	Units[self.UniqueId] = self

	local function OnLevel(Level: number)
		local Func = self.DefaultRuns[Level]
		if Func then
			Func(self)
		end
	end

	OnLevel(self.Level)
	self.Upgraded:Connect(OnLevel)

	local Part = HelperFunctions.EmitParticle(
		{ SmokeEmitter },
		self.CFrame - Vector3.new(0, 0.2, 0),
		20,
		function(Particle)
			local Raycast = workspace:Raycast(self.CFrame.Position + Vector3.new(0, 1, 0), Vector3.new(0, -100, 0))
			if Raycast and Raycast.Instance then
				Particle.Color = ColorSequence.new(Raycast.Instance.Color)
			end
		end
	)

	local function SetColor(Particle: ParticleEmitter)
		Particle.Color = ColorSequence.new(self.Character["Body Colors"].TorsoColor3)
	end

	self.Destroying:Connect(function()
		local Particle = HelperFunctions.EmitParticle({ DestroyParticle }, self.Root.CFrame, 1, SetColor, true)
		local OtherParticle =
			HelperFunctions.EmitParticle({ OtherDestroyParticle }, self.Root.CFrame, 16, SetColor, true)
		Particle.Parent = ParticlesFolder
		OtherParticle.Parent = ParticlesFolder
	end)

	Part.Parent = ParticlesFolder

	SFXService.PlaySoundAt(PlacementSound, self.Root.CFrame)

	self.NewUnit:Fire(self, New)
end

local function UnitDestroy(self: Types.Unit)
	self.Destroying:Fire()
	self.Trove:Destroy()
	Units[self.UniqueId] = nil
	GenerateId.RemoveId(self.UniqueId)
	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function UnitModule:LoadCharacter(Character)
	self.Character = self.CharacterTrove:Clone(Character)

	self.Root = self.Character.HumanoidRootPart
	self.Humanoid = self.Character.Humanoid
	self.Animator = self.Humanoid.Animator
	self.SizeRatio = self.Humanoid.BodyHeightScale.Value

	HelperFunctions.DisableHumanoid(self.Humanoid)
	self.Root.Anchored = true

	local CenterVector3 = self.UnitData.Vector3Offset

	if CenterVector3 and CenterVector3 ~= Vector3.zero then
		self.CenterPart = CenterPartRef:Clone()
		self.CenterPart.CFrame = self.Root.CFrame + CenterVector3
		Weld(self.CenterPart, self.Root)
	else
		self.CenterPart = self.Root
	end

	self.VectorOffset = Vector3.new(0, 3 * self.Humanoid.BodyHeightScale.Value, 0)
	self.VisualCFrame = self.CFrame + self.VectorOffset
	self:TPToRootPosition()

	self.Character.Parent = UnitsFolder

	self.RadiusPart = self.Trove:Clone(RadiusReference)
	self.RadiusPart.Transparency = 1
	self.RadiusPart.Anchored = true
	self.RadiusPart.Size = Vector3.new(self.CollisionRadius, self.RadiusPart.Size.Y, self.CollisionRadius)
	self.RadiusPart.CFrame = self.CFrame
	self.RadiusPart.Parent = self.Character

	local RangePart, Animate, RangeTrove = GetRotatingRange()

	self.RangePart = RangePart
	self.RangePart.Anchored = true
	self.RangePart.CFrame = self.CFrame
	self.Trove:Add(RangeTrove)

	local function OnClick()
		local Range = self:GetProperties()["Range" :: "Range"]
		Animate(Range, true)

		self:AddPromise(
			Promise.delay(0.01):andThen(function()
				self.RangePart.Parent = self.Character
			end),
			"RangeAnimatePromise"
		)
		self:AddPromise(
			Promise.defer(function()
				TweenTransparency(self.RadiusPart, 0.2)
			end),
			"ClickOpenPromise"
		)
	end

	local function OnClose()
		self:AddPromise(
			Promise.defer(function()
				TweenTransparency(self.RadiusPart, 1)
			end),
			"ClickClosePromise"
		)
		RangePart.Parent = nil
	end

	if self.IsClicked then
		OnClick()
	else
		OnClose()
	end

	self.CharacterTrove:Connect(self.CharacterClicked, function(Enabled: boolean)
		if Enabled then
			OnClick()
		else
			OnClose()
		end
	end)

	self.CharacterTrove:Connect(self.Upgraded, function()
		if self.IsClicked then
			OnClick()
		end
	end)

	for _, BasePart in ipairs(self.Character:GetDescendants()) do
		if BasePart:IsA("BasePart") then
			BasePart.CollisionGroup = "PlacedCharacters"
		end
	end

	self.Animations = {}
	local AnimFolder = UnitsAnimations:FindFirstChild(self.UnitName)
	if AnimFolder then
		for _, Animation in ipairs(AnimFolder:GetChildren()) do
			self.Animations[Animation.Name] = self.Animator:LoadAnimation(Animation)
		end
	end
	--[[for _, Animation in ipairs(Global:GetChildren()) do
		self.Animations[Animation.Name] = self.Animator:LoadAnimation(Animation)
	end]]
	if not self.Animations["Idle"] then
		self.Animations["Idle"] = self.Animator:LoadAnimation(Default)
	end

	self.Animations.Idle.Looped = true
	if self.Animations.Attack then
		self.Animations.Attack.Looped = false
	end

	self:PlayAnimation("Idle", nil, nil, 0)
end

function UnitModule:TPToRootPosition()
	self.CenterPart.CFrame = self.VisualCFrame
end

function UnitModule:PlayAnimation(
	AnimationName: string,
	SecondsAfter: number?,
	SpeedRatio: number?,
	FadeTime: number?,
	Length: number?
)
	local Anim = self.Animations[AnimationName]

	if Anim then
		local Name = "AnimationEvent" .. AnimationName
		self:CancelPromise(Name)
		Anim:Play(FadeTime)
		if SpeedRatio then
			Anim:AdjustSpeed(SpeedRatio)
		end
		if SecondsAfter then
			Anim.TimePosition = SecondsAfter
		end
		if Length then
			self:AddPromise(
				Promise.delay(Length):andThen(function()
					Anim:Stop()
				end),
				Name
			)
		end
		self.AnimationPlayed:Fire(AnimationName)

		return Anim
	end

	return
end

function UnitModule:StopAnimation(AnimationName: string, FadeTime: number?)
	local Anim = self.Animations[AnimationName]

	if Anim then
		local Name = "AnimationEvent" .. AnimationName
		self:CancelPromise(Name)
		Anim:Stop(FadeTime)
		return Anim
	end

	return
end

function UnitModule:Watch(AnimationName: string, Funcs: { { Func: () -> (), PlayAfter: boolean, TimeRatio: number } })
	local Anim = self.Animations[AnimationName]
	local CurrentRatio = math.max(Anim.TimePosition + 0.1, 0) / Anim.Length

	for _, FuncData in ipairs(Funcs) do
		if FuncData.TimeRatio >= CurrentRatio or FuncData.PlayAfter then
			local RatioDifference = FuncData.TimeRatio - CurrentRatio
			local Time = RatioDifference * (Anim.Length / self.Ratios.FireRate)

			self.AttackTrove:Add(task.delay(Time, FuncData.Func))
		end
	end
end

function UnitModule:RotateToEnemy(Enemy: Types.EnemyClient)
	local NewCFrame = CFrame.lookAt(self.CFrame.Position, Enemy.CFrame.Position)
	local _, Rad, _ = NewCFrame:ToEulerAnglesYXZ()

	self:RotateTo(math.deg(Rad))
end

function UnitModule:RotateTo(Degree: number)
	self.CFrame = CFrame.new(self.CFrame.Position) * CFrame.Angles(0, math.rad(Degree), 0)
	self.VisualCFrame = self.CFrame + self.VectorOffset
	self:TPToRootPosition()
end

function UnitModule:PartIsDescendantOf(Part: BasePart)
	return Part:IsDescendantOf(self.Character)
end

function UnitModule:ClickCharacter(Enabled: boolean)
	self.IsClicked = Enabled
	self.CharacterClicked:Fire(Enabled)
end

function UnitModule:ApplyDetail()
	local _, AdornmentLevel = GetAdornmentFromLevel(self.UnitName, self.Level)

	local UnitModel, UnitLevel = GetUnitModelFromLevel(self.UnitName, self.Level)

	if UnitLevel ~= self.CharacterLevel then
		self.CharacterTrove:Destroy()
		self:LoadCharacter(UnitModel)
		self.CharacterLevel = UnitLevel
		self.AdornmentLevel = nil
		self.Adornment = nil
	end

	if AdornmentLevel ~= self.AdornmentLevel then
		if self.Adornment then
			self.Adornment:Destroy()
		end
		self.AdornmentLevel = AdornmentLevel
		self.Adornment = SetAdornment(self.Character, self.UnitName, self.Level)

		if self.Adornment then
			for _, BasePart in ipairs(self.Adornment:GetDescendants()) do
				if BasePart:IsA("BasePart") then
					BasePart.CanCollide = false
					BasePart.CanQuery = false
					BasePart.CanTouch = false
				end
			end
		end
	end
end

function UnitModule:_CalculateRatio()
	local Ratios = {
		Damage = 1,
		FireRate = 1,
		Range = 1,
		Coins = 1,
	}

	for _, Data in pairs(self.RatioData) do
		local _, OtherData = next(Data)

		if not OtherData then
			continue
		end
		local HighestRatio: number? = nil

		for _, Ratio in pairs(Data) do
			if Ratio.Type == "FireRate" then
				if not HighestRatio or Ratio.Ratio < HighestRatio then
					HighestRatio = Ratio.Ratio
				end
			else
				if not HighestRatio or Ratio.Ratio > HighestRatio then
					HighestRatio = Ratio.Ratio
				end
			end
		end

		if HighestRatio then
			Ratios[OtherData.Type] *= HighestRatio
		end
	end

	for Type, Ratio in pairs(Ratios) do
		if self.Ratios[Type] ~= Ratio then
			self.Ratios[Type] = Ratio
			self.PropertyChanged:Fire(Type, Ratio)
		end
	end
end
--[[Clones adornment automatically]]
function UnitModule:WeldAdornment(AdornmentInput: Model)
	local Adornment = self.Trove:Add(AdornmentInput)
	WeldParts(self.Character, Adornment)

	return Adornment
end

function UnitModule:AddPromise(NewPromise: Promise.Promise, PromiseName: string)
	self:CancelPromise(PromiseName)
	self.Promises[PromiseName] = NewPromise

	self.Trove:AddPromise(NewPromise :: any)

	NewPromise:finally(function()
		self.Promises[PromiseName] = nil
	end)
end

function UnitModule:AddAttackPromise(AttackPromise: Promise.Promise, PromiseName: string)
	self:CancelPromise(PromiseName)
	self.Promises[PromiseName] = AttackPromise

	self.AttackTrove:AddPromise(AttackPromise :: any)

	AttackPromise:finally(function()
		self.Promises[PromiseName] = nil
	end)
end

function UnitModule:CancelPromise(PromiseName: string)
	local UnitPromise = self.Promises[PromiseName]
	if UnitPromise then
		UnitPromise:cancel()
		self.Promises[PromiseName] = nil
	end
end

function UnitModule:LevelUp()
	Upgrade.Fire(self.UniqueId)
end

function UnitModule:ChangePriority()
	ChangePriority.Fire(self.UniqueId)
	self.AttackPriority = UnitInfo.GetNextSortType(self.AttackPriority)
	self.PriorityChanged:Fire(self.AttackPriority)
end

function UnitModule:OnUpgrade(Level: number)
	self.AttackTrove:Destroy()
	self.Level = Level
	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)
	self.Upgraded:Fire(Level)
	self:ApplyDetail()
end

function UnitModule:OnAttack(Input: Types.UnitAttackInput)
	local Difference = workspace:GetServerTimeNow() - Input.Firetime
	local Enemy = EnemyClient.GetEnemy(Input.EnemyId)

	self.AttackTrove:Destroy()
	if self.UnitAttacks and self.UnitAttacks[self.Level] and self.UnitAttacks[self.Level][Input.Index] then
		task.spawn(function()
			self.UnitAttacks[self.Level][Input.Index](self, Input, Enemy, Difference)
		end)
	end

	self.Attacked:Fire()
end

function UnitModule:UseAbility(Index: number)
	UseAbility.Fire(self.UniqueId, Index)
end

function UnitModule:Sell()
	SellUnit.Fire(self.UniqueId)
end

function UnitModule:GetProperties()
	local UnitData = self.UnitData.UnitData
	local Level = self.Level
	return {
		Damage = math.ceil(UnitData[Level].Damage[1] * self.Ratios.Damage),
		FireRate = UnitData[Level].FireRate * self.Ratios.FireRate,
		Range = math.floor(UnitData[Level].Range * self.Ratios.Range),
		Coins = UnitData[Level].Coins,
		Special = UnitData[Level].Special,
	}
end

function UnitModule:GetNextProperties()
	local UnitData = self.UnitData.UnitData
	local Level = self.Level + 1

	if not UnitData[Level] then
		return nil
	end

	return {
		Damage = math.ceil(UnitData[Level].Damage[1] * self.Ratios.Damage),
		FireRate = UnitData[Level].FireRate * self.Ratios.FireRate,
		Range = UnitData[Level].Range * self.Ratios.Range,
		Coins = UnitData[Level].Coins,
		Special = UnitData[Level].Special,
	}
end

function UnitModule:GetSpecial()
	return
end

function UnitModule.GetUnit(UniqueId: string)
	return Units[UniqueId]
end

function UnitModule.GetUnits()
	return Units
end

local function GetMouseIsPointing(Params: RaycastParams?)
	local MouseLocation = UserInputService:GetMouseLocation()
	local Ray = Camera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
	return workspace:Raycast(Ray.Origin, Ray.Direction * 500, Params)
end

local function GetIdle(Unit: string)
	local AnimFolder = UnitsAnimations:FindFirstChild(Unit)
	if AnimFolder then
		local Idle = AnimFolder:FindFirstChild("Idle")

		if Idle then
			return Idle
		end
	end

	return Default
end

local function GetWalk(Unit: string)
	local AnimFolder = UnitsAnimations:FindFirstChild(Unit)
	if AnimFolder then
		local Walk = AnimFolder:FindFirstChild("Walk")

		if Walk then
			return Walk
		end
	end

	return DefaultWalk
end

local DefaultCFrame = CFrame.new(0, -0.4, -2) * CFrame.Angles(0, math.rad(-180), 0)

function UnitModule.InitCharacter(Unit: string, Position: CFrame?, Level: number?)
	local InitTrove = Trove.new()

	local Model = GetUnitModelFromLevel(Unit, Level or 0)

	local UnitModel: typeof(_Rig) = InitTrove:Clone(Model)
	local Humanoid: Humanoid & { [any]: any } = UnitModel.Humanoid
	local Animator: Animator & { [any]: any } = Humanoid.Animator
	local Root: BasePart = UnitModel.HumanoidRootPart
	Root.Anchored = true

	local CenterPart: BasePart = nil
	local UnitData = UnitInfo.UnitInfo[Unit]

	SetAdornment(UnitModel, Unit, Level or 0)

	if UnitData.Vector3Offset and UnitData.Vector3Offset ~= Vector3.zero then
		CenterPart = CenterPartRef:Clone()
		CenterPart.CFrame = Root.CFrame + UnitData.Vector3Offset
		Weld(CenterPart, Root)
	else
		CenterPart = Root
	end

	InitTrove:Add(task.defer(function()
		if Position then
			CenterPart.CFrame = Position
		else
			CenterPart.CFrame = DefaultCFrame
		end
	end))

	HelperFunctions.DisableHumanoid(Humanoid)

	local Connection: RBXScriptConnection? = nil

	local WalkAnim: AnimationTrack? = nil

	local function PlayWalk(Enabled: boolean)
		if WalkAnim then
			if Enabled then
				WalkAnim:Play()
			else
				WalkAnim:Stop()
			end
		end
	end

	Connection = InitTrove:Add(UnitModel:GetPropertyChangedSignal("Parent"):Connect(function()
		if UnitModel.Parent ~= nil then
			if Connection then
				Connection:Disconnect()
				Connection = nil
			end
			local Animation = GetIdle(Unit)
			if Animation then
				local Track = Animator:LoadAnimation(Animation)
				Track:Play(0)
			end
			local Walk = GetWalk(Unit)
			if Walk then
				WalkAnim = Animator:LoadAnimation(Walk)
				if WalkAnim then
					WalkAnim.Priority = Enum.AnimationPriority.Action2
				end
			end
		end
	end))

	return {
		UnitModel = UnitModel,
		Trove = InitTrove,
		CenterPart = CenterPart,
		PlayWalk = PlayWalk,
	}
end

function UnitModule.InitPlacement(Unit: string)
	local InitTrove = Trove.new()

	local Data = {
		Trove = InitTrove,
		Clicked = InitTrove:Construct(Signal),
	}

	local CharacterData = UnitModule.InitCharacter(Unit, CFrame.new())
	InitTrove:Add(CharacterData.Trove)
	local UnitModel = CharacterData.UnitModel
	local CenterPart = CharacterData.CenterPart

	local UnitData = UnitInfo.UnitInfo[Unit]

	local BaseUpgradeData = UnitData.UnitData[0]
	local Range = BaseUpgradeData.Range
	local Radius = UnitData.CollisionRadius

	for _, BasePart in ipairs(UnitModel:GetDescendants()) do
		if BasePart:IsA("BasePart") then
			BasePart.CollisionGroup = "PlacementClient"
		end
	end

	local Humanoid = UnitModel.Humanoid

	local Ratio = Humanoid.BodyHeightScale.Value
	local RatioRadius = Radius / Ratio

	local Root = CharacterData.CenterPart

	local BottomPosition = Root.Position - Vector3.new(0, 3 * Ratio, 0)

	local RadiusPart = InitTrove:Clone(RadiusReference)
	RadiusPart.CFrame = CFrame.new(BottomPosition)
	RadiusPart.Size = Vector3.new(RatioRadius, RadiusPart.Size.Y, RatioRadius)
	Weld(RadiusPart, Root)
	RadiusPart.Transparency = 1
	RadiusPart.Parent = UnitModel
	TweenTransparency(RadiusPart, RadiusReference.Transparency)

	local VectorOffset = Vector3.new(0, 3 * Humanoid.BodyHeightScale.Value, 0)

	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude
	RayParams.FilterDescendantsInstances = { UnitModel }
	RayParams.CollisionGroup = "CollisionRadius"

	local OvParams = OverlapParams.new()
	OvParams.FilterType = Enum.RaycastFilterType.Exclude
	OvParams.FilterDescendantsInstances = { UnitModel }
	OvParams.CollisionGroup = "CollisionRadius"

	local OriginalColors: { [BasePart]: Color3 } = {}

	local UnitPosition: Vector3? = nil
	local RotationIndex: number = 0
	local IsValid: boolean = nil

	local RangePart, Animate, RangeTrove = GetRotatingRange()
	InitTrove:Add(RangeTrove)
	Animate(Range, true)

	InitTrove:Connect(RunService.PreSimulation, function()
		if UnitPosition then
			RangePart.CFrame = CFrame.new(UnitPosition) * RangePart.CFrame.Rotation
		end
	end)

	RangePart.Anchored = true
	RangePart.Parent = workspace
	Variables.InPlacement = true

	InitTrove:AddPromise(Promise.defer(function()
		for _, OtherUnit in pairs(Units) do
			TweenTransparency(OtherUnit.RadiusPart, 0.4)
		end
	end) :: any)

	InitTrove:Add(function()
		Variables.InPlacement = false
		for _, OtherUnit in pairs(Units) do
			TweenTransparency(OtherUnit.RadiusPart, 1)
		end
	end)

	for _, Descendant in ipairs(UnitModel:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			OriginalColors[Descendant] = Descendant.Color
		end
	end

	local function CheckValidity(Parts: { BasePart })
		for _, Part in ipairs(Parts) do
			if not Part:HasTag("CanPlace") then
				return false
			end
		end
		if UnitPosition then
			local NewUnitPosition = HelperFunctions.ConvertToVec2(UnitPosition)
			for _, OtherUnit in pairs(Units) do
				local OtherPosition = HelperFunctions.ConvertToVec2(OtherUnit.CFrame.Position)
				if (NewUnitPosition - OtherPosition).Magnitude < (OtherUnit.CollisionRadius + Radius) / 2 then
					return false
				end
			end
		end

		return true
	end

	local function OnValdiityCheck(Old: boolean)
		if Old ~= IsValid then
			if IsValid then
				for BasePart, Color in pairs(OriginalColors) do
					BasePart.Color = Color
				end
			else
				for BasePart, _ in pairs(OriginalColors) do
					BasePart.Color = UnableToPlaceColor
				end
			end
		end
	end

	local AnimatedRotation = RotationIndex
	local Changed = InitTrove:Construct(Signal)
	local AfterChanged = InitTrove:Construct(Signal)
	local CurrentPromise: Promise.Promise? = nil

	Changed:Connect(function()
		if CurrentPromise then
			CurrentPromise:cancel()
		end
		local FinalIndex = RotationIndex

		if FinalIndex == 0 then
			AnimatedRotation -= 4
		end

		local NumberLerp = Lerps.number(AnimatedRotation, FinalIndex)

		CurrentPromise = InitTrove:AddPromise(HelperFunctions.TweenPromise(0.2, function(alpha: number)
			local Value = TweenService:GetValue(alpha, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			AnimatedRotation = NumberLerp(Value)
		end) :: any)
	end)

	local NewPosition: Vector3 = nil

	local function Update(NewUnitPosition: Vector3)
		NewPosition = NewUnitPosition
		local LastPosition = CFrame.new(NewUnitPosition) * CFrame.Angles(0, math.rad(-90 * AnimatedRotation), 0)
			+ VectorOffset
		CenterPart.CFrame = LastPosition

		local OldValid = IsValid

		local Parts = CastCylinder(NewUnitPosition, OvParams, Radius)
		IsValid = CheckValidity(Parts)
		OnValdiityCheck(OldValid)

		UnitModel.Parent = PlacementClient
	end

	local function OnFrame()
		local RaycastResult: RaycastResult? = GetMouseIsPointing(RayParams)

		if RaycastResult and RaycastResult.Position then
			UnitPosition = RaycastResult.Position

			if UnitPosition then
				Update(UnitPosition)
			end
		else
			UnitPosition = nil
			UnitModel.Parent = nil
		end
	end

	-- Make Existing Units and Paths visually distict to show that they are blocked --

	local function RotateIndex()
		RotationIndex = math.fmod(RotationIndex + 1, 4)
		Changed:Fire()
		AfterChanged:Fire()
	end

	local StartTime = tick()
	local function HandleClick()
		if (tick() - StartTime) < 0.1 then
			return
		end

		if UnitPosition and IsValid then
			PlaceUnit.Fire({
				Unit = Unit,
				UnitPosition = UnitPosition,
				RotationIndex = RotationIndex,
			})
			Data.Clicked:Fire()
			InitTrove:Destroy()
		else
			SendWarning:Fire(string.format("Invalid Placement!"))
		end
	end

	local InputTrove = InitTrove:Extend()

	InputLib.PreferredInput.Observe(function(Preferred)
		if Preferred == "MouseKeyboard" then
			local Mouse = InputTrove:Construct(InputLib.Mouse)
			local Keyboard = InputTrove:Construct(InputLib.Keyboard)

			OnFrame()

			Mouse.LeftDown:Connect(function()
				HandleClick()
			end)

			Keyboard.KeyDown:Connect(function(Key: Enum.KeyCode)
				if Key == Enum.KeyCode.R then
					RotateIndex()
				elseif Key == Enum.KeyCode.Escape then
					InitTrove:Destroy()
				end
			end)

			InputTrove:BindToRenderStep("InitPlacement", Enum.RenderPriority.Character.Value, OnFrame)
		elseif Preferred == "Touch" then
			local Touch = InputTrove:Construct(InputLib.Touch)

			local Result = HelperFunctions.Raycast(Camera.ViewportSize / 2, RayParams)

			if Result and Result.Position then
				Update(Result.Position)
			else
				OnFrame()
			end

			AfterChanged:Connect(function()
				if CurrentPromise then
					InputTrove:BindToRenderStep("InitPlacement", Enum.RenderPriority.Character.Value, function()
						Update(NewPosition)
					end)
					CurrentPromise:andThen(function()
						RunService:UnbindFromRenderStep("InitPlacement")
					end)
				end
			end)

			Touch.TouchMoved:Connect(function(_, processed: boolean)
				if processed then
					return
				end
				OnFrame()
			end)
		elseif Preferred == "Gamepad" then
			return
		end
	end)

	if not UserInputService.KeyboardEnabled and UserInputService.TouchEnabled then
		local NewRoot = InitTrove:Construct(Instance, "Part") :: Part
		NewRoot.CanCollide = false
		NewRoot.CanQuery = false
		NewRoot.CanTouch = false
		NewRoot.Name = "GuiRoot"
		NewRoot.Size = Vector3.new(1, 1, 1)
		NewRoot.Transparency = 1
		NewRoot.CFrame = Root.CFrame + Vector3.new(0, 3, 0)
		Weld(NewRoot, Root)
		NewRoot.Parent = workspace

		local RootGui = InitTrove:Construct(Instance, "BillboardGui") :: BillboardGui
		RootGui.Adornee = NewRoot
		RootGui.Active = true
		RootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		RootGui.Size = UDim2.fromOffset(100, 100)
		RootGui.Name = "UnitRoot"
		RootGui.AlwaysOnTop = true
		RootGui.ResetOnSpawn = false
		RootGui.Parent = Player.PlayerGui

		local Place = function()
			HandleClick()
		end

		local ReactRoot = ReactRoblox.createRoot(RootGui)
		ReactRoot:render(e(MobilePlacementFrame, {
			Place = Place,
			Cancel = InitTrove:WrapClean(),
			Rotate = function()
				RotateIndex()
			end,
		}))
	end

	return Data
end

OnPlacement.SetCallback(function(PlacementData: { [string]: Types.UnitInput }, New: boolean)
	for _, NewInput in pairs(PlacementData) do
		NewUnit(NewInput, New)
	end
end)

Attack.SetCallback(function(Data: Types.UnitAttackInput)
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		Unit:OnAttack(Data)
	end
end)

PriorityChanged.SetCallback(function(Data: { UniqueId: string, Priority: UnitInfo.SortType })
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		if Unit.AttackPriority ~= Data.Priority then
			Unit.AttackPriority = Data.Priority
			Unit.PriorityChanged:Fire(Data.Priority)
		end
	end
end)

AnimationEvent.SetCallback(function(
	Data: {
		UniqueId: string,
		AnimationName: string,
		SecondsAfter: number?,
		SpeedRatio: number?,
		FadeTime: number?,
		Length: number?,
		SentTime: number,
	},
	Enabled: boolean
)
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		if Enabled then
			local SecondsAfter = Data.SecondsAfter or 0
			local NewTime = SecondsAfter + (workspace:GetServerTimeNow() - Data.SentTime)
			Unit:PlayAnimation(Data.AnimationName, NewTime, Data.SpeedRatio, Data.FadeTime, Data.Length)
		else
			Unit:StopAnimation(Data.AnimationName, Data.FadeTime)
		end
	end
end)

RatioEvent.SetCallback(
	function(UniqueId: string, Name: string, SubName: string, Data: { Type: string, Ratio: number, EndTime: number }?)
		local Unit = UnitModule.GetUnit(UniqueId)
		local PromiseName = "Ratio" .. Name .. SubName

		if Unit then
			if Data then
				Unit:CancelPromise(PromiseName)
				if not Unit.RatioData[Name] then
					Unit.RatioData[Name] = {}
				end
				Unit.RatioData[Name][SubName] = Data

				local Difference = Data.EndTime - workspace:GetServerTimeNow()

				if Data.EndTime ~= math.huge then
					if Difference > 0 then
						Unit:AddPromise(
							Promise.delay(Data.EndTime - workspace:GetServerTimeNow()):andThen(function()
								Unit.RatioData[Name][SubName] = nil
								if not next(Unit.RatioData[Name]) then
									Unit.RatioData[Name] = nil
								end
								Unit:_CalculateRatio()
							end),
							PromiseName
						)
					else
						Unit.RatioData[Name] = nil
					end
				end
			else
				Unit:CancelPromise(PromiseName)
				if Unit.RatioData[Name] and Unit.RatioData[Name][SubName] then
					Unit.RatioData[Name][SubName] = nil
				end
				if not next(Unit.RatioData[Name]) then
					Unit.RatioData[Name] = nil
				end
			end
			Unit:_CalculateRatio()
		end
	end
)

OnUpgrade.SetCallback(function(Data: { UniqueId: string, Level: number })
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		Unit:OnUpgrade(Data.Level)
	end
end)

AbilityEvent.SetCallback(function(UniqueId: string, Index: number, TimeUsed: number)
	local Unit = UnitModule.GetUnit(UniqueId)

	if Unit then
		local Data = Unit.Abilities[Index]
		Data.LastUsed = TimeUsed
		if Data.Func then
			Data.Func(Unit, {
				Cooldown = Data.Cooldown,
				LastUsed = Data.LastUsed,
				Length = Data.Length,
			})
		end
		Unit.AbilityUsed:Fire(Index, TimeUsed)
	end
end)

UnitCoinsEvent.SetCallback(function(Data: { Coins: number, UniqueId: string })
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		Unit.CoinsAdded:Fire(Data.Coins)
	end
end)

Destroy.SetCallback(function(UniqueIds: { string })
	for _, Id in ipairs(UniqueIds) do
		local Unit = Units[Id]
		if Unit then
			UnitDestroy(Unit)
		end
	end
end)

return UnitModule
