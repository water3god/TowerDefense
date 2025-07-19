--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local ModelStorage = ReplicatedStorage.ModelStorage
local Extra = ModelStorage.Extra
local Rig = Extra.Rig

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local function HandleChar(Character: typeof(Rig), Player: Player)
	local CharTrove = Trove.new()
	for _, Descendant in ipairs(Character:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end

	CharTrove:Connect(Character.DescendantAdded, function(Descendant: Instance)
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end)

	local Humanoid = Character.Humanoid
	if Humanoid then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	Player.CharacterRemoving:Once(function()
		CharTrove:Destroy()
	end)
end

SafePlayerAdded:Connect(function(Player: Player)
	if Player.Character then
		HandleChar(Player.Character, Player)
	end
	Player.CharacterAdded:Connect(function(Character)
		HandleChar(Character, Player)
	end)
end, true)
