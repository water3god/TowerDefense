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
local TipsFolder = Gui.Tips
local TipsContext = require(TipsFolder.TipsContext)
local Tips = require(TipsFolder.TipsGui)

-- Controls --
local controls = {
	Text = "Did you know you can use the 'Shift' key to sprint?",
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(TipsContext.Context.Provider, {
			value = Properties.controls.Text,
		}, {
			TipsGui = e(Tips, {
				native = {
					Size = UDim2.fromScale(0.9, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
				},
			}),
		})

		return Frame
	end,
}

return Story
