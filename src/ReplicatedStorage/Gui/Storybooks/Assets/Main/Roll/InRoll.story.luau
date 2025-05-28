--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local Roll = Gui.Roll
local InRoll = require(Roll.InRoll)
local SettingsContext = require(Gui.Settings.SettingsContext)

local SettingsData = require(ReplicatedStorage.Shared.Settings)

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
			table.insert(Units, { Name = "Spartacus", UniqueId = "@498)(*)&(" })
		end
		local Frame = e(SettingsContext.Context.Provider, {
			value = Join(SettingsData.Default, { ["RareSkip"] = true }),
		}, {
			Frame = e(InRoll.Create, {
				UnitNames = Units,
				LastFiredTime = workspace:GetServerTimeNow(),
				AutoRoll = false,
			}),
		})
		return Frame
	end,
}

return Story
