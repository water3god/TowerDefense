--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local Inventory = Gui.Inventory
local ClickedInventory = require(Inventory.ClickedInventory)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function()
		local Frame = e(ClickedInventory.Create, {
			Loading = true,
			Frames = {},
			Level = 1,
			Name = "Wa1er_God",
		})
		return Frame
	end,
}

return Story
