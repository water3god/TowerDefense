--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ModelStorage = ReplicatedStorage.ModelStorage
local Extra = ModelStorage.Extra
local Rig = Extra.Rig

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local GlobalWorkspace = workspace.GlobalWorkspace
local CharacterFolder = GlobalWorkspace.Characters

local function HandleChar(Character: typeof(Rig))
	for _, Descendant in ipairs(Character:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end

	Character.DescendantAdded:Connect(function(Descendant: Instance)
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end)

	local Humanoid = Character.Humanoid
	if Humanoid then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	Character.Parent = CharacterFolder
end

SafePlayerAdded:Connect(function(Player: Player)
	if Player.Character then
		HandleChar(Player.Character)
	end
	Player.CharacterAdded:Connect(HandleChar)
end, true)
