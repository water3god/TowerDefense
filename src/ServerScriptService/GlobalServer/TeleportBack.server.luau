--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Remotes = ReplicatedStorage.Remotes
local Core = Remotes.Core
local TeleportBack = Core.TeleportBack

TeleportBack.OnServerEvent:Connect(function(Player: Player, Lobby: boolean)
	if typeof(Lobby) == "boolean" then
		if Lobby then
			HelperFunctions.SafeTeleport(function()
				return TeleportService:TeleportAsync(133996430724424, { Player })
			end, 3)
		end
	end
end)
