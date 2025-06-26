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

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Player = Players.LocalPlayer

local Positions = {
	Vector3.new(1, 0, 0),
	Vector3.new(0.5, 0, 0.5),
	Vector3.new(0, 0, 1),
	Vector3.new(-0.5, 0, 0.5),
	Vector3.new(-1, 0, 0),
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

	self.Trove = Trove.new()

	self.Destroying = self.Trove:Construct(Signal)

	self.Character = Player.Character

	local FollowerData = UnitClient.InitCharacter(Data.UnitName)
	self.Trove:Add(FollowerData.Trove)
	self.Follower = FollowerData.UnitModel
	self.CharRoot = FollowerData.CenterPart

	local RootAttachment = self.CharRoot:FindFirstChild("RootAttachment") :: Attachment

	self.Humanoid = self.Character.Humanoid
	self.Animator = self.Character.Humanoid.Animator

	self.IdealPart = self.Trove:Add(HelperFunctions.CreateRaw())
	self.IdealPart.Transparency = 1
	self.IdealPart.Name = "IdealPart"
	self.IdealPart.Parent = self.Follower

	local Attachment = self.Trove:Construct(Instance, "Attachment") :: Attachment
	Attachment.Name = "FollowerAttachment"
	Attachment.Parent = self.IdealPart

	self.IKControl = self.Trove:Construct(Instance, "IKControl") :: IKControl
	self.IKControl.Enabled = false
	self.IKControl.Name = "FollowerIKControl"
	self.IKControl.Type = Enum.IKControlType.Transform
	self.IKControl.EndEffector = self.Character.LeftHand
	self.IKControl.Parent = self.Follower

	self.AlignOrientation = self.Trove:Construct(Instance, "AlignOrientation") :: AlignOrientation
	self.AlignOrientation.Name = "FollowerAlignOrientation"
	self.AlignOrientation.RigidityEnabled = true
	self.AlignOrientation.Attachment0 = Attachment
	self.AlignOrientation.Attachment1 = RootAttachment
	self.AlignOrientation.Parent = self.CharRoot

	self.AlignPosition = self.Trove:Construct(Instance, "AlignPosition") :: AlignPosition
	self.AlignPosition.Name = "FollowerAlignPosition"
	self.AlignPosition.RigidityEnabled = true
	self.AlignOrientation.Attachment0 = Attachment
	self.AlignOrientation.Attachment1 = RootAttachment
	self.AlignPosition.Parent = self.CharRoot

	for _, Descendant in ipairs(self.Follower:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "PlacedCharacters"
		end
	end

	self.Trove:Connect(RunService.PostSimulation, function()
		local CharCFrame = self.Character.HumanoidRootPart.CFrame
		local Position = CharCFrame:VectorToWorldSpace(Positions[Data.Index])
		local FollowerCFrame = CFrame.new(Position - Vector3.new(0, 3, 0)) * CharCFrame.Rotation

		local Raycast = workspace:Raycast(FollowerCFrame.Position + Vector3.new(0, 1, 1), -Vector3.yAxis * 10, Params)

		if Raycast and Raycast.Position then
			self.IdealPart.Position = Raycast.Position
		else
			self.IdealPart.Position = FollowerCFrame.Position
		end
	end)

	self.Trove:AddPromise(Promise.defer(function(resolve)
		self.Follower.Parent = Followers
		resolve()
	end) :: any)

	return self
end

function Follower:Destroy()
	self.Trove:Destroy()
	setmetatable(self :: any, nil)
end

return Follower
