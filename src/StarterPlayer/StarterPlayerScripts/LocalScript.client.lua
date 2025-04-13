--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local Inventory = Gui.Inventory
local InventoryMain = require(Inventory.InventoryMain)
local StatsFrame = require(Inventory.StatsFrame)
local UnitFrame = require(Inventory.UnitFrame)

local GlobalGui = Instance.new("ScreenGui")
GlobalGui.Name = "GlobalGui"
GlobalGui.Parent = PlayerGui

local function Render()
	local VisibleFrame: GuiObject?, SetVisibleFrame = React.useState(nil :: GuiObject?)

	return e("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		InventoryFrame = e(InventoryMain, {}),
	})
end

local GlobalRoot = ReactRoblox.createRoot(GlobalGui)
GlobalRoot:render(e(InventoryMain))
