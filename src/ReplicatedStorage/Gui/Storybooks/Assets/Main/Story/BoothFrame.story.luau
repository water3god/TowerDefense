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
local StoryFolder = Gui.Story
local BoothContext = require(StoryFolder.BoothContext)
local BoothFrame = require(StoryFolder.BoothFrame)

-- Controls --
local controls = {
	MaxPlayerCount = 1,
}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(BoothContext.Context.Provider, {
			value = {
				MapId = "Rome",
				LevelId = "Rome_LegionsMarch",
				Difficulty = "Normal",
				PlayerCount = Properties.controls.MaxPlayerCount,
				MaxPlayerCount = 4,
				StartTime = workspace:GetServerTimeNow(),
				EndTime = workspace:GetServerTimeNow() + 10,
				Status = "LoadingPlayers",
			},
		}, {
			BoothFrame = e(BoothFrame, {
				UniqueId = "BoothFrameStory",
				native = {
					Size = UDim2.fromScale(0.6, 0.8),
					Position = UDim2.fromScale(0.5, 0.4),
				},
			}),
		})
		return Frame
	end,
}

return Story
