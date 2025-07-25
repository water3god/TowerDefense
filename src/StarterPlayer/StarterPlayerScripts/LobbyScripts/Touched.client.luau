--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Touched = require(ReplicatedStorage.Network.ClientOnly).EvolutionTouched

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local ObserveTag = require(Modules.ObserveTag)

local Player = Players.LocalPlayer

ObserveTag.ObserveTag("EvolutionTouch", function(BasePart: Instance)
	if BasePart:IsA("BasePart") then
		local Connection = BasePart.Touched:Connect(function(OtherPart)
			local OtherPlayer = HelperFunctions.GetPlayerFromPart(OtherPart)

			if Player == OtherPlayer then
				Touched:Fire()
			end
		end)

		return function()
			Connection:Disconnect()
		end
	end

	return function() end
end)
