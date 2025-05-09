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
local BaseFrame = require(Gui.CoreGame.BaseFrame)

-- Controls --

local controls = {
	Name = "Goku",
	LeftText = "1",
	RightText = "$200",
}

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(BaseFrame, {
			Name = Properties.controls.Name,
			LeftText = Properties.controls.LeftText,
			RightText = Properties.controls.RightText,

			BackgroundColor = Properties.controls.BackgroundColor,
			NameColor = Properties.controls.NameColor,
			LeftColor = Properties.controls.LeftColor,
			RightColor = Properties.controls.RightColor,
			OnClick = function() end,
		})
		return Frame
	end,
}

return Story
