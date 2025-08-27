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
local StoreFolder = Gui.Store
local Store = require(StoreFolder.Store)
local PurchaseContext = require(StoreFolder.PurchaseContext)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(PurchaseContext.Provider, {
			value = {
				ProductData = {},
				GamepassData = {},
				Loaded = false,
			},
		}, {
			Store = e(Store, {}),
		})
		return Frame
	end,
}

return Story
