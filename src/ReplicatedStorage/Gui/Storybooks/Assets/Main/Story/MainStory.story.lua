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
local MainStory = require(Gui.Story.MainStory)

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	story = function(Properties)
		local Frame = e(MainStory, {
			native = {
				Size = UDim2.fromScale(0.65, 0.9),
			},
		})
		return Frame
	end,
}

return Story
