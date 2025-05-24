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
local Leaderboard = Gui.Leaderboard
local LobbyLeaderboard = require(Leaderboard.LobbyLeaderboard)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local Frame = e(LobbyLeaderboard.Create, {
			Type = "TotalGoldStore",
			Data = { { UserId = 1, Value = 10 }, { UserId = 2, Value = 5 } },
			native = {
				Size = UDim2.fromScale(0.7, 0.9),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.61,
			}),
		})
		return Frame
	end,
}

return Story
