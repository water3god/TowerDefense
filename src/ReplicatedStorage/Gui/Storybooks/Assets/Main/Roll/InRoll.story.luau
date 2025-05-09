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
local Roll = Gui.Roll
local InRoll = require(Roll.InRoll)

-- Controls --
local controls = {
	Count = 1,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Units = {}
		for _ = 1, Properties.controls.Count, 1 do
			table.insert(Units, "Minigunner")
		end
		local Frame = e(InRoll.Create, {
			UnitNames = Units,
		})
		return Frame
	end,
}

return Story
