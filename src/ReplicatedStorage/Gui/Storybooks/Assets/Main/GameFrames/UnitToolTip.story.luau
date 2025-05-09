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
local GameFrames = Gui.GameFrames
local UnitToolTip = require(GameFrames.UnitToolTip)

-- Controls --
local controls = {
	Damage = 10,
	FireRate = 10,
	Range = 1,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(UnitToolTip.Create, {
			UnitName = "Minigunner",
			Data = Properties.controls,
			native = {
				Position = UDim2.fromScale(0.5, 0.4),
			},
		})
		return Frame
	end,
}

return Story
