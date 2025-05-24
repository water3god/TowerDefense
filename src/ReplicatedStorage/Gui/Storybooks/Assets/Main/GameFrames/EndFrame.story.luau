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
local controls = {
	Success = true,
	OldXP = 40,
}

local function Container(props: any)
	local Enabled = React.useState(true)
	local PlayerData = React.useBinding({
		Votes = 3,
		Total = 3,
	})

	return e(EndFrame.Create, {
		Enabled = Enabled,
		Success = props.controls.Success,
		PlayerData = PlayerData,
		MainXPData = { OldXP = 10, NewXP = 20, OldLevel = 2, NewLevel = 5 },
		EndData = {
			Units = {
				"Augustus",
			},
			Resources = {
				{ Resource = "Gold", Count = 10 },
			},
			ExistingUnits = {
				{ Name = "Trajan", OldXP = 0, OldLevel = 1, NewXP = 20, NewLevel = 10 },
				{ Name = "Spartacus", OldXP = 10, OldLevel = 1, NewXP = 30, NewLevel = 10 },
			},
		},
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
	controls = controls,
	story = function(Properties)
		return e(Container, Properties)
	end,
}

return Story
