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
local Button = require(Gui.Components.Button)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function()
		local Frame = e(Button, {
			Color = "Purple",
			Text = "Create a button lol hello",
			native = {
				Size = UDim2.fromScale(0.8, 0.4),
			},
		})
		return Frame
	end,
}

return Story
