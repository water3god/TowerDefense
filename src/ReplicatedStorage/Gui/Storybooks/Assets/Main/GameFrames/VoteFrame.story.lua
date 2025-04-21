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
local VoteFrame = require(GameFrames.VoteFrame)

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	story = function(Properties)
		local Frame = e(VoteFrame, {
			VoteStartCount = 0,
			StartTime = workspace:GetServerTimeNow(),
			EndTime = workspace:GetServerTimeNow() + 10,

			native = {
				Size = UDim2.fromScale(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
			},
		})
		return Frame
	end,
}

return Story
