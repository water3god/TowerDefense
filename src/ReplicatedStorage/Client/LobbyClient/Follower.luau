--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local GenerateId = require(Modules.GenerateId)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Player = Players.LocalPlayer

local Positions = {
	Vector3.new(-1, 0, 0),
	Vector3.new(-0.75, 0, 0.75),
	Vector3.new(0, 0, 1),
	Vector3.new(0.75, 0, 0.75),
	Vector3.new(1, 0, 0),
}

local GlobalWorkspace = workspace.GlobalWorkspace
local Followers = GlobalWorkspace.Followers

export type Character = typeof(ReplicatedStorage.ModelStorage.Extra.Rig)

export type Input = {
	UnitName: string,
	Index: number,
	Character: Character,
}

type FollowerData = {
	UniqueId: string,
	Trove: Trove.Trove,

	Character: Character,
	CharRoot: BasePart,
	Humanoid: Humanoid,
	Animator: Animator,

	IKControl: IKControl,
	AlignPosition: AlignPosition,
	AlignOrientation: AlignOrientation,
	IdealPart: BasePart,

	Follower: Character,

	Destroying: Signal.Signal<>,
}

type FollowerImpl = {
	new: (Input: Input) -> Follower,
	Destroy: (self: Follower) -> (),
	__index: FollowerImpl,
}

export type Follower = typeof(setmetatable({} :: FollowerData, {} :: FollowerImpl))

local Follower: FollowerImpl = {} :: FollowerImpl
Follower.__index = Follower

local Params = RaycastParams.new()
Params.CollisionGroup = "Character"

function Follower.new(Data: Input): Follower
	local self = setmetatable({}, Follower) :: Follower

	self.UniqueId = GenerateId.GenerateId()
	self.Trove = Trove.new()

	self.Destroying = self.Trove:Construct(Signal)

	self.Character = Data.Character
	local FollowerData = UnitClient.InitCharacter(Data.UnitName)
	self.Trove:Add(FollowerData.Trove)
	self.Follower = FollowerData.UnitModel
	self.CharRoot = FollowerData.CenterPart

	local PlayWalk = FollowerData.PlayWalk

	self.Humanoid = self.Character.Humanoid
	self.Animator = self.Character.Humanoid.Animator

	self.IdealPart = self.Trove:Add(HelperFunctions.CreateRaw())
	self.IdealPart.Transparency = 1
	self.IdealPart.Name = "IdealPart"
	self.IdealPart.Anchored = false
	self.IdealPart.Parent = self.Follower

	local Attachment = self.Trove:Construct(Instance, "Attachment") :: Attachment
	Attachment.Name = "FollowerAttachment"
	Attachment.Parent = self.IdealPart

	--[[
	self.IKControl = self.Trove:Construct(Instance, "IKControl") :: IKControl
	self.IKControl.Enabled = false
	self.IKControl.Name = "FollowerIKControl"
	self.IKControl.Type = Enum.IKControlType.Transform
	self.IKControl.EndEffector = self.Character.LeftHand
	self.IKControl.Parent = self.Follower]]

	self.AlignOrientation = self.Trove:Construct(Instance, "AlignOrientation") :: AlignOrientation
	self.AlignOrientation.Name = "FollowerAlignOrientation"

	self.AlignOrientation.MaxTorque = 100000
	self.AlignOrientation.Responsiveness = 25
	self.AlignOrientation.Attachment0 = Attachment
	self.AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.AlignOrientation.Parent = self.CharRoot

	self.AlignPosition = self.Trove:Construct(Instance, "AlignPosition") :: AlignPosition
	self.AlignPosition.Name = "FollowerAlignPosition"

	self.AlignPosition.MaxForce = 100000
	self.AlignPosition.Responsiveness = 25
	self.AlignPosition.Attachment0 = Attachment
	self.AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	self.AlignPosition.Parent = self.CharRoot

	for _, Descendant in ipairs(self.Follower:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "PlacedCharacters"
		end
	end

	local LastPosition = self.CharRoot.Position
	local Count = 0
	local InWalk = false

	local function UpdateWalk()
		local Movement = LastPosition - self.CharRoot.Position

		if Movement.Magnitude > 0.05 then
			if not InWalk then
				Count += 1
			else
				Count = math.max(Count - 1, 0)
			end
		else
			if InWalk then
				Count += 1
			else
				Count = math.max(Count - 1, 0)
			end
		end

		if Count > 3 then
			if InWalk then
				PlayWalk(false)
				InWalk = false
			else
				PlayWalk(true)
				InWalk = true
			end
			Count = 0
		end

		LastPosition = self.CharRoot.Position
	end

	local PlayerRoot: BasePart? = nil
	local Offset = Positions[Data.Index] * 6

	task.spawn(function()
		PlayerRoot = Player.Character:WaitForChild("HumanoidRootPart")
	end)

	local function OnStep()
		if not PlayerRoot then
			return
		end
		local CharCFrame = PlayerRoot.CFrame
		local AlteredCFrame = CharCFrame + CharCFrame:VectorToWorldSpace(Offset)

		self.AlignPosition.Position = AlteredCFrame.Position
		self.AlignOrientation.CFrame = AlteredCFrame
	end

	local function OtherStep()
		local OtherRay = workspace:Raycast(self.IdealPart.Position, -Vector3.yAxis * 30, Params)

		if OtherRay and OtherRay.Position then
			local Position = Vector3.new(self.IdealPart.CFrame.X, OtherRay.Position.Y, self.IdealPart.CFrame.Z)
			self.CharRoot.CFrame = (CFrame.new(Position) + Vector3.new(0, 1.8, 0)) * self.IdealPart.CFrame.Rotation
		else
			self.CharRoot.CFrame = self.IdealPart.CFrame
		end
	end

	RunService.RenderStepped:Connect(OnStep)
	self.Trove:BindToRenderStep("Follower" .. self.UniqueId, Enum.RenderPriority.Character.Value, OtherStep)
	local WalkCount = 0
	RunService.Heartbeat:Connect(function(Delta)
		WalkCount += Delta
		if WalkCount >= 0.016 then
			UpdateWalk()
			WalkCount = 0
		end
	end)

	--self.Trove:BindToRenderStep("Follower" .. self.UniqueId, Enum.RenderPriority.Character.Value, OnStep)

	self.Trove:AddPromise(Promise.defer(function(resolve)
		self.Follower.Parent = Followers
		resolve()
	end) :: any)

	return self
end

function Follower:Destroy()
	GenerateId.RemoveId(self.UniqueId)
	self.Trove:Destroy()
	setmetatable(self :: any, nil)
end

return Follower
