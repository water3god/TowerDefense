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
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local BoothFrame = e(BoothContext.Context.Provider, {
			value = {
				MapId = "Rome",
				LevelId = "Hastingsv1",
				Difficulty = "Normal",
				PlayerCount = 1,
				MaxPlayerCount = 4,
				StartTime = workspace:GetServerTimeNow(),
				EndTime = workspace:GetServerTimeNow() + 10,
				Status = "LoadingPlayers",
			},
		}, {
			BoothFrame = e(BoothFrame, {
				native = {
					Size = UDim2.fromScale(0.6, 0.8),
					Position = UDim2.fromScale(0.5, 0.4),
				},
			}),
		})
		return BoothFrame
	end,
}

return Story
