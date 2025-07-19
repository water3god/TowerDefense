--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)
local HelperFunctions = require(Modules.HelperFunctions)

local Network = require(ReplicatedStorage.Network.Server)
local TeleportBack = Network.TeleportBack

TeleportBack.SetCallback(function(Player: Player, Lobby: boolean)
	if typeof(Lobby) == "boolean" then
		if Lobby and DelayHandler("TeleportBack" .. Player.UserId, 5) then
			HelperFunctions.SafeTeleport(function()
				return TeleportService:TeleportAsync(133996430724424, { Player })
			end, 3)
		end
	end
end)
