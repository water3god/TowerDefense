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
local StatsFrame = require(Inventory.StatsFrame)

-- Controls --

local controls = {}

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local Frame = e(StatsFrame, {
			Name = "Trajans",
			Type = "Unit",
			Level = 1,
			Visible = true,
			native = {
				Size = UDim2.fromScale(0.8, 0.8),
			},
		})
		return Frame
	end,
}

return Story
