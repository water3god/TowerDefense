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
local TradePopup = require(Gui.Trade.TradePopup)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function()
		local Frame = e(TradePopup.Create, {
			Ids = { 343804839, 123456789 },
			native = {
				Position = UDim2.fromScale(0.3, 0.3),
			},
		})
		return Frame
	end,
}

return Story
