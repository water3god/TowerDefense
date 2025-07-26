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
local Components = Gui.Components
local SelectCount = require(Components.SelectCount)

local Inventory = Gui.Inventory
local ResourceFrame = require(Inventory.ResourceFrame)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function()
		local Frame = e(
			SelectCount,
			{
				OnClick = function() end,
			},
			e(ResourceFrame, {
				Name = "Gold",
			})
		)
		return Frame
	end,
}

return Story
