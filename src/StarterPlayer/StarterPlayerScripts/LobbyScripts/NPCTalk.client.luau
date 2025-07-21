--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
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
		local Root = NPC:WaitForChild("HumanoidRootPart") :: BasePart
		local Humanoid = NPC:WaitForChild("Humanoid") :: Humanoid
		local Animator = Humanoid:WaitForChild("Animator") :: Animator
		Animator:LoadAnimation(Idle):Play()

		for _, BasePart in ipairs(NPC:GetDescendants()) do
			if BasePart:IsA("BasePart") then
				BasePart.CollisionGroup = "PlacedCharacters"
			end
		end

		local Input = {
			Name = NPC.Name,
			Messages = NPCTalks[NPC.Name] and NPCTalks[NPC.Name].Messages or {},
			NPCCFrame = Root.CFrame,
		}

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

		ProximityPrompt.Parent = Root
	else
		warn("NPCTalk: ObserveTag called on non-Model instance:", NPC:GetFullName())
	end

	return function() end
end)
