--!strict

local ServerScriptService = game:GetService("ServerScriptService")

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local function AddCollision(Character: Model)
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
end

SafePlayerAdded:Connect(function(Player: Player)
	if Player.Character then
		AddCollision(Player.Character)
	end
	Player.CharacterAdded:Connect(AddCollision)
end, true)
