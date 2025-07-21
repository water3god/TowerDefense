--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = script.Parent

local Animations = ReplicatedStorage.Animations
local SprintAnimId = Animations.Misc.Sprint.AnimationId
local WalkAnimId = "http://www.roblox.com/asset/?id=913376220"

local RunAnimation = Character:WaitForChild("Animate"):WaitForChild("run"):WaitForChild("RunAnim") :: Animation

local ClientOnly = require(ReplicatedStorage.Network.ClientOnly)

--[[ClientOnly.ChangeWalk:Connect(function(Enabled: boolean)
	if Enabled then
		RunAnimation.AnimationId = SprintAnimId
	else
		RunAnimation.AnimationId = WalkAnimId
	end
end)]]
