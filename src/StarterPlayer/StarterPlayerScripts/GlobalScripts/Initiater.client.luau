--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

_G.__DEV__ = RunService:IsStudio()

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Core = require(CoreGame.Core)

local Shared = ReplicatedStorage.Shared
local Variables = require(Shared.Variables)

local ClientOnly = require(ReplicatedStorage.Network.ClientOnly)

local GlobalGui = Instance.new("ScreenGui")
GlobalGui.Name = "GlobalGui"
GlobalGui.ResetOnSpawn = false
GlobalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GlobalGui.Parent = PlayerGui

GlobalGui.Enabled = Variables.GuiEnabled

ClientOnly.GuiEnabled:Connect(function(Enabled: boolean)
	GlobalGui.Enabled = Enabled
end)

local GlobalRoot = ReactRoblox.createRoot(GlobalGui)
GlobalRoot:render(e(Core))
