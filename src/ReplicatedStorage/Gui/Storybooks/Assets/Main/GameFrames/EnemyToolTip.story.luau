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
local EnemyToolTip = require(GameFrames.EnemyToolTip)

-- Controls --
local controls = {
	Name = "Zombie",
	Health = 100,
	MaxHealth = 100,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(EnemyToolTip.Create, {
			EnemyName = Properties.controls.Name,
			Health = Properties.controls.Health,
			MaxHealth = Properties.controls.MaxHealth,
			native = {
				Position = UDim2.fromScale(0.5, 0.3),
			},
		})
		return Frame
	end,
}

return Story
