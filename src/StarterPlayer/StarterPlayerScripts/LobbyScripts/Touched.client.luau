--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local ClientOnly = require(ReplicatedStorage.Network.ClientOnly)
local EvolutionTouched = ClientOnly.EvolutionTouched
local TraitsTouched = ClientOnly.TraitsTouched
local DailysTouched = ClientOnly.DailysTouched

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local ObserveTag = require(Modules.ObserveTag)

local Player = Players.LocalPlayer

local function HandleTouched(Tag: string, TouchedEvent: Signal.Signal<>)
	ObserveTag.ObserveTag(Tag, function(BasePart: Instance)
		if BasePart:IsA("BasePart") then
			local Connection = BasePart.Touched:Connect(function(OtherPart)
				local OtherPlayer = HelperFunctions.GetPlayerFromPart(OtherPart)

				if Player == OtherPlayer then
					TouchedEvent:Fire()
				end
			end)

			return function()
				Connection:Disconnect()
			end
		end

		return function() end
	end)
end

HandleTouched("EvolutionTouch", EvolutionTouched)
HandleTouched("TraitsTouch", TraitsTouched)
HandleTouched("DailysTouch", DailysTouched)
