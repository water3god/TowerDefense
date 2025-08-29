--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Server)
local ServerOnly = require(NetworkFolder.ServerOnly)
local GameLoaded = Network.GameLoaded

local Utility = ServerScriptService.Utility
local Variables = require(Utility.Variables)

GameLoaded.SetCallback(function(Player)
	if not Variables.Loaded[Player] then
		Variables.Loaded[Player] = true
		ServerOnly.PlayerLoaded:Fire(Player)
	end
end)

local function HandlePlayer(Player: Player)
	Variables.Loaded[Player] = false

	task.delay(30, function()
		if Player:IsDescendantOf(Players) then
			if not Variables.Loaded[Player] then
				Variables.Loaded[Player] = true
				ServerOnly.PlayerLoaded:Fire(Player)
			end
		end
	end)
end

for _, Player in ipairs(Players:GetPlayers()) do
	HandlePlayer(Player)
end

Players.PlayerAdded:Connect(HandlePlayer)

Players.PlayerRemoving:Connect(function(Player)
	Variables.Loaded[Player] = nil
end)
