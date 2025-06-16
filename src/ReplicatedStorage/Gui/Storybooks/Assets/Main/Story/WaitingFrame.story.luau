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
local StoryContext = require(StoryFolder.StoryContext)
local WaitingFrame = require(StoryFolder.WaitingFrame)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(StoryContext.Context.Provider, {
			value = {
				Enabled = true,
				Data = {
					OwnerId = 343804839,
					MapId = "Rome",
					LevelId = "Hastingsv1",
					Difficulty = "Normal",
					Players = {},
					StartTime = workspace:GetServerTimeNow(),
					EndTime = workspace:GetServerTimeNow() + 10,
				},
			},
		}, {
			WaitingFrame = e(WaitingFrame, {
				native = {
					Size = UDim2.fromScale(0.6, 0.8),
					Position = UDim2.fromScale(0.5, 0.5),
				},
			}),
		})
		return Frame
	end,
}

return Story
