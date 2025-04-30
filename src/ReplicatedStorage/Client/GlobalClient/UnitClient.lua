--!strict

-- By Wa1er_God --

local UnableToPlaceColor = Color3.new(1, 0.140795, 0)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ModelStorage = ReplicatedStorage.ModelStorage
local UnitsAnimations = ReplicatedStorage.Animations.Units

local GlobalWorkspace = workspace.GlobalWorkspace
local UnitsFolder = GlobalWorkspace.Units
local PlacementClient = GlobalWorkspace.PlacementClient

local UnitModels: { [string]: Model } = {}
for _, Model in ipairs(ModelStorage.Units:GetChildren()) do
	UnitModels[Model.Name] = Model
end
local Adornments: { [string]: Model } = {}
for _, Model in ipairs(ModelStorage.Adornments:GetChildren()) do
	Adornments[Model.Name] = Model
end

local Camera = workspace.CurrentCamera

local Extra = ModelStorage.Extra
local RadiusReference = Extra.CollisionRadius
local Rig = Extra.Rig
local RangeDisplay = Extra.RangeDisplay
local CenterPart = Extra.CenterPart
local CylinderCast = Extra.CylinderCast

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local EnemyClient = require(GlobalClient.EnemyClient)

local Shared = ReplicatedStorage.Shared
local UnitAttacks = require(Shared.UnitAttacks)
local UnitInfo = require(Shared.UnitInfo)
local Types = require(Shared.Types)

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Events = ReplicatedStorage.Remotes.Unit

local Attack = Events.Attack
local Destroy = Events.DestroyEvent
local OnPlacement = Events.PlacementEvent
local OnUpgrade = Events.Upgrade
local PriorityChanged = Events.PriorityChanged

local OtherEvents = ReplicatedStorage.Remotes.UnitClient
local PlaceUnit = OtherEvents.Placement
local SellUnit = OtherEvents.Sell
local Upgrade = OtherEvents.Upgrade
local ChangePriority = OtherEvents.ChangePriority

export type Unit = Types.Unit
export type UnitModule = Types.UnitModule
export type UnitInput = Types.UnitInput
export type UnitData = UnitInfo.UnitData
export type TotalUnitData = UnitInfo.TotalUnitData

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
		local Middle: BasePart = Limb:FindFirstChild("Middle") :: BasePart

		if not Middle then
			warn("No BasePart Called Middle For: " .. Limb.Name)
		end

		if not CharLimb then
			continue
		end

		local Bases: { [BasePart]: CFrame } = {}

		for _, BasePart in ipairs(Limb:GetDescendants()) do
			if BasePart:IsA("BasePart") and BasePart.Name ~= "Middle" then
				BasePart.CanCollide = false
				BasePart.Anchored = false

				local Motor = Instance.new("Motor6D")
				Motor.C0 = BasePart.CFrame:Inverse()
				Motor.C1 = Middle.CFrame:Inverse()
				Motor.Name = BasePart.Name
				Motor.Part0 = BasePart
				Motor.Part1 = Middle
				Bases[BasePart] = Middle.CFrame:ToObjectSpace(BasePart.CFrame)
				Motor.Parent = Middle
			end
		end

		Middle.CFrame = CharLimb.CFrame
		for Base, CFrame in pairs(Bases) do
			Base.CFrame = Middle.CFrame:ToWorldSpace(CFrame)
		end

		local Weld = Instance.new("Motor6D")
		Weld.C0 = CFrame.new()
		Weld.C1 = CFrame.new()
		Weld.Name = "MainMiddleWeld"
		Weld.Part0 = Middle
		Weld.Part1 = CharLimb

		Weld.Parent = Middle
	end
end

local function DisableHumanoid(Humanoid: Humanoid)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
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

local function SetAdornment(Character: typeof(Rig), AdornmentName: string)
	local Adornment = Adornments[AdornmentName]:Clone()
	WeldParts(Character, Adornment)
	Adornment.Parent = Character
	return Adornment
end

local function GetRangePart(Range: number)
	local RangeDisplay = RangeDisplay:Clone()
	RangeDisplay.Size = Vector3.new(Range, RangeDisplay.Size.Y, Range)
	local Connection: RBXScriptConnection? = nil

	RangeDisplay:GetPropertyChangedSignal("Parent"):Connect(function()
		if RangeDisplay.Parent then
			Connection = RunService.PostSimulation:Connect(function()
				RangeDisplay.CFrame *= CFrame.Angles(0, math.rad(1), 0)
			end)
		else
			if Connection then
				Connection:Disconnect()
				Connection = nil
			end
		end
	end)

	return RangeDisplay
end

local function CastCylinder(Position: Vector3, Params: OverlapParams?)
	local Cast = CylinderCast:Clone()
	Cast.CFrame = CFrame.new(Position) * Cast.CFrame.Rotation
	return workspace:GetPartsInPart(Cast, Params)
end

local function NewUnit(Input: Types.UnitInput)
	local self = setmetatable({}, UnitModule) :: Types.Unit

	self.UniqueId = Input.UniqueId
	self.Trove = Trove.new()

	self.AttackTrove = self.Trove:Extend()

	self.Attacked = self.Trove:Construct(Signal)
	self.Upgraded = self.Trove:Construct(Signal)
	self.Destroying = self.Trove:Construct(Signal)
	self.PriorityChanged = self.Trove:Construct(Signal)
	self.PropertyChanged = self.Trove:Construct(Signal)

	self.UnitName = Input.UnitName
	self.CFrame = Input.CFrame
	self.OwnerId = Input.OwnerId
	self.AttackPriority = Input.AttackPriority
	self.Level = Input.Level
	self.SpeedRatio = Input.SpeedRatio

	self.UnitData = UnitInfo.UnitInfo[self.UnitName]
	self.CollisionRadius = self.UnitData.CollisionRadius
	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)
	self.UnitAttacks = UnitAttacks[self.UnitName] :: any

	self.Character = self.Trove:Clone(UnitModels[self.UnitName])
	self.Root = self.Character.HumanoidRootPart
	self.Humanoid = self.Character.Humanoid
	self.Animator = self.Humanoid.Animator
	self.SizeRatio = self.Humanoid.BodyHeightScale.Value

	DisableHumanoid(self.Humanoid)
	self.Root.Anchored = true

	local CenterVector3 = self.UnitData.Vector3Offset

	if CenterVector3 and CenterVector3 ~= Vector3.zero then
		self.CenterPart = CenterPart:Clone()
		self.CenterPart.CFrame = self.Root.CFrame + CenterVector3
		Weld(self.CenterPart, self.Root)
	else
		self.CenterPart = self.Root
	end

	self:ApplyDetail()

	self.VectorOffset = HelperFunctions.GetModelVectorOffset(self.Character)
	self.VisualCFrame = self.CFrame + self.VectorOffset
	self:TPToRootPosition()

	self.Character.Parent = UnitsFolder

	self.RadiusPart = self.Trove:Clone(RadiusReference)
	self.RadiusPart.Transparency = 1
	self.RadiusPart.Anchored = true
	self.RadiusPart.Size = Vector3.new(self.CollisionRadius, self.RadiusPart.Size.Y, self.CollisionRadius)
	self.RadiusPart.CFrame = self.CFrame
	self.RadiusPart.Parent = self.Character

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

	self:PlayAnimation("Idle", nil, nil, 0)

	Units[self.UniqueId] = self

	self.NewUnit:Fire(self)
end

local function UnitDestroy(self: Types.Unit)
	self.Destroying:Fire()
	self.Trove:Destroy()
	Units[self.UniqueId] = nil
	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function UnitModule:TPToRootPosition()
	self.CenterPart.CFrame = self.VisualCFrame
end

function UnitModule:PlayAnimation(AnimationName: string, SecondsAfter: number?, SpeedRatio: number?, FadeTime: number?)
	local Anim = self.Animations[AnimationName]

	if Anim then
		Anim:Play(FadeTime)
		if SpeedRatio then
			Anim:AdjustSpeed(SpeedRatio)
		end
		if SecondsAfter then
			Anim.TimePosition = SecondsAfter
		end

		return Anim
	end

	return
end

function UnitModule:Watch(Anim: AnimationTrack, Funcs: { { Func: () -> (), PlayAfter: boolean, TimeRatio: number } })
	local CurrentRatio = Anim.TimePosition / Anim.Length

	for _, FuncData in ipairs(Funcs) do
		if FuncData.TimeRatio >= CurrentRatio or FuncData.PlayAfter then
			local RatioDifference = FuncData.TimeRatio - CurrentRatio
			local Time = RatioDifference * (Anim.Length / self.SpeedRatio)

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
end

function UnitModule:PartIsDescendantOf(Part: BasePart)
	return Part:IsDescendantOf(self.Character)
end

function UnitModule:ApplyDetail()
	local AdornmentName = self.UnitData.UnitData[self.Level].Armor

	if self.Armor then
		if self.Armor.Name == AdornmentName then
			return
		end
		self.Armor:Destroy()
		self.Armor = nil
	end

	if typeof(AdornmentName) == "string" then
		self.Armor = SetAdornment(self.Character, AdornmentName)
	end
end

function UnitModule:LevelUp()
	Upgrade:FireClient(self.UniqueId)
end

function UnitModule:ChangePriority()
	ChangePriority:FireServer(self.UniqueId)
	self.AttackPriority = UnitInfo.GetNextSortType(self.AttackPriority)
end

function UnitModule:OnUpgrade(Level: number)
	self.AttackTrove:Destroy()
	self.Level = Level
	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)
	self.Upgraded:Fire(Level)
	self:ApplyDetail()
	self.VectorOffset = HelperFunctions.GetModelVectorOffset(self.Character)
	self.VisualCFrame = self.CFrame + self.VectorOffset
	self:TPToRootPosition()
end

function UnitModule:OnAttack(Input: Types.UnitAttackInput)
	local Difference = workspace:GetServerTimeNow() - Input.Firetime
	local Enemy = EnemyClient.GetEnemy(Input.EnemyId)

	self.AttackTrove:Destroy()
	if self.UnitAttacks and self.UnitAttacks[self.Level] and self.UnitAttacks[self.Level][Input.Index] then
		self.UnitAttacks[self.Level][Input.Index](self, Input, Enemy, Difference)
	end

	self.Attacked:Fire()
end

function UnitModule:Sell()
	SellUnit:FireServer(self.UniqueId)
end

function UnitModule:GetProperties()
	local UnitData = self.UnitData.UnitData
	local Level = self.Level
	return {
		Damage = UnitData[Level].Damage[1],
		FireRate = UnitData[Level].FireRate,
		Range = UnitData[Level].Range,
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

local function TweenTransparency(BasePart: BasePart, Transparency: number)
	if BasePart.Transparency ~= Transparency then
		local Tween = TweenService:Create(
			BasePart,
			TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ Transparency = Transparency }
		)

		Tween:Play()
	end
end

local function GetIdle(Unit: string)
	local AnimFolder = UnitsAnimations:FindFirstChild(Unit)
	if AnimFolder then
		local Idle = AnimFolder:FindFirstChild("Idle")

		if Idle then
			return Idle
		end
	end

	return
end

local DefaultCFrame = CFrame.new(0, -0.4, -2) * CFrame.Angles(0, math.rad(-180), 0)

function UnitModule.InitCharacter(Unit: string, Position: CFrame?)
	local InitTrove = Trove.new()
	local UnitModel: typeof(Rig) = InitTrove:Clone(UnitModels[Unit])
	local Humanoid: Humanoid & { [any]: any } = UnitModel.Humanoid
	local Animator: Animator & { [any]: any } = Humanoid.Animator
	local Root: BasePart = UnitModel.HumanoidRootPart
	Root.Anchored = true

	local CenterPart: BasePart = nil
	local UnitData = UnitInfo.UnitInfo[Unit]
	local BaseUpgradeData = UnitData.UnitData[0]
	local AdornmentName = BaseUpgradeData.Armor

	if typeof(AdornmentName) == "string" then
		SetAdornment(UnitModel, AdornmentName)
	end

	if UnitData.Vector3Offset and UnitData.Vector3Offset ~= Vector3.zero then
		CenterPart = CenterPart:Clone()
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

	DisableHumanoid(Humanoid)

	InitTrove:Add(UnitModel:GetPropertyChangedSignal("Parent"):Once(function()
		if UnitModel.Parent ~= nil then
			local Animation = GetIdle(Unit)
			if Animation then
				local Track = Animator:LoadAnimation(Animation)
				Track:Play(0)
			end
		end
	end))

	return {
		UnitModel = UnitModel,
		Trove = InitTrove,
		CenterPart = CenterPart,
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

	local Root = CharacterData.CenterPart

	local Pos, Size = UnitModel:GetBoundingBox()
	local BottomPosition = Pos.Position - Vector3.new(0, Size.Y / 2, 0)

	local RangePart = InitTrove:Add(GetRangePart(Range))
	RangePart.CFrame = CFrame.new(BottomPosition)
	Weld(RangePart, Root)
	RangePart.Parent = UnitModel

	local Ratio = UnitModel.Humanoid.BodyHeightScale.Value

	local RadiusPart = InitTrove:Clone(RadiusReference)
	RadiusPart.CFrame = CFrame.new(BottomPosition)
	RadiusPart.Size = Vector3.new(Radius / Ratio, RadiusPart.Size.Y, Radius / Ratio)
	Weld(RadiusPart, Root)
	RadiusPart.Transparency = 1
	RadiusPart.Parent = UnitModel
	TweenTransparency(RadiusPart, RadiusReference.Transparency)

	local VectorOffset = HelperFunctions.GetModelVectorOffset(UnitModel)

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
	local IsValid: boolean = false

	InitTrove:Add(task.defer(function()
		for Id, Unit in pairs(Units) do
			TweenTransparency(Unit.RadiusPart, 0)
		end
	end))

	InitTrove:Add(function()
		for Id, Unit in pairs(Units) do
			TweenTransparency(Unit.RadiusPart, 1)
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
			local UnitPosition = HelperFunctions.ConvertToVec2(UnitPosition)
			for _, Unit in pairs(Units) do
				local OtherPosition = HelperFunctions.ConvertToVec2(Unit.CFrame.Position)
				if (UnitPosition - OtherPosition).Magnitude < (Unit.CollisionRadius + Radius) / 2 then
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
	local CurrentPromise: Promise.Promise? = nil

	Changed:Connect(function()
		if CurrentPromise then
			CurrentPromise:cancel()
		end
		CurrentPromise = InitTrove:AddPromise(HelperFunctions.TweenPromise(0.1, function(alpha: number)
			AnimatedRotation = TweenService:GetValue(alpha, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
				+ (RotationIndex - 1)
		end) :: any)
	end)

	local function OnFrame()
		local RaycastResult: RaycastResult? = GetMouseIsPointing(RayParams)

		if RaycastResult and RaycastResult.Position then
			UnitPosition = RaycastResult.Position

			if UnitPosition then
				CenterPart.CFrame = CFrame.new(UnitPosition) * CFrame.Angles(0, math.rad(-90 * AnimatedRotation), 0)
					+ VectorOffset

				local OldValid = IsValid

				local Parts = CastCylinder(UnitPosition, OvParams)
				IsValid = CheckValidity(Parts)
				OnValdiityCheck(OldValid)

				UnitModel.Parent = PlacementClient
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
		OnFrame()
	end

	local StartTime = tick()
	local function HandleClick()
		if (tick() - StartTime) < 0.1 then
			return
		end

		if UnitPosition and IsValid then
			PlaceUnit:FireServer({
				Unit = Unit,
				UnitPosition = UnitPosition,
				RotationIndex = RotationIndex,
			})
			Data.Clicked:Fire()
			InitTrove:Destroy()
		end
	end

	local function HandleInput(Input: InputObject, Processed: boolean)
		if Processed then
			return
		end
		if HelperFunctions.IsClick(Input) then
			HandleClick()
		elseif Input.UserInputType == Enum.UserInputType.Keyboard then
			if Input.KeyCode == Enum.KeyCode.R then
				RotateIndex()
			end
		end
	end

	InitTrove:Connect(UserInputService.InputBegan, HandleInput)
	InitTrove:BindToRenderStep("InitPlacement", Enum.RenderPriority.Character.Value, OnFrame)

	return Data
end

OnPlacement.OnClientEvent:Connect(function(PlacementData: { [string]: Types.UnitInput })
	for _, Input in pairs(PlacementData) do
		NewUnit(Input)
	end
end)

Attack.OnClientEvent:Connect(function(Data: Types.UnitAttackInput)
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		Unit:OnAttack(Data)
	end
end)

PriorityChanged.OnClientEvent:Connect(function(Data: { UniqueId: string, Priority: UnitInfo.SortType })
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		if Unit.AttackPriority ~= Data.Priority then
			Unit.AttackPriority = Data.Priority
			Unit.PriorityChanged:Fire(Data.Priority)
		end
	end
end)

OnUpgrade.OnClientEvent:Connect(function(Data: { UniqueId: string, Level: number })
	local Unit = UnitModule.GetUnit(Data.UniqueId)

	if Unit then
		Unit:OnUpgrade(Data.Level)
	end
end)

Destroy.OnClientEvent:Connect(function(UniqueIds: { string })
	for _, Id in ipairs(UniqueIds) do
		local Unit = Units[Id]
		if Unit then
			UnitDestroy(Unit)
		end
	end
end)

return UnitModule
