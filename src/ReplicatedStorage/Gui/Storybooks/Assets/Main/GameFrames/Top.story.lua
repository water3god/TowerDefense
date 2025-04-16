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
local GameFrames = Gui.GameFrames
local Top = require(GameFrames.Top)
local WaveContext = require(GameFrames.WaveContext)

-- Controls --
local controls = {}

local Value = {
	Wave = 5,
	Time = 5,
	StartTime = 0,
	BaseHealth = 100,
	MaxHealth = 100,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(WaveContext.Context.Provider, {
			value = Value,
		}, {
			TopFrame = e(Top, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.8, 0.5),
				},
			}),
		})
		return Frame
	end,
}

return Story
