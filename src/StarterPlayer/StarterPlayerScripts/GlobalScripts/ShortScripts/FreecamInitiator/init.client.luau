--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseService = require(ReplicatedStorage.Client.GlobalClient.PurchaseService)

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local OldFreecam = PlayerGui:FindFirstChild("Freecam")
if OldFreecam then
	OldFreecam:Destroy()
end

Promise.try(function()
	if not PurchaseService.IsLoaded then
		PurchaseService.Loaded:Wait()
	end

	return Player:GetRankInGroup(Constants.GroupId) >= 200 or PurchaseService.OwnsGamepass(3)
end)
	:andThen(function(CanUse: boolean)
		if CanUse then
			local Freecam = script:WaitForChild("Freecam")
			local FreecamScript = Freecam:WaitForChild("FreecamScript")

			Freecam.Parent = PlayerGui
			FreecamScript.Enabled = true
		end
	end)
	:catch(function(err)
		warn("Failed to get player rank in group: ", err)
	end)
