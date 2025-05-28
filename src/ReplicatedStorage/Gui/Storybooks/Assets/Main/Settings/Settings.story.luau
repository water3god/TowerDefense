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
local SettingsFolder = Gui.Settings
local Settings = require(SettingsFolder.Settings)
local SettingsContext = require(SettingsFolder.SettingsContext)

local Shared = ReplicatedStorage.Shared
local SettingsData = require(Shared.Settings)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local Frame = e(SettingsContext.Context.Provider, {
			value = SettingsData.Default,
		}, {
			Settings = e(Settings.Create, {}),
		})
		return Frame
	end,
}

return Story
