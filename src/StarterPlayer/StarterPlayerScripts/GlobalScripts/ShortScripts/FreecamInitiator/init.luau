--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local OldFreecam = PlayerGui:WaitForChild("Freecam")
OldFreecam:Destroy()

local Freecam = script:WaitForChild("Freecam")
local FreecamScript = Freecam:WaitForChild("FreecamScript")

Freecam.Parent = PlayerGui
FreecamScript.Enabled = true
