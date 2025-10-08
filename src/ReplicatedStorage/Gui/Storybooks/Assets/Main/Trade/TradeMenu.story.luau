--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local TradeFolder = Gui.Trade
local TradeMenu = require(TradeFolder.TradeMenu)
local TradeContext = require(TradeFolder.TradeContext)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(TradeContext.Context.Provider, {
			value = {
				[LocalPlayer] = "CanTrade",
			},
		}, e(TradeMenu, {}))
		return Frame
	end,
}

return Story
