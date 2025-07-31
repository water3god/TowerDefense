--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local ObserveTag = require(Modules.ObserveTag)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local NPCTalk = require(LobbyClient.NPCTalk)

local Animations = ReplicatedStorage.Animations
local Units = Animations.Units
local Idle = Units.Default

local Shared = ReplicatedStorage.Shared
local NPCTalks = require(Shared.NPCTalks)

local ActivePrompt: NPCTalk.NPCTalk? = nil

ObserveTag.ObserveTag("NPCTalk", function(NPC)
	if NPC:IsA("Model") then
		local HumanoidRoot = NPC:WaitForChild("HumanoidRootPart") :: BasePart
		local Humanoid = NPC:WaitForChild("Humanoid") :: Humanoid
		local Animator = Humanoid:WaitForChild("Animator") :: Animator

		HelperFunctions.DisableHumanoid(Humanoid)

		local OverrideAnim = NPC:GetAttribute("OverrideAnimation") :: string
		local PlayedOverride = false
		if OverrideAnim then
			local CharFolder = Units:FindFirstChild(NPC.Name)

			if CharFolder then
				local Animation = CharFolder:FindFirstChild(OverrideAnim) :: Animation
				if Animation then
					Animator:LoadAnimation(Animation):Play()
					PlayedOverride = true
				end
			end
		end

		if not PlayedOverride then
			Animator:LoadAnimation(Idle):Play()
		end

		for _, BasePart in ipairs(NPC:GetDescendants()) do
			if BasePart:IsA("BasePart") then
				BasePart.CollisionGroup = "PlacedCharacters"
			end
		end

		local Input = {
			Name = NPC.Name,
			Messages = NPCTalks[NPC.Name] and NPCTalks[NPC.Name].Messages or {},
			NPCCFrame = HumanoidRoot.CFrame,
		}

		local Folder = Instance.new("Folder")
		Folder.Name = "NPCTalk"
		Folder.Parent = HumanoidRoot

		local Root = ReactRoblox.createRoot(Folder)

		Root:render(e("BillboardGui", {
			Adornee = HumanoidRoot,
			Size = UDim2.fromScale(5, 5),
			StudsOffsetWorldSpace = Vector3.new(0, 4, 0),
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Text = NPC.Name,
					Size = UDim2.fromScale(1, 0.2),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
		}))

		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.ActionText = "Talk"
		ProximityPrompt.ObjectText = NPC.Name

		ProximityPrompt.Triggered:Connect(function()
			if ActivePrompt then
				return
			end
			local Talk = NPCTalk.new(Input)
			ActivePrompt = Talk
			ProximityPrompt.Enabled = false
			Talk.Destroying:Connect(function()
				task.wait(1.5)
				ActivePrompt = nil
				ProximityPrompt.Enabled = true
			end)
		end)

		ProximityPrompt.Parent = HumanoidRoot

		return function()
			Root:unmount()
		end
	else
		warn("NPCTalk: ObserveTag called on non-Model instance:", NPC:GetFullName())
	end

	return function() end
end)
