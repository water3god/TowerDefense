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
local Core = require(Gui.CoreGame.Core)

local controls = {
	OpenFrame = "",
}

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		return e(Core, {
			--OpenFrame = Properties.controls.OpenFrame,
		})
	end,
}

return Story
