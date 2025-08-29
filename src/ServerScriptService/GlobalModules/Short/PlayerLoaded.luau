--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local NetworkFolder = ReplicatedStorage.Network
local ServerOnly = require(NetworkFolder.ServerOnly)

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving)

local Signals = {}

SafePlayerAdded:Connect(function(Player: Player)
	Signals[Player] = Signal.new()

	ServerOnly.PlayerLoaded:Connect(function(LoadedPlayer: Player)
		if LoadedPlayer == Player then
			Signals[Player]:Fire()
		end
	end)
end, true)

SafePlayerRemoving:Connect(function(Player: Player)
	Signals[Player] = nil
end)

return function(Player: Player)
	if not Signals[Player] then
		repeat
			task.wait()
		until Signals[Player]
	end
	return Signals[Player]
end
