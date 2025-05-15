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
local EndFrame = require(GameFrames.EndFrame)

-- Controls --
local controls = {}

local function Container()
	local Enabled = React.useState(true)
	local Success = React.useBinding(false)
	local PlayerData = React.useBinding({
		Votes = 3,
		Total = 3,
	})

	return e(EndFrame.Create, {
		Enabled = Enabled,
		Success = Success,
		PlayerData = PlayerData,
		--[[native = {
			Size = UDim2.fromScale(0.8, 0.3),
			Position = UDim2.fromScale(0.5, 0.5),
		},]]
	})
end

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		return e(Container)
	end,
}

return Story
