--!strict

-- By Wa1er_God --

if true then
	return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

SafePlayerAdded:Connect(function(Player: Player)
	local PlayerData = PlayerData.GetPlayerDataAsync(Player)

	if PlayerData then
		local Leaderstats = Instance.new("Folder")
		Leaderstats.Name = "leaderstats"
		Leaderstats.Parent = Player

		local RollCount = Instance.new("IntValue")
		RollCount.Name = "Roll Count"
		RollCount.Value = PlayerData.Profile.Data.RollCount
		RollCount.Parent = Leaderstats

		PlayerData.Rolled:Connect(function(Value)
			RollCount.Value = Value
		end)
	end
end)
