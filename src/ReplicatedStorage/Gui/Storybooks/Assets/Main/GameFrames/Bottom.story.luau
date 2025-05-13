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
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local GameFrames = Gui.GameFrames
local Bottom = require(GameFrames.Bottom)
local EquippedContext = require(GameFrames.EquippedUnitsContext)
local CurrencyContext = require(GameFrames.Currency)

-- Controls --
local controls = {}

local Units = {
	Units = {
		[1] = {
			UniqueId = "Hello",
			Unit = "Minigunner",
			Level = 7,
		},
	},
	GlobalLevel = 5,
	XP = 15,
	NeededXP = 20,
}

local Currency = {
	CurrencyName = "Gold",
	Icon = "rbxassetid://72304165589077",
	Value = 10,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(EquippedContext.Context.Provider, {
			value = Units,
		}, {
			CurrencyProvider = e(CurrencyContext.Context.Provider, {
				value = Currency,
			}, {
				Bottom = e(Bottom, {
					native = {
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
					},
				}),
			}),
		})
		return Frame
	end,
}

return Story
