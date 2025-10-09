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
local ProgressBar = require(Gui.Components.ProgressBar)

-- Controls --
local controls = {
	Bar = 1,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(props)
		local Binding, setBinding = React.useBinding(props.controls.Bar)

		React.useEffect(function()
			setBinding(props.controls.Bar)
		end, { props.controls.Bar })

		local Frame = e(ProgressBar, {
			Bar = Binding,
			native = {
				Size = UDim2.fromScale(0.7, 0.2),
			},
		})
		return Frame
	end,
}

return Story
