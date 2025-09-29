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
local MainStory = require(StoryFolder.MainStory)
local StoryContext = require(StoryFolder.StoryContext)

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	story = function(Properties)
		return e(StoryContext.Context.Provider, {
			value = {
				Enabled = true,
				CompletedMaps = {},
				CompletedInfinites = {},
				Data = nil,
				BoothTimeData = {
					StartTime = workspace:GetServerTimeNow(),
					EndTime = workspace:GetServerTimeNow() + 10,
				},
			},
		}, {
			MainStory = e(MainStory, {
				Visible = true,
				IsVisible = true,
				--[[	native = {
					Size = UDim2.fromScale(0.65, 0.9),
				},]]
			}),
		})
	end,
}

return Story
