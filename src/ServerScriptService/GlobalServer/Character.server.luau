--!strict

local ServerScriptService = game:GetService("ServerScriptService")

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local GlobalWorkspace = workspace.GlobalWorkspace
local CharacterFolder = GlobalWorkspace.Characters

local function HandleChar(Character: Model)
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

	Character.Parent = CharacterFolder
end

SafePlayerAdded:Connect(function(Player: Player)
	if Player.Character then
		HandleChar(Player.Character)
	end
	Player.CharacterAdded:Connect(HandleChar)
end, true)
