--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Gui = ReplicatedStorage.Gui
local Message = require(Gui.Message.Message)

local LocalPlayer = Players.LocalPlayer

type NPCInput = {
	Name: string,
	Messages: { string },
	NPCCFrame: CFrame,
}

type NPCTalkData = {
	Trove: Trove.Trove,

	Name: string,
	Messages: { string },
	NPCCFrame: CFrame,

	Camera: Camera,

	Destroying: Signal.Signal<>,
}

type NPCTalkImpl = {
	new: (Input: NPCInput) -> NPCTalk,
	Destroy: (self: NPCTalk) -> (),
	__index: NPCTalkImpl,
}

export type NPCTalk = typeof(setmetatable({} :: NPCTalkData, {} :: NPCTalkImpl))

local NPCTalk: NPCTalkImpl = {} :: NPCTalkImpl
NPCTalk.__index = NPCTalk

function NPCTalk.new(Input: NPCInput): NPCTalk
	local self = setmetatable({}, NPCTalk) :: NPCTalk

	self.Trove = Trove.new()

	self.Destroying = self.Trove:Construct(Signal)

	self.Name = Input.Name
	self.Messages = Input.Messages
	self.NPCCFrame = Input.NPCCFrame

	self.Camera = workspace.CurrentCamera
	local OldCFrame = self.Camera.CFrame

	local Prom = Promise.resolve(
		(self.NPCCFrame * CFrame.Angles(0, math.rad(180), 0) + self.NPCCFrame.LookVector * 6 + Vector3.new(0, 1, 0))
	)
		:andThen(function(NPCCFrame: CFrame)
			local Character = LocalPlayer.Character
			if Character then
				Character:SetAttribute("Disabled", true)
			end
			return NPCCFrame
		end)
		:andThen(function(NPCCFrame: CFrame)
			self.Camera.CameraType = Enum.CameraType.Scriptable
			return HelperFunctions.ConventialTween(
				self.Camera,
				TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ CFrame = NPCCFrame }
			)
		end)
		:catch(function() end)

	self.Trove:AddPromise(Prom :: any)

	self.Trove:Connect(LocalPlayer.CharacterRemoving, function()
		self:Destroy()
	end)

	local NPCGui = Instance.new("ScreenGui")
	NPCGui.Name = "NPCTalkGui"
	NPCGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	NPCGui.DisplayOrder = 3
	NPCGui.Parent = LocalPlayer.PlayerGui

	local Root = ReactRoblox.createRoot(NPCGui)

	local function CloseCallback()
		local CameraTween = HelperFunctions.ConventialTween(
			workspace.CurrentCamera,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ CFrame = OldCFrame }
		)
			:andThen(function()
				workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

				local Character = LocalPlayer.Character
				if Character then
					Character:SetAttribute("Disabled", false)
				end
			end)
			:catch(function() end)

		LocalPlayer.CharacterRemoving:Once(function()
			CameraTween:cancel()
		end)

		self:Destroy()
	end

	Root:render(React.createElement(Message, {
		SpeakerName = self.Name,
		Messages = self.Messages,
		CloseClick = CloseCallback,
	}))

	self.Trove:Add(function()
		Root:unmount()
	end)

	return self
end

function NPCTalk:Destroy()
	self.Destroying:Fire()
	self.Trove:Destroy()
	setmetatable(self :: any, nil)
	table.clear(self :: any)
end

return NPCTalk
